From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release.patch removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:49 -0800
Message-ID: <5318dc9d.02I22xTwyvjkzmDE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaCFUhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xtfeng@gmail.com, tglx@linutronix.de, stable@vger.kernel.org, mporter@kernel.crashing.org, bitbucket@online.de, alexandre.bounine@idt.com

Subject: [merged] rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release.patch removed from -mm tree
To: alexandre.bounine@idt.com,bitbucket@online.de,mporter@kernel.crashing.org,stable@vger.kernel.org,tglx@linutronix.de,xtfeng@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:49 -0800


The patch titled
     Subject: rapidio/tsi721: fix tasklet termination in dma channel release
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix tasklet termination in dma channel release

This patch is a modification of the patch originally proposed by Xiaotian
Feng <xtfeng@gmail.com>: https://lkml.org/lkml/2012/11/5/413 This new
version disables DMA channel interrupts and ensures that the tasklet wil
not be scheduled again before calling tasklet_kill().

Unfortunately the updated patch was not released at that time due to
planned rework of Tsi721 mport driver to use threaded interrupts (which
has yet to happen).  Recently the issue was reported again:
https://lkml.org/lkml/2014/2/19/762.

Description from the original Xiaotian's patch:

"Some drivers use tasklet_disable in device remove/release process,
tasklet_disable will inc tasklet->count and return.  If the tasklet is not
handled yet under some softirq pressure, the tasklet will be placed on the
tasklet_vec, never have a chance to be excuted.  This might lead to a
heavy loaded ksoftirqd, wakeup with pending_softirq, but tasklet is
disabled.  tasklet_kill should be used in this case."

This patch is applicable to kernel versions starting from v3.5.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: <stable@vger.kernel.org>	[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.h     |    1 
 drivers/rapidio/devices/tsi721_dma.c |   27 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release
+++ a/drivers/rapidio/devices/tsi721.h
@@ -678,6 +678,7 @@ struct tsi721_bdma_chan {
 	struct list_head	free_list;
 	dma_cookie_t		completed_cookie;
 	struct tasklet_struct	tasklet;
+	bool			active;
 };
 
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-fix-tasklet-termination-in-dma-channel-release
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -206,8 +206,8 @@ void tsi721_bdma_handler(struct tsi721_b
 {
 	/* Disable BDMA channel interrupts */
 	iowrite32(0, bdma_chan->regs + TSI721_DMAC_INTE);
-
-	tasklet_schedule(&bdma_chan->tasklet);
+	if (bdma_chan->active)
+		tasklet_schedule(&bdma_chan->tasklet);
 }
 
 #ifdef CONFIG_PCI_MSI
@@ -562,7 +562,7 @@ static int tsi721_alloc_chan_resources(s
 	}
 #endif /* CONFIG_PCI_MSI */
 
-	tasklet_enable(&bdma_chan->tasklet);
+	bdma_chan->active = true;
 	tsi721_bdma_interrupt_enable(bdma_chan, 1);
 
 	return bdma_chan->bd_num - 1;
@@ -576,9 +576,7 @@ err_out:
 static void tsi721_free_chan_resources(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-#ifdef CONFIG_PCI_MSI
 	struct tsi721_device *priv = to_tsi721(dchan->device);
-#endif
 	LIST_HEAD(list);
 
 	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
@@ -589,14 +587,25 @@ static void tsi721_free_chan_resources(s
 	BUG_ON(!list_empty(&bdma_chan->active_list));
 	BUG_ON(!list_empty(&bdma_chan->queue));
 
-	tasklet_disable(&bdma_chan->tasklet);
+	tsi721_bdma_interrupt_enable(bdma_chan, 0);
+	bdma_chan->active = false;
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX) {
+		synchronize_irq(priv->msix[TSI721_VECT_DMA0_DONE +
+					   bdma_chan->id].vector);
+		synchronize_irq(priv->msix[TSI721_VECT_DMA0_INT +
+					   bdma_chan->id].vector);
+	} else
+#endif
+	synchronize_irq(priv->pdev->irq);
+
+	tasklet_kill(&bdma_chan->tasklet);
 
 	spin_lock_bh(&bdma_chan->lock);
 	list_splice_init(&bdma_chan->free_list, &list);
 	spin_unlock_bh(&bdma_chan->lock);
 
-	tsi721_bdma_interrupt_enable(bdma_chan, 0);
-
 #ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		free_irq(priv->msix[TSI721_VECT_DMA0_DONE +
@@ -790,6 +799,7 @@ int tsi721_register_dma(struct tsi721_de
 		bdma_chan->dchan.cookie = 1;
 		bdma_chan->dchan.chan_id = i;
 		bdma_chan->id = i;
+		bdma_chan->active = false;
 
 		spin_lock_init(&bdma_chan->lock);
 
@@ -799,7 +809,6 @@ int tsi721_register_dma(struct tsi721_de
 
 		tasklet_init(&bdma_chan->tasklet, tsi721_dma_tasklet,
 			     (unsigned long)bdma_chan);
-		tasklet_disable(&bdma_chan->tasklet);
 		list_add_tail(&bdma_chan->dchan.device_node,
 			      &mport->dma.channels);
 	}
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-tsi721_dma-optimize-use-of-bdma-descriptors.patch
rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices.patch

