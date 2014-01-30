From: akpm@linux-foundation.org
Subject: [merged] dma-debug-fix-overlap-detection.patch removed from -mm
 tree
Date: Thu, 30 Jan 2014 12:05:24 -0800
Message-ID: <52eab084.91pNzKx3VBElQVh6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaA3UFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, romieu@fr.zoreil.com, linux@eikelenboom.it, dan.j.williams@intel.com

Subject: [merged] dma-debug-fix-overlap-detection.patch removed from -mm tree
To: dan.j.williams@intel.com,linux@eikelenboom.it,romieu@fr.zoreil.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:24 -0800


The patch titled
     Subject: dma-debug: fix overlap detection
has been removed from the -mm tree.  Its filename was
     dma-debug-fix-overlap-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dma-debug: fix overlap detection

0abdd7a81b7e ("dma-debug: introduce debug_dma_assert_idle()") was reworked
to expand the overlap counter to the full range expressable by 3 tag bits,
but it has a thinko in treating the overlap counter as a pure reference
count for the entry.

Instead of deleting when the reference-count drops to zero, we need to
delete when the overlap-count drops below zero.  Also, when detecting
overflow we can just test the overlap-count > MAX rather than applying
special meaning to 0.

Regression report available here:
http://marc.info/?l=linux-netdev&m=139073373932386&w=2

This patch, now tested on the original net_dma case, sees the expected
handful of reports before the eventual data corruption occurs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-overlap-detection lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-overlap-detection
+++ a/lib/dma-debug.c
@@ -463,7 +463,7 @@ static int active_pfn_set_overlap(unsign
 	int i;
 
 	if (overlap > ACTIVE_PFN_MAX_OVERLAP || overlap < 0)
-		return 0;
+		return overlap;
 
 	for (i = RADIX_TREE_MAX_TAGS - 1; i >= 0; i--)
 		if (overlap & 1 << i)
@@ -486,7 +486,7 @@ static void active_pfn_inc_overlap(unsig
 	 * debug_dma_assert_idle() as the pfn may be marked idle
 	 * prematurely.
 	 */
-	WARN_ONCE(overlap == 0,
+	WARN_ONCE(overlap > ACTIVE_PFN_MAX_OVERLAP,
 		  "DMA-API: exceeded %d overlapping mappings of pfn %lx\n",
 		  ACTIVE_PFN_MAX_OVERLAP, pfn);
 }
@@ -517,7 +517,11 @@ static void active_pfn_remove(struct dma
 	unsigned long flags;
 
 	spin_lock_irqsave(&radix_lock, flags);
-	if (active_pfn_dec_overlap(entry->pfn) == 0)
+	/* since we are counting overlaps the final put of the
+	 * entry->pfn will occur when the overlap count is 0.
+	 * active_pfn_dec_overlap() returns -1 in that case
+	 */
+	if (active_pfn_dec_overlap(entry->pfn) < 0)
 		radix_tree_delete(&dma_active_pfn, entry->pfn);
 	spin_unlock_irqrestore(&radix_lock, flags);
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
linux-next.patch

