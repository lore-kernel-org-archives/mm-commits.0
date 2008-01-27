From: akpm@linux-foundation.org
Subject: + atmel_serial-use-existing-console-options-only-if-brg-is-running.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:52 -0800
Message-ID: <200801270517.m0R5HnaJ031152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbYA0FSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial: use existing console options only if BRG is running
has been added to the -mm tree.  Its filename is
     atmel_serial-use-existing-console-options-only-if-brg-is-running.patch

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
Subject: atmel_serial: use existing console options only if BRG is running
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

If BRGR is zero, the baud rate generator isn't running, so the boot loader
can't have initialized the port.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-use-existing-console-options-only-if-brg-is-running drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-use-existing-console-options-only-if-brg-is-running
+++ a/drivers/serial/atmel_serial.c
@@ -835,13 +835,13 @@ static void __init atmel_console_get_opt
 {
 	unsigned int mr, quot;
 
-// TODO: CR is a write-only register
-//	unsigned int cr;
-//
-//	cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
-//	if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
-//		/* ok, the port was enabled */
-//	}
+	/*
+	 * If the baud rate generator isn't running, the port wasn't
+	 * initialized by the boot loader.
+	 */
+	quot = UART_GET_BRGR(port);
+	if (!quot)
+		return;
 
 	mr = UART_GET_MR(port) & ATMEL_US_CHRL;
 	if (mr == ATMEL_US_CHRL_8)
@@ -861,7 +861,6 @@ static void __init atmel_console_get_opt
 	 * lower than one of those, as it would make us fall through
 	 * to a much lower baud rate than we really want.
 	 */
-	quot = UART_GET_BRGR(port);
 	*baud = port->uartclk / (16 * (quot - 1));
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
