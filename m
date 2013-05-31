From: akpm@linux-foundation.org
Subject: +
 mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch added to -mm tree
Date: Fri, 31 May 2013 13:20:39 -0700
Message-ID: <51a90617.Qw4EbPxOgxKyC7lF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaUUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, mgorman@suse.de, jcmvbkbc@gmail.com, hughd@google.com, catalin.marinas@arm.com, Vineet.Gupta1@synopsys.com

Subject: + mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch added to -mm tree
To: Vineet.Gupta1@synopsys.com,catalin.marinas@arm.com,hughd@google.com,jcmvbkbc@gmail.com,mgorman@suse.de,peterz@infradead.org,riel@redhat.com,rientjes@google.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:20:39 -0700


The patch titled
     Subject: mm: Fix the TLB range flushed when __tlb_remove_page() runs out of slots
has been added to the -mm tree.  Its filename is
     mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm: Fix the TLB range flushed when __tlb_remove_page() runs out of slots

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
@@ -1110,6 +1110,7 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	unsigned long range_start = addr;
 
 again:
 	init_rss_vec(rss);
@@ -1215,12 +1216,14 @@ again:
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

mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch

