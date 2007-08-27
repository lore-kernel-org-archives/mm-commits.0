From: akpm@linux-foundation.org
Subject: + ioc3-program-uart-predividers.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:55:57 -0700
Message-ID: <200708272255.l7RMtvl7000387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbXH0W4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     IOC3: program UART predividers
has been added to the -mm tree.  Its filename is
     ioc3-program-uart-predividers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IOC3: program UART predividers
From: Ralf Baechle <ralf@linux-mips.org>

The IOC3 driver's UART detection bits used to rely on the the firmware
setting the UART pre-divider in a way that's apropriate for the 8250 driver
which doesn't currently program this register.  This happens to work for
the console but not rarely for additional ports.

While at it, also program the UART to RS-232 PIO mode; it the UART might
have been in mac-serial and/or DMA mode though that hasn't actually been
observed in practice.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ioc3-eth.c |   78 +++++++++++++++++++++++++++++----------
 1 files changed, 59 insertions(+), 19 deletions(-)

diff -puN drivers/net/ioc3-eth.c~ioc3-program-uart-predividers drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~ioc3-program-uart-predividers
+++ a/drivers/net/ioc3-eth.c
@@ -48,6 +48,7 @@
 #ifdef CONFIG_SERIAL_8250
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
+#include <linux/serial_reg.h>
 #endif
 
 #include <linux/netdevice.h>
@@ -1146,13 +1147,41 @@ static int ioc3_is_menet(struct pci_dev 
  * Also look in ip27-pci.c:pci_fixup_ioc3() for some comments on working
  * around ioc3 oddities in this respect.
  *
- * The IOC3 serials use a 22MHz clock rate with an additional divider by 3.
+ * The IOC3 serials use a 22MHz clock rate with an additional divider which
+ * can be programmed in the SCR register if the DLAB bit is set.
+ *
+ * Register to interrupt zero because we share the interrupt with
+ * the serial driver which we don't properly support yet.
+ *
+ * Can't use UPF_IOREMAP as the whole of IOC3 resources have already been
+ * registered.
  */
+static void __devinit ioc3_8250_register(struct ioc3_uartregs __iomem *uart)
+{
+#define COSMISC_CONSTANT 6
+
+	struct uart_port port = {
+		.irq		= 0,
+		.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 0,
+		.uartclk	= (22000000 << 1) / COSMISC_CONSTANT,
+
+		.membase	= (unsigned char __iomem *) uart,
+		.mapbase	= (unsigned long) uart,
+	};
+	unsigned char lcr;
+
+	lcr = uart->iu_lcr;
+	uart->iu_lcr = lcr | UART_LCR_DLAB;
+	uart->iu_scr = COSMISC_CONSTANT,
+	uart->iu_lcr = lcr;
+	uart->iu_lcr;
+	serial8250_register_port(&port);
+}
 
 static void __devinit ioc3_serial_probe(struct pci_dev *pdev, struct ioc3 *ioc3)
 {
-	struct uart_port port;
-
 	/*
 	 * We need to recognice and treat the fourth MENET serial as it
 	 * does not have an SuperIO chip attached to it, therefore attempting
@@ -1166,24 +1195,35 @@ static void __devinit ioc3_serial_probe(
 		return;
 
 	/*
-	 * Register to interrupt zero because we share the interrupt with
-	 * the serial driver which we don't properly support yet.
-	 *
-	 * Can't use UPF_IOREMAP as the whole of IOC3 resources have already
-	 * been registered.
+	 * Switch IOC3 to PIO mode.  It probably already was but let's be
+	 * paranoid
 	 */
-	memset(&port, 0, sizeof(port));
-	port.irq      = 0;
-	port.flags    = UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
-	port.iotype   = UPIO_MEM;
-	port.regshift = 0;
-	port.uartclk  = 22000000 / 3;
+	ioc3->gpcr_s = GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL;
+	ioc3->gpcr_s;
+	ioc3->gppr_6 = 0;
+	ioc3->gppr_6;
+	ioc3->gppr_7 = 0;
+	ioc3->gppr_7;
+	ioc3->sscr_a = ioc3->sscr_a & ~SSCR_DMA_EN;
+	ioc3->sscr_a;
+	ioc3->sscr_b = ioc3->sscr_b & ~SSCR_DMA_EN;
+	ioc3->sscr_b;
+	/* Disable all SA/B interrupts except for SA/B_INT in SIO_IEC. */
+	ioc3->sio_iec &= ~ (SIO_IR_SA_TX_MT | SIO_IR_SA_RX_FULL |
+			    SIO_IR_SA_RX_HIGH | SIO_IR_SA_RX_TIMER |
+			    SIO_IR_SA_DELTA_DCD | SIO_IR_SA_DELTA_CTS |
+			    SIO_IR_SA_TX_EXPLICIT | SIO_IR_SA_MEMERR);
+	ioc3->sio_iec |= SIO_IR_SA_INT;
+	ioc3->sscr_a = 0;
+	ioc3->sio_iec &= ~ (SIO_IR_SB_TX_MT | SIO_IR_SB_RX_FULL |
+			    SIO_IR_SB_RX_HIGH | SIO_IR_SB_RX_TIMER |
+			    SIO_IR_SB_DELTA_DCD | SIO_IR_SB_DELTA_CTS |
+			    SIO_IR_SB_TX_EXPLICIT | SIO_IR_SB_MEMERR);
+	ioc3->sio_iec |= SIO_IR_SB_INT;
+	ioc3->sscr_b = 0;
 
-	port.membase  = (unsigned char *) &ioc3->sregs.uarta;
-	serial8250_register_port(&port);
-
-	port.membase  = (unsigned char *) &ioc3->sregs.uartb;
-	serial8250_register_port(&port);
+	ioc3_8250_register(&ioc3->sregs.uarta);
+	ioc3_8250_register(&ioc3->sregs.uartb);
 }
 #endif
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
fix-font-dependency-for-sgi-newport-console-driver.patch
add-maintainers-entry-for-ioc3-serial-driver.patch
fix-modpost-warning-in-serial-driver.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
mips-qemu-network-work-again.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-irix_getcontext-will-always-fail-efault.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
dont-use-gfp_dma-for-zone-allocation.patch
sgiseeq-fix-return-type-of-sgiseeq_remove.patch
ioc3-program-uart-predividers.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
serio-fix-modpost-warning.patch
pci-section-warning-fix.patch
pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
vt-fix-warnings-in-selectionh.patch
define-global-bit-macro.patch
