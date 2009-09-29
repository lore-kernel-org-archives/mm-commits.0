From: akpm@linux-foundation.org
Subject: + dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:51:18 -0700
Message-ID: <200909292051.n8TKpIVl032248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbZI2UvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 16:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net, joerg.roedel@amd.com


The patch titled
     dma-debug: allow DMA_BIDIRECTIONAL mappings to be synced with DMA_FROM_DEVICE and
has been added to the -mm tree.  Its filename is
     dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-allow-dma_bidirectional-mappings-to-be-synced-with-dma_from_device-and
+++ a/lib/dma-debug.c
@@ -907,6 +907,9 @@ static void check_sync(struct device *de
 				ref->size);
 	}
 
+	if (entry->direction == DMA_BIDIRECTIONAL)
+		goto out;
+
 	if (ref->direction != entry->direction) {
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
@@ -917,9 +920,6 @@ static void check_sync(struct device *de
 				dir2name[ref->direction]);
 	}
 
-	if (entry->direction == DMA_BIDIRECTIONAL)
-		goto out;
-
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
 		      !(ref->direction == DMA_TO_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
@@ -942,7 +942,6 @@ static void check_sync(struct device *de
 
 out:
 	put_hash_bucket(bucket, &flags);
