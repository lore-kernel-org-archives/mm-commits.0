From: akpm@linux-foundation.org
Subject: [merged] tty-support-compat_ioctl-get-set-termios_locked.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:36 -0700
Message-ID: <201110272308.p9RN8aBX000488@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:48944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tty: support compat_ioctl get/set termios_locked
has been removed from the -mm tree.  Its filename was
     tty-support-compat_ioctl-get-set-termios_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: tty: support compat_ioctl get/set termios_locked

When running a Fedora 15 (x86) on an x86_64 kernel, in the boot process
plymouthd complains about those two missing ioctls:

[    2.581783] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005457){t:'T';sz:0} arg(ffb6a5d0) on /dev/tty1
[    2.581803] ioctl32(plymouthd:186): Unknown cmd fd(10) cmd(00005456){t:'T';sz:0} arg(ffb6a680) on /dev/tty1

both ioctl functions work on the 'struct termios' resp.  'struct
termios2', which has the same size (36 bytes resp.  44 bytes) on x86 and
x86_64, so it's just a matter of converting the pointer from userland.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/tty_io.c    |    2 ++
 drivers/tty/tty_ioctl.c |   17 +++++++++++++++++
 include/linux/tty.h     |    2 ++
 3 files changed, 21 insertions(+)

diff -puN drivers/tty/tty_io.c~tty-support-compat_ioctl-get-set-termios_locked drivers/tty/tty_io.c
--- a/drivers/tty/tty_io.c~tty-support-compat_ioctl-get-set-termios_locked
+++ a/drivers/tty/tty_io.c
@@ -2716,6 +2716,8 @@ static long tty_compat_ioctl(struct file
 	ld = tty_ldisc_ref_wait(tty);
 	if (ld->ops->compat_ioctl)
 		retval = ld->ops->compat_ioctl(tty, file, cmd, arg);
+	else
+		retval = n_tty_compat_ioctl_helper(tty, file, cmd, arg);
 	tty_ldisc_deref(ld);
 
 	return retval;
diff -puN drivers/tty/tty_ioctl.c~tty-support-compat_ioctl-get-set-termios_locked drivers/tty/tty_ioctl.c
--- a/drivers/tty/tty_ioctl.c~tty-support-compat_ioctl-get-set-termios_locked
+++ a/drivers/tty/tty_ioctl.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/compat.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -1179,3 +1180,19 @@ int n_tty_ioctl_helper(struct tty_struct
 	}
 }
 EXPORT_SYMBOL(n_tty_ioctl_helper);
+
+#ifdef CONFIG_COMPAT
+long n_tty_compat_ioctl_helper(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case TIOCGLCKTRMIOS:
+	case TIOCSLCKTRMIOS:
+		return tty_mode_ioctl(tty, file, cmd, (unsigned long) compat_ptr(arg));
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL(n_tty_compat_ioctl_helper);
+#endif
+
diff -puN include/linux/tty.h~tty-support-compat_ioctl-get-set-termios_locked include/linux/tty.h
--- a/include/linux/tty.h~tty-support-compat_ioctl-get-set-termios_locked
+++ a/include/linux/tty.h
@@ -581,6 +581,8 @@ extern int __init tty_init(void);
 /* tty_ioctl.c */
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
+extern long n_tty_compat_ioctl_helper(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg);
 
 /* serial.c */
 
_

Patches currently in -mm which might be from thomas@m3y3r.de are

origin.patch
linux-next.patch

