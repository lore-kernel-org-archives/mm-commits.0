From: akpm@linux-foundation.org
Subject: + 8250_gsc-coding-style.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:21 -0800
Message-ID: <200711200723.lAK7NLOo021379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbXKTH3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     8250_gsc: coding style
has been added to the -mm tree.  Its filename is
     8250_gsc-coding-style.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8250_gsc: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_gsc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/serial/8250_gsc.c~8250_gsc-coding-style drivers/serial/8250_gsc.c
--- a/drivers/serial/8250_gsc.c~8250_gsc-coding-style
+++ a/drivers/serial/8250_gsc.c
@@ -25,8 +25,7 @@
 
 #include "8250.h"
 
-static int __init 
-serial_init_chip(struct parisc_device *dev)
+static int __init serial_init_chip(struct parisc_device *dev)
 {
 	struct uart_port port;
 	unsigned long address;
@@ -38,18 +37,17 @@ serial_init_chip(struct parisc_device *d
 		 * what we have here is a missing parent device, so tell
 		 * the user what they're missing.
 		 */
-		if (parisc_parent(dev)->id.hw_type != HPHW_IOA) {
-			printk(KERN_INFO "Serial: device 0x%lx not configured.\n"
+		if (parisc_parent(dev)->id.hw_type != HPHW_IOA)
+			printk(KERN_INFO
+				"Serial: device 0x%lx not configured.\n"
 				"Enable support for Wax, Lasi, Asp or Dino.\n",
 				dev->hpa.start);
-		}
 		return -ENODEV;
 	}
 
 	address = dev->hpa.start;
-	if (dev->id.sversion != 0x8d) {
+	if (dev->id.sversion != 0x8d)
 		address += 0x800;
-	}
 
 	memset(&port, 0, sizeof(port));
 	port.iotype	= UPIO_MEM;
@@ -63,11 +61,12 @@ serial_init_chip(struct parisc_device *d
 
 	err = serial8250_register_port(&port);
 	if (err < 0) {
-		printk(KERN_WARNING "serial8250_register_port returned error %d\n", err);
+		printk(KERN_WARNING
+			"serial8250_register_port returned error %d\n", err);
 		iounmap(port.membase);
 		return err;
 	}
-        
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

termios-document-callback-more-clearly.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
ahci-invalid-use-of-writel-readl-with-iomap.patch
libata-core-list-more-documentation-sources-for-reference.patch
libata-iordy-handling.patch
libata-sff-tf_load.patch
pata_ali-add-mitac-8317-and-derivatives.patch
pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
pata_isapnp-polled-devices.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
pata_ninja32-cardbus-ata-initial-support.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
