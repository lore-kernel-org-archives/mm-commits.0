From: akpm@linux-foundation.org
Subject: - ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch removed from -mm tree
Date: Mon, 06 Aug 2007 11:25:34 -0700
Message-ID: <200708061825.l76IPY9E008146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758965AbXHFSZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata ahci ALPM: Enable Aggressive Link Power management for AHCI controllers
has been removed from the -mm tree.  Its filename was
     ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ata ahci ALPM: Enable Aggressive Link Power management for AHCI controllers
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

This patch will set the correct bits to turn on Aggressive Link Power
Management (ALPM) for the ahci driver.  This will cause the controller and
disk to negotiate a lower power state for the link when there is no activity
(see the AHCI 1.x spec for details).  This feature is mutually exclusive with
Hot Plug, so when ALPM is enabled, Hot Plug is disabled.  ALPM will be enabled
by default, but it is settable via the scsi host syfs interface.  Possible
settings for this feature are:

Setting		Effect
----------------------------------------------------------
min_power	ALPM is enabled, and link set to enter
		lowest power state (SLUMBER) when idle
		Hot plug not allowed.

max_performance	ALPM is disabled, Hot Plug is allowed

medium_power	ALPM is enabled, and link set to enter
		second lowest power state (PARTIAL) when
		idle.  Hot plug not allowed.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |  168 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 167 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ahci.c~ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers
+++ a/drivers/ata/ahci.c
@@ -48,6 +48,9 @@
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"2.3"
 
+static int ahci_enable_alpm(struct ata_port *ap,
+		enum scsi_host_link_pm policy);
+static int ahci_disable_alpm(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -98,6 +101,7 @@ enum {
 	/* HOST_CAP bits */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
 	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
 	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
 	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
@@ -153,6 +157,8 @@ enum {
 				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
 
 	/* PORT_CMD bits */
+	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -175,6 +181,7 @@ enum {
 	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
 	AHCI_FLAG_MV_PATA		= (1 << 29), /* PATA port */
 	AHCI_FLAG_NO_MSI		= (1 << 30), /* no PCI MSI */
+	AHCI_FLAG_NO_HOTPLUG		= (1 << 31), /* ignore PxSERR.DIAG.N */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -260,6 +267,7 @@ static struct scsi_host_template ahci_sh
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+	.set_link_pm_policy	= ata_scsi_set_link_pm_policy,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -291,6 +299,8 @@ static const struct ata_port_operations 
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
 #endif
+	.enable_pm		= ahci_enable_alpm,
+	.disable_pm		= ahci_disable_alpm,
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -778,6 +788,156 @@ static void ahci_power_up(struct ata_por
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
+static int ahci_disable_alpm(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd, scontrol;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/*
+ 	 * disable Interface Power Management State Transitions
+ 	 * This is accomplished by setting bits 8:11 of the
+ 	 * SATA Control register
+ 	 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol |= (0x3 << 8);
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* disable ALPM and ASP */
+	cmd &= ~PORT_CMD_ASP;
+	cmd &= ~PORT_CMD_ALPE;
+
+	/* force the interface back to active */
+	cmd |= PORT_CMD_ICC_ACTIVE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* wait 10ms to be sure we've come out of any low power state */
+	msleep(10);
+
+	/* clear out any PhyRdy stuff from interrupt status */
+	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
+
+	/* go ahead and clean out PhyRdy Change from Serror too */
+	ahci_scr_write(ap, SCR_ERROR, (1 << 16));
+
+	/*
+ 	 * Clear flag to indicate that we should ignore all PhyRdy
+ 	 * state changes
+ 	 */
+	ap->flags &= ~AHCI_FLAG_NO_HOTPLUG;
+
+	/*
+ 	 * Enable interrupts on Phy Ready.
+ 	 */
+	pp->intr_mask |= PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * don't change the link pm policy - we can be called
+ 	 * just to turn of link pm temporarily
+ 	 */
+	return 0;
+}
+
+static int ahci_enable_alpm(struct ata_port *ap,
+	enum scsi_host_link_pm policy)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd, scontrol, sstatus;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 asp;
+
+	/* Make sure the host is capable of link power management */
+	if (!(hpriv->cap & HOST_CAP_ALPM)) {
+		ap->pm_policy = SHOST_NOT_AVAILABLE;
+		return -EINVAL;
+	}
+
+	/* make sure we have a device attached */
+	sstatus = readl(port_mmio + PORT_SCR_STAT);
+	if (!(sstatus & 0xf00)) {
+		ap->pm_policy = SHOST_NOT_AVAILABLE;
+		return -EINVAL;
+	}
+
+	switch (policy) {
+	case SHOST_MAX_PERFORMANCE:
+	case SHOST_NOT_AVAILABLE:
+		/*
+ 		 * if we came here with SHOST_NOT_AVAILABLE,
+ 		 * it just means this is the first time we
+ 		 * have tried to enable - default to max performance,
+ 		 * and let the user go to lower power modes on request.
+ 		 */
+		ahci_disable_alpm(ap);
+		ap->pm_policy = SHOST_MAX_PERFORMANCE;
+		return 0;
+	case SHOST_MIN_POWER:
+		/* configure HBA to enter SLUMBER */
+		asp = PORT_CMD_ASP;
+		break;
+	case SHOST_MEDIUM_POWER:
+		/* configure HBA to enter PARTIAL */
+		asp = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ap->pm_policy = policy;
+
+	/*
+ 	 * Disable interrupts on Phy Ready. This keeps us from
+ 	 * getting woken up due to spurious phy ready interrupts
+	 * TBD - Hot plug should be done via polling now, is
+	 * that even supported?
+ 	 */
+	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * Set a flag to indicate that we should ignore all PhyRdy
+ 	 * state changes since these can happen now whenever we
+ 	 * change link state
+ 	 */
+	ap->flags |= AHCI_FLAG_NO_HOTPLUG;
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/*
+ 	 * enable Interface Power Management State Transitions
+ 	 * This is accomplished by clearing bits 8:11 of the
+ 	 * SATA Control register
+ 	 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol &= ~(0x3 << 8);
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
+
+	/*
+ 	 * Set ASP based on Policy
+ 	 */
+	cmd |= asp;
+
+	/*
+ 	 * Setting this bit will instruct the HBA to aggressively
+ 	 * enter a lower power link state when it's appropriate and
+ 	 * based on the value set above for ASP
+ 	 */
+	cmd |= PORT_CMD_ALPE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static void ahci_power_down(struct ata_port *ap)
 {
@@ -1348,6 +1508,10 @@ static void ahci_port_intr(struct ata_po
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
 
+	if ((ap->flags & AHCI_FLAG_NO_HOTPLUG) &&
+		(status & PORT_IRQ_PHYRDY))
+		status &= ~PORT_IRQ_PHYRDY;
+
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);
 		return;
@@ -1877,8 +2041,10 @@ static int ahci_init_one(struct pci_dev 
 		void __iomem *port_mmio = ahci_port_base(ap);
 
 		/* standard SATA port setup */
-		if (hpriv->port_map & (1 << i))
+		if (hpriv->port_map & (1 << i)) {
 			ap->ioaddr.cmd_addr = port_mmio;
+			ap->pm_policy = SHOST_NOT_AVAILABLE;
+		}
 
 		/* disabled/not-implemented port */
 		else
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

store-interrupt-value.patch
enable-link-power-management-for-ata-drivers.patch
enable-aggressive-link-power-management-for-ahci.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
acpiphp_ibm-add-missing-n.patch
cpqphp_ctrlc-remove-dead-code.patch
acpi-bay-send-envp-with-uevent-fix.patch
acpi-dock-send-key=value-pair-instead-of-plain-value.patch
