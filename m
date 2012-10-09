From: akpm@linux-foundation.org
Subject: [merged] mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:40 -0700
Message-ID: <20121009181541.4096F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39935 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab2JISPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:43 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so360588fae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: Use more portable PMD clearing sequenece in zap_huge_pmd().
has been removed from the -mm tree.  Its filename was
     mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Miller <davem@davemloft.net>
Subject: mm: thp: Use more portable PMD clearing sequenece in zap_huge_pmd().

Invalidation sequences are handled in various ways on various
architectures.

One way, which sparc64 uses, is to let the set_*_at() functions accumulate
pending flushes into a per-cpu array.  Then the flush_tlb_range() et al. 
calls process the pending TLB flushes.

In this regime, the __tlb_remove_*tlb_entry() implementations are
essentially NOPs.

The canonical PTE zap in mm/memory.c is:

			ptent = ptep_get_and_clear_full(mm, addr, pte,
							tlb->fullmm);
			tlb_remove_tlb_entry(tlb, pte, addr);

With a subsequent tlb_flush_mmu() if needed.

Mirror this in the THP PMD zapping using:

		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
		page = pmd_page(orig_pmd);
		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);

And we properly accomodate TLB flush mechanims like the one described
above.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -1024,9 +1024,10 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
+		pmd_t orig_pmd;
 		pgtable = pgtable_trans_huge_withdraw(tlb->mm);
-		page = pmd_page(*pmd);
-		pmd_clear(pmd);
+		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
+		page = pmd_page(orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		page_remove_rmap(page);
 		VM_BUG_ON(page_mapcount(page) < 0);
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

