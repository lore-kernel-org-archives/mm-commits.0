From: akpm@linux-foundation.org
Subject: + asm-gemeric-tlb-remove-stray-function-declarations.patch
 added to -mm tree
Date: Thu, 16 Jan 2020 17:53:53 -0800
Message-ID: <20200117015353.vx9hV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgAQBxy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 20:53:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mpe@ellerman.id.au, aneesh.kumar@linux.ibm.com, peterz@infradead.org


The patch titled
     Subject: asm-gemeric/tlb: remove stray function declarations
has been added to the -mm tree.  Its filename is
     asm-gemeric-tlb-remove-stray-function-declarations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-gemeric-tlb-remove-stray-function-declarations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-gemeric-tlb-remove-stray-function-declarations.patch

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
Subject: asm-gemeric/tlb: remove stray function declarations

We removed the actual functions a while ago.

Link: http://lkml.kernel.org/r/20200116064531.483522-5-aneesh.kumar@linux.ibm.com
Fixes: 1808d65b55e4 ("asm-generic/tlb: Remove arch_tlb*_mmu()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/asm-generic/tlb.h~asm-gemeric-tlb-remove-stray-function-declarations
+++ a/include/asm-generic/tlb.h
@@ -285,11 +285,7 @@ struct mmu_gather {
 #endif
 };
 
-void arch_tlb_gather_mmu(struct mmu_gather *tlb,
-	struct mm_struct *mm, unsigned long start, unsigned long end);
 void tlb_flush_mmu(struct mmu_gather *tlb);
-void arch_tlb_finish_mmu(struct mmu_gather *tlb,
-			 unsigned long start, unsigned long end, bool force);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 				      unsigned long address,
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
