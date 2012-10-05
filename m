From: akpm@linux-foundation.org
Subject: + mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch added to -mm tree
Date: Fri, 05 Oct 2012 15:01:18 -0700
Message-ID: <20121005220118.9F39E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52773 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab2JEWBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 18:01:19 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so249417vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 15:01:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: thp: Use more portable PMD clearing sequenece in zap_huge_pmd().
has been added to the -mm tree.  Its filename is
     mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1093,9 +1093,10 @@ int zap_huge_pmd(struct mmu_gather *tlb,
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
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

