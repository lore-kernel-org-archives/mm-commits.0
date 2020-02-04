From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 51/67] asm-gemeric/tlb: remove stray function
 declarations
Date: Mon, 03 Feb 2020 17:36:56 -0800
Message-ID: <20200204013656.Vwg5m7mW1%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgBDBg5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:36:57 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org, torvalds@linux-foundation.org

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
