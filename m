From: akpm@linux-foundation.org
Subject: + ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:22 -0700
Message-ID: <200805222316.m4MNGMpS026603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbYEVXQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jkosina@suse.cz


The patch titled
     ds1302: push down the BKL into the driver ioctl code
has been added to the -mm tree.  Its filename is
     ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch

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
Subject: ds1302: push down the BKL into the driver ioctl code
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ds1302.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/char/ds1302.c~ds1302-push-down-the-bkl-into-the-driver-ioctl-code drivers/char/ds1302.c
--- a/drivers/char/ds1302.c~ds1302-push-down-the-bkl-into-the-driver-ioctl-code
+++ a/drivers/char/ds1302.c
@@ -20,10 +20,11 @@
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/bcd.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
-#include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/rtc.h>
 #if defined(CONFIG_M32R)
 #include <asm/m32r.h>
@@ -153,9 +154,7 @@ static unsigned char days_in_mo[] =
 
 /* ioctl that supports RTC_RD_TIME and RTC_SET_TIME (read and set time/date). */
 
-static int
-rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 
@@ -165,7 +164,9 @@ rtc_ioctl(struct inode *inode, struct fi
 			struct rtc_time rtc_tm;
 
 			memset(&rtc_tm, 0, sizeof (struct rtc_time));
+			lock_kernel();
 			get_rtc_time(&rtc_tm);
+			unlock_kernel();
 			if (copy_to_user((struct rtc_time*)arg, &rtc_tm, sizeof(struct rtc_time)))
 				return -EFAULT;
 			return 0;
@@ -217,6 +218,7 @@ rtc_ioctl(struct inode *inode, struct fi
 			BIN_TO_BCD(mon);
 			BIN_TO_BCD(yrs);
 
+			lock_kernel();
 			local_irq_save(flags);
 			CMOS_WRITE(yrs, RTC_YEAR);
 			CMOS_WRITE(mon, RTC_MONTH);
@@ -225,6 +227,7 @@ rtc_ioctl(struct inode *inode, struct fi
 			CMOS_WRITE(min, RTC_MINUTES);
 			CMOS_WRITE(sec, RTC_SECONDS);
 			local_irq_restore(flags);
+			unlock_kernel();
 
 			/* Notice that at this point, the RTC is updated but
 			 * the kernel is still running with the old time.
@@ -244,8 +247,10 @@ rtc_ioctl(struct inode *inode, struct fi
 			if(copy_from_user(&tcs_val, (int*)arg, sizeof(int)))
 				return -EFAULT;
 
+			lock_kernel();
 			tcs_val = RTC_TCR_PATTERN | (tcs_val & 0x0F);
 			ds1302_writereg(RTC_TRICKLECHARGER, tcs_val);
+			unlock_kernel();
 			return 0;
 		}
 		default:
@@ -282,7 +287,7 @@ get_rtc_status(char *buf)
 
 static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 };
 
 /* Probe for the chip by writing something to its RAM and try reading it back. */
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

