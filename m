From: akpm@linux-foundation.org
Subject: + synclink-series-prepare-for-bkl-pushdown.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:37 -0800
Message-ID: <200802230737.m1N7bQlG018515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYBWIBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, paulkf@microgate.com


The patch titled
     synclink series: Prepare for BKL pushdown
has been added to the -mm tree.  Its filename is
     synclink-series-prepare-for-bkl-pushdown.patch

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
Subject: synclink series: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

As these are quite complex I've simply pushed the BKL down into the ioctl
handler not tried to do anything neater.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c    |    6 +++
 drivers/char/synclink_gt.c |   58 +++++++++++++++++++++++------------
 drivers/char/synclinkmp.c  |   12 ++++++-
 3 files changed, 55 insertions(+), 21 deletions(-)

diff -puN drivers/char/synclink.c~synclink-series-prepare-for-bkl-pushdown drivers/char/synclink.c
--- a/drivers/char/synclink.c~synclink-series-prepare-for-bkl-pushdown
+++ a/drivers/char/synclink.c
@@ -2945,6 +2945,7 @@ static int mgsl_ioctl(struct tty_struct 
 		    unsigned int cmd, unsigned long arg)
 {
 	struct mgsl_struct * info = (struct mgsl_struct *)tty->driver_data;
+	int ret;
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
@@ -2959,7 +2960,10 @@ static int mgsl_ioctl(struct tty_struct 
 		    return -EIO;
 	}
 
-	return mgsl_ioctl_common(info, cmd, arg);
+	lock_kernel();
+	ret = mgsl_ioctl_common(info, cmd, arg);
+	unlock_kernel();
+	return ret;
 }
 
 static int mgsl_ioctl_common(struct mgsl_struct *info, unsigned int cmd, unsigned long arg)
diff -puN drivers/char/synclink_gt.c~synclink-series-prepare-for-bkl-pushdown drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink-series-prepare-for-bkl-pushdown
+++ a/drivers/char/synclink_gt.c
@@ -1098,6 +1098,7 @@ static int ioctl(struct tty_struct *tty,
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
+	int ret;
 
 	if (sanity_check(info, tty->name, "ioctl"))
 		return -ENODEV;
@@ -1109,37 +1110,54 @@ static int ioctl(struct tty_struct *tty,
 		    return -EIO;
 	}
 
+	lock_kernel();
+
 	switch (cmd) {
 	case MGSL_IOCGPARAMS:
-		return get_params(info, argp);
+		ret = get_params(info, argp);
+		break;
 	case MGSL_IOCSPARAMS:
-		return set_params(info, argp);
+		ret = set_params(info, argp);
+		break;
 	case MGSL_IOCGTXIDLE:
-		return get_txidle(info, argp);
+		ret = get_txidle(info, argp);
+		break;
 	case MGSL_IOCSTXIDLE:
-		return set_txidle(info, (int)arg);
+		ret = set_txidle(info, (int)arg);
+		break;
 	case MGSL_IOCTXENABLE:
-		return tx_enable(info, (int)arg);
+		ret = tx_enable(info, (int)arg);
+		break;
 	case MGSL_IOCRXENABLE:
-		return rx_enable(info, (int)arg);
+		ret = rx_enable(info, (int)arg);
+		break;
 	case MGSL_IOCTXABORT:
-		return tx_abort(info);
+		ret = tx_abort(info);
+		break;
 	case MGSL_IOCGSTATS:
-		return get_stats(info, argp);
+		ret = get_stats(info, argp);
+		break;
 	case MGSL_IOCWAITEVENT:
-		return wait_mgsl_event(info, argp);
+		ret = wait_mgsl_event(info, argp);
+		break;
 	case TIOCMIWAIT:
-		return modem_input_wait(info,(int)arg);
+		ret = modem_input_wait(info,(int)arg);
+		break;
 	case MGSL_IOCGIF:
-		return get_interface(info, argp);
+		ret = get_interface(info, argp);
+		break;
 	case MGSL_IOCSIF:
-		return set_interface(info,(int)arg);
+		ret = set_interface(info,(int)arg);
+		break;
 	case MGSL_IOCSGPIO:
-		return set_gpio(info, argp);
+		ret = set_gpio(info, argp);
+		break;
 	case MGSL_IOCGGPIO:
-		return get_gpio(info, argp);
+		ret = get_gpio(info, argp);
+		break;
 	case MGSL_IOCWAITGPIO:
-		return wait_gpio(info, argp);
+		ret = wait_gpio(info, argp);
+		break;
 	case TIOCGICOUNT:
 		spin_lock_irqsave(&info->lock,flags);
 		cnow = info->icount;
@@ -1156,12 +1174,14 @@ static int ioctl(struct tty_struct *tty,
 		    put_user(cnow.parity, &p_cuser->parity) ||
 		    put_user(cnow.brk, &p_cuser->brk) ||
 		    put_user(cnow.buf_overrun, &p_cuser->buf_overrun))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		ret = 0;
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
 	}
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 /*
diff -puN drivers/char/synclinkmp.c~synclink-series-prepare-for-bkl-pushdown drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~synclink-series-prepare-for-bkl-pushdown
+++ a/drivers/char/synclinkmp.c
@@ -1303,7 +1303,7 @@ static void tx_release(struct tty_struct
  *
  * Return Value:	0 if success, otherwise error code
  */
-static int ioctl(struct tty_struct *tty, struct file *file,
+static int do_ioctl(struct tty_struct *tty, struct file *file,
 		 unsigned int cmd, unsigned long arg)
 {
 	SLMP_INFO *info = (SLMP_INFO *)tty->driver_data;
@@ -1393,6 +1393,16 @@ static int ioctl(struct tty_struct *tty,
 	return 0;
 }
 
+static int ioctl(struct tty_struct *tty, struct file *file,
+		 unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	ret = do_ioctl(tty, file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 /*
  * /proc fs routines....
  */
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
