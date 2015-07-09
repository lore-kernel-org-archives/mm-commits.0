From: akpm@linux-foundation.org
Subject: + memory-make-the-function-tlb_next_batch-bool-now.patch added to -mm tree
Date: Thu, 09 Jul 2015 15:48:23 -0700
Message-ID: <559efa37.YDm3o2BBgA18qua3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbGIWsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: make tlb_next_batch() return bool
has been added to the -mm tree.  Its filename is
     memory-make-the-function-tlb_next_batch-bool-now.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-make-the-function-tlb_next_batch-bool-now.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-make-the-function-tlb_next_batch-bool-now.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm/memory.c: make tlb_next_batch() return bool

This makes the tlb_next_batch() bool due to this particular function only
ever returning either one or zero as its return value.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~memory-make-the-function-tlb_next_batch-bool-now mm/memory.c
--- a/mm/memory.c~memory-make-the-function-tlb_next_batch-bool-now
+++ a/mm/memory.c
@@ -181,22 +181,22 @@ static void check_sync_rss_stat(struct t
 
 #ifdef HAVE_GENERIC_MMU_GATHER
 
-static int tlb_next_batch(struct mmu_gather *tlb)
+static bool tlb_next_batch(struct mmu_gather *tlb)
 {
 	struct mmu_gather_batch *batch;
 
 	batch = tlb->active;
 	if (batch->next) {
 		tlb->active = batch->next;
-		return 1;
+		return true;
 	}
 
 	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
-		return 0;
+		return false;
 
 	batch = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
 	if (!batch)
-		return 0;
+		return false;
 
 	tlb->batch_count++;
 	batch->next = NULL;
@@ -206,7 +206,7 @@ static int tlb_next_batch(struct mmu_gat
 	tlb->active->next = batch;
 	tlb->active = batch;
 
-	return 1;
+	return true;
 }
 
 /* tlb_gather_mmu
_

Patches currently in -mm which might be from xerofoify@gmail.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch
memory-make-the-function-tlb_next_batch-bool-now.patch
linux-next.patch

