From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 13:22:02 -0800
Message-ID: <56b906fa.twAyZrxI9eM1xd3N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcBHVWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add option to configure direct mapping of IB window
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch

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
Subject: rapidio/tsi721: add option to configure direct mapping of IB window

Add an option to configure mapping of Inbound Window without RIO-to-PCIe
address translation.

If a local memory buffer is not properly aligned to meet HW requirements
for RapidIO address mapping with address translation, caller can request
an inbound window with matching RapidIO address assigned to it.  This
implementation selects RapidIO base address and size for inbound window
that are capable to accommodate the local memory buffer.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |  163 +++++++++++++++++++++++------
 drivers/rapidio/devices/tsi721.h |    9 +
 2 files changed, 142 insertions(+), 30 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window
+++ a/drivers/rapidio/devices/tsi721.c
@@ -888,71 +888,145 @@ static int tsi721_rio_map_inb_mem(struct
 	int i, avail = -1;
 	u32 regval;
 	struct tsi721_ib_win *ib_win;
+	bool direct = (lstart == rstart);
+	u64 ibw_size;
+	dma_addr_t loc_start;
+	u64 ibw_start;
+	struct tsi721_ib_win_mapping *map = NULL;
 	int ret = -EBUSY;
 
-	if (!is_power_of_2(size) || size < 0x1000 ||
-	    ((u64)lstart & (size - 1)) || (rstart & (size - 1)))
-		return -EINVAL;
+	if (direct) {
+		dev_dbg(&priv->pdev->dev,
+			"Direct (RIO_0x%llx -> PCIe_0x%pad), size=0x%x",
+			rstart, &lstart, size);
+
+		/* Calculate minimal acceptable window size and base address */
+
+		ibw_size = roundup_pow_of_two(size);
+		ibw_start = lstart & ~(ibw_size - 1);
+
+		while ((lstart + size) > (ibw_start + ibw_size)) {
+			ibw_size *= 2;
+			ibw_start = lstart & ~(ibw_size - 1);
+			if (ibw_size > 0x80000000) { /* Limit max size to 2GB */
+				return -EBUSY;
+			}
+		}
+
+		loc_start = ibw_start;
+
+		map = kzalloc(sizeof(struct tsi721_ib_win_mapping), GFP_ATOMIC);
+		if (map == NULL)
+			return -ENOMEM;
+
+	} else {
+		dev_dbg(&priv->pdev->dev,
+			"Translated (RIO_0x%llx -> PCIe_0x%pad), size=0x%x",
+			rstart, &lstart, size);
+
+		if (!is_power_of_2(size) || size < 0x1000 ||
+		    ((u64)lstart & (size - 1)) || (rstart & (size - 1)))
+			return -EINVAL;
+		if (priv->ibwin_cnt == 0)
+			return -EBUSY;
+		ibw_start = rstart;
+		ibw_size = size;
+		loc_start = lstart;
+	}
 
-	spin_lock(&priv->win_lock);
 	/*
 	 * Scan for overlapping with active regions and mark the first available
 	 * IB window at the same time.
 	 */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
 		ib_win = &priv->ib_win[i];
+
 		if (!ib_win->active) {
 			if (avail == -1) {
 				avail = i;
 				ret = 0;
 			}
-		} else if (rstart < (ib_win->rstart + ib_win->size) &&
-					(rstart + size) > ib_win->rstart) {
+		} else if (ibw_start < (ib_win->rstart + ib_win->size) &&
+			   (ibw_start + ibw_size) > ib_win->rstart) {
+			/* Return error if address translation involved */
+			if (direct && ib_win->xlat) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/*
+			 * Direct mappings usually are larger than originally
+			 * requested fragments - check if this new request fits
+			 * into it.
+			 */
+			if (rstart >= ib_win->rstart &&
+			    (rstart + size) <= (ib_win->rstart +
+							ib_win->size)) {
+				/* We are in - no further mapping required */
+				map->lstart = lstart;
+				list_add_tail(&map->node, &ib_win->mappings);
+				return 0;
+			}
+
 			ret = -EFAULT;
 			break;
 		}
 	}
 
 	if (ret)
-		goto err_out;
+		goto out;
 	i = avail;
 
 	/* Sanity check: available IB window must be disabled at this point */
 	regval = ioread32(priv->regs + TSI721_IBWIN_LB(i));
 	if (WARN_ON(regval & TSI721_IBWIN_LB_WEN)) {
 		ret = -EIO;
-		goto err_out;
+		goto out;
 	}
 
 	ib_win = &priv->ib_win[i];
 	ib_win->active = true;
-	ib_win->rstart = rstart;
-	ib_win->lstart = lstart;
-	ib_win->size = size;
-	spin_unlock(&priv->win_lock);
+	ib_win->rstart = ibw_start;
+	ib_win->lstart = loc_start;
+	ib_win->size = ibw_size;
+	ib_win->xlat = (lstart != rstart);
+	INIT_LIST_HEAD(&ib_win->mappings);
 
-	iowrite32(TSI721_IBWIN_SIZE(size) << 8,
+	/*
+	 * When using direct IBW mapping and have larger than requested IBW size
+	 * we can have multiple local memory blocks mapped through the same IBW
+	 * To handle this situation we maintain list of "clients" for such IBWs.
+	 */
+	if (direct) {
+		map->lstart = lstart;
+		list_add_tail(&map->node, &ib_win->mappings);
+	}
+
+	iowrite32(TSI721_IBWIN_SIZE(ibw_size) << 8,
 			priv->regs + TSI721_IBWIN_SZ(i));
 
-	iowrite32(((u64)lstart >> 32), priv->regs + TSI721_IBWIN_TUA(i));
-	iowrite32(((u64)lstart & TSI721_IBWIN_TLA_ADD),
+	iowrite32(((u64)loc_start >> 32), priv->regs + TSI721_IBWIN_TUA(i));
+	iowrite32(((u64)loc_start & TSI721_IBWIN_TLA_ADD),
 		  priv->regs + TSI721_IBWIN_TLA(i));
 
-	iowrite32(rstart >> 32, priv->regs + TSI721_IBWIN_UB(i));
-	iowrite32((rstart & TSI721_IBWIN_LB_BA) | TSI721_IBWIN_LB_WEN,
+	iowrite32(ibw_start >> 32, priv->regs + TSI721_IBWIN_UB(i));
+	iowrite32((ibw_start & TSI721_IBWIN_LB_BA) | TSI721_IBWIN_LB_WEN,
 		priv->regs + TSI721_IBWIN_LB(i));
+
+	priv->ibwin_cnt--;
+
 	dev_dbg(&priv->pdev->dev,
-		"Configured IBWIN%d mapping (RIO_0x%llx -> PCIe_0x%llx)\n",
-		i, rstart, (unsigned long long)lstart);
+		"Configured IBWIN%d (RIO_0x%llx -> PCIe_0x%llx), size=0x%llx\n",
+		i, ibw_start, (unsigned long long)loc_start, ibw_size);
 
 	return 0;
-err_out:
-	spin_unlock(&priv->win_lock);
+out:
+	kfree(map);
 	return ret;
 }
 
 /**
- * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * tsi721_rio_unmap_inb_mem -- Unmapping inbound memory region.
  * @mport: RapidIO master port
  * @lstart: Local memory space start address.
  */
@@ -963,22 +1037,53 @@ static void tsi721_rio_unmap_inb_mem(str
 	struct tsi721_ib_win *ib_win;
 	int i;
 
+	dev_dbg(&priv->pdev->dev,
+		"Unmap IBW mapped to PCIe_0x%pad", &lstart);
+
 	/* Search for matching active inbound translation window */
-	spin_lock(&priv->win_lock);
 	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
 		ib_win = &priv->ib_win[i];
-		if (ib_win->active && ib_win->lstart == lstart) {
+
+		/* Address translating IBWs must to be an exact march */
+		if (!ib_win->active ||
+		    (ib_win->xlat && lstart != ib_win->lstart))
+			continue;
+
+		if (lstart >= ib_win->lstart &&
+		    lstart < (ib_win->lstart + ib_win->size)) {
+
+			if (!ib_win->xlat) {
+				struct tsi721_ib_win_mapping *map;
+				int found = 0;
+
+				list_for_each_entry(map,
+						    &ib_win->mappings, node) {
+					if (map->lstart == lstart) {
+						list_del(&map->node);
+						kfree(map);
+						found = 1;
+						break;
+					}
+				}
+
+				if (!found)
+					continue;
+
+				if (!list_empty(&ib_win->mappings))
+					break;
+			}
+
+			dev_dbg(&priv->pdev->dev, "Disable IBWIN_%d", i);
 			iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
 			ib_win->active = false;
+			priv->ibwin_cnt++;
 			break;
 		}
 	}
-	spin_unlock(&priv->win_lock);
 
 	if (i == TSI721_IBWIN_NUM)
-		dev_err(&priv->pdev->dev,
-			"IB window mapped to %llx not found\n",
-			(unsigned long long)lstart);
+		dev_dbg(&priv->pdev->dev,
+			"IB window mapped to %pad not found", &lstart);
 }
 
 /**
@@ -995,7 +1100,7 @@ static void tsi721_init_sr2pc_mapping(st
 	/* Disable all SR2PC inbound windows */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++)
 		iowrite32(0, priv->regs + TSI721_IBWIN_LB(i));
-	spin_lock_init(&priv->win_lock);
+	priv->ibwin_cnt = TSI721_IBWIN_NUM;
 }
 
 /**
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window
+++ a/drivers/rapidio/devices/tsi721.h
@@ -808,11 +808,18 @@ struct msix_irq {
 };
 #endif /* CONFIG_PCI_MSI */
 
+struct tsi721_ib_win_mapping {
+	struct list_head node;
+	dma_addr_t	lstart;
+};
+
 struct tsi721_ib_win {
 	u64		rstart;
 	u32		size;
 	dma_addr_t	lstart;
 	bool		active;
+	bool		xlat;
+	struct list_head mappings;
 };
 
 struct tsi721_device {
@@ -853,7 +860,7 @@ struct tsi721_device {
 
 	/* Inbound Mapping Windows */
 	struct tsi721_ib_win ib_win[TSI721_IBWIN_NUM];
-	spinlock_t	win_lock;
+	int		ibwin_cnt;
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

