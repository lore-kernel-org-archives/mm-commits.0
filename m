From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:06 -0700
Message-ID: <20130507223906.DA4C231C145@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48048 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3EGWjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:07 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so120990ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-ds1511.c: fix issues related to spaces and braces
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1511.c: fix issues related to spaces and braces

Fixes the following types of issues:
WARNING: please, no spaces at the start of a line
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c |   93 +++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 49 deletions(-)

diff -puN drivers/rtc/rtc-ds1511.c~drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces
+++ a/drivers/rtc/rtc-ds1511.c
@@ -104,31 +104,31 @@ static DEFINE_SPINLOCK(ds1511_lock);
 static __iomem char *ds1511_base;
 static u32 reg_spacing = 1;
 
- static noinline void
+static noinline void
 rtc_write(uint8_t val, uint32_t reg)
 {
 	writeb(val, ds1511_base + (reg * reg_spacing));
 }
 
- static inline void
+static inline void
 rtc_write_alarm(uint8_t val, enum ds1511reg reg)
 {
 	rtc_write((val | 0x80), reg);
 }
 
- static noinline uint8_t
+static noinline uint8_t
 rtc_read(enum ds1511reg reg)
 {
 	return readb(ds1511_base + (reg * reg_spacing));
 }
 
- static inline void
+static inline void
 rtc_disable_update(void)
 {
 	rtc_write((rtc_read(RTC_CMD) & ~RTC_TE), RTC_CMD);
 }
 
- static void
+static void
 rtc_enable_update(void)
 {
 	rtc_write((rtc_read(RTC_CMD) | RTC_TE), RTC_CMD);
@@ -145,7 +145,7 @@ rtc_enable_update(void)
  * just enough code to set the watchdog timer so that it
  * will reboot the system
  */
- void
+void
 ds1511_wdog_set(unsigned long deciseconds)
 {
 	/*
@@ -163,7 +163,7 @@ ds1511_wdog_set(unsigned long decisecond
 	rtc_write(DS1511_WDE | DS1511_WDS, RTC_CMD);
 }
 
- void
+void
 ds1511_wdog_disable(void)
 {
 	/*
@@ -191,13 +191,12 @@ static int ds1511_rtc_set_time(struct de
 	/*
 	 * won't have to change this for a while
 	 */
-	if (rtc_tm->tm_year < 1900) {
+	if (rtc_tm->tm_year < 1900)
 		rtc_tm->tm_year += 1900;
-	}
 
-	if (rtc_tm->tm_year < 1970) {
+	if (rtc_tm->tm_year < 1970)
 		return -EINVAL;
-	}
+
 	yrs = rtc_tm->tm_year % 100;
 	cen = rtc_tm->tm_year / 100;
 	mon = rtc_tm->tm_mon + 1;   /* tm_mon starts at zero */
@@ -207,17 +206,14 @@ static int ds1511_rtc_set_time(struct de
 	min = rtc_tm->tm_min;
 	sec = rtc_tm->tm_sec;
 
-	if ((mon > 12) || (day == 0)) {
+	if ((mon > 12) || (day == 0))
 		return -EINVAL;
-	}
 
-	if (day > rtc_month_days(rtc_tm->tm_mon, rtc_tm->tm_year)) {
+	if (day > rtc_month_days(rtc_tm->tm_mon, rtc_tm->tm_year))
 		return -EINVAL;
-	}
 
-	if ((hrs >= 24) || (min >= 60) || (sec >= 60)) {
+	if ((hrs >= 24) || (min >= 60) || (sec >= 60))
 		return -EINVAL;
-	}
 
 	/*
 	 * each register is a different number of valid bits
@@ -299,7 +295,7 @@ static int ds1511_rtc_read_time(struct d
  * date/hours/mins/secs matches.  the ds1511 has many more
  * permutations, but the kernel doesn't.
  */
- static void
+static void
 ds1511_rtc_update_alarm(struct rtc_plat_data *pdata)
 {
 	unsigned long flags;
@@ -322,7 +318,7 @@ ds1511_rtc_update_alarm(struct rtc_plat_
 	spin_unlock_irqrestore(&pdata->lock, flags);
 }
 
- static int
+static int
 ds1511_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -335,14 +331,14 @@ ds1511_rtc_set_alarm(struct device *dev,
 	pdata->alrm_hour = alrm->time.tm_hour;
 	pdata->alrm_min = alrm->time.tm_min;
 	pdata->alrm_sec = alrm->time.tm_sec;
-	if (alrm->enabled) {
+	if (alrm->enabled)
 		pdata->irqen |= RTC_AF;
-	}
+
 	ds1511_rtc_update_alarm(pdata);
 	return 0;
 }
 
- static int
+static int
 ds1511_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -359,7 +355,7 @@ ds1511_rtc_read_alarm(struct device *dev
 	return 0;
 }
 
- static irqreturn_t
+static irqreturn_t
 ds1511_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
@@ -406,7 +402,7 @@ static const struct rtc_class_ops ds1511
 	.alarm_irq_enable	= ds1511_rtc_alarm_irq_enable,
 };
 
- static ssize_t
+static ssize_t
 ds1511_nvram_read(struct file *filp, struct kobject *kobj,
 		  struct bin_attribute *ba,
 		  char *buf, loff_t pos, size_t size)
@@ -417,26 +413,26 @@ ds1511_nvram_read(struct file *filp, str
 	 * if count is more than one, turn on "burst" mode
 	 * turn it off when you're done
 	 */
-	if (size > 1) {
+	if (size > 1)
 		rtc_write((rtc_read(RTC_CMD) | DS1511_BME), RTC_CMD);
-	}
-	if (pos > DS1511_RAM_MAX) {
+
+	if (pos > DS1511_RAM_MAX)
 		pos = DS1511_RAM_MAX;
-	}
-	if (size + pos > DS1511_RAM_MAX + 1) {
+
+	if (size + pos > DS1511_RAM_MAX + 1)
 		size = DS1511_RAM_MAX - pos + 1;
-	}
+
 	rtc_write(pos, DS1511_RAMADDR_LSB);
-	for (count = 0; size > 0; count++, size--) {
+	for (count = 0; size > 0; count++, size--)
 		*buf++ = rtc_read(DS1511_RAMDATA);
-	}
-	if (count > 1) {
+
+	if (count > 1)
 		rtc_write((rtc_read(RTC_CMD) & ~DS1511_BME), RTC_CMD);
-	}
+
 	return count;
 }
 
- static ssize_t
+static ssize_t
 ds1511_nvram_write(struct file *filp, struct kobject *kobj,
 		   struct bin_attribute *bin_attr,
 		   char *buf, loff_t pos, size_t size)
@@ -447,22 +443,22 @@ ds1511_nvram_write(struct file *filp, st
 	 * if count is more than one, turn on "burst" mode
 	 * turn it off when you're done
 	 */
-	if (size > 1) {
+	if (size > 1)
 		rtc_write((rtc_read(RTC_CMD) | DS1511_BME), RTC_CMD);
-	}
-	if (pos > DS1511_RAM_MAX) {
+
+	if (pos > DS1511_RAM_MAX)
 		pos = DS1511_RAM_MAX;
-	}
-	if (size + pos > DS1511_RAM_MAX + 1) {
+
+	if (size + pos > DS1511_RAM_MAX + 1)
 		size = DS1511_RAM_MAX - pos + 1;
-	}
+
 	rtc_write(pos, DS1511_RAMADDR_LSB);
-	for (count = 0; size > 0; count++, size--) {
+	for (count = 0; size > 0; count++, size--)
 		rtc_write(*buf++, DS1511_RAMDATA);
-	}
-	if (count > 1) {
+
+	if (count > 1)
 		rtc_write((rtc_read(RTC_CMD) & ~DS1511_BME), RTC_CMD);
-	}
+
 	return count;
 }
 
@@ -484,9 +480,9 @@ static int ds1511_rtc_probe(struct platf
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
+	if (!res)
 		return -ENODEV;
-	}
+
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
@@ -518,9 +514,8 @@ static int ds1511_rtc_probe(struct platf
 	/*
 	 * check for a dying bat-tree
 	 */
-	if (rtc_read(RTC_CMD1) & DS1511_BLF1) {
+	if (rtc_read(RTC_CMD1) & DS1511_BLF1)
 		dev_warn(&pdev->dev, "voltage-low detected.\n");
-	}
 
 	spin_lock_init(&pdata->lock);
 	platform_set_drvdata(pdev, pdata);
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

