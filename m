From: akpm@linux-foundation.org
Subject: + atmel_serial-add-dma-support-fix.patch added to -mm tree
Date: Mon, 28 Jan 2008 04:06:16 -0800
Message-ID: <200801281205.m0SC5vIl027400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbYA1MGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 07:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, linux@bohmer.net, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial dma: Misc fixes and cleanups
has been added to the -mm tree.  Its filename is
     atmel_serial-add-dma-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial dma: Misc fixes and cleanups
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Fix some issues identified by Andrew Morton:
  * Kill unused PDC_RX_BUF() and PDC_RX_SWITCH() macros
  * Simplify TX circ buffer management a bit.
  * Don't open-code min()
  * Add comment explaining why "count = head - tail" will not cause
    wraparound problems.

Also, s/SERIAL_XMIT_SIZE/UART_XMIT_SIZE/ since the latter is what the
serial core circ macros use.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Remy Bohmer <linux@bohmer.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-add-dma-support-fix drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-add-dma-support-fix
+++ a/drivers/serial/atmel_serial.c
@@ -114,7 +114,7 @@ static void (*atmel_close_hook)(struct u
 struct atmel_dma_buffer {
 	unsigned char	*buf;
 	dma_addr_t	dma_addr;
-	size_t		dma_size;
+	unsigned int	dma_size;
 	unsigned int	ofs;
 };
 
@@ -150,9 +150,6 @@ struct atmel_uart_port {
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
 
-#define PDC_RX_BUF(port)	&(port)->pdc_rx[(port)->pdc_rx_idx]
-#define PDC_RX_SWITCH(port)	(port)->pdc_rx_idx = !(port)->pdc_rx_idx
-
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
 #endif
@@ -561,8 +558,7 @@ static void atmel_tx_dma(struct uart_por
 	int count;
 
 	xmit->tail += pdc->ofs;
-	if (xmit->tail >= SERIAL_XMIT_SIZE)
-		xmit->tail -= SERIAL_XMIT_SIZE;
+	xmit->tail &= UART_XMIT_SIZE - 1;
 
 	port->icount.tx += pdc->ofs;
 	pdc->ofs = 0;
@@ -577,10 +573,7 @@ static void atmel_tx_dma(struct uart_por
 					   pdc->dma_size,
 					   DMA_TO_DEVICE);
 
-		if (xmit->tail < xmit->head)
-			count = xmit->head - xmit->tail;
-		else
-			count = SERIAL_XMIT_SIZE - xmit->tail;
+		count = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 		pdc->ofs = count;
 
 		UART_PUT_TPR(port, pdc->dma_addr + xmit->tail);
@@ -695,14 +688,20 @@ static void atmel_rx_from_dma(struct uar
 		 * ENDRX bit as well, so that we can safely re-enable
 		 * all interrupts below.
 		 */
-		if (head >= pdc->dma_size)
-			head = pdc->dma_size;
+		head = min(head, pdc->dma_size);
 
 		if (likely(head != tail)) {
 			dma_sync_single_for_cpu(port->dev, pdc->dma_addr,
 					pdc->dma_size, DMA_FROM_DEVICE);
 
+			/*
+			 * head will only wrap around when we recycle
+			 * the DMA buffer, and when that happens, we
+			 * explicitly set tail to 0. So head will
+			 * always be greater than tail.
+			 */
 			count = head - tail;
+
 			tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
 
 			dma_sync_single_for_device(port->dev, pdc->dma_addr,
@@ -852,9 +851,9 @@ static int atmel_startup(struct uart_por
 		pdc->buf = xmit->buf;
 		pdc->dma_addr = dma_map_single(port->dev,
 					       pdc->buf,
-					       SERIAL_XMIT_SIZE,
+					       UART_XMIT_SIZE,
 					       DMA_TO_DEVICE);
-		pdc->dma_size = SERIAL_XMIT_SIZE;
+		pdc->dma_size = UART_XMIT_SIZE;
 		pdc->ofs = 0;
 	}
 
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch
git-mtd.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
config_highpte-vs-sub-page-page-tables-avr32-fix.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
add-have_oprofile.patch
atmel_lcdfb-validate-display-timings.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-add-dma-support-fix.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
