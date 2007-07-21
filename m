From: akpm@linux-foundation.org
Subject: - fix-dma-on-dreamcast.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:27:23 -0700
Message-ID: <200707211027.l6LARNmE012064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbXGUK2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrianmcmenamin@gmail.com, adrian@mcmen.demon.co.uk, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Fix DMA on Dreamcast
has been removed from the -mm tree.  Its filename was
     fix-dma-on-dreamcast.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: Fix DMA on Dreamcast
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>

-ENOCHANGELOG

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/drivers/dma/dma-api.c |   11 ++++++-----
 include/asm-sh/dma.h          |    1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/sh/drivers/dma/dma-api.c~fix-dma-on-dreamcast arch/sh/drivers/dma/dma-api.c
--- a/arch/sh/drivers/dma/dma-api.c~fix-dma-on-dreamcast
+++ a/arch/sh/drivers/dma/dma-api.c
@@ -31,8 +31,8 @@ struct dma_info *get_dma_info(unsigned i
 	 * the channel is.
 	 */
 	list_for_each_entry(info, &registered_dmac_list, list) {
-		if ((chan <  info->first_channel_nr) ||
-		    (chan >= info->first_channel_nr + info->nr_channels))
+		if ((chan <  info->first_vchannel_nr) ||
+		    (chan >= info->first_vchannel_nr + info->nr_channels))
 			continue;
 
 		return info;
@@ -82,7 +82,7 @@ struct dma_channel *get_dma_channel(unsi
 
 	for (i = 0; i < info->nr_channels; i++) {
 		channel = &info->channels[i];
-		if (channel->chan == chan)
+		if (channel->chan == (chan - info->first_vchannel_nr))
 			return channel;
 	}
 
@@ -183,6 +183,7 @@ int dmac_search_free_channel(const char 
 			return result;
 
 		atomic_set(&channel->busy, 1);
+
 		return channel->chan;
 	}
 
@@ -194,7 +195,6 @@ int request_dma(unsigned int chan, const
 	struct dma_channel *channel = { 0 };
 	struct dma_info *info = get_dma_info(chan);
 	int result;
-
 	channel = get_dma_channel(chan);
 	if (atomic_xchg(&channel->busy, 1))
 		return -EBUSY;
@@ -369,6 +369,7 @@ int register_dmac(struct dma_info *info)
 	}
 
 	total_channels = get_nr_channels();
+	info->first_vchannel_nr = total_channels;
 	for (i = 0; i < info->nr_channels; i++) {
 		struct dma_channel *chan = &info->channels[i];
 
@@ -387,7 +388,7 @@ int register_dmac(struct dma_info *info)
 	}
 
 	list_add(&info->list, &registered_dmac_list);
-
+
 	return 0;
 }
 EXPORT_SYMBOL(register_dmac);
diff -puN include/asm-sh/dma.h~fix-dma-on-dreamcast include/asm-sh/dma.h
--- a/include/asm-sh/dma.h~fix-dma-on-dreamcast
+++ a/include/asm-sh/dma.h
@@ -111,6 +111,7 @@ struct dma_info {
 
 	struct list_head list;
 	int first_channel_nr;
+	int first_vchannel_nr;
 };
 
 struct dma_chan_caps {
_

Patches currently in -mm which might be from adrianmcmenamin@gmail.com are
