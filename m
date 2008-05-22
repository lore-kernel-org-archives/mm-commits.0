From: akpm@linux-foundation.org
Subject: + ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:17 -0700
Message-ID: <200805222316.m4MNGH4W026597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758149AbYEVXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     ppdev: wrap ioctl handler in driver and push lock down
has been added to the -mm tree.  Its filename is
     ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch

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
Subject: ppdev: wrap ioctl handler in driver and push lock down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ppdev.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/char/ppdev.c~ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down
+++ a/drivers/char/ppdev.c
@@ -67,7 +67,7 @@
 #include <linux/major.h>
 #include <linux/ppdev.h>
 #include <linux/smp_lock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define PP_VERSION "ppdev: user-space parallel port driver"
 #define CHRDEV "ppdev"
@@ -328,10 +328,9 @@ static enum ieee1284_phase init_phase (i
 	return IEEE1284_PH_FWD_IDLE;
 }
 
-static int pp_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	unsigned int minor = iminor(inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct pp_struct *pp = file->private_data;
 	struct parport * port;
 	void __user *argp = (void __user *)arg;
@@ -634,6 +633,15 @@ static int pp_ioctl(struct inode *inode,
 	return 0;
 }
 
+static long pp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = pp_do_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static int pp_open (struct inode * inode, struct file * file)
 {
 	unsigned int minor = iminor(inode);
@@ -745,7 +753,7 @@ static const struct file_operations pp_f
 	.read		= pp_read,
 	.write		= pp_write,
 	.poll		= pp_poll,
-	.ioctl		= pp_ioctl,
+	.unlocked_ioctl	= pp_ioctl,
 	.open		= pp_open,
 	.release	= pp_release,
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
dac960-push-down-bkl.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

