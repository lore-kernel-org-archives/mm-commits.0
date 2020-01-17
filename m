From: akpm@linux-foundation.org
Subject: + asm-generic-tlb-avoid-potential-double-flush.patch added
 to -mm tree
Date: Thu, 16 Jan 2020 17:53:51 -0800
Message-ID: <20200117015351.h--YZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgAQBxw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 20:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mpe@ellerman.id.au, aneesh.kumar@linux.ibm.com, peterz@infradead.org


The patch titled
     Subject: asm-generic/tlb: avoid potential double flush
has been added to the -mm tree.  Its filename is
     asm-generic-tlb-avoid-potential-double-flush.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-tlb-avoid-potential-double-flush.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-tlb-avoid-potential-double-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: asm-generic/tlb: avoid potential double flush

Aneesh reported that:

	tlb_flush_mmu()
	  tlb_flush_mmu_tlbonly()
	    tlb_flush()			<-- #1
	  tlb_flush_mmu_free()
	    tlb_table_flush()
	      tlb_table_invalidate()
		tlb_flush_mmu_tlbonly()
		  tlb_flush()		<-- #2

does two TLBIs when tlb->fullmm, because __tlb_reset_range() will not
clear tlb->end in that case.

Observe that any caller to __tlb_adjust_range() also sets at least one of
the tlb->freed_tables || tlb->cleared_p* bits, and those are
unconditionally cleared by __tlb_reset_range().

Change the condition for actually issuing TLBI to having one of those bits
set, as opposed to having tlb->end != 0.

Link: http://lkml.kernel.org/r/20200116064531.483522-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/asm-generic/tlb.h~asm-generic-tlb-avoid-potential-double-flush
+++ a/include/asm-generic/tlb.h
@@ -402,7 +402,12 @@ tlb_update_vma_flags(struct mmu_gather *
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 {
-	if (!tlb->end)
+	/*
+	 * Anything calling __tlb_adjust_range() also sets at least one of
+	 * these bits.
+	 */
+	if (!(tlb->freed_tables || tlb->cleared_ptes || tlb->cleared_pmds ||
+	      tlb->cleared_puds || tlb->cleared_p4ds))
 		return;
 
 	tlb_flush(tlb);
_

Patches currently in -mm which might be from peterz@infradead.org are

mm-mmu_gather-invalidate-tlb-correctly-on-batch-allocation-failure-and-flush.patch
asm-generic-tlb-avoid-potential-double-flush.patch
asm-gemeric-tlb-remove-stray-function-declarations.patch
asm-generic-tlb-add-missing-config-symbol.patch
asm-generic-tlb-rename-have_rcu_table_free.patch
asm-generic-tlb-rename-have_mmu_gather_page_size.patch
asm-generic-tlb-rename-have_mmu_gather_no_gather.patch
asm-generic-tlb-provide-mmu_gather_table_free.patch
