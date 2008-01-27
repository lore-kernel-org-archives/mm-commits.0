From: akpm@linux-foundation.org
Subject: + atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:55 -0800
Message-ID: <200801270517.m0R5HqEN031155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYA0FSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial: fix bugs in probe() error path and remove()
has been added to the -mm tree.  Its filename is
     atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch

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
Subject: atmel_serial: fix bugs in probe() error path and remove()
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

When an error happens in probe(), the clocks should be disabled, but
only if the port isn't already used as a console.

In remove(), the port struct shouldn't be freed because it's defined
statically.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   39 +++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-bugs-in-probe-error-path-and-remove drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-bugs-in-probe-error-path-and-remove
+++ a/drivers/serial/atmel_serial.c
@@ -935,8 +935,18 @@ static int __init atmel_late_console_ini
 
 core_initcall(atmel_late_console_init);
 
+static inline bool atmel_is_console_port(struct uart_port *port)
+{
+	return port->cons && port->cons->index == port->line;
+}
+
 #else
 #define ATMEL_CONSOLE_DEVICE	NULL
+
+static inline bool atmel_is_console_port(struct uart_port *port)
+{
+	return false;
+}
 #endif
 
 static struct uart_driver atmel_uart = {
@@ -994,9 +1004,19 @@ static int __devinit atmel_serial_probe(
 	atmel_init_port(port, pdev);
 
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
-	if (!ret) {
-		device_init_wakeup(&pdev->dev, 1);
-		platform_set_drvdata(pdev, port);
+	if (ret)
+		goto err_add_port;
+
+	device_init_wakeup(&pdev->dev, 1);
+	platform_set_drvdata(pdev, port);
+
+	return 0;
+
+err_add_port:
+	if (!atmel_is_console_port(&port->uart)) {
+		clk_disable(port->clk);
+		clk_put(port->clk);
+		port->clk = NULL;
 	}
 
 	return ret;
@@ -1008,16 +1028,15 @@ static int __devexit atmel_serial_remove
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	int ret = 0;
 
-	clk_disable(atmel_port->clk);
-	clk_put(atmel_port->clk);
-
 	device_init_wakeup(&pdev->dev, 0);
 	platform_set_drvdata(pdev, NULL);
 
-	if (port) {
-		ret = uart_remove_one_port(&atmel_uart, port);
-		kfree(port);
-	}
+	ret = uart_remove_one_port(&atmel_uart, port);
+
+	/* "port" is allocated statically, so we shouldn't free it */
+
+	clk_disable(atmel_port->clk);
+	clk_put(atmel_port->clk);
 
 	return ret;
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
