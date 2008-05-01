From: akpm@linux-foundation.org
Subject: - synclink-series-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:10 -0700
Message-ID: <200805010928.m419SAPL030559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756857AbYEAJ2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     synclink series: Prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     synclink-series-prepare-for-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2942,6 +2942,7 @@ static int mgsl_ioctl(struct tty_struct 
 		    unsigned int cmd, unsigned long arg)
 {
 	struct mgsl_struct * info = (struct mgsl_struct *)tty->driver_data;
+	int ret;
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
@@ -2956,7 +2957,10 @@ static int mgsl_ioctl(struct tty_struct 
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
@@ -1097,6 +1097,7 @@ static int ioctl(struct tty_struct *tty,
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
+	int ret;
 
 	if (sanity_check(info, tty->name, "ioctl"))
 		return -ENODEV;
@@ -1108,37 +1109,54 @@ static int ioctl(struct tty_struct *tty,
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
@@ -1155,12 +1173,14 @@ static int ioctl(struct tty_struct *tty,
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
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

