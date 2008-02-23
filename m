From: akpm@linux-foundation.org
Subject: + riscom8-prepare-for-bkl-pushdown.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:25 -0800
Message-ID: <200802230737.m1N7bE1P018497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761403AbYBWH5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:57:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     riscom8: Prepare for BKL pushdown
has been added to the -mm tree.  Its filename is
     riscom8-prepare-for-bkl-pushdown.patch

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
Subject: riscom8: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the locking down into a couple of functions that need it and remove
bogus TIOCG/SSOFTCAR handling

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/char/riscom8.c~riscom8-prepare-for-bkl-pushdown drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~riscom8-prepare-for-bkl-pushdown
+++ a/drivers/char/riscom8.c
@@ -1385,7 +1385,7 @@ static int rc_ioctl(struct tty_struct * 
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	int retval;
+	int retval = 0;
 				
 	if (rc_paranoia_check(port, tty->name, "rc_ioctl"))
 		return -ENODEV;
@@ -1406,23 +1406,20 @@ static int rc_ioctl(struct tty_struct * 
 		tty_wait_until_sent(tty, 0);
 		rc_send_break(port, arg ? arg*(HZ/10) : HZ/4);
 		break;
-	 case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned __user *)argp);
-	 case TIOCSSOFTCAR:
-		if (get_user(arg,(unsigned __user *) argp))
-			return -EFAULT;
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
+	 case TIOCGSERIAL:
+	 	lock_kernel();
+		retval = rc_get_serial_info(port, argp);
+		unlock_kernel();
 		break;
-	 case TIOCGSERIAL:	
-		return rc_get_serial_info(port, argp);
 	 case TIOCSSERIAL:	
-		return rc_set_serial_info(port, argp);
+	 	lock_kernel();
+		retval = rc_set_serial_info(port, argp);
+		unlock_kernel();
+		break;
 	 default:
-		return -ENOIOCTLCMD;
+		retval = -ENOIOCTLCMD;
 	}
-	return 0;
+	return retval;
 }
 
 static void rc_throttle(struct tty_struct * tty)
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
