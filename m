From: akpm@linux-foundation.org
Subject: + atmel_serial-keep-clock-off-when-its-not-needed.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:05:47 -0800
Message-ID: <200811052005.mA5K5l6Q028157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbYKEUGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, haavard.skinnemoen@atmel.com


The patch titled
     atmel_serial: keep clock off when it's not needed
has been added to the -mm tree.  Its filename is
     atmel_serial-keep-clock-off-when-its-not-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: keep clock off when it's not needed
From: David Brownell <dbrownell@users.sourceforge.net>

The atmel_serial driver is mismanaging its clock by leaving it on at all
times ...  the whole point of clock management is to leave it off unless
it's actively needed, which conserves power!!

Although the kernel doesn't actually hang without my fix, it does
discard quite a lot of early console output.

The result still looks correct:

          usart        users= 1 on   35000000 Hz, for atmel_usart.0
          usart        users= 0 off  35000000 Hz, for atmel_usart.2

when using ttyS0 as serial console.

[haavard.skinnemoen@atmel.com: Make sure clock is enabled early for console]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-keep-clock-off-when-its-not-needed drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-keep-clock-off-when-its-not-needed
+++ a/drivers/serial/atmel_serial.c
@@ -1258,6 +1258,8 @@ static void __devinit atmel_init_port(st
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
+		clk_disable(atmel_port->clk);
+		/* only enable clock when USART is in use */
 	}
 
 	atmel_port->use_dma_rx = data->use_dma_rx;
@@ -1379,6 +1381,8 @@ static int __init atmel_console_setup(st
 		return -ENODEV;
 	}
 
+	clk_enable(atmel_ports[co->index].clk);
+
 	UART_PUT_IDR(port, -1);
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
@@ -1403,7 +1407,7 @@ static struct console atmel_console = {
 	.data		= &atmel_uart,
 };
 
-#define ATMEL_CONSOLE_DEVICE	&atmel_console
+#define ATMEL_CONSOLE_DEVICE	(&atmel_console)
 
 /*
  * Early console initialization (before VM subsystem initialized).
@@ -1534,6 +1538,15 @@ static int __devinit atmel_serial_probe(
 	if (ret)
 		goto err_add_port;
 
+	if (atmel_is_console_port(&port->uart)
+			&& ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
+		/*
+		 * The serial core enabled the clock for us, so undo
+		 * the clk_enable() in atmel_console_setup()
+		 */
+		clk_disable(port->clk);
+	}
+
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
 
@@ -1544,7 +1557,6 @@ err_add_port:
 	port->rx_ring.buf = NULL;
 err_alloc_ring:
 	if (!atmel_is_console_port(&port->uart)) {
-		clk_disable(port->clk);
 		clk_put(port->clk);
 		port->clk = NULL;
 	}
@@ -1568,7 +1580,6 @@ static int __devexit atmel_serial_remove
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clk_disable(atmel_port->clk);
 	clk_put(atmel_port->clk);
 
 	return ret;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

atmel_serial-keep-clock-off-when-its-not-needed.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
rtc-ds1307-remove-legacy-probe-checks.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch
genirq-record-irq_level-in-irq_desc.patch

