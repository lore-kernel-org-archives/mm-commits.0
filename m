From: akpm@linux-foundation.org
Subject: + asm-generic-tlb-add-missing-config-symbol.patch added to
 -mm tree
Date: Thu, 16 Jan 2020 17:53:55 -0800
Message-ID: <20200117015355.spzJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgAQBx4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 20:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mpe@ellerman.id.au, aneesh.kumar@linux.ibm.com, peterz@infradead.org


The patch titled
     Subject: asm-generic/tlb: add missing CONFIG symbol
has been added to the -mm tree.  Its filename is
     asm-generic-tlb-add-missing-config-symbol.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-tlb-add-missing-config-symbol.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-tlb-add-missing-config-symbol.patch

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
Subject: asm-generic/tlb: add missing CONFIG symbol

Without this the symbol will not actually end up in .config files.

Link: http://lkml.kernel.org/r/20200116064531.483522-6-aneesh.kumar@linux.ibm.com
Fixes: a30e32bd79e9 ("asm-generic/tlb: Provide generic tlb_flush() based on flush_tlb_mm()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/Kconfig~asm-generic-tlb-add-missing-config-symbol
+++ a/arch/Kconfig
@@ -399,6 +399,9 @@ config HAVE_RCU_TABLE_FREE
 config HAVE_MMU_GATHER_PAGE_SIZE
 	bool
 
+config MMU_GATHER_NO_RANGE
+	bool
+
 config HAVE_MMU_GATHER_NO_GATHER
 	bool
 
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
