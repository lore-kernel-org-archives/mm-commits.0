From: akpm@linux-foundation.org
Subject: [merged] mremap-avoid-sending-one-ipi-per-page.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:16 -0700
Message-ID: <201111012110.pA1LAGS0004385@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab1KAVKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: avoid sending one IPI per page
has been removed from the -mm tree.  Its filename was
     mremap-avoid-sending-one-ipi-per-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mremap: avoid sending one IPI per page

This replaces ptep_clear_flush() with ptep_get_and_clear() and a single
flush_tlb_range() at the end of the loop, to avoid sending one IPI for
each page.

The mmu_notifier_invalidate_range_start/end section is enlarged
accordingly but this is not going to fundamentally change things.  It was
more by accident that the region under mremap was for the most part still
available for secondary MMUs: the primary MMU was never allowed to
reliably access that region for the duration of the mremap (modulo
trapping SIGSEGV on the old address range which sounds unpractical and
flakey).  If users wants secondary MMUs not to lose access to a large
region under mremap they should reduce the mremap size accordingly in
userland and run multiple calls.  Overall this will run faster so it's
actually going to reduce the time the region is under mremap for the
primary MMU which should provide a net benefit to apps.

For KVM this is a noop because the guest physical memory is never
mremapped, there's just no point it ever moving it while guest runs.  One
target of this optimization is JVM GC (so unrelated to the mmu notifier
logic).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/mremap.c~mremap-avoid-sending-one-ipi-per-page mm/mremap.c
--- a/mm/mremap.c~mremap-avoid-sending-one-ipi-per-page
+++ a/mm/mremap.c
@@ -80,11 +80,7 @@ static void move_ptes(struct vm_area_str
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
-	unsigned long old_start;
 
-	old_start = old_addr;
-	mmu_notifier_invalidate_range_start(vma->vm_mm,
-					    old_start, old_end);
 	if (vma->vm_file) {
 		/*
 		 * Subtle point from Rajesh Venkatasubramanian: before
@@ -111,7 +107,7 @@ static void move_ptes(struct vm_area_str
 				   new_pte++, new_addr += PAGE_SIZE) {
 		if (pte_none(*old_pte))
 			continue;
-		pte = ptep_clear_flush(vma, old_addr, old_pte);
+		pte = ptep_get_and_clear(mm, old_addr, old_pte);
 		pte = move_pte(pte, new_vma->vm_page_prot, old_addr, new_addr);
 		set_pte_at(mm, new_addr, new_pte, pte);
 	}
@@ -123,7 +119,6 @@ static void move_ptes(struct vm_area_str
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
-	mmu_notifier_invalidate_range_end(vma->vm_mm, old_start, old_end);
 }
 
 #define LATENCY_LIMIT	(64 * PAGE_SIZE)
@@ -134,10 +129,13 @@ unsigned long move_page_tables(struct vm
 {
 	unsigned long extent, next, old_end;
 	pmd_t *old_pmd, *new_pmd;
+	bool need_flush = false;
 
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
+	mmu_notifier_invalidate_range_start(vma->vm_mm, old_addr, old_end);
+
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
 		next = (old_addr + PMD_SIZE) & PMD_MASK;
@@ -158,7 +156,12 @@ unsigned long move_page_tables(struct vm
 			extent = LATENCY_LIMIT;
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent,
 				new_vma, new_pmd, new_addr);
+		need_flush = true;
 	}
+	if (likely(need_flush))
+		flush_tlb_range(vma, old_end-len, old_addr);
+
+	mmu_notifier_invalidate_range_end(vma->vm_mm, old_end-len, old_end);
 
 	return len + old_addr - old_end;	/* how much done */
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

