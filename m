From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:41:17 -0700
Message-ID: <56f2d53d.ELWXyvJobUSShFhX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbcCWRlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add check for overlapped IB window mappings
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: add check for overlapped IB window mappings

Add check for attempts to request mapping of inbound RapidIO address space
that overlaps with existing active mapping windows.

Tsi721 device does not support overlapped inbound windows and SRIO address
decoding behavior is not defined in such cases.

This patch is applicable to kernel versions starting from v3.7.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   72 ++++++++++++++++++++---------
 drivers/rapidio/devices/tsi721.h |   11 ++++
 2 files changed, 62 insertions(+), 21 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-check-for-overlapped-ib-window-mappings drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-check-for-overlapped-ib-window-mappings
+++ a/drivers/rapidio/devices/tsi721.c
@@ -885,26 +885,52 @@ static int tsi721_rio_map_inb_mem(struct
 		u64 rstart, u32 size, u32 flags)
 {
 	struct tsi721_device *priv = mport->priv;
-	int i;
+	int i, avail = -1;
 	u32 regval;
+	struct tsi721_ib_win *ib_win;
+	int ret = -EBUSY;
 
 	if (!is_power_of_2(size) || size < 0x1000 ||
 	    ((u64)lstart & (size - 1)) || (rstart & (size - 1)))
 		return -EINVAL;
 
-	/* Search for free inbound translation window */
+	spin_lock(&priv->win_lock);
+	/*
+	 * Scan for overlapping with active regions and mark the first available
+	 * IB window at the same time.
+	 */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
-		regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
-		if (!(regval & TSI721_IBWIN_LB_WEN))
+		ib_win = &priv->ib_win[i];
+		if (!ib_win->active) {
+			if (avail == -1) {
+				avail = i;
+				ret = 0;
+			}
+		} else if (rstart < (ib_win->rstart + ib_win->size) &&
+					(rstart + size) > ib_win->rstart) {
+			ret = -EFAULT;
 			break;
+		}
 	}
 
-	if (i >= TSI721_IBWIN_NUM) {
-		dev_err(&priv->pdev->dev,
-			"Unable to find free inbound window\n");
-		return -EBUSY;
+	if (ret)
+		goto err_out;
+	i = avail;
+
+	/* Sanity check: available IB window must be disabled at this point */
+	regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
+	if (WARN_ON(regval & TSI721_IBWIN_LB_WEN)) {
+		ret = -EIO;
+		goto err_out;
 	}
 
+	ib_win = &priv->ib_win[i];
+	ib_win->active = true;
+	ib_win->rstart = rstart;
+	ib_win->lstart = lstart;
+	ib_win->size = size;
+	spin_unlock(&priv->win_lock);
+
 	iowrite32(TSI721_IBWIN_SIZE(size) << 8,
 			priv->regs + TSI721_IBWIN_SZ(i));
 
@@ -920,6 +946,9 @@ static int tsi721_rio_map_inb_mem(struct
 		i, rstart, (unsigned long long)lstart);
 
 	return 0;
+err_out:
+	spin_unlock(&priv->win_lock);
+	return ret;
 }
 
 /**
@@ -931,25 +960,25 @@ static void tsi721_rio_unmap_inb_mem(str
 				dma_addr_t lstart)
 {
 	struct tsi721_device *priv = mport->priv;
+	struct tsi721_ib_win *ib_win;
 	int i;
-	u64 addr;
-	u32 regval;
 
 	/* Search for matching active inbound translation window */
+	spin_lock(&priv->win_lock);
 	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
-		regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
-		if (regval & TSI721_IBWIN_LB_WEN) {
-			regval = ioread32(priv->regs + TSI721_IBWIN_TUA(i));
-			addr = (u64)regval << 32;
-			regval = ioread32(priv->regs + TSI721_IBWIN_TLA(i));
-			addr |= regval & TSI721_IBWIN_TLA_ADD;
-
-			if (addr == (u64)lstart) {
-				iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
-				break;
-			}
+		ib_win = &priv->ib_win[i];
+		if (ib_win->active && ib_win->lstart == lstart) {
+			iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
+			ib_win->active = false;
+			break;
 		}
 	}
+	spin_unlock(&priv->win_lock);
+
+	if (i == TSI721_IBWIN_NUM)
+		dev_err(&priv->pdev->dev,
+			"IB window mapped to %llx not found\n",
+			(unsigned long long)lstart);
 }
 
 /**
@@ -966,6 +995,7 @@ static void tsi721_init_sr2pc_mapping(st
 	/* Disable all SR2PC inbound windows */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++)
 		iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
+	spin_lock_init(&priv->win_lock);
 }
 
 /**
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-check-for-overlapped-ib-window-mappings drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-check-for-overlapped-ib-window-mappings
+++ a/drivers/rapidio/devices/tsi721.h
@@ -808,6 +808,13 @@ struct msix_irq {
 };
 #endif /* CONFIG_PCI_MSI */
 
+struct tsi721_ib_win {
+	u64		rstart;
+	u32		size;
+	dma_addr_t	lstart;
+	bool		active;
+};
+
 struct tsi721_device {
 	struct pci_dev	*pdev;
 	struct rio_mport *mport;
@@ -843,6 +850,10 @@ struct tsi721_device {
 	/* Outbound Messaging */
 	int		omsg_init[TSI721_OMSG_CHNUM];
 	struct tsi721_omsg_ring	omsg_ring[TSI721_OMSG_CHNUM];
+
+	/* Inbound Mapping Windows */
+	struct tsi721_ib_win ib_win[TSI721_IBWIN_NUM];
+	spinlock_t	win_lock;
 };
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


