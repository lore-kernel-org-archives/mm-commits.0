From: akpm@linux-foundation.org
Subject: - misc-phantom-add-compat-ioctl.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:11 -0700
Message-ID: <200804300540.m3U5eBTF028938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbYD3FkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, add compat ioctl
has been removed from the -mm tree.  Its filename was
     misc-phantom-add-compat-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Misc: phantom, add compat ioctl
From: Jiri Slaby <jirislaby@gmail.com>

Openhaptics uses pointers in _IOC() macros, implement compat for them. Also
add _IOC alternatives which are not 32/64 bit dependent (structures
passed through aren't yet) -- libphantom will use them.

[akpm@linux-foundation.org: coding-style fixes]
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
+#define PHN_SETREG		_IOW(PH_IOC_MAGIC, 6, struct phm_reg)
+#define PHN_GETREGS		_IOWR(PH_IOC_MAGIC, 7, struct phm_regs)
+#define PHN_SETREGS		_IOW(PH_IOC_MAGIC, 8, struct phm_regs)
 
 #define PHN_CONTROL		0x6     /* control byte in iaddr space */
 #define PHN_CTL_AMP		0x1     /*   switch after torques change */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-centralize-board-readiness-warning-fix.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
char-ip2-macros-cleanup.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
char-rio-fix-cirrus-defines.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-isicom-fix.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

