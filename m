From: akpm@linux-foundation.org
Subject: - at91_cf-use-generic-gpio-calls.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:23 -0800
Message-ID: <200802052227.m15MR4qQ011747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200AbYBEWm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     at91_cf: use generic gpio calls
has been removed from the -mm tree.  Its filename was
     at91_cf-use-generic-gpio-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-input.patch
git-backlight.patch
spi-core-stop-updating-dev-powerpower_state.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
spi-superh-spi-using-sci.patch
spi-omap2_mcspi-handles-omap3-too.patch
spi_bfin-remove-useless-fault-path.patch
spi_bfin-use-more-useful-gpio-labels.patch
spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch
spi_bfin-wait-for-tx-to-complete-on-full-duplex-paths.patch
spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
spi_bfin-headers-are-not-for-changelogs.patch
spi-remove-more-dev-powerpower_state-usage.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
rtc-ds1307-ds_1340-change-init.patch
rtc-remove-more-dev-powerpower_state-usage.patch
rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch
rtc-at91sam9-rtc-support-rtt-and-or-rtc-fix.patch
gpio-rename-pca9539-driver.patch
gpio-rename-pca953x-symbols.patch
gpio-handle-pca95345678-too.patch
atmel_lcdfb-backlight-control.patch
atmel_lcdfb-backlight-control-tiny-rework.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
basic-pwm-driver-for-avr32-and-at91.patch
pwm-led-driver.patch
