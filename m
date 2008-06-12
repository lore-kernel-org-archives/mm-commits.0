From: akpm@linux-foundation.org
Subject: - forcedeth-msi-interrupts.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:52 -0700
Message-ID: <200806122037.m5CKbq1j005471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184AbYFLUiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, jeff@garzik.org, manfred@colorfullife.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     forcedeth: msi interrupts
has been removed from the -mm tree.  Its filename was
     forcedeth-msi-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: msi interrupts
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add a workaround for lost MSI interrupts.  There is a race condition in
the HW in which future interrupts could be missed.  The workaround is to
toggle the MSI irq mask.

Added cleanup based on comments from Andrew Morton.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-msi-interrupts drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-msi-interrupts
+++ a/drivers/net/forcedeth.c
@@ -3277,6 +3277,20 @@ static void nv_link_irq(struct net_devic
 	dprintk(KERN_DEBUG "%s: link change notification done.\n", dev->name);
 }
 
+static void nv_msi_workaround(struct fe_priv *np)
+{
+
+	/* Need to toggle the msi irq mask within the ethernet device,
+	 * otherwise, future interrupts will not be detected.
+	 */
+	if (np->msi_flags & NV_MSI_ENABLED) {
+		u8 __iomem *base = np->base;
+
+		writel(0, base + NvRegMSIIrqMask);
+		writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+	}
+}
+
 static irqreturn_t nv_nic_irq(int foo, void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
@@ -3299,6 +3313,8 @@ static irqreturn_t nv_nic_irq(int foo, v
 		if (!(events & np->irqmask))
 			break;
 
+		nv_msi_workaround(np);
+
 		spin_lock(&np->lock);
 		nv_tx_done(dev);
 		spin_unlock(&np->lock);
@@ -3414,6 +3430,8 @@ static irqreturn_t nv_nic_irq_optimized(
 		if (!(events & np->irqmask))
 			break;
 
+		nv_msi_workaround(np);
+
 		spin_lock(&np->lock);
 		nv_tx_done_optimized(dev, TX_WORK_PER_LOOP);
 		spin_unlock(&np->lock);
@@ -3754,6 +3772,8 @@ static irqreturn_t nv_nic_irq_test(int f
 	if (!(events & NVREG_IRQ_TIMER))
 		return IRQ_RETVAL(0);
 
+	nv_msi_workaround(np);
+
 	spin_lock(&np->lock);
 	np->intr_test = 1;
 	spin_unlock(&np->lock);
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

origin.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch

