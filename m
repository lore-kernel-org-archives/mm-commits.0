From: akpm@linux-foundation.org
Subject: [merged] rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:16 -0700
Message-ID: <20120326193116.5867DA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57526 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2CZTbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:18 -0400
Received: by bkcjm19 with SMTP id jm19so288218bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shiraz.hashim@st.com, deepak.sikri@st.com, rajeev-dlh.kumar@st.com, viresh.kumar@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors
has been removed from the -mm tree.  Its filename was
     rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shiraz Hashim <shiraz.hashim@st.com>
Subject: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors

Define API for '.alarm_irq_enable' to enable and disable alarm irq. This
is required by the framework else RTC_AIE_ON and RTC_AIE_OFF ioctls
return errors.

Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Deepak Sikri <deepak.sikri@st.com>
Acked-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN drivers/rtc/rtc-spear.c~rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors
+++ a/drivers/rtc/rtc-spear.c
@@ -327,11 +327,39 @@ static int spear_rtc_set_alarm(struct de
 
 	return 0;
 }
+
+static int spear_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	struct spear_rtc_config *config = dev_get_drvdata(&rtc->dev);
+	int ret = 0;
+
+	spear_rtc_clear_interrupt(config);
+
+	switch (enabled) {
+	case 0:
+		/* alarm off */
+		spear_rtc_disable_interrupt(config);
+		break;
+	case 1:
+		/* alarm on */
+		spear_rtc_enable_interrupt(config);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static struct rtc_class_ops spear_rtc_ops = {
 	.read_time = spear_rtc_read_time,
 	.set_time = spear_rtc_set_time,
 	.read_alarm = spear_rtc_read_alarm,
 	.set_alarm = spear_rtc_set_alarm,
+	.alarm_irq_enable = spear_alarm_irq_enable,
 };
 
 static int __devinit spear_rtc_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from shiraz.hashim@st.com are

origin.patch
linux-next.patch

