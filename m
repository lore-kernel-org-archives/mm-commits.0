From: akpm@linux-foundation.org
Subject: - libata-add-a-host-flag-to-indicate-lack-of-iordy.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:03:00 -0800
Message-ID: <200702160803.l1G8307A023970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423400AbXBPIDT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:03:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: Add a host flag to indicate lack of IORDY capability
has been removed from the -mm tree.  Its filename was
     libata-add-a-host-flag-to-indicate-lack-of-iordy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: Add a host flag to indicate lack of IORDY capability
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is the first preparation to doing the !IORDY cases properly.  Further
diffs will then add the needed logic to do it right.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |   11 +++++++++--
 drivers/ata/pata_qdi.c    |    4 +++-
 include/linux/libata.h    |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/ata/pata_legacy.c~libata-add-a-host-flag-to-indicate-lack-of-iordy drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~libata-add-a-host-flag-to-indicate-lack-of-iordy
+++ a/drivers/ata/pata_legacy.c
@@ -89,9 +89,10 @@ static int probe_all;			/* Set to check 
 static int ht6560a;			/* HT 6560A on primary 1, secondary 2, both 3 */
 static int ht6560b;			/* HT 6560A on primary 1, secondary 2, both 3 */
 static int opti82c611a;			/* Opti82c611A on primary 1, secondary 2, both 3 */
-static int opti82c46x;		/* Opti 82c465MV present (pri/sec autodetect) */
+static int opti82c46x;			/* Opti 82c465MV present (pri/sec autodetect) */
 static int autospeed;			/* Chip present which snoops speed changes */
 static int pio_mask = 0x1F;		/* PIO range for autospeed devices */
+static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
 /**
  *	legacy_set_mode		-	mode setting
@@ -113,6 +114,7 @@ static int legacy_set_mode(struct ata_po
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 		if (ata_dev_enabled(dev)) {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
@@ -695,6 +697,7 @@ static __init int legacy_init_one(int po
 	void __iomem *io_addr, *ctrl_addr;
 	int pio_modes = pio_mask;
 	u32 mask = (1 << port);
+	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
 	int ret;
 
 	pdev = platform_device_register_simple(DRV_NAME, nr_legacy_host, NULL, 0);
@@ -715,6 +718,7 @@ static __init int legacy_init_one(int po
 	if (ht6560a & mask) {
 		ops = &ht6560a_port_ops;
 		pio_modes = 0x07;
+		iordy = ATA_FLAG_NO_IORDY;
 	}
 	if (ht6560b & mask) {
 		ops = &ht6560b_port_ops;
@@ -750,6 +754,7 @@ static __init int legacy_init_one(int po
 			printk(KERN_INFO "PDC20230-C/20630 VLB ATA controller detected.\n");
 				pio_modes = 0x07;
 			ops = &pdc20230_port_ops;
+			iordy = ATA_FLAG_NO_IORDY;
 			udelay(100);
 			inb(0x1F5);
 		} else {
@@ -767,6 +772,7 @@ static __init int legacy_init_one(int po
 	/* Chip does mode setting by command snooping */
 	if (ops == &legacy_port_ops && (autospeed & mask))
 		ops = &simple_port_ops;
+
 	memset(&ae, 0, sizeof(struct ata_probe_ent));
 	INIT_LIST_HEAD(&ae.node);
 	ae.dev = &pdev->dev;
@@ -776,7 +782,7 @@ static __init int legacy_init_one(int po
 	ae.pio_mask = pio_modes;
 	ae.irq = irq;
 	ae.irq_flags = 0;
-	ae.port_flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST;
+	ae.port_flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST|iordy;
 	ae.port[0].cmd_addr = io_addr;
 	ae.port[0].altstatus_addr = ctrl_addr;
 	ae.port[0].ctl_addr = ctrl_addr;
@@ -945,6 +951,7 @@ module_param(ht6560b, int, 0);
 module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
 module_param(pio_mask, int, 0);
+module_param(iordy_mask, int, 0);
 
 module_init(legacy_init);
 module_exit(legacy_exit);
diff -puN drivers/ata/pata_qdi.c~libata-add-a-host-flag-to-indicate-lack-of-iordy drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~libata-add-a-host-flag-to-indicate-lack-of-iordy
+++ a/drivers/ata/pata_qdi.c
@@ -264,16 +264,18 @@ static __init int qdi_init_one(unsigned 
 	if (type == 6580) {
 		ae.port_ops = &qdi6580_port_ops;
 		ae.pio_mask = 0x1F;
+		ae.port_flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST;
 	} else {
 		ae.port_ops = &qdi6500_port_ops;
 		ae.pio_mask = 0x07;	/* Actually PIO3 !IORDY is possible */
+		ae.port_flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST |
+				ATA_FLAG_NO_IORDY;
 	}
 
 	ae.sht = &qdi_sht;
 	ae.n_ports = 1;
 	ae.irq = irq;
 	ae.irq_flags = 0;
-	ae.port_flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST;
 	ae.port[0].cmd_addr = io_addr;
 	ae.port[0].altstatus_addr = ctl_addr;
 	ae.port[0].ctl_addr = ctl_addr;
diff -puN include/linux/libata.h~libata-add-a-host-flag-to-indicate-lack-of-iordy include/linux/libata.h
--- a/include/linux/libata.h~libata-add-a-host-flag-to-indicate-lack-of-iordy
+++ a/include/linux/libata.h
@@ -173,6 +173,7 @@ enum {
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
+	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
sis-warning-fixes.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
add-an-option-for-the-via-c7-which-sets-appropriate-l1.patch
driver_bfin_serial_core.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
