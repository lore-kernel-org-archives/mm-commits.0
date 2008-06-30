From: akpm@linux-foundation.org
Subject: + char-mxser-ioctl-cleanup.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:21:23 -0700
Message-ID: <200806302121.m5ULLVTl025991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758626AbYF3VVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:21:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


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

- remove break ctl from ioctl handler, it's never reached, since
  tty_ops->break_ctl is defined (mxser break handling is done in software)
- mark MOXA_GET_MAJOR as deprecated
- fix TIOCGICOUNT (some retval non-checks of put_user). Use copy_to_user
  to whole structure instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   78 +++++++++--------------------------------
 1 file changed, 19 insertions(+), 59 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-ioctl-cleanup drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-ioctl-cleanup
+++ a/drivers/char/mxser.c
@@ -16,7 +16,6 @@
  *	Fed through a cleanup, indent and remove of non 2.6 code by Alan Cox
  *	<alan@redhat.com>. The original 1.8 code is available on www.moxa.com.
  *	- Fixed x86_64 cleanness
- *	- Fixed sleep with spinlock held in mxser_send_break
  */
 
 #include <linux/module.h>
@@ -1473,27 +1472,6 @@ static int mxser_get_lsr_info(struct mxs
 	return put_user(result, value);
 }
 
-/*
- * This routine sends a break character out the serial port.
- */
-static void mxser_send_break(struct mxser_port *info, int duration)
-{
-	unsigned long flags;
-
-	if (!info->ioaddr)
-		return;
-	set_current_state(TASK_INTERRUPTIBLE);
-	spin_lock_irqsave(&info->slock, flags);
-	outb(inb(info->ioaddr + UART_LCR) | UART_LCR_SBC,
-		info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
-	schedule_timeout(duration);
-	spin_lock_irqsave(&info->slock, flags);
-	outb(inb(info->ioaddr + UART_LCR) & ~UART_LCR_SBC,
-		info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
-}
-
 static int mxser_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct mxser_port *info = tty->driver_data;
@@ -1662,6 +1640,8 @@ static int mxser_ioctl_special(unsigned 
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
+		printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl %x, fix "
+				"your userspace\n", current->comm, cmd);
 		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
@@ -1832,7 +1812,6 @@ static int mxser_ioctl(struct tty_struct
 {
 	struct mxser_port *info = tty->driver_data;
 	struct async_icount cnow;
-	struct serial_icounter_struct __user *p_cuser;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -1881,21 +1860,6 @@ static int mxser_ioctl(struct tty_struct
 		return -EIO;
 
 	switch (cmd) {
-	case TCSBRK:		/* SVID version: non-zero arg --> no break */
-		retval = tty_check_change(tty);
-		if (retval)
-			return retval;
-		tty_wait_until_sent(tty, 0);
-		if (!arg)
-			mxser_send_break(info, HZ / 4);	/* 1/4 second */
-		return 0;
-	case TCSBRKP:		/* support for POSIX tcsendbreak() */
-		retval = tty_check_change(tty);
-		if (retval)
-			return retval;
-		tty_wait_until_sent(tty, 0);
-		mxser_send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
-		return 0;
 	case TIOCGSERIAL:
 		lock_kernel();
 		retval = mxser_get_serial_info(info, argp);
@@ -1927,30 +1891,26 @@ static int mxser_ioctl(struct tty_struct
 	 * NB: both 1->0 and 0->1 transitions are counted except for
 	 *     RI where only 0->1 is counted.
 	 */
-	case TIOCGICOUNT:
+	case TIOCGICOUNT: {
+		struct serial_icounter_struct icnt = { 0 };
 		spin_lock_irqsave(&info->slock, flags);
 		cnow = info->icount;
 		spin_unlock_irqrestore(&info->slock, flags);
-		p_cuser = argp;
-		if (put_user(cnow.frame, &p_cuser->frame))
-			return -EFAULT;
-		if (put_user(cnow.brk, &p_cuser->brk))
-			return -EFAULT;
-		if (put_user(cnow.overrun, &p_cuser->overrun))
-			return -EFAULT;
-		if (put_user(cnow.buf_overrun, &p_cuser->buf_overrun))
-			return -EFAULT;
-		if (put_user(cnow.parity, &p_cuser->parity))
-			return -EFAULT;
-		if (put_user(cnow.rx, &p_cuser->rx))
-			return -EFAULT;
-		if (put_user(cnow.tx, &p_cuser->tx))
-			return -EFAULT;
-		put_user(cnow.cts, &p_cuser->cts);
-		put_user(cnow.dsr, &p_cuser->dsr);
-		put_user(cnow.rng, &p_cuser->rng);
-		put_user(cnow.dcd, &p_cuser->dcd);
-		return 0;
+
+		icnt.frame = cnow.frame;
+		icnt.brk = cnow.brk;
+		icnt.overrun = cnow.overrun;
+		icnt.buf_overrun = cnow.buf_overrun;
+		icnt.parity = cnow.parity;
+		icnt.rx = cnow.rx;
+		icnt.tx = cnow.tx;
+		icnt.cts = cnow.cts;
+		icnt.dsr = cnow.dsr;
+		icnt.rng = cnow.rng;
+		icnt.dcd = cnow.dcd;
+
+		return copy_to_user(argp, &icnt, sizeof(icnt)) ? -EFAULT : 0;
+	}
 	case MOXA_HighSpeedOn:
 		return put_user(info->baud_base != 115200 ? 1 : 0, (int __user *)argp);
 	case MOXA_SDS_RSTICOUNTER:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-add-cp-102uf-support.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

