From: akpm@linux-foundation.org
Subject: + ata_piix-replace-spaces-with-tabs.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:01:33 -0700
Message-ID: <200709150801.l8F81XKN024506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbXIOIB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.d.gaston@intel.com, alan@redhat.com


The patch titled
     ata_piix: replace spaces with tabs
has been added to the -mm tree.  Its filename is
     ata_piix-replace-spaces-with-tabs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata_piix: replace spaces with tabs
From: Jason Gaston <jason.d.gaston@intel.com>

This patch removes some incorrect formatting spaces and replaces them with
tabs.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c      |   18 ++--
 drivers/ata/ata_piix.c.orig |  134 +++++++++++++++++++++++++---------
 2 files changed, 108 insertions(+), 44 deletions(-)

diff -puN drivers/ata/ata_piix.c~ata_piix-replace-spaces-with-tabs drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-replace-spaces-with-tabs
+++ a/drivers/ata/ata_piix.c
@@ -437,15 +437,15 @@ static const struct piix_map_db ich8_map
 };
 
 static const struct piix_map_db tolapai_map_db = {
-        .mask = 0x3,
-        .port_enable = 0x3,
-        .map = {
-                /* PM   PS   SM   SS       MAP */
-                {  P0,  NA,  P1,  NA }, /* 00b */
-                {  RV,  RV,  RV,  RV }, /* 01b */
-                {  RV,  RV,  RV,  RV }, /* 10b */
-                {  RV,  RV,  RV,  RV },
-        },
+	.mask = 0x3,
+	.port_enable = 0x3,
+	.map = {
+		/* PM   PS   SM   SS       MAP */
+		{  P0,  NA,  P1,  NA }, /* 00b */
+		{  RV,  RV,  RV,  RV }, /* 01b */
+		{  RV,  RV,  RV,  RV }, /* 10b */
+		{  RV,  RV,  RV,  RV },
+	},
 };
 
 static const struct piix_map_db *piix_map_db_table[] = {
diff -puN drivers/ata/ata_piix.c.orig~ata_piix-replace-spaces-with-tabs drivers/ata/ata_piix.c.orig
--- a/drivers/ata/ata_piix.c.orig~ata_piix-replace-spaces-with-tabs
+++ a/drivers/ata/ata_piix.c.orig
@@ -94,7 +94,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME	"ata_piix"
-#define DRV_VERSION	"2.11"
+#define DRV_VERSION	"2.12"
 
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
@@ -123,13 +123,13 @@ enum {
 	ich_pata_33		= 1,	/* ICH up to UDMA 33 only */
 	ich_pata_66		= 2,	/* ICH up to 66 Mhz */
 	ich_pata_100		= 3,	/* ICH up to UDMA 100 */
-	ich_pata_133		= 4,	/* ICH up to UDMA 133 */
 	ich5_sata		= 5,
 	ich6_sata		= 6,
 	ich6_sata_ahci		= 7,
 	ich6m_sata_ahci		= 8,
 	ich8_sata_ahci		= 9,
 	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
+	tolapai_sata_ahci	= 11,
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -198,7 +198,7 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x24CA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x8086, 0x24CB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* Intel ICH5 */
-	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
+	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* C-ICH (i810E2) */
 	{ 0x8086, 0x245B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ESB (855GME/875P + 6300ESB) UDMA 100  */
@@ -206,7 +206,7 @@ static const struct pci_device_id piix_p
 	/* ICH6 (and 6) (i915) UDMA 100 */
 	{ 0x8086, 0x266F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ICH7/7-R (i945, i975) UDMA 100*/
-	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
+	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ICH8 Mobile PATA Controller */
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
@@ -253,6 +253,8 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9M) */
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (Tolapai) */
+	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata_ahci },
 
 	{ }	/* terminate list */
 };
@@ -287,7 +289,6 @@ static struct scsi_host_template piix_sh
 };
 
 static const struct ata_port_operations piix_pata_ops = {
-	.port_disable		= ata_port_disable,
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
 	.mode_filter		= ata_pci_default_filter,
@@ -315,13 +316,11 @@ static const struct ata_port_operations 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
-	.irq_ack		= ata_irq_ack,
 
 	.port_start		= ata_port_start,
 };
 
 static const struct ata_port_operations ich_pata_ops = {
-	.port_disable		= ata_port_disable,
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= ich_set_dmamode,
 	.mode_filter		= ata_pci_default_filter,
@@ -349,14 +348,11 @@ static const struct ata_port_operations 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
-	.irq_ack		= ata_irq_ack,
 
 	.port_start		= ata_port_start,
 };
 
 static const struct ata_port_operations piix_sata_ops = {
-	.port_disable		= ata_port_disable,
-
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
 	.check_status		= ata_check_status,
@@ -379,7 +375,6 @@ static const struct ata_port_operations 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
-	.irq_ack		= ata_irq_ack,
 
 	.port_start		= ata_port_start,
 };
@@ -441,16 +436,29 @@ static const struct piix_map_db ich8_map
 	},
 };
 
+static const struct piix_map_db tolapai_map_db = {
+        .mask = 0x3,
+        .port_enable = 0x3,
+        .map = {
+                /* PM   PS   SM   SS       MAP */
+                {  P0,  NA,  P1,  NA }, /* 00b */
+                {  RV,  RV,  RV,  RV }, /* 01b */
+                {  RV,  RV,  RV,  RV }, /* 10b */
+                {  RV,  RV,  RV,  RV },
+        },
+};
+
 static const struct piix_map_db *piix_map_db_table[] = {
 	[ich5_sata]		= &ich5_map_db,
 	[ich6_sata]		= &ich6_map_db,
 	[ich6_sata_ahci]	= &ich6_map_db,
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
+	[tolapai_sata_ahci]	= &tolapai_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
-	/* piix_pata_33: 0:  PIIX4 at 33MHz */
+	[piix_pata_33] =	/* PIIX4 at 33MHz */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -460,7 +468,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_pata_ops,
 	},
 
-	/* ich_pata_33: 1 	ICH0 - ICH at 33Mhz*/
+	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -469,7 +477,8 @@ static struct ata_port_info piix_port_in
 		.udma_mask	= ATA_UDMA2, /* UDMA33 */
 		.port_ops	= &ich_pata_ops,
 	},
-	/* ich_pata_66: 2 	ICH controllers up to 66MHz */
+
+	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -479,7 +488,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &ich_pata_ops,
 	},
 
-	/* ich_pata_100: 3 */
+	[ich_pata_100] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
@@ -489,17 +498,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &ich_pata_ops,
 	},
 
-	/* ich_pata_133: 4 	ICH with full UDMA6 */
-	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
-		.pio_mask 	= 0x1f,	/* pio 0-4 */
-		.mwdma_mask	= 0x06, /* Check: maybe 0x07  */
-		.udma_mask	= ATA_UDMA6, /* UDMA133 */
-		.port_ops	= &ich_pata_ops,
-	},
-
-	/* ich5_sata: 5 */
+	[ich5_sata] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS,
@@ -509,7 +508,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich6_sata: 6 */
+	[ich6_sata] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR,
@@ -519,7 +518,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich6_sata_ahci: 7 */
+	[ich6_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -530,7 +529,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich6m_sata_ahci: 8 */
+	[ich6m_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -541,7 +540,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* ich8_sata_ahci: 9 */
+	[ich8_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -552,7 +551,7 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
-	/* piix_pata_mwdma: 10:  PIIX3 MWDMA only */
+	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
@@ -560,6 +559,17 @@ static struct ata_port_info piix_port_in
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
 		.port_ops	= &piix_pata_ops,
 	},
+
+	[tolapai_sata_ahci] =
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -630,19 +640,20 @@ static int ich_pata_cable_detect(struct 
 
 /**
  *	piix_pata_prereset - prereset for PATA host controller
- *	@ap: Target port
+ *	@link: Target link
  *	@deadline: deadline jiffies for the operation
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
-static int piix_pata_prereset(struct ata_port *ap, unsigned long deadline)
+static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
 {
+	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
 		return -ENOENT;
-	return ata_std_prereset(ap, deadline);
+	return ata_std_prereset(link, deadline);
 }
 
 static void piix_pata_error_handler(struct ata_port *ap)
@@ -901,6 +912,20 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA M7",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M7"),
+			},
+		},
+		{
+			.ident = "Satellite U200",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U200"),
+			},
+		},
+		{
 			.ident = "Satellite U205",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -914,7 +939,8 @@ static int piix_broken_suspend(void)
 				DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
 			},
 		},
-		{ }
+
+		{ }	/* terminate list */
 	};
 	static const char *oemstrs[] = {
 		"Tecra M3,",
@@ -1132,6 +1158,41 @@ static void __devinit piix_init_sata_map
 	hpriv->map = map;
 }
 
+static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
+{
+	static struct dmi_system_id sysids[] = {
+		{
+			/* Clevo M570U sets IOCFG bit 18 if the cdrom
+			 * isn't used to boot the system which
+			 * disables the channel.
+			 */
+			.ident = "M570U",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Clevo Co."),
+				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
+			},
+		},
+
+		{ }	/* terminate list */
+	};
+	u32 iocfg;
+
+	if (!dmi_check_system(sysids))
+		return;
+
+	/* The datasheet says that bit 18 is NOOP but certain systems
+	 * seem to use it to disable a channel.  Clear the bit on the
+	 * affected systems.
+	 */
+	pci_read_config_dword(pdev, PIIX_IOCFG, &iocfg);
+	if (iocfg & (1 << 18)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "applying IOCFG bit18 quirk\n");
+		iocfg &= ~(1 << 18);
+		pci_write_config_dword(pdev, PIIX_IOCFG, iocfg);
+	}
+}
+
 /**
  *	piix_init_one - Register PIIX ATA PCI device with kernel services
  *	@pdev: PCI device to register
@@ -1193,6 +1254,9 @@ static int piix_init_one (struct pci_dev
 			      piix_map_db_table[ent->driver_data]);
 	}
 
+	/* apply IOCFG bit18 quirk */
+	piix_iocfg_bit18_quirk(pdev);
+
 	/* On ICH5, some BIOSen disable the interrupt using the
 	 * PCI_COMMAND_INTX_DISABLE bit added in PCI 2.3.
 	 * On ICH6, this bit has the same effect, but only when
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

i2c-i801-documentation-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
ahci-raid-mode-sata-patch-for-intel-tolapai.patch
ata_piix-replace-spaces-with-tabs.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
