From: akpm@linux-foundation.org
Subject: + tty_ioctl-soft-carrier-handling.patch added to -mm tree
Date: Mon, 10 Mar 2008 21:26:51 -0700
Message-ID: <200803110426.m2B4QpTk022080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbYCKE1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 00:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty_ioctl: soft carrier handling
has been added to the -mm tree.  Its filename is
     tty_ioctl-soft-carrier-handling.patch

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
Subject: tty_ioctl: soft carrier handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

First cut at moving the soft carrier handling knowledge entirely into the core
code.  One or two drivers still needed to snoop these functions to track
CLOCAL internally.  Instead make TIOCSSOFTCAR generate the same driver calls
as other termios ioctls changing the clocal flag.  This allows us to remove
any driver knowledge and special casing.  Also while we are at it we can fix
the error handling.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty_ioctl-soft-carrier-handling drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty_ioctl-soft-carrier-handling
+++ a/drivers/char/tty_ioctl.c
@@ -756,6 +756,32 @@ static int send_prio_char(struct tty_str
 }
 
 /**
+ *	tty_change_softcar	-	carrier change ioctl helper
+ *	@tty: tty to update
+ *	@arg: enable/disable CLOCAL
+ *
+ *	Perform a change to the CLOCAL state and call into the driver
+ *	layer to make it visible. All done with the termios mutex
+ */
+
+static int tty_change_softcar(struct tty_struct *tty, int arg)
+{
+	int ret = 0;
+	int bit = arg ? CLOCAL : 0;
+	struct ktermios old = *tty->termios;
+
+	mutex_lock(&tty->termios_mutex);
+	tty->termios->c_cflag &= ~CLOCAL;
+	tty->termios->c_cflag |= bit;
+	if (tty->driver->set_termios)
+		tty->driver->set_termios(tty, &old);
+	if ((tty->termios->c_cflag & CLOCAL) != bit)
+		ret = -EINVAL;
+	mutex_unlock(&tty->termios_mutex);
+	return ret;
+}
+
+/**
  *	tty_mode_ioctl		-	mode related ioctls
  *	@tty: tty for the ioctl
  *	@file: file pointer for the tty
@@ -865,12 +891,7 @@ int tty_mode_ioctl(struct tty_struct *tt
 	case TIOCSSOFTCAR:
 		if (get_user(arg, (unsigned int __user *) arg))
 			return -EFAULT;
-		mutex_lock(&tty->termios_mutex);
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			 (arg ? CLOCAL : 0));
-		mutex_unlock(&tty->termios_mutex);
-		return 0;
+		return tty_change_softcar(tty, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
3c501-further-coding-style-fixes.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
char-riscom-fix-rc_board-indexing.patch
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
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
istallion-tiocg-ssoftcar-handling-removal.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

