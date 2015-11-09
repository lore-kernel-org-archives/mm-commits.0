From: akpm@linux-foundation.org
Subject: [merged] dma-debug-check-nents-in-dma_sync_sg.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 12:13:50 -0800
Message-ID: <5640fe7e.qYU849skOWT9byt9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbKIUNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robin.murphy@arm.com, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: check nents in dma_sync_sg*
has been removed from the -mm tree.  Its filename was
     dma-debug-check-nents-in-dma_sync_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Murphy <robin.murphy@arm.com>
Subject: dma-debug: check nents in dma_sync_sg*

Like dma_unmap_sg, dma_sync_sg* should be called with the original number
of entries passed to dma_map_sg, so do the same check in the sync path as
we do in the unmap path.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN lib/dma-debug.c~dma-debug-check-nents-in-dma_sync_sg lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-check-nents-in-dma_sync_sg
+++ a/lib/dma-debug.c
@@ -1249,6 +1249,14 @@ static void check_sync(struct device *de
 				dir2name[entry->direction],
 				dir2name[ref->direction]);
 
+	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
+	    ref->sg_call_ents != entry->sg_call_ents) {
+		err_printk(ref->dev, entry, "DMA-API: device driver syncs "
+			   "DMA sg list with different entry count "
+			   "[map count=%d] [sync count=%d]\n",
+			   entry->sg_call_ents, ref->sg_call_ents);
+	}
+
 out:
 	put_hash_bucket(bucket, &flags);
 }
_

Patches currently in -mm which might be from robin.murphy@arm.com are

dma-debug-allow-poisoning-nonzero-allocations.patch

