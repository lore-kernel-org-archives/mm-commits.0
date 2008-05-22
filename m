From: akpm@linux-foundation.org
Subject: + snapshot-push-bkl-down-into-ioctl-handlers.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:19 -0700
Message-ID: <200805222316.m4MNGJI8026600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYEVXRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, len.brown@intel.com, rjw@sisk.pl, stern@rowland.harvard.edu


The patch titled
     snapshot: push BKL down into ioctl handlers
has been added to the -mm tree.  Its filename is
     snapshot-push-bkl-down-into-ioctl-handlers.patch

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
Subject: snapshot: push BKL down into ioctl handlers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/power/user.c~snapshot-push-bkl-down-into-ioctl-handlers kernel/power/user.c
--- a/kernel/power/user.c~snapshot-push-bkl-down-into-ioctl-handlers
+++ a/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -172,8 +173,8 @@ static ssize_t snapshot_write(struct fil
 	return res;
 }
 
-static int snapshot_ioctl(struct inode *inode, struct file *filp,
-                          unsigned int cmd, unsigned long arg)
+static long snapshot_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
 	int error = 0;
 	struct snapshot_data *data;
@@ -189,6 +190,8 @@ static int snapshot_ioctl(struct inode *
 
 	data = filp->private_data;
 
+	lock_kernel();
+
 	switch (cmd) {
 
 	case SNAPSHOT_FREEZE:
@@ -397,7 +400,7 @@ static int snapshot_ioctl(struct inode *
 		error = -ENOTTY;
 
 	}
-
+	unlock_kernel();
 	return error;
 }
 
@@ -407,7 +410,7 @@ static const struct file_operations snap
 	.read = snapshot_read,
 	.write = snapshot_write,
 	.llseek = no_llseek,
-	.ioctl = snapshot_ioctl,
+	.unlocked_ioctl = snapshot_ioctl,
 };
 
 static struct miscdevice snapshot_device = {
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

