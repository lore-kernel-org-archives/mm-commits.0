From: akpm@linux-foundation.org
Subject: + char-mxser-ioctl-cleanup.patch added to -mm tree
Date: Tue, 22 Jan 2008 00:52:32 -0800
Message-ID: <200801220852.m0M8qCEd013058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbYAVIxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 03:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     Char: mxser, ioctl cleanup
has been added to the -mm tree.  Its filename is
     char-mxser-ioctl-cleanup.patch

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
Subject: Char: mxser, ioctl cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- remove dead MOXA_GET_CONF (always returned -ENXIO)
- remove useless MOXA_GET_CUMAJOR (unused)
- use get/put_user instead of copy_from/to_user for simple types
- cleanup TIOCMIWAIT -- return -ERESTARTSYS on signal, move condition into
  separate function

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   74 +++++++++++++++----------------------
 drivers/char/mxser_new.h |    2 -
 2 files changed, 31 insertions(+), 45 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser-ioctl-cleanup drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-ioctl-cleanup
+++ a/drivers/char/mxser_new.c
@@ -175,7 +175,6 @@ MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
 static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
 static int ttymajor = MXSERMAJOR;
-static int calloutmajor = MXSERCUMAJOR;
 
 /* Variables for insmod */
 
@@ -1454,21 +1453,8 @@ static int mxser_ioctl_special(unsigned 
 	unsigned int i, j;
 
 	switch (cmd) {
-	case MOXA_GET_CONF:
-/*		if (copy_to_user(argp, mxsercfg,
-				sizeof(struct mxser_hwconf) * 4))
-			return -EFAULT;
-		return 0;*/
-		return -ENXIO;
 	case MOXA_GET_MAJOR:
-		if (copy_to_user(argp, &ttymajor, sizeof(int)))
-			return -EFAULT;
-		return 0;
-
-	case MOXA_GET_CUMAJOR:
-		if (copy_to_user(argp, &calloutmajor, sizeof(int)))
-			return -EFAULT;
-		return 0;
+		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
 		result = 0;
@@ -1606,13 +1592,33 @@ static int mxser_ioctl_special(unsigned 
 	return 0;
 }
 
+static int mxser_cflags_changed(struct mxser_port *info, unsigned long arg,
+		struct async_icount *cprev)
+{
+	struct async_icount cnow;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&info->slock, flags);
+	cnow = info->icount;	/* atomic copy */
+	spin_unlock_irqrestore(&info->slock, flags);
+
+	ret =	((arg & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
+		((arg & TIOCM_DSR) && (cnow.dsr != cprev->dsr)) ||
+		((arg & TIOCM_CD)  && (cnow.dcd != cprev->dcd)) ||
+		((arg & TIOCM_CTS) && (cnow.cts != cprev->cts));
+
+	*cprev = cnow;
+
+	return ret;
+}
+
 static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	struct mxser_port *info = tty->driver_data;
-	struct async_icount cprev, cnow;	/* kernel counter temps */
+	struct async_icount cnow;
 	struct serial_icounter_struct __user *p_cuser;
-	unsigned long templ;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -1646,7 +1652,7 @@ static int mxser_ioctl(struct tty_struct
 			shiftbit = p * 2;
 			opmode = inb(info->opmode_ioaddr) >> shiftbit;
 			opmode &= OP_MODE_MASK;
-			if (copy_to_user(argp, &opmode, sizeof(int)))
+			if (put_user(opmode, (int __user *)argp))
 				return -EFAULT;
 		}
 		return 0;
@@ -1673,11 +1679,10 @@ static int mxser_ioctl(struct tty_struct
 		mxser_send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
 		return 0;
 	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *)argp);
+		return put_user(!!C_CLOCAL(tty), (unsigned long __user *)argp);
 	case TIOCSSOFTCAR:
-		if (get_user(templ, (unsigned long __user *) argp))
+		if (get_user(arg, (unsigned long __user *)argp))
 			return -EFAULT;
-		arg = templ;
 		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) | (arg ? CLOCAL : 0));
 		return 0;
 	case TIOCGSERIAL:
@@ -1697,18 +1702,8 @@ static int mxser_ioctl(struct tty_struct
 		cnow = info->icount;	/* note the counters on entry */
 		spin_unlock_irqrestore(&info->slock, flags);
 
-		wait_event_interruptible(info->delta_msr_wait, ({
-			cprev = cnow;
-			spin_lock_irqsave(&info->slock, flags);
-			cnow = info->icount;	/* atomic copy */
-			spin_unlock_irqrestore(&info->slock, flags);
-
-			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
-		}));
-		break;
+		return wait_event_interruptible(info->delta_msr_wait,
+				mxser_cflags_changed(info, arg, &cnow));
 	/*
 	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
 	 * Return: write counters to the user passed counter struct
@@ -1755,10 +1750,7 @@ static int mxser_ioctl(struct tty_struct
 
 		len += (lsr ? 0 : 1);
 
-		if (copy_to_user(argp, &len, sizeof(int)))
-			return -EFAULT;
-
-		return 0;
+		return put_user(len, (int __user *)argp);
 	}
 	case MOXA_ASPP_MON: {
 		int mcr, status;
@@ -1789,8 +1781,7 @@ static int mxser_ioctl(struct tty_struct
 		return 0;
 	}
 	case MOXA_ASPP_LSTATUS: {
-		if (copy_to_user(argp, &info->err_shadow,
-				sizeof(unsigned char)))
+		if (put_user(info->err_shadow, (unsigned char __user *)argp))
 			return -EFAULT;
 
 		info->err_shadow = 0;
@@ -1802,10 +1793,7 @@ static int mxser_ioctl(struct tty_struct
 		if (get_user(method, (int __user *)argp))
 			return -EFAULT;
 		mxser_set_baud_method[tty->index] = method;
-		if (copy_to_user(argp, &method, sizeof(int)))
-			return -EFAULT;
-
-		return 0;
+		return put_user(method, (int __user *)argp);
 	}
 	default:
 		return -ENOIOCTLCMD;
diff -puN drivers/char/mxser_new.h~char-mxser-ioctl-cleanup drivers/char/mxser_new.h
--- a/drivers/char/mxser_new.h~char-mxser-ioctl-cleanup
+++ a/drivers/char/mxser_new.h
@@ -11,12 +11,10 @@
 
 #define MOXA			0x400
 #define MOXA_GETDATACOUNT	(MOXA + 23)
-#define	MOXA_GET_CONF		(MOXA + 35)
 #define MOXA_DIAGNOSE		(MOXA + 50)
 #define MOXA_CHKPORTENABLE	(MOXA + 60)
 #define MOXA_HighSpeedOn	(MOXA + 61)
 #define MOXA_GET_MAJOR		(MOXA + 63)
-#define MOXA_GET_CUMAJOR	(MOXA + 64)
 #define MOXA_GETMSTATUS		(MOXA + 65)
 #define MOXA_SET_OP_MODE	(MOXA + 66)
 #define MOXA_GET_OP_MODE	(MOXA + 67)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
phantom-dont-grab-other-devices.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-remove-special-baudrate-processing.patch
char-mxser-0-to-null-in-pointer.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
char-mxser-ioctl-cleanup.patch
char-mxser-remove-it.patch
char-mxser-add-support-for-cp-114ul.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
