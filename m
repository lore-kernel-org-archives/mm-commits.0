From: akpm@linux-foundation.org
Subject: - powerpc-add-new-required-termio-functions.patch removed from -mm tree
Date: Wed, 12 Sep 2007 23:45:21 -0700
Message-ID: <200709130645.l8D6jLWB006295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757070AbXIMGpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 02:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@bakeyournoodle.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, paulus@samba.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix tty_ioctl.c build
has been removed from the -mm tree.  Its filename was
     powerpc-add-new-required-termio-functions.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: powerpc: fix tty_ioctl.c build
From: Tony Breeds <tony@bakeyournoodle.com>

Add Guards around TIOCSLCKTRMIOS and TIOCGLCKTRMIOS.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/char/tty_ioctl.c~powerpc-add-new-required-termio-functions drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~powerpc-add-new-required-termio-functions
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

fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch
mkmakefile-include-arch-on-o=-builds.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
