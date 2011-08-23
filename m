From: akpm@linux-foundation.org
Subject: + mremap-avoid-sending-one-ipi-per-page.patch added to -mm tree
Date: Tue, 23 Aug 2011 14:14:57 -0700
Message-ID: <201108232114.p7NLEvJG007115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958Ab1HWVPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 17:15:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com


The patch titled
     mremap: avoid sending one IPI per page
has been added to the -mm tree.  Its filename is
     mremap-avoid-sending-one-ipi-per-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mremap: avoid sending one IPI per page
From: Andrea Arcangeli <aarcange@redhat.com>

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

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch

