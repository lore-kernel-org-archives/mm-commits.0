From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-da9063-rtc-driver-fix.patch removed from -mm
 tree
Date: Fri, 06 Jun 2014 14:03:43 -0700
Message-ID: <53922caf.RF4rq3/7/doilDmu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stwiss.opensource@diasemi.com, sameo@linux.intel.com, p.zabel@pengutronix.de, lee.jones@linaro.org, david.chen@diasemi.com, broonie@linaro.org, a.zummo@towertech.it, akpm@linux-foundation.org

Subject: [folded-merged] rtc-da9063-rtc-driver-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,a.zummo@towertech.it,broonie@linaro.org,david.chen@diasemi.com,lee.jones@linaro.org,p.zabel@pengutronix.de,sameo@linux.intel.com,stwiss.opensource@diasemi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:03:43 -0700


The patch titled
     Subject: rtc-da9063-rtc-driver-fix
has been removed from the -mm tree.  Its filename was
     rtc-da9063-rtc-driver-fix.patch

This patch was dropped because it was folded into rtc-da9063-rtc-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-da9063-rtc-driver-fix

coding-style tweaks

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Dajun Chen <david.chen@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9063.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-da9063.c~rtc-da9063-rtc-driver-fix drivers/rtc/rtc-da9063.c
--- a/drivers/rtc/rtc-da9063.c~rtc-da9063-rtc-driver-fix
+++ a/drivers/rtc/rtc-da9063.c
@@ -82,6 +82,7 @@ static void da9063_tm_to_data(struct rtc
 static int da9063_rtc_stop_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+
 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
 				  DA9063_ALARM_ON, 0);
 }
@@ -89,6 +90,7 @@ static int da9063_rtc_stop_alarm(struct
 static int da9063_rtc_start_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+
 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
 				  DA9063_ALARM_ON, DA9063_ALARM_ON);
 }
@@ -115,13 +117,12 @@ static int da9063_rtc_read_time(struct d
 
 	da9063_data_to_tm(data, tm);
 
-	(void)rtc_tm_to_time(tm, &tm_secs);
-	(void)rtc_tm_to_time(&rtc->alarm_time, &al_secs);
+	rtc_tm_to_time(tm, &tm_secs);
+	rtc_tm_to_time(&rtc->alarm_time, &al_secs);
 
 	/* handle the rtc synchronisation delay */
 	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
-		(void)memcpy((void *)tm, (const void *)&rtc->alarm_time,
-			     sizeof(struct rtc_time));
+		memcpy(tm, &rtc->alarm_time, sizeof(struct rtc_time));
 	else
 		rtc->rtc_sync = false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

