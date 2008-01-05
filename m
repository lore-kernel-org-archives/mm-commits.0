From: akpm@linux-foundation.org
Subject: + at91_cf-use-generic-gpio-calls.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:52:12 -0800
Message-ID: <200801050652.m056qwJ4032518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbYAEGxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     at91_cf: use generic gpio calls
has been added to the -mm tree.  Its filename is
     at91_cf-use-generic-gpio-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at91_cf: use generic gpio calls
From: David Brownell <dbrownell@users.sourceforge.net>

Update the AT91 CF driver to use the generic GPIO calls instead of the
AT91-specific ones; and request exclusive use of those signals.

Minor tweaks to cleanup code paths: always in reverse order of how the
resources were allocated, with remove() matching the fault paths of
probe().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/at91_cf.c |   62 ++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 15 deletions(-)

diff -puN drivers/pcmcia/at91_cf.c~at91_cf-use-generic-gpio-calls drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~at91_cf-use-generic-gpio-calls
+++ a/drivers/pcmcia/at91_cf.c
@@ -21,9 +21,9 @@
 #include <asm/hardware.h>
 #include <asm/io.h>
 #include <asm/sizes.h>
+#include <asm/gpio.h>
 
 #include <asm/arch/board.h>
-#include <asm/arch/gpio.h>
 #include <asm/arch/at91rm9200_mc.h>
 
 
@@ -56,7 +56,7 @@ struct at91_cf_socket {
 
 static inline int at91_cf_present(struct at91_cf_socket *cf)
 {
-	return !at91_get_gpio_value(cf->board->det_pin);
+	return !gpio_get_value(cf->board->det_pin);
 }
 
 /*--------------------------------------------------------------------------*/
@@ -100,9 +100,9 @@ static int at91_cf_get_status(struct pcm
 		int vcc	= cf->board->vcc_pin;
 
 		*sp = SS_DETECT | SS_3VCARD;
-		if (!rdy || at91_get_gpio_value(rdy))
+		if (!rdy || gpio_get_value(rdy))
 			*sp |= SS_READY;
-		if (!vcc || at91_get_gpio_value(vcc))
+		if (!vcc || gpio_get_value(vcc))
 			*sp |= SS_POWERON;
 	} else
 		*sp = 0;
@@ -121,10 +121,10 @@ at91_cf_set_socket(struct pcmcia_socket 
 	if (cf->board->vcc_pin) {
 		switch (s->Vcc) {
 			case 0:
-				at91_set_gpio_value(cf->board->vcc_pin, 0);
+				gpio_set_value(cf->board->vcc_pin, 0);
 				break;
 			case 33:
-				at91_set_gpio_value(cf->board->vcc_pin, 1);
+				gpio_set_value(cf->board->vcc_pin, 1);
 				break;
 			default:
 				return -EINVAL;
@@ -132,7 +132,7 @@ at91_cf_set_socket(struct pcmcia_socket 
 	}
 
 	/* toggle reset if needed */
-	at91_set_gpio_value(cf->board->rst_pin, s->flags & SS_RESET);
+	gpio_set_value(cf->board->rst_pin, s->flags & SS_RESET);
 
 	pr_debug("%s: Vcc %d, io_irq %d, flags %04x csc %04x\n",
 		driver_name, s->Vcc, s->io_irq, s->flags, s->csc_mask);
@@ -239,11 +239,24 @@ static int __init at91_cf_probe(struct p
 	platform_set_drvdata(pdev, cf);
 
 	/* must be a GPIO; ergo must trigger on both edges */
-	status = request_irq(board->det_pin, at91_cf_irq, 0, driver_name, cf);
+	status = gpio_request(board->det_pin, "cf_det");
 	if (status < 0)
 		goto fail0;
+	status = request_irq(board->det_pin, at91_cf_irq, 0, driver_name, cf);
+	if (status < 0)
+		goto fail00;
 	device_init_wakeup(&pdev->dev, 1);
 
+	status = gpio_request(board->rst_pin, "cf_rst");
+	if (status < 0)
+		goto fail0a;
+
+	if (board->vcc_pin) {
+		status = gpio_request(board->vcc_pin, "cf_vcc");
+		if (status < 0)
+			goto fail0b;
+	}
+
 	/*
 	 * The card driver will request this irq later as needed.
 	 * but it causes lots of "irqNN: nobody cared" messages
@@ -251,16 +264,20 @@ static int __init at91_cf_probe(struct p
 	 * (Note:  DK board doesn't wire the IRQ pin...)
 	 */
 	if (board->irq_pin) {
+		status = gpio_request(board->irq_pin, "cf_irq");
+		if (status < 0)
+			goto fail0c;
 		status = request_irq(board->irq_pin, at91_cf_irq,
 				IRQF_SHARED, driver_name, cf);
 		if (status < 0)
-			goto fail0a;
+			goto fail0d;
 		cf->socket.pci_irq = board->irq_pin;
 	} else
 		cf->socket.pci_irq = NR_IRQS + 1;
 
 	/* pcmcia layer only remaps "real" memory not iospace */
-	cf->socket.io_offset = (unsigned long) ioremap(cf->phys_baseaddr + CF_IO_PHYS, SZ_2K);
+	cf->socket.io_offset = (unsigned long)
+			ioremap(cf->phys_baseaddr + CF_IO_PHYS, SZ_2K);
 	if (!cf->socket.io_offset) {
 		status = -ENXIO;
 		goto fail1;
@@ -296,11 +313,21 @@ fail2:
 fail1:
 	if (cf->socket.io_offset)
 		iounmap((void __iomem *) cf->socket.io_offset);
-	if (board->irq_pin)
+	if (board->irq_pin) {
 		free_irq(board->irq_pin, cf);
+fail0d:
+		gpio_free(board->irq_pin);
+	}
+fail0c:
+	if (board->vcc_pin)
+		gpio_free(board->vcc_pin);
+fail0b:
+	gpio_free(board->rst_pin);
 fail0a:
 	device_init_wakeup(&pdev->dev, 0);
 	free_irq(board->det_pin, cf);
+fail00:
+	gpio_free(board->det_pin);
 fail0:
 	kfree(cf);
 	return status;
@@ -313,13 +340,18 @@ static int __exit at91_cf_remove(struct 
 	struct resource		*io = cf->socket.io[0].res;
 
 	pcmcia_unregister_socket(&cf->socket);
-	if (board->irq_pin)
+	release_mem_region(io->start, io->end + 1 - io->start);
+	iounmap((void __iomem *) cf->socket.io_offset);
+	if (board->irq_pin) {
 		free_irq(board->irq_pin, cf);
+		gpio_free(board->irq_pin);
+	}
+	if (board->vcc_pin)
+		gpio_free(board->vcc_pin);
+	gpio_free(board->rst_pin);
 	device_init_wakeup(&pdev->dev, 0);
 	free_irq(board->det_pin, cf);
-	iounmap((void __iomem *) cf->socket.io_offset);
-	release_mem_region(io->start, io->end + 1 - io->start);
-
+	gpio_free(board->det_pin);
 	kfree(cf);
 	return 0;
 }
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

pcmcia-remove-pxa2xx_lubbock-build-warning.patch
spi_bitbang-always-grab-lock-with-irqs-blocked.patch
git-arm.patch
git-input.patch
backlight-omap1-backlight-driver.patch
pcmcia-stop-updating-dev-powerpower_state.patch
at91_cf-use-generic-gpio-calls.patch
spi-core-stop-updating-dev-powerpower_state.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
