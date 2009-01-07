From: akpm@linux-foundation.org
Subject: - rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:57 -0800
Message-ID: <200901072218.n07MIvRd018331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbZAGWUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: move power of 2 periodic frequency check down into drivers
has been removed from the -mm tree.  Its filename was
     rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: move power of 2 periodic frequency check down into drivers
From: Jonathan Cameron <jic23@cam.ac.uk>

Move the power of 2 check on frequencies down into individual rtc drivers

This is to allow for non power of 2 real time clock periodic interrupts
such as those on the pxa27x to be found in the new pxa27x-rtc driver

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c  |    3 ---
 drivers/rtc/rtc-cmos.c   |    3 +++
 drivers/rtc/rtc-s3c.c    |    3 +++
 drivers/rtc/rtc-sh.c     |    3 +++
 drivers/rtc/rtc-vr41xx.c |    3 +++
 5 files changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2 drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2
+++ a/drivers/rtc/interface.c
@@ -504,9 +504,6 @@ int rtc_irq_set_freq(struct rtc_device *
 	if (rtc->ops->irq_set_freq == NULL)
 		return -ENXIO;
 
-	if (!is_power_of_2(freq))
-		return -EINVAL;
-
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
diff -puN drivers/rtc/rtc-cmos.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2 drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2
+++ a/drivers/rtc/rtc-cmos.c
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/log2.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -384,6 +385,8 @@ static int cmos_irq_set_freq(struct devi
 	if (!is_valid_irq(cmos->irq))
 		return -ENXIO;
 
+	if (!is_power_of_2(freq))
+		return -EINVAL;
 	/* 0 = no irqs; 1 = 2^15 Hz ... 15 = 2^0 Hz */
 	f = ffs(freq);
 	if (f-- > 16)
diff -puN drivers/rtc/rtc-s3c.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2 drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2
+++ a/drivers/rtc/rtc-s3c.c
@@ -94,6 +94,9 @@ static int s3c_rtc_setfreq(struct device
 {
 	unsigned int tmp;
 
+	if (!is_power_of_2(freq))
+		return -EINVAL;
+
 	spin_lock_irq(&s3c_rtc_pie_lock);
 
 	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
diff -puN drivers/rtc/rtc-sh.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2 drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2
+++ a/drivers/rtc/rtc-sh.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/log2.h>
 #include <asm/rtc.h>
 
 #define DRV_NAME	"sh-rtc"
@@ -551,6 +552,8 @@ static int sh_rtc_irq_set_state(struct d
 
 static int sh_rtc_irq_set_freq(struct device *dev, int freq)
 {
+	if (!is_power_of_2(freq))
+		return -EINVAL;
 	return sh_rtc_ioctl(dev, RTC_IRQP_SET, freq);
 }
 
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2 drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -27,6 +27,7 @@
 #include <linux/rtc.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
+#include <linux/log2.h>
 
 #include <asm/div64.h>
 #include <asm/io.h>
@@ -210,6 +211,8 @@ static int vr41xx_rtc_irq_set_freq(struc
 {
 	unsigned long count;
 
+	if (!is_power_of_2(freq))
+		return -EINVAL;
 	count = RTC_FREQUENCY;
 	do_div(count, freq);
 
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

origin.patch

