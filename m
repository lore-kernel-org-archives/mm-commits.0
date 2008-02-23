From: akpm@linux-foundation.org
Subject: + serial_core-prepare-for-bkl-push-down.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:48 -0800
Message-ID: <200802230737.m1N7bbeB018530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbYBWIAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk


The patch titled
     serial_core: Prepare for BKL push down
has been added to the -mm tree.  Its filename is
     serial_core-prepare-for-bkl-push-down.patch

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
-
+	unlock_kernel();
 #if 0
 	/*
 	 * No need to wake up processes in open wait, since they
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
megaraid-outb_p-extermination.patch
usb-serial-prepare-for-bkl-push-down.patch
ftdi_sio-note-missing-locking.patch
usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch
io_ti-lock-mcr-and-msr-shadows-properly.patch
iuu_phoenix-lock-priv-tiostatus-properly.patch
kobil_sct-get-rid-of-unneeded-priv-line_state.patch
ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch
git-watchdog.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
