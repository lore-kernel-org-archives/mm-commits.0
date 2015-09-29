From: akpm@linux-foundation.org
Subject: + dma-debug-check-nents-in-dma_sync_sg.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:40:58 -0700
Message-ID: <560b056a.rG9DZjijgj+FXEBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbI2Vk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robin.murphy@arm.com, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: check nents in dma_sync_sg*
has been added to the -mm tree.  Its filename is
     dma-debug-check-nents-in-dma_sync_sg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-check-nents-in-dma_sync_sg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-check-nents-in-dma_sync_sg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dmapool-fix-overflow-condition-in-pool_find_page.patch
dma-mapping-tidy-up-dma_parms-default-handling.patch
dma-debug-check-nents-in-dma_sync_sg.patch
dma-debug-allow-poisoning-nonzero-allocations.patch

