From: akpm@linux-foundation.org
Subject: + wake-up-from-a-serial-port.patch added to -mm tree
Date: Fri, 14 Sep 2007 01:42:34 -0700
Message-ID: <200709140842.l8E8gYgJ029321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbXINIn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 04:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, alan@lxorguk.ukuu.org.uk, greg@kroah.com, kay.sievers@vrfy.org, rmk@arm.linux.org.uk


The patch titled
     wake up from a serial port
has been added to the -mm tree.  Its filename is
     wake-up-from-a-serial-port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wake up from a serial port
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Enable wakeup from serial ports, make it run-time configurable over sysfs,
e.g.,

echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup

Requires

# CONFIG_SYSFS_DEPRECATED is not set

Following suggestions from Alan and Russell moved the may_wake_up checks
to serial_core.c. This time actually tested - it does even work. Could
someone, please, verify, that put_device after device_find_child is
correct?

Also would be nice to test with a Natsemi UART, that can wake up the system,
if such systems exist.

For this you just have to apply the patch below, issue the above "echo"
command to one of your Natsemi port, suspend and resume your system, and
verify that your Natsemi port still works.  If you are actually capable of
waking up the system from that port, would be nice to test that as well.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   40 ++++++++++++++++++++++++++++++++-
 include/linux/serial_core.h  |    3 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_core.c~wake-up-from-a-serial-port drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~wake-up-from-a-serial-port
+++ a/drivers/serial/serial_core.c
@@ -1938,9 +1938,24 @@ static void uart_change_pm(struct uart_s
 	}
 }
 
+struct uart_match {
+	struct uart_port *port;
+	struct uart_driver *driver;
+};
+
+static int serial_match_port(struct device *dev, void *data)
+{
+	struct uart_match *match = data;
+	dev_t devt = MKDEV(match->driver->major, match->driver->minor) + match->port->line;
+
+	return dev->devt == devt; /* Actually, only one tty per port */
+}
+
 int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 {
 	struct uart_state *state = drv->state + port->line;
+	struct device *tty_dev;
+	struct uart_match match = {port, drv};
 
 	mutex_lock(&state->mutex);
 
@@ -1951,6 +1966,15 @@ int uart_suspend_port(struct uart_driver
 	}
 #endif
 
+	tty_dev = device_find_child(port->dev, &match, serial_match_port);
+	if (device_may_wakeup(tty_dev)) {
+		enable_irq_wake(port->irq);
+		put_device(tty_dev);
+		mutex_unlock(&state->mutex);
+		return 0;
+	}
+	port->suspended = 1;
+
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
 
@@ -1999,6 +2023,13 @@ int uart_resume_port(struct uart_driver 
 	}
 #endif
 
+	if (!port->suspended) {
+		disable_irq_wake(port->irq);
+		mutex_unlock(&state->mutex);
+		return 0;
+	}
+	port->suspended = 0;
+
 	uart_change_pm(state, 0);
 
 	/*
@@ -2271,6 +2302,7 @@ int uart_add_one_port(struct uart_driver
 {
 	struct uart_state *state;
 	int ret = 0;
+	struct device *tty_dev;
 
 	BUG_ON(in_interrupt());
 
@@ -2306,7 +2338,13 @@ int uart_add_one_port(struct uart_driver
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
diff -puN include/linux/serial_core.h~wake-up-from-a-serial-port include/linux/serial_core.h
--- a/include/linux/serial_core.h~wake-up-from-a-serial-port
+++ a/include/linux/serial_core.h
@@ -291,7 +291,8 @@ struct uart_port {
 	resource_size_t		mapbase;		/* for ioremap */
 	struct device		*dev;			/* parent device */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
-	unsigned char		unused[3];
+	unsigned char		suspended;
+	unsigned char		unused[2];
 	void			*private_data;		/* generic platform data pointer */
 };
 
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

git-powerpc.patch
wake-up-from-a-serial-port.patch
