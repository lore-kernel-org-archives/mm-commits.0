From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 52/67] asm-generic/tlb: add missing CONFIG symbol
Date: Mon, 03 Feb 2020 17:36:59 -0800
Message-ID: <20200204013659.oiVEt4xlg%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgBDBhA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:00 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org, torvalds@linux-foundation.org

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
