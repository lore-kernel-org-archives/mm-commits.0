From: akpm@linux-foundation.org
Subject: + rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch added to -mm tree
Date: Thu, 19 Jan 2012 12:31:34 -0800
Message-ID: <20120119203135.93C0A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44120 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab2ASUbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2012 15:31:37 -0500
Received: by eekb15 with SMTP id b15so11507eek.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2012 12:31:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shiraz.hashim@st.com, deepak.sikri@st.com, rajeev-dlh.kumar@st.com, viresh.kumar@st.com


The patch titled
     Subject: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors
has been added to the -mm tree.  Its filename is
     rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc/spear: fix for RTC_AIE_ON and RTC_AIE_OFF ioctl errors

Patches currently in -mm which might be from shiraz.hashim@st.com are

rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

