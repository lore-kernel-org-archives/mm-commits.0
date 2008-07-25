From: akpm@linux-foundation.org
Subject: - ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:33 -0700
Message-ID: <200807252301.m6PN1XBK003717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177AbYGYXC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ds1302: push down the BKL into the driver ioctl code
has been removed from the -mm tree.  Its filename was
     ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
hugetlb-fix-config_sysctl=n-build.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

