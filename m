From: akpm@linux-foundation.org
Subject: - rtc-rtc-s3c-update-irq-handling.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:28 -0700
Message-ID: <200807242330.m6ONUSJT011510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756873AbYGXXbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-s3c: update IRQ handling
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-update-irq-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-s3c: update IRQ handling
From: Ben Dooks <ben-linux@fluff.org>

The rtc-s3c.c driver has been using its own ioctl() handling to deal with
alarm and periodic interrupts to handle what should now be done with the
rtc core code.

Change to using the .irq_set_freq and .irq_set_state driver entries and
remove the .ioctl handling.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   83 +++++++---------------------------------
 1 file changed, 16 insertions(+), 67 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-update-irq-handling drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-update-irq-handling
+++ a/drivers/rtc/rtc-s3c.c
@@ -36,10 +36,8 @@ static struct resource *s3c_rtc_mem;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
-static int s3c_rtc_freq    = 1;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
-static unsigned int tick_count;
 
 /* IRQ Handlers */
 
@@ -55,7 +53,7 @@ static irqreturn_t s3c_rtc_tickirq(int i
 {
 	struct rtc_device *rdev = id;
 
-	rtc_update_irq(rdev, tick_count++, RTC_PF | RTC_IRQF);
+	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
 	return IRQ_HANDLED;
 }
 
@@ -74,35 +72,37 @@ static void s3c_rtc_setaie(int to)
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
 }
 
-static void s3c_rtc_setpie(int to)
+static int s3c_rtc_setpie(struct device *dev, int enabled)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: pie=%d\n", __func__, to);
+	pr_debug("%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
 	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & ~S3C2410_TICNT_ENABLE;
 
-	if (to)
+	if (enabled)
 		tmp |= S3C2410_TICNT_ENABLE;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
+
+	return 0;
 }
 
-static void s3c_rtc_setfreq(int freq)
+static int s3c_rtc_setfreq(struct device *dev, int freq)
 {
 	unsigned int tmp;
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
-	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
-
-	s3c_rtc_freq = freq;
 
+	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
 	tmp |= (128 / freq)-1;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
+
+	return 0;
 }
 
 /* Time read/write */
@@ -267,12 +267,7 @@ static int s3c_rtc_setalarm(struct devic
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
-	if (0) {
-		alrm_en = readb(base + S3C2410_RTCALM);
-		alrm_en &= ~S3C2410_RTCALM_ALMEN;
-		writeb(alrm_en, base + S3C2410_RTCALM);
-		disable_irq_wake(s3c_rtc_alarmno);
-	}
+	s3c_rtc_setaie(alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(s3c_rtc_alarmno);
@@ -282,59 +277,12 @@ static int s3c_rtc_setalarm(struct devic
 	return 0;
 }
 
-static int s3c_rtc_ioctl(struct device *dev,
-			 unsigned int cmd, unsigned long arg)
-{
-	unsigned int ret = -ENOIOCTLCMD;
-
-	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-		s3c_rtc_setaie((cmd == RTC_AIE_ON) ? 1 : 0);
-		ret = 0;
-		break;
-
-	case RTC_PIE_OFF:
-	case RTC_PIE_ON:
-		tick_count = 0;
-		s3c_rtc_setpie((cmd == RTC_PIE_ON) ? 1 : 0);
-		ret = 0;
-		break;
-
-	case RTC_IRQP_READ:
-		ret = put_user(s3c_rtc_freq, (unsigned long __user *)arg);
-		break;
-
-	case RTC_IRQP_SET:
-		if (!is_power_of_2(arg)) {
-			ret = -EINVAL;
-			goto exit;
-		}
-
-		pr_debug("s3c2410_rtc: setting frequency %ld\n", arg);
-
-		s3c_rtc_setfreq(arg);
-		ret = 0;
-		break;
-
-	case RTC_UIE_ON:
-	case RTC_UIE_OFF:
-		ret = -EINVAL;
-	}
-
- exit:
-	return ret;
-}
-
 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned int ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
 		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no" );
-
-	seq_printf(seq, "periodic_freq\t: %d\n", s3c_rtc_freq);
-
 	return 0;
 }
 
@@ -374,7 +322,7 @@ static void s3c_rtc_release(struct devic
 
 	/* do not clear AIE here, it may be needed for wake */
 
-	s3c_rtc_setpie(0);
+	s3c_rtc_setpie(dev, 0);
 	free_irq(s3c_rtc_alarmno, rtc_dev);
 	free_irq(s3c_rtc_tickno, rtc_dev);
 }
@@ -382,11 +330,12 @@ static void s3c_rtc_release(struct devic
 static const struct rtc_class_ops s3c_rtcops = {
 	.open		= s3c_rtc_open,
 	.release	= s3c_rtc_release,
-	.ioctl		= s3c_rtc_ioctl,
 	.read_time	= s3c_rtc_gettime,
 	.set_time	= s3c_rtc_settime,
 	.read_alarm	= s3c_rtc_getalarm,
 	.set_alarm	= s3c_rtc_setalarm,
+	.irq_set_freq	= s3c_rtc_setfreq,
+	.irq_set_state	= s3c_rtc_setpie,
 	.proc	        = s3c_rtc_proc,
 };
 
@@ -437,7 +386,7 @@ static int __devexit s3c_rtc_remove(stru
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
-	s3c_rtc_setpie(0);
+	s3c_rtc_setpie(&dev->dev, 0);
 	s3c_rtc_setaie(0);
 
 	iounmap(s3c_rtc_base);
@@ -504,7 +453,7 @@ static int __devinit s3c_rtc_probe(struc
  	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
 		 readb(s3c_rtc_base + S3C2410_RTCCON));
 
-	s3c_rtc_setfreq(s3c_rtc_freq);
+	s3c_rtc_setfreq(&pdev->dev, 1);
 
 	/* register RTC and exit */
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

