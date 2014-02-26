From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2.patch
 added to -mm tree
Date: Wed, 26 Feb 2014 15:51:22 -0800
Message-ID: <530e7dfa.duSLQAOqy1NrRI5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaBZXvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alexandre.bounine@idt.com

Subject: + rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2.patch added to -mm tree
To: alexandre.bounine@idt.com
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:51:22 -0800


The patch titled
     Subject: rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2

v2 - fixes compile error if MSI support (CONFIG_PCI_MSI) is disabled.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2 drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -576,9 +576,7 @@ err_out:
 static void tsi721_free_chan_resources(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-#ifdef CONFIG_PCI_MSI
 	struct tsi721_device *priv = to_tsi721(dchan->device);
-#endif
 	LIST_HEAD(list);
 
 	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release.patch
rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release-v2.patch
rapidio-tsi721_dma-optimize-use-of-bdma-descriptors.patch
rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices.patch

