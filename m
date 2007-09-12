From: akpm@linux-foundation.org
Subject: + powerpc-add-new-required-termio-functions.patch added to -mm tree
Date: Tue, 11 Sep 2007 20:01:15 -0700
Message-ID: <200709120301.l8C31FRh013244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbXILDB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, paulus@samba.org, torvalds@linux-foundation.org


The patch titled
     powerpc: fix tty_ioctl.c build
has been added to the -mm tree.  Its filename is
     powerpc-add-new-required-termio-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: fix tty_ioctl.c build
From: Tony Breeds <tony@bakeyournoodle.com>

Add Guards around TIOCSLCKTRMIOS and TIOCGLCKTRMIOS.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
powerpc-add-new-required-termio-functions.patch
mkmakefile-include-arch-on-o=-builds.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
