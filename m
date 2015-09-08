From: akpm@linux-foundation.org
Subject: [merged] memory-make-the-function-tlb_next_batch-bool-now.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:12:13 -0700
Message-ID: <55ef24fd.8bItOI6U6kd2p2sD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: make tlb_next_batch() return bool
has been removed from the -mm tree.  Its filename was
     memory-make-the-function-tlb_next_batch-bool-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

