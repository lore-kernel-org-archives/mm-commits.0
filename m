From: akpm@linux-foundation.org
Subject: - arm-misc-minor-interrupt-handler-cleanups.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:02 -0700
Message-ID: <200710292031.l9TKV2UJ021822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbXJ2Ubv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ARM: Misc minor interrupt handler cleanups
has been removed from the -mm tree.  Its filename was
     arm-misc-minor-interrupt-handler-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM: Misc minor interrupt handler cleanups
From: Jeff Garzik <jeff@garzik.org>

mach-integrator/pci_v3.c: no need to reference 'irq' arg, its constant

mach-omap1/pm.c: remove extra whitespace

arch/arm/mach-sa1100/ssp.c: remove braces around single C stmt

arch/arm/plat-omap/mcbsp.c:
	- remove pointless casts from void*
	- make longer lines more readable

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-integrator/pci_v3.c |    8 +++++---
 arch/arm/mach-omap1/pm.c          |    2 +-
 arch/arm/mach-sa1100/ssp.c        |    3 +--
 arch/arm/plat-omap/mcbsp.c        |   20 ++++++++++++--------
 4 files changed, 19 insertions(+), 14 deletions(-)

diff -puN arch/arm/mach-integrator/pci_v3.c~arm-misc-minor-interrupt-handler-cleanups arch/arm/mach-integrator/pci_v3.c
--- a/arch/arm/mach-integrator/pci_v3.c~arm-misc-minor-interrupt-handler-cleanups
+++ a/arch/arm/mach-integrator/pci_v3.c
@@ -440,7 +440,7 @@ v3_pci_fault(unsigned long addr, unsigne
 	return 1;
 }
 
-static irqreturn_t v3_irq(int irq, void *devid)
+static irqreturn_t v3_irq(int dummy, void *devid)
 {
 #ifdef CONFIG_DEBUG_LL
 	struct pt_regs *regs = get_irq_regs();
@@ -448,8 +448,10 @@ static irqreturn_t v3_irq(int irq, void 
 	unsigned long instr = *(unsigned long *)pc;
 	char buf[128];
 
-	sprintf(buf, "V3 int %d: pc=0x%08lx [%08lx] LBFADDR=%08x LBFCODE=%02x ISTAT=%02x\n", irq,
-		pc, instr, __raw_readl(SC_LBFADDR), __raw_readl(SC_LBFCODE) & 255,
+	sprintf(buf, "V3 int %d: pc=0x%08lx [%08lx] LBFADDR=%08x LBFCODE=%02x "
+		"ISTAT=%02x\n", IRQ_AP_V3INT, pc, instr,
+		__raw_readl(SC_LBFADDR),
+		__raw_readl(SC_LBFCODE) & 255,
 		v3_readb(V3_LB_ISTAT));
 	printascii(buf);
 #endif
diff -puN arch/arm/mach-omap1/pm.c~arm-misc-minor-interrupt-handler-cleanups arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~arm-misc-minor-interrupt-handler-cleanups
+++ a/arch/arm/mach-omap1/pm.c
@@ -646,7 +646,7 @@ static void omap_pm_finish(void)
 }
 
 
-static irqreturn_t  omap_wakeup_interrupt(int irq, void *dev)
+static irqreturn_t omap_wakeup_interrupt(int irq, void *dev)
 {
 	return IRQ_HANDLED;
 }
diff -puN arch/arm/mach-sa1100/ssp.c~arm-misc-minor-interrupt-handler-cleanups arch/arm/mach-sa1100/ssp.c
--- a/arch/arm/mach-sa1100/ssp.c~arm-misc-minor-interrupt-handler-cleanups
+++ a/arch/arm/mach-sa1100/ssp.c
@@ -29,9 +29,8 @@ static irqreturn_t ssp_interrupt(int irq
 {
 	unsigned int status = Ser4SSSR;
 
-	if (status & SSSR_ROR) {
+	if (status & SSSR_ROR)
 		printk(KERN_WARNING "SSP: receiver overrun\n");
-	}
 
 	Ser4SSSR = SSSR_ROR;
 
diff -puN arch/arm/plat-omap/mcbsp.c~arm-misc-minor-interrupt-handler-cleanups arch/arm/plat-omap/mcbsp.c
--- a/arch/arm/plat-omap/mcbsp.c~arm-misc-minor-interrupt-handler-cleanups
+++ a/arch/arm/plat-omap/mcbsp.c
@@ -98,9 +98,10 @@ static void omap_mcbsp_dump_reg(u8 id)
 
 static irqreturn_t omap_mcbsp_tx_irq_handler(int irq, void *dev_id)
 {
-	struct omap_mcbsp * mcbsp_tx = (struct omap_mcbsp *)(dev_id);
+	struct omap_mcbsp *mcbsp_tx = dev_id;
 
-	DBG("TX IRQ callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_tx->io_base, SPCR2));
+	DBG("TX IRQ callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_tx->io_base, SPCR2));
 
 	complete(&mcbsp_tx->tx_irq_completion);
 	return IRQ_HANDLED;
@@ -108,9 +109,10 @@ static irqreturn_t omap_mcbsp_tx_irq_han
 
 static irqreturn_t omap_mcbsp_rx_irq_handler(int irq, void *dev_id)
 {
-	struct omap_mcbsp * mcbsp_rx = (struct omap_mcbsp *)(dev_id);
+	struct omap_mcbsp *mcbsp_rx = dev_id;
 
-	DBG("RX IRQ callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_rx->io_base, SPCR2));
+	DBG("RX IRQ callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_rx->io_base, SPCR2));
 
 	complete(&mcbsp_rx->rx_irq_completion);
 	return IRQ_HANDLED;
@@ -118,9 +120,10 @@ static irqreturn_t omap_mcbsp_rx_irq_han
 
 static void omap_mcbsp_tx_dma_callback(int lch, u16 ch_status, void *data)
 {
-	struct omap_mcbsp * mcbsp_dma_tx = (struct omap_mcbsp *)(data);
+	struct omap_mcbsp *mcbsp_dma_tx = data;
 
-	DBG("TX DMA callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_dma_tx->io_base, SPCR2));
+	DBG("TX DMA callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_dma_tx->io_base, SPCR2));
 
 	/* We can free the channels */
 	omap_free_dma(mcbsp_dma_tx->dma_tx_lch);
@@ -131,9 +134,10 @@ static void omap_mcbsp_tx_dma_callback(i
 
 static void omap_mcbsp_rx_dma_callback(int lch, u16 ch_status, void *data)
 {
-	struct omap_mcbsp * mcbsp_dma_rx = (struct omap_mcbsp *)(data);
+	struct omap_mcbsp *mcbsp_dma_rx = data;
 
-	DBG("RX DMA callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_dma_rx->io_base, SPCR2));
+	DBG("RX DMA callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_dma_rx->io_base, SPCR2));
 
 	/* We can free the channels */
 	omap_free_dma(mcbsp_dma_rx->dma_rx_lch);
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc-vs-git-libata-all.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
