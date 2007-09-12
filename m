From: akpm@linux-foundation.org
Subject: - wake-up-from-a-serial-port.patch removed from -mm tree
Date: Wed, 12 Sep 2007 15:18:28 -0700
Message-ID: <200709122218.l8CMISAD021927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040AbXILWTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 18:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, alan@lxorguk.ukuu.org.uk, greg@kroah.com, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     wake up from a serial port
has been removed from the -mm tree.  Its filename was
     wake-up-from-a-serial-port.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: wake up from a serial port
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Enable wakeup from serial ports, make it run-time configurable over sysfs,
e.g.,

echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup

Requires

# CONFIG_SYSFS_DEPRECATED is not set

Linkstation / kurobox systems from Buffalo Tech.  have an AVR controller
connected to host's UART.  The AVR controls power, buttons, fan, LEDs,
sensors...  So, practically the only way to wake the system up is to press a
button, which sends a byte from the AVR to the CPU.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c        |   30 ++++++++++++++++++++++++++----
 drivers/serial/serial_core.c |    9 ++++++++-
 2 files changed, 34 insertions(+), 5 deletions(-)

diff -puN drivers/serial/8250.c~wake-up-from-a-serial-port drivers/serial/8250.c
--- a/drivers/serial/8250.c~wake-up-from-a-serial-port
+++ a/drivers/serial/8250.c
@@ -129,6 +129,7 @@ struct uart_8250_port {
 	unsigned char		mcr;
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
+	char			suspended;
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
@@ -2701,6 +2702,14 @@ static int __devexit serial8250_remove(s
 	return 0;
 }
 
+static int serial8250_match_port(struct device *dev, void *data)
+{
+	struct uart_port *port = data;
+	dev_t devt = MKDEV(serial8250_reg.major, serial8250_reg.minor) + port->line;
+
+	return dev->devt == devt; /* Actually, only one tty per port */
+}
+
 static int serial8250_suspend(struct platform_device *dev, pm_message_t state)
 {
 	int i;
@@ -2708,8 +2717,16 @@ static int serial8250_suspend(struct pla
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
-			uart_suspend_port(&serial8250_reg, &up->port);
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev) {
+			struct device *tty_dev = device_find_child(up->port.dev, &up->port,
+								   serial8250_match_port);
+			if (device_may_wakeup(tty_dev))
+				enable_irq_wake(up->port.irq);
+			else {
+				uart_suspend_port(&serial8250_reg, &up->port);
+				up->suspended = 1;
+			}
+		}
 	}
 
 	return 0;
@@ -2722,8 +2739,13 @@ static int serial8250_resume(struct plat
 	for (i = 0; i < UART_NR; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
-		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
-			serial8250_resume_port(i);
+		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev) {
+			if (up->suspended) {
+				serial8250_resume_port(i);
+				up->suspended = 0;
+			} else
+				disable_irq_wake(up->port.irq);
+		}
 	}
 
 	return 0;
diff -puN drivers/serial/serial_core.c~wake-up-from-a-serial-port drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~wake-up-from-a-serial-port
+++ a/drivers/serial/serial_core.c
@@ -2271,6 +2271,7 @@ int uart_add_one_port(struct uart_driver
 {
 	struct uart_state *state;
 	int ret = 0;
+	struct device *tty_dev;
 
 	BUG_ON(in_interrupt());
 
@@ -2306,7 +2307,13 @@ int uart_add_one_port(struct uart_driver
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this ports parameters.
 	 */
-	tty_register_device(drv->tty_driver, port->line, port->dev);
+	tty_dev = tty_register_device(drv->tty_driver, port->line, port->dev);
+	if (likely(!IS_ERR(tty_dev))) {
+		device_can_wakeup(tty_dev) = 1;
+		device_set_wakeup_enable(tty_dev, 0);
+	} else
+		printk(KERN_ERR "Cannot register tty device on line %d\n",
+		       port->line);
 
 	/*
 	 * If this driver supports console, and it hasn't been
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

git-powerpc.patch
wake-up-from-a-serial-port.patch
