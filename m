From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:32 -0700
Message-ID: <51db1268.FIu8uNyl6Wk15kCP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3GHT0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, mgorman@suse.de, jcmvbkbc@gmail.com, hughd@google.com, catalin.marinas@arm.com, Vineet.Gupta1@synopsys.com

Subject: [merged] mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch removed from -mm tree
To: Vineet.Gupta1@synopsys.com,catalin.marinas@arm.com,hughd@google.com,jcmvbkbc@gmail.com,mgorman@suse.de,peterz@infradead.org,riel@redhat.com,rientjes@google.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:32 -0700


The patch titled
     Subject: mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots
has been removed from the -mm tree.  Its filename was
     mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots

zap_pte_range loops from @addr to @end.  In the middle, if it runs out of
batching slots, TLB entries needs to be flushed for @start to @interim,
NOT @interim to @end.

Since ARC port doesn't use page free batching I can't test it myself but
this seems like the right thing to do.

Observed this when working on a fix for the issue at thread:
http://www.spinics.net/lists/linux-arch/msg21736.html

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots mm/memory.c
--- a/mm/memory.c~mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots
+++ a/mm/memory.c
@@ -1101,6 +1101,7 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	unsigned long range_start = addr;
 
 again:
 	init_rss_vec(rss);
@@ -1206,12 +1207,14 @@ again:
 		force_flush = 0;
 
 #ifdef HAVE_GENERIC_MMU_GATHER
-		tlb->start = addr;
-		tlb->end = end;
+		tlb->start = range_start;
+		tlb->end = addr;
 #endif
 		tlb_flush_mmu(tlb);
-		if (addr != end)
+		if (addr != end) {
+			range_start = addr;
 			goto again;
+		}
 	}
 
 	return addr;
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

origin.patch

