From: akpm@linux-foundation.org
Subject: + shmem-make-shmem_inode_info-lock-irq-safe.patch added to -mm
 tree
Date: Tue, 07 Jun 2016 14:04:53 -0700
Message-ID: <575736f5.9OuLpBdU8yo9ea51%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423268AbcFGVEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: make shmem_inode_info::lock irq-safe
has been added to the -mm tree.  Its filename is
     shmem-make-shmem_inode_info-lock-irq-safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-make-shmem_inode_info-lock-irq-safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-make-shmem_inode_info-lock-irq-safe.patch

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
Subject: shmem: make shmem_inode_info::lock irq-safe

We are going to need to call shmem_charge() under tree_lock to get
accoutning right on collapse of small tmpfs pages into a huge one.

The problem is that tree_lock is irq-safe and lockdep is not happy, that
we take irq-unsafe lock under irq-safe[1].

Let's convert the lock to irq-safe.

[1] https://gist.github.com/kiryl/80c0149e03ed35dfaf26628b8e03cdbc


Link: http://lkml.kernel.org/r/1465297246-98985-29-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Ning Qu <quning@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c  |    4 ++--
 mm/shmem.c |   50 ++++++++++++++++++++++++++------------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff -puN ipc/shm.c~shmem-make-shmem_inode_info-lock-irq-safe ipc/shm.c
--- a/ipc/shm.c~shmem-make-shmem_inode_info-lock-irq-safe
+++ a/ipc/shm.c
@@ -766,10 +766,10 @@ static void shm_add_rss_swap(struct shmi
 	} else {
 #ifdef CONFIG_SHMEM
 		struct shmem_inode_info *info = SHMEM_I(inode);
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		*rss_add += inode->i_mapping->nrpages;
 		*swp_add += info->swapped;
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 #else
 		*rss_add += inode->i_mapping->nrpages;
 #endif
diff -puN mm/shmem.c~shmem-make-shmem_inode_info-lock-irq-safe mm/shmem.c
--- a/mm/shmem.c~shmem-make-shmem_inode_info-lock-irq-safe
+++ a/mm/shmem.c
@@ -258,14 +258,15 @@ bool shmem_charge(struct inode *inode, l
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	unsigned long flags;
 
 	if (shmem_acct_block(info->flags, pages))
 		return false;
-	spin_lock(&info->lock);
+	spin_lock_irqsave(&info->lock, flags);
 	info->alloced += pages;
 	inode->i_blocks += pages * BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irqrestore(&info->lock, flags);
 	inode->i_mapping->nrpages += pages;
 
 	if (!sbinfo->max_blocks)
@@ -273,10 +274,10 @@ bool shmem_charge(struct inode *inode, l
 	if (percpu_counter_compare(&sbinfo->used_blocks,
 				sbinfo->max_blocks - pages) > 0) {
 		inode->i_mapping->nrpages -= pages;
-		spin_lock(&info->lock);
+		spin_lock_irqsave(&info->lock, flags);
 		info->alloced -= pages;
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irqrestore(&info->lock, flags);
 
 		return false;
 	}
@@ -288,12 +289,13 @@ void shmem_uncharge(struct inode *inode,
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	unsigned long flags;
 
-	spin_lock(&info->lock);
+	spin_lock_irqsave(&info->lock, flags);
 	info->alloced -= pages;
 	inode->i_blocks -= pages * BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	if (sbinfo->max_blocks)
 		percpu_counter_sub(&sbinfo->used_blocks, pages);
@@ -818,10 +820,10 @@ static void shmem_undo_range(struct inod
 		index++;
 	}
 
-	spin_lock(&info->lock);
+	spin_lock_irq(&info->lock);
 	info->swapped -= nr_swaps_freed;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irq(&info->lock);
 }
 
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
@@ -838,9 +840,9 @@ static int shmem_getattr(struct vfsmount
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
 	if (info->alloced - info->swapped != inode->i_mapping->nrpages) {
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 	}
 	generic_fillattr(inode, stat);
 	return 0;
@@ -984,9 +986,9 @@ static int shmem_unuse_inode(struct shme
 		delete_from_swap_cache(*pagep);
 		set_page_dirty(*pagep);
 		if (!error) {
-			spin_lock(&info->lock);
+			spin_lock_irq(&info->lock);
 			info->swapped--;
-			spin_unlock(&info->lock);
+			spin_unlock_irq(&info->lock);
 			swap_free(swap);
 		}
 	}
@@ -1134,10 +1136,10 @@ static int shmem_writepage(struct page *
 		list_add_tail(&info->swaplist, &shmem_swaplist);
 
 	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
 		info->swapped++;
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 
 		swap_shmem_alloc(swap);
 		shmem_delete_from_page_cache(page, swp_to_radix_entry(swap));
@@ -1523,10 +1525,10 @@ repeat:
 
 		mem_cgroup_commit_charge(page, memcg, true, false);
 
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		info->swapped--;
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 
 		if (sgp == SGP_WRITE)
 			mark_page_accessed(page);
@@ -1603,11 +1605,11 @@ alloc_nohuge:		page = shmem_alloc_and_ac
 				PageTransHuge(page));
 		lru_cache_add_anon(page);
 
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		info->alloced += 1 << compound_order(page);
 		inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 		alloced = true;
 
 		/*
@@ -1639,9 +1641,9 @@ clear:
 		if (alloced) {
 			ClearPageDirty(page);
 			delete_from_page_cache(page);
-			spin_lock(&info->lock);
+			spin_lock_irq(&info->lock);
 			shmem_recalc_inode(inode);
-			spin_unlock(&info->lock);
+			spin_unlock_irq(&info->lock);
 		}
 		error = -EINVAL;
 		goto unlock;
@@ -1673,9 +1675,9 @@ unlock:
 	}
 	if (error == -ENOSPC && !once++) {
 		info = SHMEM_I(inode);
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 		goto repeat;
 	}
 	if (error == -EEXIST)	/* from above or from radix_tree_insert */
@@ -1874,7 +1876,7 @@ int shmem_lock(struct file *file, int lo
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int retval = -ENOMEM;
 
-	spin_lock(&info->lock);
+	spin_lock_irq(&info->lock);
 	if (lock && !(info->flags & VM_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
@@ -1889,7 +1891,7 @@ int shmem_lock(struct file *file, int lo
 	retval = 0;
 
 out_nomem:
-	spin_unlock(&info->lock);
+	spin_unlock_irq(&info->lock);
 	return retval;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
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
a.patch

