From: akpm@linux-foundation.org
Subject: [merged] pata_amd-program-fifo.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:37 -0800
Message-ID: <200902261930.n1QJUbnr014443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbZBZTas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:30:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, hancockrwd@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pata_amd: program FIFO
has been removed from the -mm tree.  Its filename was
     pata_amd-program-fifo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_amd: program FIFO
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

With 32bit PIO we can use the posted write buffers, but only for 32bit I/O
cycles.  This means we must disable the FIFO for ATAPI where a final 16bit
cycle may occur.

Rework the FIFO logic so that we disable the FIFO then selectively
re-enable it when we set the timings on AMD devices.  Also fix a case
where we scribbled on PCI config 0x41 of Nvidia chips when we shouldn't.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |   76 ++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff -puN drivers/ata/pata_amd.c~pata_amd-program-fifo drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_amd-program-fifo
+++ a/drivers/ata/pata_amd.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.11"
+#define DRV_VERSION "0.4.1"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -145,6 +145,13 @@ static int amd_pre_reset(struct ata_link
 	return ata_sff_prereset(link, deadline);
 }
 
+/**
+ *	amd_cable_detect	-	report cable type
+ *	@ap: port
+ *
+ *	AMD controller/BIOS setups record the cable type in word 0x42
+ */
+
 static int amd_cable_detect(struct ata_port *ap)
 {
 	static const u32 bitmask[2] = {0x03, 0x0C};
@@ -158,6 +165,40 @@ static int amd_cable_detect(struct ata_p
 }
 
 /**
+ *	amd_fifo_setup		-	set the PIO FIFO for ATA/ATAPI
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Set the PCI fifo for this device according to the devices present
+ *	on the bus at this point in time. We need to turn the post write buffer
+ *	off for ATAPI devices as we may need to issue a word sized write to the
+ *	device as the final I/O
+ */
+
+static void amd_fifo_setup(struct ata_port *ap)
+{
+	struct ata_device *adev;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static const u8 fifobit[2] = { 0xC0, 0x30};
+	u8 fifo = fifobit[ap->port_no];
+	u8 r;
+
+
+	ata_for_each_dev(adev, &ap->link, ENABLED) {
+		if (adev->class == ATA_DEV_ATAPI)
+			fifo = 0;
+	}
+	if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411) /* FIFO is broken */
+		fifo = 0;
+
+	/* On the later chips the read prefetch bits become no-op bits */
+	pci_read_config_byte(pdev, 0x41, &r);
+	r &= ~fifobit[ap->port_no];
+	r |= fifo;
+	pci_write_config_byte(pdev, 0x41, r);
+}
+
+/**
  *	amd33_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -167,21 +208,25 @@ static int amd_cable_detect(struct ata_p
 
 static void amd33_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 1);
 }
 
 static void amd66_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 2);
 }
 
 static void amd100_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 3);
 }
 
 static void amd133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 4);
 }
 
@@ -397,6 +442,16 @@ static struct ata_port_operations nv133_
 	.set_dmamode	= nv133_set_dmamode,
 };
 
+static void amd_clear_fifo(struct pci_dev *pdev)
+{
+	u8 fifo;
+	/* Disable the FIFO, the FIFO logic will re-enable it as
+	   appropriate */
+	pci_read_config_byte(pdev, 0x41, &fifo);
+	fifo &= 0x0F;
+	pci_write_config_byte(pdev, 0x41, fifo);
+}
+
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info[10] = {
@@ -503,14 +558,8 @@ static int amd_init_one(struct pci_dev *
 
 	if (type < 3)
 		ata_pci_bmdma_clear_simplex(pdev);
-
-	/* Check for AMD7411 */
-	if (type == 3)
-		/* FIFO is broken */
-		pci_write_config_byte(pdev, 0x41, fifo & 0x0F);
-	else
-		pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
-
+	if (pdev->vendor == PCI_VENDOR_ID_AMD)
+		amd_clear_fifo(pdev);
 	/* Cable detection on Nvidia chips doesn't work too well,
 	 * cache BIOS programmed UDMA mode.
 	 */
@@ -536,18 +585,11 @@ static int amd_reinit_one(struct pci_dev
 		return rc;
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
-		u8 fifo;
-		pci_read_config_byte(pdev, 0x41, &fifo);
-		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411)
-			/* FIFO is broken */
-			pci_write_config_byte(pdev, 0x41, fifo & 0x0F);
-		else
-			pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
+		amd_clear_fifo(pdev);
 		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7409 ||
 		    pdev->device == PCI_DEVICE_ID_AMD_COBRA_7401)
 			ata_pci_bmdma_clear_simplex(pdev);
 	}
-
 	ata_host_resume(host);
 	return 0;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-update-pnp-ids.patch
linux-next.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
tty-pty-lookup-retval-fixup.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
max3100-spi-uart-driver.patch
devpts-must-release-s_umount-on-error.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
jsm-fix-the-return-variable-and-remov-the-unused-retval.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rio-addition-has-higher-precedence-than.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

