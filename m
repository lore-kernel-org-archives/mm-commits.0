From: akpm@linux-foundation.org
Subject: + hugetlbfs-per-mount-huge-page-sizes.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:33 -0700
Message-ID: <200806081911.m58JBXoj016139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261AbYFHTMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, agl@us.ibm.com, ak@suse.de, nacc@us.ibm.com


The patch titled
     hugetlbfs: per mount huge page sizes
has been added to the -mm tree.  Its filename is
     hugetlbfs-per-mount-huge-page-sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: per mount huge page sizes
From: Nick Piggin <npiggin@suse.de>

Add the ability to configure the hugetlb hstate used on a per mount basis.

- Add a new pagesize= option to the hugetlbfs mount that allows setting
  the page size
- This option causes the mount code to find the hstate corresponding to the
  specified size, and sets up a pointer to the hstate in the mount's
  superblock.
- Change the hstate accessors to use this information rather than the
  global_hstate they were using (requires a slight change in mm/memory.c
  so we don't NULL deref in the error-unmap path -- see comments).

[np: take hstate out of hugetlbfs inode and vma->vm_private_data]

Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   45 ++++++++++++++++++++++++++++++--------
 include/linux/hugetlb.h |   14 +++++++----
 mm/hugetlb.c            |   16 ++-----------
 mm/memory.c             |   18 +++++++++++++--
 4 files changed, 64 insertions(+), 29 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-per-mount-huge-page-sizes fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-per-mount-huge-page-sizes
+++ a/fs/hugetlbfs/inode.c
@@ -53,6 +53,7 @@ int sysctl_hugetlb_shm_group;
 enum {
 	Opt_size, Opt_nr_inodes,
 	Opt_mode, Opt_uid, Opt_gid,
+	Opt_pagesize,
 	Opt_err,
 };
 
@@ -62,6 +63,7 @@ static match_table_t tokens = {
 	{Opt_mode,	"mode=%o"},
 	{Opt_uid,	"uid=%u"},
 	{Opt_gid,	"gid=%u"},
+	{Opt_pagesize,	"pagesize=%s"},
 	{Opt_err,	NULL},
 };
 
@@ -750,6 +752,8 @@ hugetlbfs_parse_options(char *options, s
 	char *p, *rest;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
+	unsigned long long size = 0;
+	enum { NO_SIZE, SIZE_STD, SIZE_PERCENT } setsize = NO_SIZE;
 
 	if (!options)
 		return 0;
@@ -780,17 +784,13 @@ hugetlbfs_parse_options(char *options, s
 			break;
 
 		case Opt_size: {
- 			unsigned long long size;
 			/* memparse() will accept a K/M/G without a digit */
 			if (!isdigit(*args[0].from))
 				goto bad_val;
 			size = memparse(args[0].from, &rest);
-			if (*rest == '%') {
-				size <<= HPAGE_SHIFT;
-				size *= max_huge_pages;
-				do_div(size, 100);
-			}
-			pconfig->nr_blocks = (size >> HPAGE_SHIFT);
+			setsize = SIZE_STD;
+			if (*rest == '%')
+				setsize = SIZE_PERCENT;
 			break;
 		}
 
@@ -801,6 +801,19 @@ hugetlbfs_parse_options(char *options, s
 			pconfig->nr_inodes = memparse(args[0].from, &rest);
 			break;
 
+		case Opt_pagesize: {
+			unsigned long ps;
+			ps = memparse(args[0].from, &rest);
+			pconfig->hstate = size_to_hstate(ps);
+			if (!pconfig->hstate) {
+				printk(KERN_ERR
+				"hugetlbfs: Unsupported page size %lu MB\n",
+					ps >> 20);
+				return -EINVAL;
+			}
+			break;
+		}
+
 		default:
 			printk(KERN_ERR "hugetlbfs: Bad mount option: \"%s\"\n",
 				 p);
@@ -808,6 +821,18 @@ hugetlbfs_parse_options(char *options, s
 			break;
 		}
 	}
+
+	/* Do size after hstate is set up */
+	if (setsize > NO_SIZE) {
+		struct hstate *h = pconfig->hstate;
+		if (setsize == SIZE_PERCENT) {
+			size <<= huge_page_shift(h);
+			size *= h->max_huge_pages;
+			do_div(size, 100);
+		}
+		pconfig->nr_blocks = (size >> huge_page_shift(h));
+	}
+
 	return 0;
 
 bad_val:
@@ -832,6 +857,7 @@ hugetlbfs_fill_super(struct super_block 
 	config.uid = current->fsuid;
 	config.gid = current->fsgid;
 	config.mode = 0755;
+	config.hstate = &default_hstate;
 	ret = hugetlbfs_parse_options(data, &config);
 	if (ret)
 		return ret;
@@ -840,14 +866,15 @@ hugetlbfs_fill_super(struct super_block 
 	if (!sbinfo)
 		return -ENOMEM;
 	sb->s_fs_info = sbinfo;
+	sbinfo->hstate = config.hstate;
 	spin_lock_init(&sbinfo->stat_lock);
 	sbinfo->max_blocks = config.nr_blocks;
 	sbinfo->free_blocks = config.nr_blocks;
 	sbinfo->max_inodes = config.nr_inodes;
 	sbinfo->free_inodes = config.nr_inodes;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	sb->s_blocksize = HPAGE_SIZE;
-	sb->s_blocksize_bits = HPAGE_SHIFT;
+	sb->s_blocksize = huge_page_size(config.hstate);
+	sb->s_blocksize_bits = huge_page_shift(config.hstate);
 	sb->s_magic = HUGETLBFS_MAGIC;
 	sb->s_op = &hugetlbfs_ops;
 	sb->s_time_gran = 1;
diff -puN include/linux/hugetlb.h~hugetlbfs-per-mount-huge-page-sizes include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-per-mount-huge-page-sizes
+++ a/include/linux/hugetlb.h
@@ -100,6 +100,7 @@ struct hugetlbfs_config {
 	umode_t mode;
 	long	nr_blocks;
 	long	nr_inodes;
+	struct hstate *hstate;
 };
 
 struct hugetlbfs_sb_info {
@@ -108,6 +109,7 @@ struct hugetlbfs_sb_info {
 	long	max_inodes;   /* inodes allowed */
 	long	free_inodes;  /* inodes free */
 	spinlock_t	stat_lock;
+	struct hstate *hstate;
 };
 
 
@@ -191,19 +193,21 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
-static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
+static inline struct hstate *hstate_inode(struct inode *i)
 {
-	return &default_hstate;
+	struct hugetlbfs_sb_info *hsb;
+	hsb = HUGETLBFS_SB(i->i_sb);
+	return hsb->hstate;
 }
 
 static inline struct hstate *hstate_file(struct file *f)
 {
-	return &default_hstate;
+	return hstate_inode(f->f_dentry->d_inode);
 }
 
-static inline struct hstate *hstate_inode(struct inode *i)
+static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
 {
-	return &default_hstate;
+	return hstate_file(vma->vm_file);
 }
 
 static inline unsigned long huge_page_size(struct hstate *h)
diff -puN mm/hugetlb.c~hugetlbfs-per-mount-huge-page-sizes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-per-mount-huge-page-sizes
+++ a/mm/hugetlb.c
@@ -1334,19 +1334,9 @@ void __unmap_hugepage_range(struct vm_ar
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page)
 {
-	/*
-	 * It is undesirable to test vma->vm_file as it should be non-null
-	 * for valid hugetlb area. However, vm_file will be NULL in the error
-	 * cleanup path of do_mmap_pgoff. When hugetlbfs ->mmap method fails,
-	 * do_mmap_pgoff() nullifies vma->vm_file before calling this function
-	 * to clean up. Since no pte has actually been setup, it is safe to
-	 * do nothing in this case.
-	 */
-	if (vma->vm_file) {
-		spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
-		__unmap_hugepage_range(vma, start, end, ref_page);
-		spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
-	}
+	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
+	__unmap_hugepage_range(vma, start, end, ref_page);
+	spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
 }
 
 /*
diff -puN mm/memory.c~hugetlbfs-per-mount-huge-page-sizes mm/memory.c
--- a/mm/memory.c~hugetlbfs-per-mount-huge-page-sizes
+++ a/mm/memory.c
@@ -901,9 +901,23 @@ unsigned long unmap_vmas(struct mmu_gath
 			}
 
 			if (unlikely(is_vm_hugetlb_page(vma))) {
-				unmap_hugepage_range(vma, start, end, NULL);
-				zap_work -= (end - start) /
+				/*
+				 * It is undesirable to test vma->vm_file as it
+				 * should be non-null for valid hugetlb area.
+				 * However, vm_file will be NULL in the error
+				 * cleanup path of do_mmap_pgoff. When
+				 * hugetlbfs ->mmap method fails,
+				 * do_mmap_pgoff() nullifies vma->vm_file
+				 * before calling this function to clean up.
+				 * Since no pte has actually been setup, it is
+				 * safe to do nothing in this case.
+				 */
+				if (vma->vm_file) {
+					unmap_hugepage_range(vma, start, end, NULL);
+					zap_work -= (end - start) /
 					pages_per_huge_page(hstate_vma(vma));
+				}
+
 				start = end;
 			} else
 				start = unmap_page_range(*tlbp, vma,
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

