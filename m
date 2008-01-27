From: akpm@linux-foundation.org
Subject: + atmel_serial-use-cpu_relax-when-busy-waiting.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:50 -0800
Message-ID: <200801270517.m0R5Hld3031148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbYA0FV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial: use cpu_relax() when busy-waiting
has been added to the -mm tree.  Its filename is
     atmel_serial-use-cpu_relax-when-busy-waiting.patch

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
Subject: atmel_serial: use cpu_relax() when busy-waiting
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Replace two instances of barrier() with cpu_relax() since that's the right
thing to do when busy-waiting.  This does not actually change anything since
cpu_relax() is defined as barrier() on both ARM and AVR32.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-use-cpu_relax-when-busy-waiting drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-use-cpu_relax-when-busy-waiting
+++ a/drivers/serial/atmel_serial.c
@@ -616,7 +616,7 @@ static void atmel_set_termios(struct uar
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		barrier();
+		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
@@ -795,7 +795,7 @@ void __init atmel_register_uart_fns(stru
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
-		barrier();
+		cpu_relax();
 	UART_PUT_CHAR(port, ch);
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
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
