From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-add-outbound-windows-mapping-support.patch added to -mm tree
Date: Mon, 08 Feb 2016 13:22:44 -0800
Message-ID: <56b90724.Iqy2WhEm6xKiJ6cE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbcBHVWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add outbound windows mapping support
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-add-outbound-windows-mapping-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-add-outbound-windows-mapping-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-add-outbound-windows-mapping-support.patch

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
Subject: rapidio/tsi721: add outbound windows mapping support

Add device-specific callback functions to support outbound windows mapping
and release.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |  222 ++++++++++++++++++++++++++++-
 drivers/rapidio/devices/tsi721.h |   20 ++
 2 files changed, 235 insertions(+), 7 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-outbound-windows-mapping-support drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-outbound-windows-mapping-support
+++ a/drivers/rapidio/devices/tsi721.c
@@ -841,6 +841,169 @@ static void tsi721_free_irq(struct tsi72
 	free_irq(priv->pdev->irq, (void *)priv);
 }
 
+static int
+tsi721_obw_alloc(struct tsi721_device *priv, struct tsi721_obw_bar *pbar,
+		 u32 size, int *win_id)
+{
+	u64 win_base;
+	u64 bar_base;
+	u64 bar_end;
+	u32 align;
+	struct tsi721_ob_win *win;
+	struct tsi721_ob_win *new_win = NULL;
+	int new_win_idx = -1;
+	int i = 0;
+
+	bar_base = pbar->base;
+	bar_end =  bar_base + pbar->size;
+	win_base = bar_base;
+	align = size/TSI721_PC2SR_ZONES;
+
+	while (i < TSI721_IBWIN_NUM) {
+		for (i = 0; i < TSI721_IBWIN_NUM; i++) {
+			if (!priv->ob_win[i].active) {
+				if (new_win == NULL) {
+					new_win = &priv->ob_win[i];
+					new_win_idx = i;
+				}
+				continue;
+			}
+
+			/*
+			 * If this window belongs to the current BAR check it
+			 * for overlap
+			 */
+			win = &priv->ob_win[i];
+
+			if (win->base >= bar_base && win->base < bar_end) {
+				if (win_base < (win->base + win->size) &&
+						(win_base + size) > win->base) {
+					/* Overlap detected */
+					win_base = win->base + win->size;
+					win_base = ALIGN(win_base, align);
+					break;
+				}
+			}
+		}
+	}
+
+	if (win_base + size > bar_end)
+		return -ENOMEM;
+
+	if (!new_win) {
+		dev_err(&priv->pdev->dev, "ERR: OBW count tracking failed\n");
+		return -EIO;
+	}
+
+	new_win->active = true;
+	new_win->base = win_base;
+	new_win->size = size;
+	new_win->pbar = pbar;
+	priv->obwin_cnt--;
+	pbar->free -= size;
+	*win_id = new_win_idx;
+	return 0;
+}
+
+static int tsi721_map_outb_win(struct rio_mport *mport, u16 destid, u64 rstart,
+			u32 size, u32 flags, dma_addr_t *laddr)
+{
+	struct tsi721_device *priv = mport->priv;
+	int i;
+	struct tsi721_obw_bar *pbar;
+	struct tsi721_ob_win *ob_win;
+	int obw = -1;
+	u32 rval;
+	u64 rio_addr;
+	u32 zsize;
+	int ret = -ENOMEM;
+
+	if (!is_power_of_2(size) || (size < 0x8000) || (rstart & (size - 1)))
+		return -EINVAL;
+
+	if (priv->obwin_cnt == 0)
+		return -EBUSY;
+
+	for (i = 0; i < 2; i++) {
+		if (priv->p2r_bar[i].free >= size) {
+			pbar = &priv->p2r_bar[i];
+			ret = tsi721_obw_alloc(priv, pbar, size, &obw);
+			if (!ret)
+				break;
+		}
+	}
+
+	if (ret)
+		return ret;
+
+	WARN_ON(obw == -1);
+	ob_win = &priv->ob_win[obw];
+	ob_win->destid = destid;
+	ob_win->rstart = rstart;
+
+	/*
+	 * Configure Outbound Window
+	 */
+
+	zsize = size/TSI721_PC2SR_ZONES;
+	rio_addr = rstart;
+
+	/*
+	 * Program Address Translation Zones:
+	 *  This implementation uses all 8 zones associated wit window.
+	 */
+	for (i = 0; i < TSI721_PC2SR_ZONES; i++) {
+
+		while (ioread32(priv->regs + TSI721_ZONE_SEL) &
+			TSI721_ZONE_SEL_GO) {
+			udelay(1);
+		}
+
+		rval = (u32)(rio_addr & TSI721_LUT_DATA0_ADD) |
+			TSI721_LUT_DATA0_NREAD | TSI721_LUT_DATA0_NWR;
+		iowrite32(rval, priv->regs + TSI721_LUT_DATA0);
+		rval = (u32)(rio_addr >> 32);
+		iowrite32(rval, priv->regs + TSI721_LUT_DATA1);
+		rval = destid;
+		iowrite32(rval, priv->regs + TSI721_LUT_DATA2);
+
+		rval = TSI721_ZONE_SEL_GO | (obw << 3) | i;
+		iowrite32(rval, priv->regs + TSI721_ZONE_SEL);
+
+		rio_addr += zsize;
+	}
+
+	iowrite32(TSI721_OBWIN_SIZE(size) << 8,
+		  priv->regs + TSI721_OBWINSZ(obw));
+	iowrite32((u32)(ob_win->base >> 32), priv->regs + TSI721_OBWINUB(obw));
+	iowrite32((u32)(ob_win->base & TSI721_OBWINLB_BA) | TSI721_OBWINLB_WEN,
+		  priv->regs + TSI721_OBWINLB(obw));
+
+	*laddr = ob_win->base;
+	return 0;
+}
+
+static void tsi721_unmap_outb_win(struct rio_mport *mport,
+				  u16 destid, u64 rstart)
+{
+	struct tsi721_device *priv = mport->priv;
+	struct tsi721_ob_win *ob_win;
+	int i;
+
+	for (i = 0; i < TSI721_OBWIN_NUM; i++) {
+		ob_win = &priv->ob_win[i];
+
+		if (ob_win->active &&
+		    ob_win->destid == destid && ob_win->rstart == rstart) {
+			ob_win->active = false;
+			iowrite32(0, priv->regs + TSI721_OBWINLB(i));
+			ob_win->pbar->free += ob_win->size;
+			priv->obwin_cnt++;
+			break;
+		}
+	}
+}
+
 /**
  * tsi721_init_pc2sr_mapping - initializes outbound (PCIe->SRIO)
  * translation regions.
@@ -850,11 +1013,41 @@ static void tsi721_free_irq(struct tsi72
  */
 static void tsi721_init_pc2sr_mapping(struct tsi721_device *priv)
 {
-	int i;
+	int i, z;
+	u32 rval;
 
 	/* Disable all PC2SR translation windows */
 	for (i = 0; i < TSI721_OBWIN_NUM; i++)
 		iowrite32(0, priv->regs + TSI721_OBWINLB(i));
+
+	/* Initialize zone lookup tables to avoid ECC errors on reads */
+	iowrite32(0, priv->regs + TSI721_LUT_DATA0);
+	iowrite32(0, priv->regs + TSI721_LUT_DATA1);
+	iowrite32(0, priv->regs + TSI721_LUT_DATA2);
+
+	for (i = 0; i < TSI721_OBWIN_NUM; i++) {
+		for (z = 0; z < TSI721_PC2SR_ZONES; z++) {
+			while (ioread32(priv->regs + TSI721_ZONE_SEL) &
+				TSI721_ZONE_SEL_GO) {
+				udelay(1);
+			}
+			rval = TSI721_ZONE_SEL_GO | (i << 3) | z;
+			iowrite32(rval, priv->regs + TSI721_ZONE_SEL);
+		}
+	}
+
+	if (priv->p2r_bar[0].size == 0 && priv->p2r_bar[1].size == 0) {
+		priv->obwin_cnt = 0;
+		return;
+	}
+
+	priv->p2r_bar[0].free = priv->p2r_bar[0].size;
+	priv->p2r_bar[1].free = priv->p2r_bar[1].size;
+
+	for (i = 0; i < TSI721_OBWIN_NUM; i++)
+		priv->ob_win[i].active = false;
+
+	priv->obwin_cnt = TSI721_OBWIN_NUM;
 }
 
 /**
@@ -2418,6 +2611,8 @@ static struct rio_ops tsi721_rio_ops = {
 	.unmap_inb		= tsi721_rio_unmap_inb_mem,
 	.pwenable		= tsi721_pw_enable,
 	.query_mport		= tsi721_query_mport,
+	.map_outb		= tsi721_map_outb_win,
+	.unmap_outb		= tsi721_unmap_outb_win,
 };
 
 static void tsi721_mport_release(struct device *dev)
@@ -2573,14 +2768,27 @@ static int tsi721_probe(struct pci_dev *
 	 * It may be a good idea to keep them disabled using HW configuration
 	 * to save PCI memory space.
 	 */
-	if ((pci_resource_flags(pdev, BAR_2) & IORESOURCE_MEM) &&
-	    (pci_resource_flags(pdev, BAR_2) & IORESOURCE_MEM_64)) {
-		dev_info(&pdev->dev, "Outbound BAR2 is not used but enabled.\n");
+
+	priv->p2r_bar[0].size = priv->p2r_bar[1].size = 0;
+
+	if (pci_resource_flags(pdev, BAR_2) & IORESOURCE_MEM_64) {
+		if (pci_resource_flags(pdev, BAR_2) & IORESOURCE_PREFETCH)
+			dev_info(&pdev->dev,
+				 "Prefetchable OBW BAR2 will not be used\n");
+		else {
+			priv->p2r_bar[0].base = pci_resource_start(pdev, BAR_2);
+			priv->p2r_bar[0].size = pci_resource_len(pdev, BAR_2);
+		}
 	}
 
-	if ((pci_resource_flags(pdev, BAR_4) & IORESOURCE_MEM) &&
-	    (pci_resource_flags(pdev, BAR_4) & IORESOURCE_MEM_64)) {
-		dev_info(&pdev->dev, "Outbound BAR4 is not used but enabled.\n");
+	if (pci_resource_flags(pdev, BAR_4) & IORESOURCE_MEM_64) {
+		if (pci_resource_flags(pdev, BAR_4) & IORESOURCE_PREFETCH)
+			dev_info(&pdev->dev,
+				 "Prefetchable OBW BAR4 will not be used\n");
+		else {
+			priv->p2r_bar[1].base = pci_resource_start(pdev, BAR_4);
+			priv->p2r_bar[1].size = pci_resource_len(pdev, BAR_4);
+		}
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-outbound-windows-mapping-support drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-outbound-windows-mapping-support
+++ a/drivers/rapidio/devices/tsi721.h
@@ -822,6 +822,21 @@ struct tsi721_ib_win {
 	struct list_head mappings;
 };
 
+struct tsi721_obw_bar {
+	u64		base;
+	u64		size;
+	u64		free;
+};
+
+struct tsi721_ob_win {
+	u64		base;
+	u32		size;
+	u16		destid;
+	u64		rstart;
+	bool		active;
+	struct tsi721_obw_bar *pbar;
+};
+
 struct tsi721_device {
 	struct pci_dev	*pdev;
 	struct rio_mport mport;
@@ -861,6 +876,11 @@ struct tsi721_device {
 	/* Inbound Mapping Windows */
 	struct tsi721_ib_win ib_win[TSI721_IBWIN_NUM];
 	int		ibwin_cnt;
+
+	/* Outbound Mapping Windows */
+	struct tsi721_obw_bar p2r_bar[2];
+	struct tsi721_ob_win  ob_win[TSI721_OBWIN_NUM];
+	int		obwin_cnt;
 };
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch

