Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D77BC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbiBPAaZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245107AbiBPAaX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC0EF70F8
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF4466164C
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACAEC340EB;
        Wed, 16 Feb 2022 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971407;
        bh=/sR3o3pECl+7tfkAa2iUmv7PQE8OWjTvAQVngxRF3qU=;
        h=Date:To:From:Subject:From;
        b=pJw7rjzxA/TptAgcJEkyvuB8vJqhfd4G+8nwG1WhI+fFCOs/9MSMa72aV0naWg5O3
         DYSwLNCZcmhAeeS+Tlnx6w2NfiakikXkH2aSgZkdpW3NaWcXCOEjhfMDjewb4aoAfw
         bBDof2aS88hTZOqjjndzRqTnGwsD8Ysdme/UzLSE=
Date:   Tue, 15 Feb 2022 16:30:06 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch added to -mm tree
Message-Id: <20220216003007.0ACAEC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: delete munlock_vma_pages_all(), allow oomreap
has been added to the -mm tree.  Its filename is
     mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: delete munlock_vma_pages_all(), allow oomreap

munlock_vma_pages_range() will still be required, when munlocking but not
munmapping a set of pages; but when unmapping a pte, the mlock count will
be maintained in much the same way as it will be maintained when mapping
in the pte.  Which removes the need for munlock_vma_pages_all() on mlocked
vmas when munmapping or exiting: eliminating the catastrophic contention
on i_mmap_rwsem, and the need for page lock on the pages.

There is still a need to update locked_vm accounting according to the
munmapped vmas when munmapping: do that in detach_vmas_to_be_unmapped(). 
exit_mmap() does not need locked_vm updates, so delete unlock_range().

And wasn't I the one who forbade the OOM reaper to attack mlocked vmas,
because of the uncertainty in blocking on all those page locks?  No fear
of that now, so permit the OOM reaper on mlocked vmas.

Link: https://lkml.kernel.org/r/d9a9f8c3-1ee0-4c81-7017-6ecb78554a7@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   16 ++--------------
 mm/madvise.c  |    5 +++++
 mm/mlock.c    |    4 ++--
 mm/mmap.c     |   32 ++------------------------------
 mm/oom_kill.c |    2 +-
 5 files changed, 12 insertions(+), 47 deletions(-)

--- a/mm/internal.h~mm-munlock-delete-munlock_vma_pages_all-allow-oomreap
+++ a/mm/internal.h
@@ -71,11 +71,6 @@ void free_pgtables(struct mmu_gather *tl
 		unsigned long floor, unsigned long ceiling);
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
-static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
-{
-	return !(vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP));
-}
-
 struct zap_details;
 void unmap_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
@@ -398,12 +393,8 @@ extern long populate_vma_page_range(stru
 extern long faultin_vma_page_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   bool write, int *locked);
-extern void munlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
-static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
-{
-	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
-}
+extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
+			      unsigned long len);
 
 /*
  * must be called with vma's mmap_lock held for read or write, and page locked.
@@ -411,9 +402,6 @@ static inline void munlock_vma_pages_all
 extern void mlock_vma_page(struct page *page);
 extern void munlock_vma_page(struct page *page);
 
-extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
-			      unsigned long len);
-
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
  * we want to unconditionally remove a page from the pagecache -- e.g.,
--- a/mm/madvise.c~mm-munlock-delete-munlock_vma_pages_all-allow-oomreap
+++ a/mm/madvise.c
@@ -554,6 +554,11 @@ static void madvise_cold_page_range(stru
 	tlb_end_vma(tlb, vma);
 }
 
+static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
+{
+	return !(vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP));
+}
+
 static long madvise_cold(struct vm_area_struct *vma,
 			struct vm_area_struct **prev,
 			unsigned long start_addr, unsigned long end_addr)
--- a/mm/mlock.c~mm-munlock-delete-munlock_vma_pages_all-allow-oomreap
+++ a/mm/mlock.c
@@ -137,8 +137,8 @@ void munlock_vma_page(struct page *page)
  * Returns with VM_LOCKED cleared.  Callers must be prepared to
  * deal with this.
  */
-void munlock_vma_pages_range(struct vm_area_struct *vma,
-			     unsigned long start, unsigned long end)
+static void munlock_vma_pages_range(struct vm_area_struct *vma,
+				    unsigned long start, unsigned long end)
 {
 	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
--- a/mm/mmap.c~mm-munlock-delete-munlock_vma_pages_all-allow-oomreap
+++ a/mm/mmap.c
@@ -2674,6 +2674,8 @@ detach_vmas_to_be_unmapped(struct mm_str
 	vma->vm_prev = NULL;
 	do {
 		vma_rb_erase(vma, &mm->mm_rb);
+		if (vma->vm_flags & VM_LOCKED)
+			mm->locked_vm -= vma_pages(vma);
 		mm->map_count--;
 		tail_vma = vma;
 		vma = vma->vm_next;
@@ -2778,22 +2780,6 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
-static inline void
-unlock_range(struct vm_area_struct *start, unsigned long limit)
-{
-	struct mm_struct *mm = start->vm_mm;
-	struct vm_area_struct *tmp = start;
-
-	while (tmp && tmp->vm_start < limit) {
-		if (tmp->vm_flags & VM_LOCKED) {
-			mm->locked_vm -= vma_pages(tmp);
-			munlock_vma_pages_all(tmp);
-		}
-
-		tmp = tmp->vm_next;
-	}
-}
-
 /* Munmap is split into 2 main parts -- this part which finds
  * what needs doing, and the areas themselves, which do the
  * work.  This now handles partial unmappings.
@@ -2874,12 +2860,6 @@ int __do_munmap(struct mm_struct *mm, un
 			return error;
 	}
 
-	/*
-	 * unlock any mlock()ed ranges before detaching vmas
-	 */
-	if (mm->locked_vm)
-		unlock_range(vma, end);
-
 	/* Detach vmas from rbtree */
 	if (!detach_vmas_to_be_unmapped(mm, vma, prev, end))
 		downgrade = false;
@@ -3147,20 +3127,12 @@ void exit_mmap(struct mm_struct *mm)
 		 * Nothing can be holding mm->mmap_lock here and the above call
 		 * to mmu_notifier_release(mm) ensures mmu notifier callbacks in
 		 * __oom_reap_task_mm() will not block.
-		 *
-		 * This needs to be done before calling unlock_range(),
-		 * which clears VM_LOCKED, otherwise the oom reaper cannot
-		 * reliably test it.
 		 */
 		(void)__oom_reap_task_mm(mm);
-
 		set_bit(MMF_OOM_SKIP, &mm->flags);
 	}
 
 	mmap_write_lock(mm);
-	if (mm->locked_vm)
-		unlock_range(mm->mmap, ULONG_MAX);
-
 	arch_exit_mmap(mm);
 
 	vma = mm->mmap;
--- a/mm/oom_kill.c~mm-munlock-delete-munlock_vma_pages_all-allow-oomreap
+++ a/mm/oom_kill.c
@@ -554,7 +554,7 @@ bool __oom_reap_task_mm(struct mm_struct
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
 	for (vma = mm->mmap ; vma; vma = vma->vm_next) {
-		if (!can_madv_lru_vma(vma))
+		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
 		/*
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

