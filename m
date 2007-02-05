From: akpm@linux-foundation.org
Subject: + libata-add-a-host-flag-to-indicate-lack-of-iordy.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:52:35 -0800
Message-ID: <200702052252.l15MqZtr001742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927AbXBEWwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: Add a host flag to indicate lack of IORDY capability
has been added to the -mm tree.  Its filename is
     libata-add-a-host-flag-to-indicate-lack-of-iordy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -678,6 +680,7 @@ static __init int legacy_init_one(int po
 	struct ata_probe_ent ae;
 	struct platform_device *pdev;
 	struct ata_port_operations *ops = &legacy_port_ops;
+	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
 	void __iomem *io_addr, *ctrl_addr;
 	int pio_modes = pio_mask;
 	u32 mask = (1 << port);
@@ -701,6 +704,7 @@ static __init int legacy_init_one(int po
 	if (ht6560a & mask) {
 		ops = &ht6560a_port_ops;
 		pio_modes = 0x07;
+		iordy = ATA_FLAG_NO_IORDY;
 	}
 	if (ht6560b & mask) {
 		ops = &ht6560b_port_ops;
@@ -736,6 +740,7 @@ static __init int legacy_init_one(int po
 			printk(KERN_INFO "PDC20230-C/20630 VLB ATA controller detected.\n");
 				pio_modes = 0x07;
 			ops = &pdc20230_port_ops;
+			iordy = ATA_FLAG_NO_IORDY;
 			udelay(100);
 			inb(0x1F5);
 		} else {
@@ -753,6 +758,7 @@ static __init int legacy_init_one(int po
 	/* Chip does mode setting by command snooping */
 	if (ops == &legacy_port_ops && (autospeed & mask))
 		ops = &simple_port_ops;
+
 	memset(&ae, 0, sizeof(struct ata_probe_ent));
 	INIT_LIST_HEAD(&ae.node);
 	ae.dev = &pdev->dev;
@@ -762,7 +768,7 @@ static __init int legacy_init_one(int po
 	ae.pio_mask = pio_modes;
 	ae.irq = irq;
 	ae.irq_flags = 0;
-	ae.port_flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST;
+	ae.port_flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST|iordy;
 	ae.port[0].cmd_addr = io_addr;
 	ae.port[0].altstatus_addr = ctrl_addr;
 	ae.port[0].ctl_addr = ctrl_addr;
@@ -931,6 +937,7 @@ module_param(ht6560b, int, 0);
 module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
 module_param(pio_mask, int, 0);
+module_param(iordy_mask, int, 0);
 
 module_init(legacy_init);
 module_exit(legacy_exit);
diff -puN drivers/ata/pata_qdi.c~libata-add-a-host-flag-to-indicate-lack-of-iordy drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~libata-add-a-host-flag-to-indicate-lack-of-iordy
+++ a/drivers/ata/pata_qdi.c
@@ -260,16 +260,18 @@ static __init int qdi_init_one(unsigned 
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
@@ -175,6 +175,7 @@ enum {
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
+	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
sis-warning-fixes.patch
kconfig-clarify-ata_piix-description.patch
ata-add-defines-for-the-iordy-bits.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
libata-early-cfa-adapters-are-not-required-to-support-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
geode-configuration-fixes.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
sched-avoid-div-in-rebalance_tick.patch
pm3fb-kill-pci_find_device-usage.patch
