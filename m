From: akpm@linux-foundation.org
Subject: - serial-8250-implement-dtr-dsr-handshaking.patch removed from -mm tree
Date: Thu, 13 Sep 2007 01:04:54 -0700
Message-ID: <200709130804.l8D84sdG008942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbXIMIFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 04:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@dvmwest.de, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial/8250: implement dtr/dsr handshaking
has been removed from the -mm tree.  Its filename was
     serial-8250-implement-dtr-dsr-handshaking.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: serial/8250: implement dtr/dsr handshaking
From: Michael Westermann <michael@dvmwest.de>

I make a driver for Point of Sale Printer, a wide range of Printers use
only a DTR/DSR hardware-handshaking.  When I use a handshaking in
userspace, the printer has a overrun problem and our customer has a problem
with the tax office.

Add a simple DTR/DSR handhake with a small change of the code.  Userspace
can select it with

cflags |= CDTRDSR;

The stty tool will need updating for this.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c        |   12 ++++++++----
 drivers/serial/serial_core.c |   12 ++++++++++++
 include/asm-i386/termbits.h  |    1 +
 include/linux/serial_core.h  |   16 +++++++++-------
 include/linux/termios.h      |    5 +++++
 5 files changed, 35 insertions(+), 11 deletions(-)

diff -puN drivers/serial/8250.c~serial-8250-implement-dtr-dsr-handshaking drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-8250-implement-dtr-dsr-handshaking
+++ a/drivers/serial/8250.c
@@ -1400,12 +1400,16 @@ static unsigned int check_modem_status(s
 	    up->port.info != NULL) {
 		if (status & UART_MSR_TERI)
 			up->port.icount.rng++;
-		if (status & UART_MSR_DDSR)
-			up->port.icount.dsr++;
 		if (status & UART_MSR_DDCD)
 			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
-		if (status & UART_MSR_DCTS)
-			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
+		if (status & (UART_MSR_DCTS|UART_MSR_DDSR)) {
+			if (status & UART_MSR_DDSR)
+				up->port.icount.dsr++;
+			else
+				up->port.icount.cts++;
+			uart_handle_dsr_cts_change(&up->port,
+				status & UART_MSR_CTS, status & UART_MSR_DSR);
+		}
 
 		wake_up_interruptible(&up->port.info->delta_msr_wait);
 	}
diff -puN drivers/serial/serial_core.c~serial-8250-implement-dtr-dsr-handshaking drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-8250-implement-dtr-dsr-handshaking
+++ a/drivers/serial/serial_core.c
@@ -192,6 +192,13 @@ static int uart_startup(struct uart_stat
 			spin_unlock_irq(&port->lock);
 		}
 
+		if (info->flags & UIF_DSR_FLOW) {
+			spin_lock_irq(&port->lock);
+			if (!(port->ops->get_mctrl(port) & TIOCM_DSR))
+				info->tty->hw_stopped = 1;
+			spin_unlock_irq(&port->lock);
+		}
+
 		info->flags |= UIF_INITIALIZED;
 
 		clear_bit(TTY_IO_ERROR, &info->tty->flags);
@@ -437,6 +444,11 @@ uart_change_speed(struct uart_state *sta
 	else
 		state->info->flags &= ~UIF_CTS_FLOW;
 
+	if (termios->c_cflag & CDTRDSR)
+		state->info->flags |= UIF_DSR_FLOW;
+	else
+		state->info->flags &= ~UIF_DSR_FLOW;
+
 	if (termios->c_cflag & CLOCAL)
 		state->info->flags &= ~UIF_CHECK_CD;
 	else
diff -puN include/asm-i386/termbits.h~serial-8250-implement-dtr-dsr-handshaking include/asm-i386/termbits.h
--- a/include/asm-i386/termbits.h~serial-8250-implement-dtr-dsr-handshaking
+++ a/include/asm-i386/termbits.h
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3500000 0010016
 #define  B4000000 0010017
 #define CIBAUD	  002003600000
+#define CDTRDSR	  004000000000		/* dtrdsr flow control */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
diff -puN include/linux/serial_core.h~serial-8250-implement-dtr-dsr-handshaking include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-8250-implement-dtr-dsr-handshaking
+++ a/include/linux/serial_core.h
@@ -335,6 +335,7 @@ struct uart_info {
  * Definitions for info->flags.  These are _private_ to serial_core, and
  * are specific to this structure.  They may be queried by low level drivers.
  */
+#define UIF_DSR_FLOW		((__force uif_t) (1 << 22))
 #define UIF_CHECK_CD		((__force uif_t) (1 << 25))
 #define UIF_CTS_FLOW		((__force uif_t) (1 << 26))
 #define UIF_NORMAL_ACTIVE	((__force uif_t) (1 << 29))
@@ -494,26 +495,27 @@ uart_handle_dcd_change(struct uart_port 
 
 /**
  *	uart_handle_cts_change - handle a change of clear-to-send state
+ *	when set DTR/DSR and RTS/CTS send only when both lines ok
  *	@port: uart_port structure for the open port
  *	@status: new clear to send status, nonzero if active
  */
 static inline void
-uart_handle_cts_change(struct uart_port *port, unsigned int status)
+uart_handle_dsr_cts_change(struct uart_port *port, unsigned int status_cts, unsigned int status_dsr)
 {
 	struct uart_info *info = port->info;
 	struct tty_struct *tty = info->tty;
+	int 	cts_stop = (info->flags & UIF_CTS_FLOW) && !status_cts;
+	int	dsr_stop = (info->flags & UIF_DSR_FLOW) && !status_dsr;
 
-	port->icount.cts++;
-
-	if (info->flags & UIF_CTS_FLOW) {
+	if ((info->flags & UIF_CTS_FLOW) || (info->flags & UIF_DSR_FLOW)) {
 		if (tty->hw_stopped) {
-			if (status) {
+			if (!(cts_stop||dsr_stop)) {
 				tty->hw_stopped = 0;
 				port->ops->start_tx(port);
 				uart_write_wakeup(port);
 			}
 		} else {
-			if (!status) {
+			if (cts_stop||dsr_stop) {
 				tty->hw_stopped = 1;
 				port->ops->stop_tx(port);
 			}
@@ -544,7 +546,7 @@ uart_insert_char(struct uart_port *port,
  *	UART_ENABLE_MS - determine if port should enable modem status irqs
  */
 #define UART_ENABLE_MS(port,cflag)	((port)->flags & UPF_HARDPPS_CD || \
-					 (cflag) & CRTSCTS || \
+					 (cflag) & (CRTSCTS|CDTRDSR) || \
 					 !((cflag) & CLOCAL))
 
 #endif
diff -puN include/linux/termios.h~serial-8250-implement-dtr-dsr-handshaking include/linux/termios.h
--- a/include/linux/termios.h~serial-8250-implement-dtr-dsr-handshaking
+++ a/include/linux/termios.h
@@ -4,4 +4,9 @@
 #include <linux/types.h>
 #include <asm/termios.h>
 
+#ifndef CDTRDSR
+#warning This architecture should implement CDTRDSR
+#define CDTRDSR 0 /* remove this when all architectures have a definition */
+#endif
+
 #endif
_

Patches currently in -mm which might be from michael@dvmwest.de are

serial-8250-implement-dtr-dsr-handshaking.patch
