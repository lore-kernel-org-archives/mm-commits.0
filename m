From: akpm@linux-foundation.org
Subject: [merged] dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:17:47 -0800
Message-ID: <201001112017.o0BKHlWw025426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab0AKUTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, davem@davemloft.net, joerg.roedel@amd.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dma-debug: allow DMA_BIDIRECTIONAL mappings to be synced with DMA_FROM_DEVICE and
has been removed from the -mm tree.  Its filename was
     dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-debug: allow DMA_BIDIRECTIONAL mappings to be synced with DMA_FROM_DEVICE and
From: Krzysztof Halasa <khc@pm.waw.pl>

There is no need to perform full BIDIR sync (copying the buffers in case
of swiotlb and similar schemes) if we know that the owner (CPU or device)
hasn't altered the data.

Addresses the false-positive reported at
http://bugzilla.kernel.org/show_bug.cgi?id=14169

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Miller <davem@davemloft.net>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and
+++ a/lib/dma-debug.c
@@ -913,6 +913,9 @@ static void check_sync(struct device *de
 				ref->size);
 	}
 
+	if (entry->direction == DMA_BIDIRECTIONAL)
+		goto out;
+
 	if (ref->direction != entry->direction) {
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
@@ -923,9 +926,6 @@ static void check_sync(struct device *de
 				dir2name[ref->direction]);
 	}
 
-	if (entry->direction == DMA_BIDIRECTIONAL)
-		goto out;
-
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
 		      !(ref->direction == DMA_TO_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
@@ -948,7 +948,6 @@ static void check_sync(struct device *de
 
 out:
 	put_hash_bucket(bucket, &flags);
