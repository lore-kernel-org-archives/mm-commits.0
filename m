From: akpm@linux-foundation.org
Subject: [merged] drivers-thermal-step_wisec-add-missing-static-storage-class-specifiers.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:48 -0700
Message-ID: <20121001192848.B09191E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48494 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JAT2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:49 -0400
Received: by ggmi4 with SMTP id i4so8389ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, amit.kachhap@linaro.org, durgadoss.r@intel.com, len.brown@intel.com, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/thermal/step_wise.c: add missing static storage class specifiers
has been removed from the -mm tree.  Its filename was
     drivers-thermal-step_wisec-add-missing-static-storage-class-specifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/thermal/step_wise.c: add missing static storage class specifiers

Fixes the following sparse warnings:
drivers/thermal/step_wise.c:153:5: warning:
symbol 'step_wise_throttle' was not declared. Should it be static?
drivers/thermal/step_wise.c:172:25: warning:
symbol 'thermal_gov_step_wise' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/step_wise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/step_wise.c~drivers-thermal-step_wisec-add-missing-static-storage-class-specifiers drivers/thermal/step_wise.c
--- a/drivers/thermal/step_wise.c~drivers-thermal-step_wisec-add-missing-static-storage-class-specifiers
+++ a/drivers/thermal/step_wise.c
@@ -150,7 +150,7 @@ static void thermal_zone_trip_update(str
  * step. If the zone is 'cooling down' it brings back the performance of
  * the devices by one step.
  */
-int step_wise_throttle(struct thermal_zone_device *tz, int trip)
+static int step_wise_throttle(struct thermal_zone_device *tz, int trip)
 {
 	struct thermal_instance *instance;
 
@@ -169,7 +169,7 @@ int step_wise_throttle(struct thermal_zo
 	return 0;
 }
 
-struct thermal_governor thermal_gov_step_wise = {
+static struct thermal_governor thermal_gov_step_wise = {
 	.name		= DEFAULT_THERMAL_GOVERNOR,
 	.throttle	= step_wise_throttle,
 	.owner		= THIS_MODULE,
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch
proc-use-null-instead-of-0-for-pointer.patch

