From: akpm@linux-foundation.org
Subject: - rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:01 -0700
Message-ID: <200807242330.m6ONU15R011442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904AbYGXXa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     rtc: push the BKL down into the driver ioctl method
has been removed from the -mm tree.  Its filename was
     rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: push the BKL down into the driver ioctl method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

For now just wrap the main logic, but this driver is a prime candidate for
someone wanting to eliminate the lock entirely

[lizf@cn.fujitsu.com: fix build failure]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
@@ -144,8 +145,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_d
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static int rtc_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
@@ -719,10 +719,13 @@ static int rtc_do_ioctl(unsigned int cmd
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
@@ -915,7 +918,7 @@ static const struct file_operations rtc_
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
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

