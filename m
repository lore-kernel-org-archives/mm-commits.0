From: akpm@linux-foundation.org
Subject: + tty-fix-network-driver-interactions-with-tcget-set-calls.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:35:18 -0800
Message-ID: <200711090435.lA94ZIu5029568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761696AbXKIEf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:35:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davem@davemloft.net, jeff@garzik.org


The patch titled
     tty: fix network driver interactions with TCGET/SET calls
has been added to the -mm tree.  Its filename is
     tty-fix-network-driver-interactions-with-tcget-set-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: fix network driver interactions with TCGET/SET calls
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Dave Miller noted various cases where line disciplines for things like ppp go
poking around in termios themselves in ways that broke with the new termios
code.  Rather than have them all learning about termios internals provide
proper methods for this

- tty_mode_ioctl()

  This handles all the terminal mode handling for speed/carrier etc and none
  of the methods are ldisc dependant so they can be called by any user

- tty_perform_flush()

  This extracts the flush functionality and enables pppd the ppp layer to
  share it cleanly.

The existing n_tty_ioctl code is refactored in this patch to provide the new
functions and to call them itself appropriately.  This patch has no (intended)
behaviour changes and simply prepares for the other fixes.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |  170 ++++++++++++++++++++++---------------
 include/linux/tty.h      |    4 
 2 files changed, 107 insertions(+), 67 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-fix-network-driver-interactions-with-tcget-set-calls drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-fix-network-driver-interactions-with-tcget-set-calls
+++ a/drivers/char/tty_ioctl.c
@@ -730,13 +730,23 @@ static int send_prio_char(struct tty_str
 	return 0;
 }
 
-int n_tty_ioctl(struct tty_struct * tty, struct file * file,
-		       unsigned int cmd, unsigned long arg)
+/**
+ *	tty_mode_ioctl		-	mode related ioctls
+ *	@tty: tty for the ioctl
+ *	@file: file pointer for the tty
+ *	@cmd: command
+ *	@arg: ioctl argument
+ *
+ *	Perform non line discipline specific mode control ioctls. This
+ *	is designed to be called by line disciplines to ensure they provide
+ *	consistent mode setting.
+ */
+
+int tty_mode_ioctl(struct tty_struct * tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct * real_tty;
 	void __user *p = (void __user *)arg;
-	int retval;
-	struct tty_ldisc *ld;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -799,6 +809,93 @@ int n_tty_ioctl(struct tty_struct * tty,
 			return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_TERMIO);
 		case TCSETA:
 			return set_termios(real_tty, p, TERMIOS_TERMIO);
+#ifndef TCGETS2
+		case TIOCGLCKTRMIOS:
+			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
+				return -EFAULT;
+			return 0;
+
+		case TIOCSLCKTRMIOS:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
+				return -EFAULT;
+			return 0;
+#else
+		case TIOCGLCKTRMIOS:
+			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
+				return -EFAULT;
+			return 0;
+
+		case TIOCSLCKTRMIOS:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
+				return -EFAULT;
+			return 0;
+#endif
+		case TIOCGSOFTCAR:
+			return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)arg);
+		case TIOCSSOFTCAR:
+			if (get_user(arg, (unsigned int __user *) arg))
+				return -EFAULT;
+			mutex_lock(&tty->termios_mutex);
+			tty->termios->c_cflag =
+				((tty->termios->c_cflag & ~CLOCAL) |
+				 (arg ? CLOCAL : 0));
+			mutex_unlock(&tty->termios_mutex);
+			return 0;
+		default:
+			return -ENOIOCTLCMD;
+	}
+}
+
+EXPORT_SYMBOL_GPL(tty_mode_ioctl);
+
+int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
+{
+	struct tty_ldisc *ld;
+	int retval = tty_check_change(tty);
+	if (retval)
+		return retval;
+
+	ld = tty_ldisc_ref(tty);
+	switch (arg) {
+	case TCIFLUSH:
+		if (ld && ld->flush_buffer)
+			ld->flush_buffer(tty);
+		break;
+	case TCIOFLUSH:
+		if (ld && ld->flush_buffer)
+			ld->flush_buffer(tty);
+		/* fall through */
+	case TCOFLUSH:
+		if (tty->driver->flush_buffer)
+			tty->driver->flush_buffer(tty);
+		break;
+	default:
+		tty_ldisc_deref(ld);
+		return -EINVAL;
+	}
+	tty_ldisc_deref(ld);
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(tty_perform_flush);
+
+int n_tty_ioctl(struct tty_struct * tty, struct file * file,
+		       unsigned int cmd, unsigned long arg)
+{
+	struct tty_struct * real_tty;
+	int retval;
+
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
+	    tty->driver->subtype == PTY_TYPE_MASTER)
+		real_tty = tty->link;
+	else
+		real_tty = tty;
+
+	switch (cmd) {
 		case TCXONC:
 			retval = tty_check_change(tty);
 			if (retval)
@@ -829,30 +926,7 @@ int n_tty_ioctl(struct tty_struct * tty,
 			}
 			return 0;
 		case TCFLSH:
-			retval = tty_check_change(tty);
-			if (retval)
-				return retval;
-				
-			ld = tty_ldisc_ref(tty);
-			switch (arg) {
-			case TCIFLUSH:
-				if (ld && ld->flush_buffer)
-					ld->flush_buffer(tty);
-				break;
-			case TCIOFLUSH:
-				if (ld && ld->flush_buffer)
-					ld->flush_buffer(tty);
-				/* fall through */
-			case TCOFLUSH:
-				if (tty->driver->flush_buffer)
-					tty->driver->flush_buffer(tty);
-				break;
-			default:
-				tty_ldisc_deref(ld);
-				return -EINVAL;
-			}
-			tty_ldisc_deref(ld);
-			return 0;
+			return tty_perform_flush(tty, arg);
 		case TIOCOUTQ:
 			return put_user(tty->driver->chars_in_buffer ?
 					tty->driver->chars_in_buffer(tty) : 0,
@@ -862,32 +936,6 @@ int n_tty_ioctl(struct tty_struct * tty,
 			if (L_ICANON(tty))
 				retval = inq_canon(tty);
 			return put_user(retval, (unsigned int __user *) arg);
-#ifndef TCGETS2
-		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
-				return -EFAULT;
-			return 0;
-
-		case TIOCSLCKTRMIOS:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
-				return -EFAULT;
-			return 0;
-#else
-		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
-				return -EFAULT;
-			return 0;
-
-		case TIOCSLCKTRMIOS:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
-				return -EFAULT;
-			return 0;
-#endif
-
 		case TIOCPKT:
 		{
 			int pktmode;
@@ -906,19 +954,9 @@ int n_tty_ioctl(struct tty_struct * tty,
 				tty->packet = 0;
 			return 0;
 		}
-		case TIOCGSOFTCAR:
-			return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)arg);
-		case TIOCSSOFTCAR:
-			if (get_user(arg, (unsigned int __user *) arg))
-				return -EFAULT;
-			mutex_lock(&tty->termios_mutex);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			mutex_unlock(&tty->termios_mutex);
-			return 0;
 		default:
-			return -ENOIOCTLCMD;
+			/* Try the mode commands */
+			return tty_mode_ioctl(tty, file, cmd, arg);
 		}
 }
 
diff -puN include/linux/tty.h~tty-fix-network-driver-interactions-with-tcget-set-calls include/linux/tty.h
--- a/include/linux/tty.h~tty-fix-network-driver-interactions-with-tcget-set-calls
+++ a/include/linux/tty.h
@@ -332,7 +332,9 @@ extern void tty_ldisc_flush(struct tty_s
 
 extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		     unsigned long arg);
-
+extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg);
+extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
frv-remove-bogus-no_irq-=-1-define.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
keyspan-init-termios-properly.patch
tty-fix-network-driver-interactions-with-tcget-set-calls.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
