From: akpm@linux-foundation.org
Subject: + pps-serial-clients-support.patch added to -mm tree
Date: Thu, 20 Mar 2008 13:03:35 -0700
Message-ID: <200803202003.m2KK3ZuM021540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbYCTUEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 16:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it


The patch titled
     PPS: serial clients support
has been added to the -mm tree.  Its filename is
     pps-serial-clients-support.patch

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
Subject: PPS: serial clients support
From: Rodolfo Giometti <giometti@linux.it>

Adds support for the PPS sources connected with the CD (Carrier Detect) pin of
a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/Kconfig  |   10 ++++
 drivers/serial/8250.c        |    2 
 drivers/serial/serial_core.c |   71 ++++++++++++++++++++++++++++++++-
 include/linux/serial_core.h  |   30 +++++++++++--
 4 files changed, 106 insertions(+), 7 deletions(-)

diff -puN drivers/pps/clients/Kconfig~pps-serial-clients-support drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-serial-clients-support
+++ a/drivers/pps/clients/Kconfig
@@ -15,4 +15,14 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.ko.
 
+comment "UART serial support (forced off)"
+	depends on ! (SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y))
+
+config PPS_CLIENT_UART
+	bool "UART serial support"
+	depends on SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y)
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
 endif
diff -puN drivers/serial/8250.c~pps-serial-clients-support drivers/serial/8250.c
--- a/drivers/serial/8250.c~pps-serial-clients-support
+++ a/drivers/serial/8250.c
@@ -2173,6 +2173,8 @@ serial8250_set_termios(struct uart_port 
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
+	if (up->port.flags & UPF_HARDPPS_CD)
+		up->ier |= UART_IER_MSI;	/* enable interrupts */
 
 	serial_out(up, UART_IER, up->ier);
 
diff -puN drivers/serial/serial_core.c~pps-serial-clients-support drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~pps-serial-clients-support
+++ a/drivers/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/pps.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -642,6 +643,54 @@ static int uart_get_info(struct uart_sta
 	return 0;
 }
 
+#ifdef CONFIG_PPS_CLIENT_UART
+
+static int
+uart_register_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	struct tty_driver *drv = port->info->tty->driver;
+	int ret;
+
+	state->pps_info.owner = THIS_MODULE;
+	state->pps_info.dev = port->dev;
+	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
+		drv->driver_name, port->line);
+	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
+		drv->name, port->line);
+
+	state->pps_info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (ret < 0) {
+		dev_err(port->dev, "cannot register PPS source \"%s\"\n",
+						state->pps_info.path);
+		return ret;
+	}
+	port->pps_source = ret;
+	dev_dbg(port->dev, "PPS source #%d \"%s\" added\n",
+		port->pps_source, state->pps_info.path);
+
+	return 0;
+}
+
+static void
+uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	pps_unregister_source(port->pps_source);
+	dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
+				port->pps_source, state->pps_info.path);
+}
+
+#else
+
+#define uart_register_pps_port(state, port)	do { } while (0)
+#define uart_unregister_pps_port(state, port)	do { } while (0)
+
+#endif /* CONFIG_PPS_CLIENT_UART */
+
 static int uart_set_info(struct uart_state *state,
 			 struct serial_struct __user *newinfo)
 {
@@ -817,11 +866,19 @@ static int uart_set_info(struct uart_sta
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
+	/* PPS support enabled/disabled? */
+	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {
+		if (new_flags & UPF_HARDPPS_CD)
+			uart_register_pps_port(state, port);
+		else
+			uart_unregister_pps_port(state, port);
+	}
+
 	retval = 0;
 	if (port->type == PORT_UNKNOWN)
 		goto exit;
 	if (state->info->flags & UIF_INITIALIZED) {
-		if (((old_flags ^ port->flags) & UPF_SPD_MASK) ||
+		if (((old_flags ^ port->flags) & (UPF_SPD_MASK|UPF_HARDPPS_CD)) ||
 		    old_custom_divisor != port->custom_divisor) {
 			/*
 			 * If they're setting up a custom divisor or speed,
@@ -2164,6 +2221,12 @@ uart_configure_port(struct uart_driver *
 		port->ops->config_port(port, flags);
 	}
 
+	/*
+	 * Add the PPS support for the current port.
+	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_register_pps_port(state, port);
+
 	if (port->type != PORT_UNKNOWN) {
 		unsigned long flags;
 
@@ -2480,6 +2543,12 @@ int uart_remove_one_port(struct uart_dri
 	mutex_unlock(&state->mutex);
 
 	/*
+	 * Remove PPS support from the current port.
+	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_unregister_pps_port(state, port);
+
+	/*
 	 * Remove the devices from the tty layer
 	 */
 	tty_unregister_device(drv->tty_driver, port->line);
diff -puN include/linux/serial_core.h~pps-serial-clients-support include/linux/serial_core.h
--- a/include/linux/serial_core.h~pps-serial-clients-support
+++ a/include/linux/serial_core.h
@@ -168,6 +168,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/pps.h>
 
 struct uart_port;
 struct uart_info;
@@ -251,6 +252,9 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
+#ifdef CONFIG_PPS_CLIENT_UART
+	int			pps_source;		/* PPS source ID */
+#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -295,7 +299,8 @@ struct uart_port {
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
 #define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
-#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
+#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY\
+							|UPF_HARDPPS_CD))
 
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		timeout;		/* character-based timeout */
@@ -328,6 +333,10 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
+#ifdef CONFIG_PPS_CLIENT_UART
+	struct pps_source_info	pps_info;
+#endif
+
 	struct mutex		mutex;
 };
 
@@ -492,13 +501,22 @@ uart_handle_dcd_change(struct uart_port 
 {
 	struct uart_info *info = port->info;
 
-	port->icount.dcd++;
-
-#ifdef CONFIG_HARD_PPS
-	if ((port->flags & UPF_HARDPPS_CD) && status)
-		hardpps();
+#ifdef CONFIG_PPS_CLIENT_UART
+	if (port->flags & UPF_HARDPPS_CD) {
+		if (status) {
+			pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+			dev_dbg(port->dev, "PPS assert at %lu on source #%d\n",
+				jiffies, port->pps_source);
+		} else {
+			pps_event(port->pps_source, PPS_CAPTURECLEAR, port);
+			dev_dbg(port->dev, "PPS clear at %lu on source #%d\n",
+				jiffies, port->pps_source);
+		}
+	}
 #endif
 
+	port->icount.dcd++;
+
 	if (info->flags & UIF_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&info->open_wait);
_

Patches currently in -mm which might be from giometti@linux.it are

linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
pps-serial-clients-support.patch
pps-example-program-to-enable-pps-support-on-serial-ports.patch
pps-parallel-port-clients-support.patch

