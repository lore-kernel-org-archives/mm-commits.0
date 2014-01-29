From: akpm@linux-foundation.org
Subject: + dma-debug-fix-overlap-detection.patch added to -mm tree
Date: Wed, 29 Jan 2014 11:08:21 -0800
Message-ID: <52e951a5.7r+KFjNjn2RjFRi/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaA2TIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 14:08:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, romieu@fr.zoreil.com, linux@eikelenboom.it, dan.j.williams@intel.com

Subject: + dma-debug-fix-overlap-detection.patch added to -mm tree
To: dan.j.williams@intel.com,linux@eikelenboom.it,romieu@fr.zoreil.com
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 11:08:21 -0800


The patch titled
     Subject: dma-debug: fix overlap detection
has been added to the -mm tree.  Its filename is
     dma-debug-fix-overlap-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-fix-overlap-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-fix-overlap-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
dma-debug-fix-overlap-detection.patch
linux-next.patch

