Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1649C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbjDFDEH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjDFDDu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6879D93D6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3243964125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8770CC433D2;
        Thu,  6 Apr 2023 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750218;
        bh=t+FWIMHt1GGlBcvhWtU08gdVwhnb+3HvXfXbnjw9VYU=;
        h=Date:To:From:Subject:From;
        b=AP9jH+j/HVgyfpOsTXrBEBNceoq2WMQUJGKEIxC6j4Cjz3M3cMnm1onh4OHQauSXh
         qm2mLQpILJSt6kCv8GB3Fc2lq8xovGmECKzFyRhJ9zyt6l7NQkomwz+M/PoyQTDSF6
         pjoLOKMRktDzK6jLqXYySzc1zZw/DXsTkz23PakQ=
Date:   Wed, 05 Apr 2023 20:03:37 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch removed from -mm tree
Message-Id: <20230406030338.8770CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: write-lock VMA while collapsing a huge page
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/khugepaged: write-lock VMA while collapsing a huge page
Date: Mon, 27 Feb 2023 09:36:14 -0800

Protect VMA from concurrent page fault handler while collapsing a huge
page.  Page fault handler needs a stable PMD to use PTL and relies on
per-VMA lock to prevent concurrent PMD changes.  pmdp_collapse_flush(),
set_huge_pmd() and collapse_and_free_pmd() can modify a PMD, which will
not be detected by a page fault handler without proper locking.

Before this patch, page tables can be walked under any one of the
mmap_lock, the mapping lock, and the anon_vma lock; so when khugepaged
unlinks and frees page tables, it must ensure that all of those either are
locked or don't exist.  This patch adds a fourth lock under which page
tables can be traversed, and so khugepaged must also lock out that one.

[surenb@google.com: vm_lock/i_mmap_rwsem inversion in retract_page_tables]
  Link: https://lkml.kernel.org/r/20230303213250.3555716-1-surenb@google.com
[surenb@google.com: build fix]
  Link: https://lkml.kernel.org/r/CAJuCfpFjWhtzRE1X=J+_JjgJzNKhq-=JT8yTBSTHthwp0pqWZw@mail.gmail.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-16-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   41 ++++++++++++++++++++++++++++++-----------
 mm/khugepaged.c    |    8 ++++++++
 mm/rmap.c          |   31 ++++++++++++++++---------------
 3 files changed, 54 insertions(+), 26 deletions(-)

--- a/include/linux/mm.h~mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page
+++ a/include/linux/mm.h
@@ -665,18 +665,23 @@ static inline void vma_end_read(struct v
 	rcu_read_unlock();
 }
 
-static inline void vma_start_write(struct vm_area_struct *vma)
+static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
 {
-	int mm_lock_seq;
-
 	mmap_assert_write_locked(vma->vm_mm);
 
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	mm_lock_seq = READ_ONCE(vma->vm_mm->mm_lock_seq);
-	if (vma->vm_lock_seq == mm_lock_seq)
+	*mm_lock_seq = READ_ONCE(vma->vm_mm->mm_lock_seq);
+	return (vma->vm_lock_seq == *mm_lock_seq);
+}
+
+static inline void vma_start_write(struct vm_area_struct *vma)
+{
+	int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
 
 	down_write(&vma->lock);
@@ -684,14 +689,26 @@ static inline void vma_start_write(struc
 	up_write(&vma->lock);
 }
 
+static inline bool vma_try_start_write(struct vm_area_struct *vma)
+{
+	int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
+		return true;
+
+	if (!down_write_trylock(&vma->vm_lock->lock))
+		return false;
+
+	vma->vm_lock_seq = mm_lock_seq;
+	up_write(&vma->vm_lock->lock);
+	return true;
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	mmap_assert_write_locked(vma->vm_mm);
-	/*
-	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
-	 * mm->mm_lock_seq can't be concurrently modified.
-	 */
-	VM_BUG_ON_VMA(vma->vm_lock_seq != READ_ONCE(vma->vm_mm->mm_lock_seq), vma);
+	int mm_lock_seq;
+
+	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
 #else /* CONFIG_PER_VMA_LOCK */
@@ -701,6 +718,8 @@ static inline bool vma_start_read(struct
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline bool vma_try_start_write(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
 
 #endif /* CONFIG_PER_VMA_LOCK */
--- a/mm/khugepaged.c~mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page
+++ a/mm/khugepaged.c
@@ -1056,6 +1056,7 @@ static int collapse_huge_page(struct mm_
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
+	vma_start_write(vma);
 	anon_vma_lock_write(vma->anon_vma);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
@@ -1517,6 +1518,9 @@ int collapse_pte_mapped_thp(struct mm_st
 		goto drop_hpage;
 	}
 
+	/* Lock the vma before taking i_mmap and page table locks */
+	vma_start_write(vma);
+
 	/*
 	 * We need to lock the mapping so that from here on, only GUP-fast and
 	 * hardware page walks can access the parts of the page tables that
@@ -1694,6 +1698,10 @@ static int retract_page_tables(struct ad
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
+			/* trylock for the same lock inversion as above */
+			if (!vma_try_start_write(vma))
+				goto unlock_next;
+
 			/*
 			 * Re-check whether we have an ->anon_vma, because
 			 * collapse_and_free_pmd() requires that either no
--- a/mm/rmap.c~mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page
+++ a/mm/rmap.c
@@ -25,21 +25,22 @@
  *     mapping->invalidate_lock (in filemap_fault)
  *       page->flags PG_locked (lock_page)
  *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
- *           mapping->i_mmap_rwsem
- *             anon_vma->rwsem
- *               mm->page_table_lock or pte_lock
- *                 swap_lock (in swap_duplicate, swap_info_get)
- *                   mmlist_lock (in mmput, drain_mmlist and others)
- *                   mapping->private_lock (in block_dirty_folio)
- *                     folio_lock_memcg move_lock (in block_dirty_folio)
- *                       i_pages lock (widely used)
- *                         lruvec->lru_lock (in folio_lruvec_lock_irq)
- *                   inode->i_lock (in set_page_dirty's __mark_inode_dirty)
- *                   bdi.wb->list_lock (in set_page_dirty's __mark_inode_dirty)
- *                     sb_lock (within inode_lock in fs/fs-writeback.c)
- *                     i_pages lock (widely used, in set_page_dirty,
- *                               in arch-dependent flush_dcache_mmap_lock,
- *                               within bdi.wb->list_lock in __sync_single_inode)
+ *           vma_start_write
+ *             mapping->i_mmap_rwsem
+ *               anon_vma->rwsem
+ *                 mm->page_table_lock or pte_lock
+ *                   swap_lock (in swap_duplicate, swap_info_get)
+ *                     mmlist_lock (in mmput, drain_mmlist and others)
+ *                     mapping->private_lock (in block_dirty_folio)
+ *                       folio_lock_memcg move_lock (in block_dirty_folio)
+ *                         i_pages lock (widely used)
+ *                           lruvec->lru_lock (in folio_lruvec_lock_irq)
+ *                     inode->i_lock (in set_page_dirty's __mark_inode_dirty)
+ *                     bdi.wb->list_lock (in set_page_dirty's __mark_inode_dirty)
+ *                       sb_lock (within inode_lock in fs/fs-writeback.c)
+ *                       i_pages lock (widely used, in set_page_dirty,
+ *                                 in arch-dependent flush_dcache_mmap_lock,
+ *                                 within bdi.wb->list_lock in __sync_single_inode)
  *
  * anon_vma->rwsem,mapping->i_mmap_rwsem   (memory_failure, collect_procs_anon)
  *   ->tasklist_lock
_

Patches currently in -mm which might be from surenb@google.com are


