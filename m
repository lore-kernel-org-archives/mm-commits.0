From: akpm@linux-foundation.org
Subject: + sata_promise-sata-hotplug-support.patch added to -mm tree
Date: Tue, 26 Jun 2007 00:04:51 -0700
Message-ID: <200706260704.l5Q74pBx020572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbXFZHFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 03:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_promise: SATA hotplug support
has been added to the -mm tree.  Its filename is
     sata_promise-sata-hotplug-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_promise: SATA hotplug support
From: Mikael Pettersson <mikpe@it.uu.se>

This patch enables hotplugging of SATA devices in the sata_promise driver. 
It's been tested successfully on both first- and second-generation Promise
SATA chips: SATA150 TX2plus, SATAII150 TX2plus, SATA300 TX2plus, and SATA300
TX4.

The only quirk I've seen is that hotplugging (insertion) on the
first-generation SATA150 TX2plus requires a lengthier EH sequence than on the
second-generation chips.  On the second-generation chips a simple soft reset
seems to suffice, but on the first-generation chip there's a "port is slow to
respond" after the initial soft reset, after which libata issues a hard reset,
and then the device is recognised.

The hotplug checks are high up in the interrupt handling path, not deep down
in error_intr as in ahci/sata_sil24.  That's because the chip doesn't signal
hotplug status changes in the per-port status register: instead a global
register contains hotplug control and status flags for all ports.  I
considered following the ahci/sata_sil24 structure, but that would have
required non-trivial changes to the interrupt handling path, so I chose to
keep the hotplug changes simple and unobtrusive.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |   40 ++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-sata-hotplug-support drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-sata-hotplug-support
+++ a/drivers/ata/sata_promise.c
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.08"
+#define DRV_VERSION	"2.09"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -716,6 +716,9 @@ static irqreturn_t pdc_interrupt (int ir
 	unsigned int i, tmp;
 	unsigned int handled = 0;
 	void __iomem *mmio_base;
+	unsigned int hotplug_offset, ata_no;
+	u32 hotplug_status;
+	int is_sataii_tx4;
 
 	VPRINTK("ENTER\n");
 
@@ -726,10 +729,20 @@ static irqreturn_t pdc_interrupt (int ir
 
 	mmio_base = host->iomap[PDC_MMIO_BAR];
 
+	/* read and clear hotplug flags for all ports */
+	if (host->ports[0]->flags & PDC_FLAG_GEN_II)
+		hotplug_offset = PDC2_SATA_PLUG_CSR;
+	else
+		hotplug_offset = PDC_SATA_PLUG_CSR;
+	hotplug_status = readl(mmio_base + hotplug_offset);
+	if (hotplug_status & 0xff)
+		writel(hotplug_status | 0xff, mmio_base + hotplug_offset);
+	hotplug_status &= 0xff;	/* clear uninteresting bits */
+
 	/* reading should also clear interrupts */
 	mask = readl(mmio_base + PDC_INT_SEQMASK);
 
-	if (mask == 0xffffffff) {
+	if (mask == 0xffffffff && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 2\n");
 		return IRQ_NONE;
 	}
@@ -737,16 +750,33 @@ static irqreturn_t pdc_interrupt (int ir
 	spin_lock(&host->lock);
 
 	mask &= 0xffff;		/* only 16 tags possible */
-	if (!mask) {
+	if (mask == 0 && hotplug_status == 0) {
 		VPRINTK("QUICK EXIT 3\n");
 		goto done_irq;
 	}
 
 	writel(mask, mmio_base + PDC_INT_SEQMASK);
 
+	is_sataii_tx4 = pdc_is_sataii_tx4(host->ports[0]->flags);
+
 	for (i = 0; i < host->n_ports; i++) {
 		VPRINTK("port %u\n", i);
 		ap = host->ports[i];
+
+		/* check for a plug or unplug event */
+		ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
+		tmp = hotplug_status & (0x11 << ata_no);
+		if (tmp && ap &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_eh_info *ehi = &ap->eh_info;
+			ata_ehi_clear_desc(ehi);
+			ata_ehi_hotplugged(ehi);
+			ata_ehi_push_desc(ehi, "hotplug_status %#x", tmp);
+			ata_port_freeze(ap);
+			continue;
+		}
+
+		/* check for a packet interrupt */
 		tmp = mask & (1 << (i + 1));
 		if (tmp && ap &&
 		    !(ap->flags & ATA_FLAG_DISABLED)) {
@@ -902,9 +932,9 @@ static void pdc_host_init(struct ata_hos
 	tmp = readl(mmio + hotplug_offset);
 	writel(tmp | 0xff, mmio + hotplug_offset);
 
-	/* mask plug/unplug ints */
+	/* unmask plug/unplug ints */
 	tmp = readl(mmio + hotplug_offset);
-	writel(tmp | 0xff0000, mmio + hotplug_offset);
+	writel(tmp & ~0xff0000, mmio + hotplug_offset);
 
 	/* don't initialise TBG or SLEW on 2nd generation chips */
 	if (is_gen2)
_

Patches currently in -mm which might be from mikpe@it.uu.se are

sata_promise-cleanups.patch
sata_promise-sata-hotplug-support.patch
