From: akpm@linux-foundation.org
Subject: + 8250_hp300-coding-style.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:22 -0800
Message-ID: <200711200723.lAK7NMLo021384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbXKTH3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     8250_hp300: coding style
has been added to the -mm tree.  Its filename is
     8250_hp300-coding-style.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8250_hp300: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_hp300.c |   35 ++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff -puN drivers/serial/8250_hp300.c~8250_hp300-coding-style drivers/serial/8250_hp300.c
--- a/drivers/serial/8250_hp300.c~8250_hp300-coding-style
+++ a/drivers/serial/8250_hp300.c
@@ -36,7 +36,7 @@ static struct hp300_port *hp300_ports;
 #ifdef CONFIG_HPDCA
 
 static int __devinit hpdca_init_one(struct dio_dev *d,
-                                const struct dio_device_id *ent);
+					const struct dio_device_id *ent);
 static void __devexit hpdca_remove_one(struct dio_dev *d);
 
 static struct dio_device_id hpdca_dio_tbl[] = {
@@ -85,7 +85,7 @@ extern int hp300_uart_scode;
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
 /*
- * Parse the bootinfo to find descriptions for headless console and 
+ * Parse the bootinfo to find descriptions for headless console and
  * debug serial ports and register them with the 8250 driver.
  * This function should be called before serial_console_init() is called
  * to make sure the serial console will be available for use. IA-64 kernel
@@ -126,13 +126,11 @@ int __init hp300_setup_serial_console(vo
 		printk(KERN_WARNING "Serial console is APCI but support is disabled (CONFIG_HPAPCI)!\n");
 		return 0;
 #endif
-	}
-	else {
+	} else {
 #ifdef CONFIG_HPDCA
 		unsigned long pa = dio_scodetophysaddr(scode);
-		if (!pa) {
+		if (!pa)
 			return 0;
-		}
 
 		printk(KERN_INFO "Serial console is HP DCA at select code %d\n", scode);
 
@@ -145,26 +143,23 @@ int __init hp300_setup_serial_console(vo
 		/* Enable board-interrupts */
 		out_8(pa + DIO_VIRADDRBASE + DCA_IC, DCA_IC_IE);
 
-		if (DIO_ID(pa + DIO_VIRADDRBASE) & 0x80) {
+		if (DIO_ID(pa + DIO_VIRADDRBASE) & 0x80)
 			add_preferred_console("ttyS", port.line, "9600n8");
-		}
 #else
 		printk(KERN_WARNING "Serial console is DCA but support is disabled (CONFIG_HPDCA)!\n");
 		return 0;
 #endif
 	}
 
-	if (early_serial_setup(&port) < 0) {
+	if (early_serial_setup(&port) < 0)
 		printk(KERN_WARNING "hp300_setup_serial_console(): early_serial_setup() failed.\n");
-	}
-
 	return 0;
 }
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
 #ifdef CONFIG_HPDCA
 static int __devinit hpdca_init_one(struct dio_dev *d,
-                                const struct dio_device_id *ent)
+				const struct dio_device_id *ent)
 {
 	struct uart_port port;
 	int line;
@@ -210,7 +205,7 @@ static int __devinit hpdca_init_one(stru
 
 static int __init hp300_8250_init(void)
 {
-	static int called = 0;
+	static int called;
 #ifdef CONFIG_HPAPCI
 	int line;
 	unsigned long base;
@@ -239,13 +234,12 @@ static int __init hp300_8250_init(void)
 	 * Port 1 is either the console or the DCA.
 	 */
 	for (i = 1; i < 4; i++) {
-		/* Port 1 is the console on a 425e, on other machines it's mapped to
-		 * DCA.
+		/* Port 1 is the console on a 425e, on other machines it's
+		 * mapped to DCA.
 		 */
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-		if (i == 1) {
+		if (i == 1)
 			continue;
-		}
 #endif
 
 		/* Create new serial device */
@@ -259,7 +253,8 @@ static int __init hp300_8250_init(void)
 
 		/* Memory mapped I/O */
 		uport.iotype = UPIO_MEM;
-		uport.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF;
+		uport.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ \
+			      | UPF_BOOT_AUTOCONF;
 		/* XXX - no interrupt support yet */
 		uport.irq = 0;
 		uport.uartclk = HPAPCI_BAUD_BASE * 16;
@@ -270,8 +265,8 @@ static int __init hp300_8250_init(void)
 		line = serial8250_register_port(&uport);
 
 		if (line < 0) {
-			printk(KERN_NOTICE "8250_hp300: register_serial() APCI %d"
-			       " irq %d failed\n", i, uport.irq);
+			printk(KERN_NOTICE "8250_hp300: register_serial() APCI"
+			       " %d irq %d failed\n", i, uport.irq);
 			kfree(port);
 			continue;
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
