From: akpm@linux-foundation.org
Subject: [merged] asm-generic-tlb-add-missing-config-symbol.patch
 removed from -mm tree
Date: Tue, 04 Feb 2020 10:42:09 -0800
Message-ID: <20200204184209.T7BTxIH4G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbgBDSmK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org


The patch titled
     Subject: asm-generic/tlb: add missing CONFIG symbol
has been removed from the -mm tree.  Its filename was
     asm-generic-tlb-add-missing-config-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
