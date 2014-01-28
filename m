From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
 removed from -mm tree
Date: Tue, 28 Jan 2014 11:10:09 -0800
Message-ID: <52e80091.C8HlYxR8eRO6Alfw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaA1TKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hpa@zytor.com, davidlohr@hp.com, alex.shi@linaro.org, mgorman@suse.de

Subject: [merged] x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch removed from -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,davidlohr@hp.com,hpa@zytor.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:10:09 -0800


The patch titled
     Subject: x86: mm: eliminate redundant page table walk during TLB range flushing
has been removed from the -mm tree.  Its filename was
     x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: mm: eliminate redundant page table walk during TLB range flushing

When choosing between doing an address space or ranged flush, the x86
implementation of flush_tlb_mm_range takes into account whether there are
any large pages in the range.  A per-page flush typically requires fewer
entries than would covered by a single large page and the check is
redundant.

There is one potential exception.  THP migration flushes single THP
entries and it conceivably would benefit from flushing a single entry
instead of the mm.  However, this flush is after a THP allocation, copy
and page table update potentially with any other threads serialised behind
it.  In comparison to that, the flush is noise.  It makes more sense to
optimise balancing to require fewer flushes than to optimise the flush
itself.

This patch deletes the redundant huge page check.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff -puN arch/x86/mm/tlb.c~x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing
+++ a/arch/x86/mm/tlb.c
@@ -158,32 +158,6 @@ void flush_tlb_current_task(void)
 	preempt_enable();
 }
 
-/*
- * It can find out the THP large page, or
- * HUGETLB page in tlb_flush when THP disabled
- */
-static inline unsigned long has_large_page(struct mm_struct *mm,
-				 unsigned long start, unsigned long end)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	unsigned long addr = ALIGN(start, HPAGE_SIZE);
-	for (; addr < end; addr += HPAGE_SIZE) {
-		pgd = pgd_offset(mm, addr);
-		if (likely(!pgd_none(*pgd))) {
-			pud = pud_offset(pgd, addr);
-			if (likely(!pud_none(*pud))) {
-				pmd = pmd_offset(pud, addr);
-				if (likely(!pmd_none(*pmd)))
-					if (pmd_large(*pmd))
-						return addr;
-			}
-		}
-	}
-	return 0;
-}
-
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
 {
@@ -218,7 +192,7 @@ void flush_tlb_mm_range(struct mm_struct
 	nr_base_pages = (end - start) >> PAGE_SHIFT;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
+	if (nr_base_pages > act_entries) {
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch
mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
mm-mempolicyc-convert-to-pr_foo.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

