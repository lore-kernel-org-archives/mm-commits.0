From: akpm@linux-foundation.org
Subject: - sparc64-and-others-fix-tty_ioctlc-build.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:35 -0700
Message-ID: <200709160926.l8G9QZv2009193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbXIPJin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, paulus@samba.org, torvalds@linux-foundation.org, mm-commit


The patch titled
     sparc64 (and others): fix tty_ioctl.c build
has been removed from the -mm tree.  Its filename was
     sparc64-and-others-fix-tty_ioctlc-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparc64 (and others): fix tty_ioctl.c build
From: Tony Breeds <tony@bakeyournoodle.com>

Add Guards around TIOCSLCKTRMIOS and TIOCGLCKTRMIOS.

Several architectures are still broken.  Put temporary-for-2.6.23 ifdef guards
around the offending code.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN drivers/char/tty_ioctl.c~sparc64-and-others-fix-tty_ioctlc-build drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~sparc64-and-others-fix-tty_ioctlc-build
+++ a/drivers/char/tty_ioctl.c
@@ -795,6 +795,19 @@ int n_tty_ioctl(struct tty_struct * tty,
 			if (L_ICANON(tty))
 				retval = inq_canon(tty);
 			return put_user(retval, (unsigned int __user *) arg);
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
 		case TIOCGLCKTRMIOS:
 			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
 				return -EFAULT;
@@ -806,6 +819,7 @@ int n_tty_ioctl(struct tty_struct * tty,
 			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
 				return -EFAULT;
 			return 0;
+#endif
 
 		case TIOCPKT:
 		{
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

origin.patch
mkmakefile-include-arch-on-o=-builds.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
