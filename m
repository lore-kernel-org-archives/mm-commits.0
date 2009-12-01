From: akpm@linux-foundation.org
Subject: [merged] mtd-error-return-eio-instead-of-eio.patch removed from -mm tree
Date: Tue, 01 Dec 2009 12:17:51 -0800
Message-ID: <200912012017.nB1KHpLR019528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbZLAURx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 15:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: error return -EIO instead of EIO
has been removed from the -mm tree.  Its filename was
     mtd-error-return-eio-instead-of-eio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: error return -EIO instead of EIO
From: Roel Kluin <roel.kluin@gmail.com>

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c    |    2 +-
 drivers/mtd/maps/vmu-flash.c  |    2 +-
 drivers/mtd/nand/atmel_nand.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~mtd-error-return-eio-instead-of-eio drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-error-return-eio-instead-of-eio
+++ a/drivers/mtd/maps/physmap.c
@@ -129,7 +129,7 @@ static int physmap_flash_probe(struct pl
 						 info->map[i].size);
 		if (info->map[i].virt == NULL) {
 			dev_err(&dev->dev, "Failed to ioremap flash region\n");
-			err = EIO;
+			err = -EIO;
 			goto err_out;
 		}
 
diff -puN drivers/mtd/maps/vmu-flash.c~mtd-error-return-eio-instead-of-eio drivers/mtd/maps/vmu-flash.c
--- a/drivers/mtd/maps/vmu-flash.c~mtd-error-return-eio-instead-of-eio
+++ a/drivers/mtd/maps/vmu-flash.c
@@ -621,7 +621,7 @@ static int __devinit vmu_connect(struct 
 
 	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
 	if (!card) {
-		error = ENOMEM;
+		error = -ENOMEM;
 		goto fail_nomem;
 	}
 
diff -puN drivers/mtd/nand/atmel_nand.c~mtd-error-return-eio-instead-of-eio drivers/mtd/nand/atmel_nand.c
--- a/drivers/mtd/nand/atmel_nand.c~mtd-error-return-eio-instead-of-eio
+++ a/drivers/mtd/nand/atmel_nand.c
@@ -463,7 +463,7 @@ static int __init atmel_nand_probe(struc
 	if (host->board->det_pin) {
 		if (gpio_get_value(host->board->det_pin)) {
 			printk(KERN_INFO "No SmartMedia card inserted.\n");
-			res = ENXIO;
+			res = -ENXIO;
 			goto err_no_card;
 		}
 	}
@@ -534,7 +534,7 @@ static int __init atmel_nand_probe(struc
 
 	if ((!partitions) || (num_partitions == 0)) {
 		printk(KERN_ERR "atmel_nand: No partitions defined, or unsupported device.\n");
-		res = ENXIO;
+		res = -ENXIO;
 		goto err_no_partitions;
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-return-ptr_err-rather-than-is_err.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
imx-bit-confusion.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

