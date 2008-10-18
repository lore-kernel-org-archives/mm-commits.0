From: akpm@linux-foundation.org
Subject: - rtc-file-close-consistently-disables-repeating-irqs.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:31 -0700
Message-ID: <200810182315.m9INFVwI028632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbYJRXQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.zummo@towertech.it, andy.sharp@onstor.com, anemo@mba.ocn.ne.jp, angelo.castello@st.com, lethal@linux-sh.org, thomas.hommel@gefanuc.com, mm-commits@v


The patch titled
     rtc: file close() consistently disables repeating irqs
has been removed from the -mm tree.  Its filename was
     rtc-file-close-consistently-disables-repeating-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: file close() consistently disables repeating irqs
From: David Brownell <dbrownell@users.sourceforge.net>

Make the rtc framework consistent about disabling 1/second update IRQs
that may have been activated through the /dev interface, when that /dev
file is closed.  (It may have closed because of coredump, etc.) This was
previously done only for emulated update IRQs ...  now, do it always.

Also comment the current policy: repeating IRQs (periodic, update) that
userspace enabled will be cleanly disabled, but alarms are left alone. 
Such repeating IRQs are a constant and pointless system load.

Update some RTC drivers to remove now-needless release() methods.  Most
such methods just enforce that policy.  The others all seem to be buggy,
and mistreat in-kernel clients of periodic or alarm IRQs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Andrew Sharp <andy.sharp@onstor.com>
Cc: Angelo Castello <angelo.castello@st.com>
Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Hommel <thomas.hommel@gefanuc.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c      |   12 +++++++++---
 drivers/rtc/rtc-ds1511.c   |   13 -------------
 drivers/rtc/rtc-ds1553.c   |   12 ------------
 drivers/rtc/rtc-sh.c       |    7 -------
 drivers/rtc/rtc-stk17ta8.c |   12 ------------
 5 files changed, 9 insertions(+), 47 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-file-close-consistently-disables-repeating-irqs drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-file-close-consistently-disables-repeating-irqs
+++ a/drivers/rtc/rtc-dev.c
@@ -432,9 +432,15 @@ static int rtc_dev_release(struct inode 
 {
 	struct rtc_device *rtc = file->private_data;
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	clear_uie(rtc);
-#endif
+	/* We shut down the repeating IRQs that userspace enabled,
+	 * since nothing is listening to them.
+	 *  - Update (UIE) ... currently only managed through ioctls
+	 *  - Periodic (PIE) ... also used through rtc_*() interface calls
+	 *
+	 * Leave the alarm alone; it may be set to trigger a system wakeup
+	 * later, or be used by kernel code, and is a one-shot event anyway.
+	 */
+	rtc_dev_ioctl(file, RTC_UIE_OFF, 0);
 	rtc_irq_set_state(rtc, NULL, 0);
 
 	if (rtc->ops->release)
diff -puN drivers/rtc/rtc-ds1511.c~rtc-file-close-consistently-disables-repeating-irqs drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-file-close-consistently-disables-repeating-irqs
+++ a/drivers/rtc/rtc-ds1511.c
@@ -379,18 +379,6 @@ ds1511_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
- static void
-ds1511_rtc_release(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq >= 0) {
-		pdata->irqen = 0;
-		ds1511_rtc_update_alarm(pdata);
-	}
-}
-
  static int
 ds1511_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
@@ -428,7 +416,6 @@ static const struct rtc_class_ops ds1511
 	.set_time	= ds1511_rtc_set_time,
 	.read_alarm	= ds1511_rtc_read_alarm,
 	.set_alarm	= ds1511_rtc_set_alarm,
-	.release	= ds1511_rtc_release,
 	.ioctl		= ds1511_rtc_ioctl,
 };
 
diff -puN drivers/rtc/rtc-ds1553.c~rtc-file-close-consistently-disables-repeating-irqs drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-file-close-consistently-disables-repeating-irqs
+++ a/drivers/rtc/rtc-ds1553.c
@@ -207,17 +207,6 @@ static irqreturn_t ds1553_rtc_interrupt(
 	return IRQ_HANDLED;
 }
 
-static void ds1553_rtc_release(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq >= 0) {
-		pdata->irqen = 0;
-		ds1553_rtc_update_alarm(pdata);
-	}
-}
-
 static int ds1553_rtc_ioctl(struct device *dev, unsigned int cmd,
 			    unsigned long arg)
 {
@@ -254,7 +243,6 @@ static const struct rtc_class_ops ds1553
 	.set_time	= ds1553_rtc_set_time,
 	.read_alarm	= ds1553_rtc_read_alarm,
 	.set_alarm	= ds1553_rtc_set_alarm,
-	.release	= ds1553_rtc_release,
 	.ioctl		= ds1553_rtc_ioctl,
 };
 
diff -puN drivers/rtc/rtc-sh.c~rtc-file-close-consistently-disables-repeating-irqs drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-file-close-consistently-disables-repeating-irqs
+++ a/drivers/rtc/rtc-sh.c
@@ -257,12 +257,6 @@ static inline void sh_rtc_setaie(struct 
 	spin_unlock_irq(&rtc->lock);
 }
 
-static void sh_rtc_release(struct device *dev)
-{
-	sh_rtc_setpie(dev, 0);
-	sh_rtc_setaie(dev, 0);
-}
-
 static int sh_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct sh_rtc *rtc = dev_get_drvdata(dev);
@@ -559,7 +553,6 @@ static int sh_rtc_irq_set_freq(struct de
 }
 
 static struct rtc_class_ops sh_rtc_ops = {
-	.release	= sh_rtc_release,
 	.ioctl		= sh_rtc_ioctl,
 	.read_time	= sh_rtc_read_time,
 	.set_time	= sh_rtc_set_time,
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-file-close-consistently-disables-repeating-irqs drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-file-close-consistently-disables-repeating-irqs
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -215,17 +215,6 @@ static irqreturn_t stk17ta8_rtc_interrup
 	return IRQ_HANDLED;
 }
 
-static void stk17ta8_rtc_release(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq >= 0) {
-		pdata->irqen = 0;
-		stk17ta8_rtc_update_alarm(pdata);
-	}
-}
