From: akpm@linux-foundation.org
Subject: + mm-tlb_fast_mode-check-missing-in-tlb_finish_mmu.patch added to -mm tree
Date: Mon, 03 Jun 2013 15:20:06 -0700
Message-ID: <51ad1696.6YNZn+dPTCP9E8Jy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602Ab3FCWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 18:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, mgorman@suse.de, hughd@google.com, Vineet.Gupta1@synopsys.com

Subject: + mm-tlb_fast_mode-check-missing-in-tlb_finish_mmu.patch added to -mm tree
To: Vineet.Gupta1@synopsys.com,hughd@google.com,mgorman@suse.de,peterz@infradead.org,riel@redhat.com,rientjes@google.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 15:20:06 -0700


The patch titled
     Subject: mm: tlb_fast_mode check missing in tlb_finish_mmu()
has been added to the -mm tree.  Its filename is
     mm-tlb_fast_mode-check-missing-in-tlb_finish_mmu.patch

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
Subject: mm: tlb_fast_mode check missing in tlb_finish_mmu()

This removes some unused generated code for tlb_fast_mode() == true

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memory.c~mm-tlb_fast_mode-check-missing-in-tlb_finish_mmu mm/memory.c
--- a/mm/memory.c~mm-tlb_fast_mode-check-missing-in-tlb_finish_mmu
+++ a/mm/memory.c
@@ -267,6 +267,9 @@ void tlb_finish_mmu(struct mmu_gather *t
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
 
+	if (tlb_fast_mode(tlb))
+		return;
+
 	for (batch = tlb->local.next; batch; batch = next) {
 		next = batch->next;
 		free_pages((unsigned long)batch, 0);
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch
mm-tlb_fast_mode-check-missing-in-tlb_finish_mmu.patch

