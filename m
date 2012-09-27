From: akpm@linux-foundation.org
Subject: + drivers-thermal-fair_sharec-add-missing-static-storage-class-specifiers.patch added to -mm tree
Date: Thu, 27 Sep 2012 15:04:07 -0700
Message-ID: <20120927220408.9FB2820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58724 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0WEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 18:04:11 -0400
Received: by wibhr7 with SMTP id hr7so166372wib.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 15:04:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, amit.kachhap@linaro.org, durgadoss.r@intel.com, len.brown@intel.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     Subject: drivers/thermal/fair_share.c: add missing static storage class specifiers
has been added to the -mm tree.  Its filename is
     drivers-thermal-fair_sharec-add-missing-static-storage-class-specifiers.patch

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
Subject: drivers/thermal/fair_share.c: add missing static storage class specifiers

Fixes the following sparse warnings:
drivers/thermal/fair_share.c:80:5: warning:
symbol 'fair_share_throttle' was not declared. Should it be static?
drivers/thermal/fair_share.c:111:25: warning:
symbol 'thermal_gov_fair_share' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/fair_share.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/fair_share.c~drivers-thermal-fair_sharec-add-missing-static-storage-class-specifiers drivers/thermal/fair_share.c
--- a/drivers/thermal/fair_share.c~drivers-thermal-fair_sharec-add-missing-static-storage-class-specifiers
+++ a/drivers/thermal/fair_share.c
@@ -77,7 +77,7 @@ static long get_target_state(struct ther
  *	(Heavily assumes the trip points are in ascending order)
  * new_state of cooling device = P3 * P2 * P1
  */
-int fair_share_throttle(struct thermal_zone_device *tz, int trip)
+static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 {
 	const struct thermal_zone_params *tzp;
 	struct thermal_cooling_device *cdev;
@@ -108,7 +108,7 @@ int fair_share_throttle(struct thermal_z
 	return 0;
 }
 
-struct thermal_governor thermal_gov_fair_share = {
+static struct thermal_governor thermal_gov_fair_share = {
 	.name		= "fair_share",
 	.throttle	= fair_share_throttle,
 	.owner		= THIS_MODULE,
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal.patch
drivers-thermal-step_wisec-add-missing-static-storage-class-specifiers.patch
drivers-thermal-fair_sharec-add-missing-static-storage-class-specifiers.patch
drivers-thermal-user_spacec-add-missing-static-storage-class-specifiers.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch
proc-use-null-instead-of-0-for-pointer.patch

