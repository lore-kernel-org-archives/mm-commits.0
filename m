From: akpm@linux-foundation.org
Subject: - tty_ioctl-soft-carrier-handling.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:40 -0700
Message-ID: <200805010928.m419SegZ030595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbYEAJ3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty_ioctl: soft carrier handling
has been removed from the -mm tree.  Its filename was
     tty_ioctl-soft-carrier-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

