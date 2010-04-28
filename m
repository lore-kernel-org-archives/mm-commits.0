From: akpm@linux-foundation.org
Subject: + mmc-atmel-mci-add-support-for-sdio-interrupts.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:25:13 -0700
Message-ID: <201004281825.o3SIPDgS011942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075Ab0D1SZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anders.grahn@hd-wireless.se, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com


The patch titled
     mmc: atmel-mci: Add support for SDIO interrupts
has been added to the -mm tree.  Its filename is
     mmc-atmel-mci-add-support-for-sdio-interrupts.patch

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
Subject: mmc: atmel-mci: Add support for SDIO interrupts
From: Anders Grahn <anders.grahn@hd-wireless.se>

Atmel-mci support for SDIO interrupts.  This adds the enable_sdio_irq()
function and the configuration of sdio irq mask per slot.  With this irq
mask information, we keep the idea of multiple slot per sd/mmc host (not
only A and B).  MMC_CAP_SDIO_IRQ is added according to slot configuration.

A new little function is added to run mmc_signal_sdio_irq() during
interrupt handling routine.

Signed-off-by: Anders Grahn <anders.grahn@hd-wireless.se>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |   42 +++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-add-support-for-sdio-interrupts drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-add-support-for-sdio-interrupts
+++ a/drivers/mmc/host/atmel-mci.c
@@ -173,6 +173,7 @@ struct atmel_mci {
  * @mmc: The mmc_host representing this slot.
  * @host: The MMC controller this slot is using.
  * @sdc_reg: Value of SDCR to be written before using this slot.
+ * @sdio_irq: SDIO irq mask for this slot.
  * @mrq: mmc_request currently being processed or waiting to be
  *	processed, or NULL when the slot is idle.
  * @queue_node: List node for placing this node in the @queue list of
@@ -191,6 +192,7 @@ struct atmel_mci_slot {
 	struct atmel_mci	*host;
 
 	u32			sdc_reg;
+	u32			sdio_irq;
 
 	struct mmc_request	*mrq;
 	struct list_head	queue_node;
@@ -792,7 +794,7 @@ static void atmci_start_request(struct a
 	mci_writel(host, SDCR, slot->sdc_reg);
 
 	iflags = mci_readl(host, IMR);
-	if (iflags)
+	if (iflags & ~(MCI_SDIOIRQA | MCI_SDIOIRQB))
 		dev_warn(&slot->mmc->class_dev, "WARNING: IMR=0x%08x\n",
 				iflags);
 
@@ -1041,11 +1043,23 @@ static int atmci_get_cd(struct mmc_host 
 	return present;
 }
 
+static void atmci_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct atmel_mci_slot	*slot = mmc_priv(mmc);
+	struct atmel_mci	*host = slot->host;
+
+	if (enable)
+		mci_writel(host, IER, slot->sdio_irq);
+	else
+		mci_writel(host, IDR, slot->sdio_irq);
+}
+
 static const struct mmc_host_ops atmci_ops = {
 	.request	= atmci_request,
 	.set_ios	= atmci_set_ios,
 	.get_ro		= atmci_get_ro,
 	.get_cd		= atmci_get_cd,
+	.enable_sdio_irq = atmci_enable_sdio_irq,
 };
 
 /* Called with host->lock held */
@@ -1497,6 +1511,19 @@ static void atmci_cmd_interrupt(struct a
 	tasklet_schedule(&host->tasklet);
 }
 
+static void atmci_sdio_interrupt(struct atmel_mci *host, u32 status)
+{
+	int	i;
+
+	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+		struct atmel_mci_slot *slot = host->slot[i];
+		if (slot && (status & slot->sdio_irq)) {
+			mmc_signal_sdio_irq(slot->mmc);
+		}
+	}
+}
+
+
 static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 {
 	struct atmel_mci	*host = dev_id;
@@ -1536,6 +1563,10 @@ static irqreturn_t atmci_interrupt(int i
 
 		if (pending & MCI_CMDRDY)
 			atmci_cmd_interrupt(host, status);
+
+		if (pending & (MCI_SDIOIRQA | MCI_SDIOIRQB))
+			atmci_sdio_interrupt(host, status);
+
 	} while (pass_count++ < 5);
 
 	return pass_count ? IRQ_HANDLED : IRQ_NONE;
@@ -1558,7 +1589,7 @@ static irqreturn_t atmci_detect_interrup
 
 static int __init atmci_init_slot(struct atmel_mci *host,
 		struct mci_slot_pdata *slot_data, unsigned int id,
-		u32 sdc_reg)
+		u32 sdc_reg, u32 sdio_irq)
 {
 	struct mmc_host			*mmc;
 	struct atmel_mci_slot		*slot;
@@ -1574,11 +1605,14 @@ static int __init atmci_init_slot(struct
 	slot->wp_pin = slot_data->wp_pin;
 	slot->detect_is_active_high = slot_data->detect_is_active_high;
 	slot->sdc_reg = sdc_reg;
+	slot->sdio_irq = sdio_irq;
 
 	mmc->ops = &atmci_ops;
 	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (sdio_irq)
+		mmc->caps |= MMC_CAP_SDIO_IRQ;
 	if (atmci_is_mci2())
 		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
 	if (slot_data->bus_width >= 4)
@@ -1769,13 +1803,13 @@ static int __init atmci_probe(struct pla
 	ret = -ENODEV;
 	if (pdata->slot[0].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[0],
-				0, MCI_SDCSEL_SLOT_A);
+				0, MCI_SDCSEL_SLOT_A, MCI_SDIOIRQA);
 		if (!ret)
 			nr_slots++;
 	}
 	if (pdata->slot[1].bus_width) {
 		ret = atmci_init_slot(host, &pdata->slot[1],
-				1, MCI_SDCSEL_SLOT_B);
+				1, MCI_SDCSEL_SLOT_B, MCI_SDIOIRQB);
 		if (!ret)
 			nr_slots++;
 	}
_

Patches currently in -mm which might be from anders.grahn@hd-wireless.se are

mmc-atmel-mci-fix-two-parameters-swapped.patch
mmc-atmel-mci-add-support-for-sdio-interrupts.patch

