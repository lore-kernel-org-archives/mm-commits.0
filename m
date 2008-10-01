From: akpm@linux-foundation.org
Subject: - atmel_serial-update-the-powersave-handler-to-match-serial-core.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:11 -0700
Message-ID: <200810012150.m91LoBWd005830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbYJAVuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anti.sullin@artecdesign.ee, haavard.skinnemoen@atmel.com, linux@maxim.org.za, trimarchimichael@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: update the powersave handler to match serial core
has been removed from the -mm tree.  Its filename was
     atmel_serial-update-the-powersave-handler-to-match-serial-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: update the powersave handler to match serial core
From: Anti Sullin <anti.sullin@artecdesign.ee>

This problem seems to be unnoticed so far:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3b708fa2780cd2b5d8266a8f0c3a1cab364d4d2

has changed the serial core behavior to not to suspend the port if the
device is enabled as a wakeup source.  If the AT91 system goes to slow
clock mode, the port should be suspended always and the clocks should be
switched off.  The patch attached updates the atmel_serial driver to match
the changes in serial core.

Also, the interrupts are disabled when the clock is disabled.  If we
disable the clock with interrupts enabled, an interrupt may get stuck.  If
this is the DBGU interrupt, this blocks the OR logic at system controller
and thus all other sysc interrupts.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-update-the-powersave-handler-to-match-serial-core drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-update-the-powersave-handler-to-match-serial-core
+++ a/drivers/serial/atmel_serial.c
@@ -131,7 +131,8 @@ struct atmel_uart_char {
 struct atmel_uart_port {
 	struct uart_port	uart;		/* uart */
 	struct clk		*clk;		/* uart clock */
-	unsigned short		suspended;	/* is port suspended? */
+	int			may_wakeup;	/* cached value of device_may_wakeup for times we need to disable it */
+	u32			backup_imr;	/* IMR saved during suspend */
 	int			break_active;	/* break being received */
 
 	short			use_dma_rx;	/* enable PDC receiver */
@@ -984,8 +985,15 @@ static void atmel_serial_pm(struct uart_
 		 * This is called on uart_open() or a resume event.
 		 */
 		clk_enable(atmel_port->clk);
+
+		/* re-enable interrupts if we disabled some on suspend */
+		UART_PUT_IER(port, atmel_port->backup_imr);
 		break;
 	case 3:
+		/* Back up the interrupt mask and disable all interrupts */
+		atmel_port->backup_imr = UART_GET_IMR(port);
+		UART_PUT_IDR(port, -1);
+
 		/*
 		 * Disable the peripheral clock for this serial port.
 		 * This is called on uart_close() or a suspend event.
@@ -1475,13 +1483,12 @@ static int atmel_serial_suspend(struct p
 			cpu_relax();
 	}
 
-	if (device_may_wakeup(&pdev->dev)
-	    && !atmel_serial_clk_will_stop())
-		enable_irq_wake(port->irq);
-	else {
-		uart_suspend_port(&atmel_uart, port);
-		atmel_port->suspended = 1;
-	}
+	/* we can not wake up if we're running on slow clock */
+	atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
+	if (atmel_serial_clk_will_stop())
+		device_set_wakeup_enable(&pdev->dev, 0);
+
+	uart_suspend_port(&atmel_uart, port);
 
 	return 0;
 }
@@ -1491,11 +1498,8 @@ static int atmel_serial_resume(struct pl
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
-	if (atmel_port->suspended) {
-		uart_resume_port(&atmel_uart, port);
-		atmel_port->suspended = 0;
-	} else
-		disable_irq_wake(port->irq);
+	uart_resume_port(&atmel_uart, port);
+	device_set_wakeup_enable(&pdev->dev, atmel_port->may_wakeup);
 
 	return 0;
 }
@@ -1513,6 +1517,8 @@ static int __devinit atmel_serial_probe(
 	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
 
 	port = &atmel_ports[pdev->id];
+	port->backup_imr = 0;
+
 	atmel_init_port(port, pdev);
 
 	if (!atmel_use_dma_rx(&port->uart)) {
_

Patches currently in -mm which might be from anti.sullin@artecdesign.ee are


