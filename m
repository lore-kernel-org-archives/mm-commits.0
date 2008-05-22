From: akpm@linux-foundation.org
Subject: + rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch added to -mm tree
Date: Thu, 22 May 2008 16:21:31 -0700
Message-ID: <200805222321.m4MNLV5v026796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760266AbYEVXV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     rtc: push the BKL down into the driver ioctl method
has been added to the -mm tree.  Its filename is
     rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch

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
Subject: rtc: push the BKL down into the driver ioctl method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

For now just wrap the main logic, but this driver is a prime candidate for
someone wanting to eliminate the lock entirely

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/char/rtc.c~rtc-push-the-bkl-down-into-the-driver-ioctl-method drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-push-the-bkl-down-into-the-driver-ioctl-method
+++ a/drivers/char/rtc.c
@@ -78,9 +78,10 @@
 #include <linux/wait.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #ifdef CONFIG_X86
@@ -142,8 +143,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_d
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static int rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
@@ -716,10 +716,13 @@ static int rtc_do_ioctl(unsigned int cmd
 			    &wtime, sizeof wtime) ? -EFAULT : 0;
 }
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return rtc_do_ioctl(cmd, arg, 0);
+	long ret;
+	lock_kernel();
+	ret = rtc_do_ioctl(cmd, arg, 0);
+	unlock_kernel();
+	return ret;
 }
 
 /*
@@ -912,7 +915,7 @@ static const struct file_operations rtc_
 #ifdef RTC_IRQ
 	.poll		= rtc_poll,
 #endif
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 	.fasync		= rtc_fasync,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
dac960-push-down-bkl.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

