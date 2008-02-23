From: akpm@linux-foundation.org
Subject: + isicom-prepare-for-lock_kernel-push-down.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:17 -0800
Message-ID: <200802230737.m1N7b6mH018483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYBWHyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     isicom: prepare for lock_kernel push down
has been added to the -mm tree.  Its filename is
     isicom-prepare-for-lock_kernel-push-down.patch

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
Subject: isicom: prepare for lock_kernel push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Again lock the bits we can't trivially prove are safe without the BKL and
remove the broken TIOCS/GSOFTCAR handler.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/char/isicom.c~isicom-prepare-for-lock_kernel-push-down drivers/char/isicom.c
--- a/drivers/char/isicom.c~isicom-prepare-for-lock_kernel-push-down
+++ a/drivers/char/isicom.c
@@ -1258,6 +1258,8 @@ static int isicom_set_serial_info(struct
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
+	lock_kernel();
+
 	reconfig_port = ((port->flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
@@ -1265,8 +1267,10 @@ static int isicom_set_serial_info(struct
 		if ((newinfo.close_delay != port->close_delay) ||
 				(newinfo.closing_wait != port->closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
-				(port->flags & ~ASYNC_USR_MASK)))
+				(port->flags & ~ASYNC_USR_MASK))) {
+			unlock_kernel();
 			return -EPERM;
+		}
 		port->flags = ((port->flags & ~ ASYNC_USR_MASK) |
 				(newinfo.flags & ASYNC_USR_MASK));
 	}
@@ -1282,6 +1286,7 @@ static int isicom_set_serial_info(struct
 		isicom_config_port(port);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -1290,6 +1295,7 @@ static int isicom_get_serial_info(struct
 {
 	struct serial_struct out_info;
 
+	lock_kernel();
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
@@ -1299,6 +1305,7 @@ static int isicom_get_serial_info(struct
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->close_delay;
 	out_info.closing_wait = port->closing_wait;
+	unlock_kernel();
 	if (copy_to_user(info, &out_info, sizeof(out_info)))
 		return -EFAULT;
 	return 0;
@@ -1331,19 +1338,6 @@ static int isicom_ioctl(struct tty_struc
 		tty_wait_until_sent(tty, 0);
 		isicom_send_break(port, arg ? arg * (HZ/10) : HZ/4);
 		return 0;
-
-	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0,
-				(unsigned long __user *)argp);
-
-	case TIOCSSOFTCAR:
-		if (get_user(arg, (unsigned long __user *) argp))
-			return -EFAULT;
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
-		return 0;
-
 	case TIOCGSERIAL:
 		return isicom_get_serial_info(port, argp);
 
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
