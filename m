From: akpm@linux-foundation.org
Subject: +
 shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch added to
 -mm tree
Date: Thu, 16 Jun 2016 15:22:58 -0700
Message-ID: <576326c2.1wr0BBTnflqyLOIO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbcFPWW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: split huge pages beyond i_size under memory pressure
has been added to the -mm tree.  Its filename is
     shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: shmem: split huge pages beyond i_size under memory pressure

Even if user asked to allocate huge pages always (huge=always), we
should be able to free up some memory by splitting pages which are
partly byound i_size if memory presure comes or once we hit limit on
filesystem size (-o size=).

In order to do this we maintain per-superblock list of inodes, which
potentially have huge pages on the border of file size.

Per-fs shrinker can reclaim memory by splitting such pages.

If we hit -ENOSPC during shmem_getpage_gfp(), we try to split a page to
free up space on the filesystem and retry allocation if it succeed.

Link: http://lkml.kernel.org/r/1466021202-61880-37-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    6 +
 mm/shmem.c               |  175 +++++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+), 1 deletion(-)

diff -puN include/linux/shmem_fs.h~shmem-split-huge-pages-beyond-i_size-under-memory-pressure include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~shmem-split-huge-pages-beyond-i_size-under-memory-pressure
+++ a/include/linux/shmem_fs.h
@@ -16,8 +16,9 @@ struct shmem_inode_info {
 	unsigned long		flags;
 	unsigned long		alloced;	/* data pages alloced to file */
 	unsigned long		swapped;	/* subtotal assigned to swap */
-	struct shared_policy	policy;		/* NUMA memory alloc policy */
+	struct list_head        shrinklist;     /* shrinkable hpage inodes */
 	struct list_head	swaplist;	/* chain of maybes on swap */
+	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct simple_xattrs	xattrs;		/* list of xattrs */
 	struct inode		vfs_inode;
 };
@@ -33,6 +34,9 @@ struct shmem_sb_info {
 	kuid_t uid;		    /* Mount uid for root directory */
 	kgid_t gid;		    /* Mount gid for root directory */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
+	spinlock_t shrinklist_lock;   /* Protects shrinklist */
+	struct list_head shrinklist;  /* List of shinkable inodes */
+	unsigned long shrinklist_len; /* Length of shrinklist */
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
diff -puN mm/shmem.c~shmem-split-huge-pages-beyond-i_size-under-memory-pressure mm/shmem.c
--- a/mm/shmem.c~shmem-split-huge-pages-beyond-i_size-under-memory-pressure
+++ a/mm/shmem.c
@@ -188,6 +188,7 @@ static const struct inode_operations shm
 static const struct inode_operations shmem_dir_inode_operations;
 static const struct inode_operations shmem_special_inode_operations;
 static const struct vm_operations_struct shmem_vm_ops;
+static struct file_system_type shmem_fs_type;
 
 static LIST_HEAD(shmem_swaplist);
 static DEFINE_MUTEX(shmem_swaplist_mutex);
@@ -406,10 +407,122 @@ static const char *shmem_format_huge(int
 	}
 }
 
+static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
+		struct shrink_control *sc, unsigned long nr_to_split)
+{
+	LIST_HEAD(list), *pos, *next;
+	struct inode *inode;
+	struct shmem_inode_info *info;
+	struct page *page;
+	unsigned long batch = sc ? sc->nr_to_scan : 128;
+	int removed = 0, split = 0;
+
+	if (list_empty(&sbinfo->shrinklist))
+		return SHRINK_STOP;
+
+	spin_lock(&sbinfo->shrinklist_lock);
+	list_for_each_safe(pos, next, &sbinfo->shrinklist) {
+		info = list_entry(pos, struct shmem_inode_info, shrinklist);
+
+		/* pin the inode */
+		inode = igrab(&info->vfs_inode);
+
+		/* inode is about to be evicted */
+		if (!inode) {
+			list_del_init(&info->shrinklist);
+			removed++;
+			goto next;
+		}
+
+		/* Check if there's anything to gain */
+		if (round_up(inode->i_size, PAGE_SIZE) ==
+				round_up(inode->i_size, HPAGE_PMD_SIZE)) {
+			list_del_init(&info->shrinklist);
+			removed++;
+			iput(inode);
+			goto next;
+		}
+
+		list_move(&info->shrinklist, &list);
+next:
+		if (!--batch)
+			break;
+	}
+	spin_unlock(&sbinfo->shrinklist_lock);
+
+	list_for_each_safe(pos, next, &list) {
+		int ret;
+
+		info = list_entry(pos, struct shmem_inode_info, shrinklist);
+		inode = &info->vfs_inode;
+
+		if (nr_to_split && split >= nr_to_split) {
+			iput(inode);
+			continue;
+		}
+
+		page = find_lock_page(inode->i_mapping,
+				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
+		if (!page)
+			goto drop;
+
+		if (!PageTransHuge(page)) {
+			unlock_page(page);
+			put_page(page);
+			goto drop;
+		}
+
+		ret = split_huge_page(page);
+		unlock_page(page);
+		put_page(page);
+
+		if (ret) {
+			/* split failed: leave it on the list */
+			iput(inode);
+			continue;
+		}
+
+		split++;
+drop:
+		list_del_init(&info->shrinklist);
+		removed++;
+		iput(inode);
+	}
+
+	spin_lock(&sbinfo->shrinklist_lock);
+	list_splice_tail(&list, &sbinfo->shrinklist);
+	sbinfo->shrinklist_len -= removed;
+	spin_unlock(&sbinfo->shrinklist_lock);
+
+	return split;
+}
+
+static long shmem_unused_huge_scan(struct super_block *sb,
+		struct shrink_control *sc)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	if (!READ_ONCE(sbinfo->shrinklist_len))
+		return SHRINK_STOP;
+
+	return shmem_unused_huge_shrink(sbinfo, sc, 0);
+}
+
+static long shmem_unused_huge_count(struct super_block *sb,
+		struct shrink_control *sc)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+	return READ_ONCE(sbinfo->shrinklist_len);
+}
 #else /* !CONFIG_TRANSPARENT_HUGE_PAGECACHE */
 
 #define shmem_huge SHMEM_HUGE_DENY
 
+static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
+		struct shrink_control *sc, unsigned long nr_to_split)
+{
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGE_PAGECACHE */
 
 /*
@@ -843,6 +956,7 @@ static int shmem_setattr(struct dentry *
 {
 	struct inode *inode = d_inode(dentry);
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	int error;
 
 	error = inode_change_ok(inode, attr);
@@ -878,6 +992,20 @@ static int shmem_setattr(struct dentry *
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
+
+			/*
+			 * Part of the huge page can be beyond i_size: subject
+			 * to shrink under memory pressure.
+			 */
+			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE)) {
+				spin_lock(&sbinfo->shrinklist_lock);
+				if (list_empty(&info->shrinklist)) {
+					list_add_tail(&info->shrinklist,
+							&sbinfo->shrinklist);
+					sbinfo->shrinklist_len++;
+				}
+				spin_unlock(&sbinfo->shrinklist_lock);
+			}
 		}
 	}
 
@@ -890,11 +1018,20 @@ static int shmem_setattr(struct dentry *
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
 		shmem_truncate_range(inode, 0, (loff_t)-1);
+		if (!list_empty(&info->shrinklist)) {
+			spin_lock(&sbinfo->shrinklist_lock);
+			if (!list_empty(&info->shrinklist)) {
+				list_del_init(&info->shrinklist);
+				sbinfo->shrinklist_len--;
+			}
+			spin_unlock(&sbinfo->shrinklist_lock);
+		}
 		if (!list_empty(&info->swaplist)) {
 			mutex_lock(&shmem_swaplist_mutex);
 			list_del_init(&info->swaplist);
@@ -1563,8 +1700,23 @@ alloc_nohuge:		page = shmem_alloc_and_ac
 					index, false);
 		}
 		if (IS_ERR(page)) {
+			int retry = 5;
 			error = PTR_ERR(page);
 			page = NULL;
+			if (error != -ENOSPC)
+				goto failed;
+			/*
+			 * Try to reclaim some spece by splitting a huge page
+			 * beyond i_size on the filesystem.
+			 */
+			while (retry--) {
+				int ret;
+				ret = shmem_unused_huge_shrink(sbinfo, NULL, 1);
+				if (ret == SHRINK_STOP)
+					break;
+				if (ret)
+					goto alloc_nohuge;
+			}
 			goto failed;
 		}
 
@@ -1603,6 +1755,22 @@ alloc_nohuge:		page = shmem_alloc_and_ac
 		spin_unlock_irq(&info->lock);
 		alloced = true;
 
+		if (PageTransHuge(page) &&
+				DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
+				hindex + HPAGE_PMD_NR - 1) {
+			/*
+			 * Part of the huge page is beyond i_size: subject
+			 * to shrink under memory pressure.
+			 */
+			spin_lock(&sbinfo->shrinklist_lock);
+			if (list_empty(&info->shrinklist)) {
+				list_add_tail(&info->shrinklist,
+						&sbinfo->shrinklist);
+				sbinfo->shrinklist_len++;
+			}
+			spin_unlock(&sbinfo->shrinklist_lock);
+		}
+
 		/*
 		 * Let SGP_FALLOC use the SGP_WRITE optimization on a new page.
 		 */
@@ -1920,6 +2088,7 @@ static struct inode *shmem_get_inode(str
 		spin_lock_init(&info->lock);
 		info->seals = F_SEAL_SEAL;
 		info->flags = flags & VM_NORESERVE;
+		INIT_LIST_HEAD(&info->shrinklist);
 		INIT_LIST_HEAD(&info->swaplist);
 		simple_xattrs_init(&info->xattrs);
 		cache_no_acl(inode);
@@ -3516,6 +3685,8 @@ int shmem_fill_super(struct super_block
 	if (percpu_counter_init(&sbinfo->used_blocks, 0, GFP_KERNEL))
 		goto failed;
 	sbinfo->free_inodes = sbinfo->max_inodes;
+	spin_lock_init(&sbinfo->shrinklist_lock);
+	INIT_LIST_HEAD(&sbinfo->shrinklist);
 
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_SIZE;
@@ -3678,6 +3849,10 @@ static const struct super_operations shm
 	.evict_inode	= shmem_evict_inode,
 	.drop_inode	= generic_delete_inode,
 	.put_super	= shmem_put_super,
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+	.nr_cached_objects	= shmem_unused_huge_count,
+	.free_cached_objects	= shmem_unused_huge_scan,
+#endif
 };
 
 static const struct vm_operations_struct shmem_vm_ops = {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

revert-mm-make-faultaround-produce-old-ptes.patch
revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
khugepaged-recheck-pmd-after-mmap_sem-re-acquired.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch

