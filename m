From: akpm@linux-foundation.org
Subject: + dmatest-properly-handle-duplicate-dma-channels.patch added to -mm tree
Date: Fri, 19 Sep 2008 16:32:34 -0700
Message-ID: <200809192332.m8JNWYON012019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbYISXcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 19:32:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timur@freescale.com, dan.j.williams@intel.com, haavard.skinnemoen@atmel.com


The patch titled
     dmatest: properly handle duplicate DMA channels
has been added to the -mm tree.  Its filename is
     dmatest-properly-handle-duplicate-dma-channels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmatest: properly handle duplicate DMA channels
From: Timur Tabi <timur@freescale.com>

Update the the dmatest driver so that it handles duplicate DMA channels
properly.

When a DMA client is notified of an available DMA channel, it must check
if it has already allocated resources for that channel.  If so, it should
return DMA_DUP.  This can happen, for example, if a DMA driver calls
dma_async_device_register() more than once.

Signed-off-by: Timur Tabi <timur@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/dma/dmatest.c~dmatest-properly-handle-duplicate-dma-channels drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmatest-properly-handle-duplicate-dma-channels
+++ a/drivers/dma/dmatest.c
@@ -321,10 +321,15 @@ static void dmatest_cleanup_channel(stru
 
 static enum dma_state_client dmatest_add_channel(struct dma_chan *chan)
 {
-	struct dmatest_chan	*dtc;
+	struct dmatest_chan	*dtc, *_dtc;
 	struct dmatest_thread	*thread;
 	unsigned int		i;
 
+	/* Have we already been told about this channel? */
+	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node)
+		if (dtc->chan == chan)
+			return DMA_DUP;
+
 	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
 	if (!dtc) {
 		pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);
_

Patches currently in -mm which might be from timur@freescale.com are

linux-next.patch
dmatest-properly-handle-duplicate-dma-channels.patch
drivers-dma-dmatestc-switch-a-gfp_atomic-to-gfp_kernel.patch

