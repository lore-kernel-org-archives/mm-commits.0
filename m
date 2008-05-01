From: akpm@linux-foundation.org
Subject: - serial_core-prepare-for-bkl-push-down.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:23 -0700
Message-ID: <200805010928.m419SNXB030575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842AbYEAJ2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial_core: Prepare for BKL push down
has been removed from the -mm tree.  Its filename was
     serial_core-prepare-for-bkl-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial_core: Prepare for BKL push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Instead of checking for the BKL in these methods, take it ourselves.  That
avoids propogating it into the serial drivers and we can then fix them later
on.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/serial/serial_core.c~serial_core-prepare-for-bkl-push-down drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial_core-prepare-for-bkl-push-down
+++ a/drivers/serial/serial_core.c
@@ -914,14 +914,14 @@ static void uart_break_ctl(struct tty_st
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->port;
 
-	BUG_ON(!kernel_locked());
-
+	lock_kernel();
 	mutex_lock(&state->mutex);
 
 	if (port->type != PORT_UNKNOWN)
 		port->ops->break_ctl(port, break_state);
 
 	mutex_unlock(&state->mutex);
+	unlock_kernel();
 }
 
 static int uart_do_autoconfig(struct uart_state *state)
@@ -1059,7 +1059,7 @@ static int uart_get_count(struct uart_st
 }
 
 /*
- * Called via sys_ioctl under the BKL.  We can use spin_lock_irq() here.
+ * Called via sys_ioctl.  We can use spin_lock_irq() here.
  */
 static int
 uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
@@ -1069,8 +1069,8 @@ uart_ioctl(struct tty_struct *tty, struc
 	void __user *uarg = (void __user *)arg;
 	int ret = -ENOIOCTLCMD;
 
-	BUG_ON(!kernel_locked());
 
+	lock_kernel();
 	/*
 	 * These ioctls don't rely on the hardware to be present.
 	 */
@@ -1143,6 +1143,7 @@ uart_ioctl(struct tty_struct *tty, struc
  out_up:
 	mutex_unlock(&state->mutex);
  out:
+	unlock_kernel();
 	return ret;
 }
 
@@ -1153,7 +1154,6 @@ static void uart_set_termios(struct tty_
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	BUG_ON(!kernel_locked());
 
 	/*
 	 * These are the bits that are used to setup various
@@ -1165,9 +1165,11 @@ static void uart_set_termios(struct tty_
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
 	    tty->termios->c_ospeed == old_termios->c_ospeed &&
 	    tty->termios->c_ispeed == old_termios->c_ispeed &&
-	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
+	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0) {
 		return;
+	}
 
+	lock_kernel();
 	uart_change_speed(state, old_termios);
 
 	/* Handle transition to B0 status */
@@ -1200,7 +1202,7 @@ static void uart_set_termios(struct tty_
 		}
 		spin_unlock_irqrestore(&state->port->lock, flags);
 	}
