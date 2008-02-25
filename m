From: akpm@linux-foundation.org
Subject: + misc-phantom-add-compat-ioctl.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:21:45 -0800
Message-ID: <200802251822.m1PIMbwh012909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:32986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbYBYSXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Misc: phantom, add compat ioctl
has been added to the -mm tree.  Its filename is
     misc-phantom-add-compat-ioctl.patch

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
Subject: Misc: phantom, add compat ioctl
From: Jiri Slaby <jirislaby@gmail.com>

Openhaptics uses pointers in _IOC() macros, implement compat for them. Also
add _IOC alternatives which are not 32/64 bit dependent (structures
passed through aren't yet) -- libphantom will use them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c  |   24 ++++++++++++++++++++----
 include/linux/phantom.h |    5 ++++-
 2 files changed, 24 insertions(+), 5 deletions(-)

diff -puN drivers/misc/phantom.c~misc-phantom-add-compat-ioctl drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-add-compat-ioctl
+++ a/drivers/misc/phantom.c
@@ -12,6 +12,7 @@
  *  or alternatively, you might use OpenHaptics provided by Sensable.
  */
 
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -91,11 +92,8 @@ static long phantom_ioctl(struct file *f
 	unsigned long flags;
 	unsigned int i;
 
-	if (_IOC_TYPE(cmd) != PH_IOC_MAGIC ||
-			_IOC_NR(cmd) > PH_IOC_MAXNR)
-		return -ENOTTY;
-
 	switch (cmd) {
+	case PHN_SETREG:
 	case PHN_SET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
 			return -EFAULT;
@@ -126,6 +124,7 @@ static long phantom_ioctl(struct file *f
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
+	case PHN_SETREGS:
 	case PHN_SET_REGS:
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
@@ -143,6 +142,7 @@ static long phantom_ioctl(struct file *f
 		}
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
+	case PHN_GETREG:
 	case PHN_GET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
 			return -EFAULT;
@@ -155,6 +155,7 @@ static long phantom_ioctl(struct file *f
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
 		break;
+	case PHN_GETREGS:
 	case PHN_GET_REGS: {
 		u32 m;
 
@@ -191,6 +192,20 @@ static long phantom_ioctl(struct file *f
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long phantom_compat_ioctl(struct file *filp, unsigned int cmd,
+		unsigned long arg)
+{
+	if (_IOC_NR(cmd) <= 3 && _IOC_SIZE(cmd) == sizeof(compat_uptr_t)) {
+		cmd &= ~(_IOC_SIZEMASK << _IOC_SIZESHIFT);
+		cmd |= sizeof(void *) << _IOC_SIZESHIFT;
+	}
+	return phantom_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#else
+#define phantom_compat_ioctl NULL
+#endif
+
 static int phantom_open(struct inode *inode, struct file *file)
 {
 	struct phantom_device *dev = container_of(inode->i_cdev,
@@ -253,6 +268,7 @@ static struct file_operations phantom_fi
 	.open = phantom_open,
 	.release = phantom_release,
 	.unlocked_ioctl = phantom_ioctl,
+	.compat_ioctl = phantom_compat_ioctl,
 	.poll = phantom_poll,
 };
 
diff -puN include/linux/phantom.h~misc-phantom-add-compat-ioctl include/linux/phantom.h
--- a/include/linux/phantom.h~misc-phantom-add-compat-ioctl
+++ a/include/linux/phantom.h
@@ -34,7 +34,10 @@ struct phm_regs {
  * use improved registers update (no more phantom switchoffs when using
  * libphantom) */
 #define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
-#define PH_IOC_MAXNR		4
+#define PHN_GETREG		_IOWR(PH_IOC_MAGIC, 5, struct phm_reg)
+#define PHN_SETREG		_IOW (PH_IOC_MAGIC, 6, struct phm_reg)
+#define PHN_GETREGS		_IOWR(PH_IOC_MAGIC, 7, struct phm_regs)
+#define PHN_SETREGS		_IOW (PH_IOC_MAGIC, 8, struct phm_regs)
 
 #define PHN_CONTROL		0x6     /* control byte in iaddr space */
 #define PHN_CTL_AMP		0x1     /*   switch after torques change */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-fix-poll.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
