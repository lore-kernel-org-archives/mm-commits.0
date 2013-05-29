From: akpm@linux-foundation.org
Subject: + mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2.patch
 added to -mm tree
Date: Wed, 29 May 2013 14:09:32 -0700
Message-ID: <51a66e8c.EG+vor4PztNf/Qgk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966927Ab3E2VJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 17:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sameo@linux.intel.com, linus.walleij@linaro.org, lee.jones@linaro.org, julien.delacou@stericsson.com, alexandre.torgue@st.com

Subject: + mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2.patch added to -mm tree
To: alexandre.torgue@st.com,julien.delacou@stericsson.com,lee.jones@linaro.org,linus.walleij@linaro.org,sameo@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 14:09:32 -0700


The patch titled
     Subject: drivers/mfd/ab8500-core.c: add device for new rtc version on ab8540 cut2
has been added to the -mm tree.  Its filename is
     mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Torgue <alexandre.torgue@st.com>
Subject: drivers/mfd/ab8500-core.c: add device for new rtc version on ab8540 cut2

Android expects the RTC to have second resolution.  On ab8540 cut2 RTC
block has a new register which allows setting seconds for wakeup alarms.


This patch:

AB8540 rtc have changed between AB8540_cut1 and AB8540_cut2.Different
ressources to define for those two version.

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/ab8500-core.c         |   55 +++++++++++++++++++++++-----
 include/linux/mfd/abx500/ab8500.h |    2 +
 2 files changed, 49 insertions(+), 8 deletions(-)

diff -puN drivers/mfd/ab8500-core.c~mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2 drivers/mfd/ab8500-core.c
--- a/drivers/mfd/ab8500-core.c~mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2
+++ a/drivers/mfd/ab8500-core.c
@@ -650,6 +650,21 @@ static struct resource ab8500_rtc_resour
 	},
 };
 
+static struct resource ab8540_rtc_resources[] = {
+	{
+		.name	= "1S",
+		.start	= AB8540_INT_RTC_1S,
+		.end	= AB8540_INT_RTC_1S,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "ALARM",
+		.start	= AB8500_INT_RTC_ALARM,
+		.end	= AB8500_INT_RTC_ALARM,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 static struct resource ab8500_poweronkey_db_resources[] = {
 	{
 		.name	= "ONKEY_DBF",
@@ -1287,11 +1302,6 @@ static struct mfd_cell ab8540_devs[] = {
 		.resources = ab8505_gpadc_resources,
 	},
 	{
-		.name = "ab8500-rtc",
-		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
-		.resources = ab8500_rtc_resources,
-	},
-	{
 		.name = "ab8500-acc-det",
 		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
 		.resources = ab8500_av_acc_detect_resources,
@@ -1331,6 +1341,24 @@ static struct mfd_cell ab8540_devs[] = {
 	},
 };
 
+static struct mfd_cell ab8540_cut1_devs[] = {
+	{
+		.name = "ab8500-rtc",
+		.of_compatible = "stericsson,ab8500-rtc",
+		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
+		.resources = ab8500_rtc_resources,
+	},
+};
+
+static struct mfd_cell ab8540_cut2_devs[] = {
+	{
+		.name = "ab8540-rtc",
+		.of_compatible = "stericsson,ab8540-rtc",
+		.num_resources = ARRAY_SIZE(ab8540_rtc_resources),
+		.resources = ab8540_rtc_resources,
+	},
+};
+
 static ssize_t show_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -1734,11 +1762,22 @@ static int ab8500_probe(struct platform_
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
 				ab8500->irq_base, ab8500->domain);
-	else if (is_ab8540(ab8500))
+	else if (is_ab8540(ab8500)) {
 		ret = mfd_add_devices(ab8500->dev, 0, ab8540_devs,
 			      ARRAY_SIZE(ab8540_devs), NULL,
-			      ab8500->irq_base, ab8500->domain);
-	else if (is_ab8505(ab8500))
+			      ab8500->irq_base, NULL);
+		if (ret)
+			return ret;
+
+		if (is_ab8540_1p2_or_earlier(ab8500))
+			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut1_devs,
+			      ARRAY_SIZE(ab8540_cut1_devs), NULL,
+			      ab8500->irq_base, NULL);
+		else /* ab8540 >= cut2 */
+			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut2_devs,
+			      ARRAY_SIZE(ab8540_cut2_devs), NULL,
+			      ab8500->irq_base, NULL);
+	} else if (is_ab8505(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab8505_devs,
 			      ARRAY_SIZE(ab8505_devs), NULL,
 			      ab8500->irq_base, ab8500->domain);
diff -puN include/linux/mfd/abx500/ab8500.h~mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2 include/linux/mfd/abx500/ab8500.h
--- a/include/linux/mfd/abx500/ab8500.h~mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2
+++ a/include/linux/mfd/abx500/ab8500.h
@@ -291,6 +291,8 @@ enum ab8500_version {
 #define AB8540_INT_FSYNC2R		213
 #define AB8540_INT_BITCLK2F		214
 #define AB8540_INT_BITCLK2R		215
+/* ab8540_irq_regoffset[27] -> IT[Source|Latch|Mask]33 */
+#define AB8540_INT_RTC_1S		216
 
 /*
  * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
_

Patches currently in -mm which might be from alexandre.torgue@st.com are

mfd-ab8540-add-device-for-new-rtc-version-on-ab8540-cut2.patch
rtc-ab8540-add-second-resolution-to-rtc-driver.patch

