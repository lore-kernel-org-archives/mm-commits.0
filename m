From: akpm@linux-foundation.org
Subject: + rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:33:46 -0700
Message-ID: <200707232133.l6NLXk4O012965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759092AbXGWVeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc_irq_set_freq() requires power-of-two and associated kerneldoc
has been added to the -mm tree.  Its filename is
     rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc_irq_set_freq() requires power-of-two and associated kerneldoc
From: David Brownell <david-b@pacbell.net>

RTC periodic IRQs are only defined to work for 2^N Hz values.  This patch
moves that validity check into the infrastructure, so drivers don't need to
check it; and adds kerneldoc for the two interface functions related to
periodic IRQs.  (One of which was quite mysterious until its first use was
recently checked in!)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   24 ++++++++++++++++++++++++
 drivers/rtc/rtc-cmos.c  |    8 +++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/interface.c~rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc
+++ a/drivers/rtc/interface.c
@@ -12,6 +12,7 @@
 */
 
 #include <linux/rtc.h>
+#include <linux/log2.h>
 
 int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
@@ -231,6 +232,16 @@ void rtc_irq_unregister(struct rtc_devic
 }
 EXPORT_SYMBOL_GPL(rtc_irq_unregister);
 
+/**
+ * rtc_irq_set_state - enable/disable 2^N Hz periodic IRQs
+ * @rtc: the rtc device
+ * @task: currently registered with rtc_irq_register()
+ * @enabled: true to enable periodic IRQs
+ * Context: any
+ *
+ * Note that rtc_irq_set_freq() should previously have been used to
+ * specify the desired frequency of periodic IRQ task->func() callbacks.
+ */
 int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled)
 {
 	int err = 0;
@@ -251,6 +262,16 @@ int rtc_irq_set_state(struct rtc_device 
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
 
+/**
+ * rtc_irq_set_freq - set 2^N Hz periodic IRQ frequency for IRQ
+ * @rtc: the rtc device
+ * @task: currently registered with rtc_irq_register()
+ * @freq: positive frequency with which task->func() will be called
+ * Context: any
+ *
+ * Note that rtc_irq_set_state() is used to enable or disable the
+ * periodic IRQs.
+ */
 int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 {
 	int err = 0;
@@ -259,6 +280,9 @@ int rtc_irq_set_freq(struct rtc_device *
 	if (rtc->ops->irq_set_freq == NULL)
 		return -ENXIO;
 
+	if (!is_power_of_2(freq))
+		return -EINVAL;
+
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != task)
 		err = -ENXIO;
diff -puN drivers/rtc/rtc-cmos.c~rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc
+++ a/drivers/rtc/rtc-cmos.c
@@ -246,11 +246,9 @@ static int cmos_irq_set_freq(struct devi
 
 	/* 0 = no irqs; 1 = 2^15 Hz ... 15 = 2^0 Hz */
 	f = ffs(freq);
-	if (f != 0) {
-		if (f-- > 16 || freq != (1 << f))
-			return -EINVAL;
-		f = 16 - f;
-	}
+	if (f-- > 16)
+		return -EINVAL;
+	f = 16 - f;
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
