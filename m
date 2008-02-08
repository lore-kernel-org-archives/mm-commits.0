From: akpm@linux-foundation.org
Subject: - serial_core-bring-mostly-into-line-with-coding-style.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:06 -0800
Message-ID: <200802082012.m18KCl9e010236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbYBHUwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     serial_core: bring mostly into line with coding style
has been removed from the -mm tree.  Its filename was
     serial_core-bring-mostly-into-line-with-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial_core: bring mostly into line with coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   55 ++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff -puN drivers/serial/serial_core.c~serial_core-bring-mostly-into-line-with-coding-style drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial_core-bring-mostly-into-line-with-coding-style
+++ a/drivers/serial/serial_core.c
@@ -58,7 +58,8 @@ static struct lock_class_key port_lock_k
 #define uart_console(port)	(0)
 #endif
 
-static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
+static void uart_change_speed(struct uart_state *state,
+					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
@@ -129,8 +130,8 @@ uart_update_mctrl(struct uart_port *port
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-#define uart_set_mctrl(port,set)	uart_update_mctrl(port,set,0)
-#define uart_clear_mctrl(port,clear)	uart_update_mctrl(port,0,clear)
+#define uart_set_mctrl(port, set)	uart_update_mctrl(port, set, 0)
+#define uart_clear_mctrl(port, clear)	uart_update_mctrl(port, 0, clear)
 
 /*
  * Startup the port.  This will be called once per open.  All calls
@@ -290,7 +291,7 @@ uart_update_timeout(struct uart_port *po
 		break;
 	default:
 		bits = 10;
-		break; // CS8
+		break; /* CS8 */
 	}
 
 	if (cflag & CSTOPB)
@@ -622,7 +623,7 @@ static int uart_get_info(struct uart_sta
 	tmp.close_delay	    = state->close_delay / 10;
 	tmp.closing_wait    = state->closing_wait == USF_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-			        state->closing_wait / 10;
+				state->closing_wait / 10;
 	tmp.custom_divisor  = port->custom_divisor;
 	tmp.hub6	    = port->hub6;
 	tmp.io_type         = port->iotype;
@@ -788,7 +789,8 @@ static int uart_set_info(struct uart_sta
 			 * We failed anyway.
 			 */
 			retval = -EBUSY;
-			goto exit;  // Added to return the correct error -Ram Gupta
+			/* Added to return the correct error -Ram Gupta */
+			goto exit;
 		}
 	}
 
@@ -858,7 +860,7 @@ static int uart_get_lsr_info(struct uart
 	    ((uart_circ_chars_pending(&state->info->xmit) > 0) &&
 	     !state->info->tty->stopped && !state->info->tty->hw_stopped))
 		result &= ~TIOCSER_TEMT;
-	
+
 	return put_user(result, value);
 }
 
@@ -996,8 +998,8 @@ uart_wait_modem_status(struct uart_state
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
 		    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
-		    	ret = 0;
-		    	break;
+			ret = 0;
+			break;
 		}
 
 		schedule();
@@ -1137,7 +1139,8 @@ uart_ioctl(struct tty_struct *tty, struc
 	return ret;
 }
 
-static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void uart_set_termios(struct tty_struct *tty,
+						struct ktermios *old_termios)
 {
 	struct uart_state *state = tty->driver_data;
 	unsigned long flags;
@@ -1213,7 +1216,7 @@ static void uart_close(struct tty_struct
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port;
-	
+
 	BUG_ON(!kernel_locked());
 
 	if (!state || !state->port)
@@ -1278,8 +1281,8 @@ static void uart_close(struct tty_struct
 	uart_shutdown(state);
 	uart_flush_buffer(tty);
 
-	tty_ldisc_flush(tty);	
-	
+	tty_ldisc_flush(tty);
+
 	tty->closing = 0;
 	state->info->tty = NULL;
 
@@ -1341,7 +1344,7 @@ static void uart_wait_until_sent(struct 
 	expire = jiffies + timeout;
 
 	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
-	        port->line, jiffies, expire);
+		port->line, jiffies, expire);
 
 	/*
 	 * Check whether the transmitter is empty every 'char_time'.
@@ -1460,10 +1463,9 @@ uart_block_til_ready(struct file *filp, 
 		 * have set TTY_IO_ERROR for a non-existant port.
 		 */
 		if ((filp->f_flags & O_NONBLOCK) ||
-	            (info->tty->termios->c_cflag & CLOCAL) ||
-		    (info->tty->flags & (1 << TTY_IO_ERROR))) {
+		    (info->tty->termios->c_cflag & CLOCAL) ||
+		    (info->tty->flags & (1 << TTY_IO_ERROR)))
 			break;
-		}
 
 		/*
 		 * Set DTR to allow modem to know we're waiting.  Do
@@ -1674,7 +1676,7 @@ static int uart_line_info(char *buf, str
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)port->mapbase
-		             : (unsigned long long) port->iobase,
+			     : (unsigned long long) port->iobase,
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
@@ -1682,8 +1684,7 @@ static int uart_line_info(char *buf, str
 		return ret + 1;
 	}
 
-	if(capable(CAP_SYS_ADMIN))
-	{
+	if (capable(CAP_SYS_ADMIN)) {
 		mutex_lock(&state->mutex);
 		pm_state = state->pm_state;
 		if (pm_state)
@@ -1709,12 +1710,12 @@ static int uart_line_info(char *buf, str
 		if (port->icount.overrun)
 			ret += sprintf(buf + ret, " oe:%d",
 				port->icount.overrun);
-	
-#define INFOBIT(bit,str) \
+
+#define INFOBIT(bit, str) \
 	if (port->mctrl & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 			strlen(stat_buf) - 2)
-#define STATBIT(bit,str) \
+#define STATBIT(bit, str) \
 	if (status & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 		       strlen(stat_buf) - 2)
@@ -1730,7 +1731,7 @@ static int uart_line_info(char *buf, str
 		if (stat_buf[0])
 			stat_buf[0] = ' ';
 		strcat(stat_buf, "\n");
-	
+
 		ret += sprintf(buf + ret, stat_buf);
 	} else {
 		strcat(buf, "\n");
@@ -1992,11 +1993,11 @@ int uart_suspend_port(struct uart_driver
 		/*
 		 * Wait for the transmitter to empty.
 		 */
-		for (tries = 3; !ops->tx_empty(port) && tries; tries--) {
+		for (tries = 3; !ops->tx_empty(port) && tries; tries--)
 			msleep(10);
-		}
 		if (!tries)
-			printk(KERN_ERR "%s%s%s%d: Unable to drain transmitter\n",
+			printk(KERN_ERR "%s%s%s%d: Unable to drain "
+					"transmitter\n",
 			       port->dev ? port->dev->bus_id : "",
 			       port->dev ? ": " : "",
 			       drv->dev_name, port->line);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
