From: akpm@linux-foundation.org
Subject: [merged] thermal-exynos-fix-build-error.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:57 -0700
Message-ID: <20120911193258.80FB520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34527 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:33:00 -0400
Received: by mail-lb0-f202.google.com with SMTP id ge1so69820lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:33:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, guenter.roeck@ericsson.com, len.brown@intel.com, lenb@kernel.org, sachin.kamat@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: fix build error
has been removed from the -mm tree.  Its filename was
     thermal-exynos-fix-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/thermal/exynos_thermal.c: fix build error

Fix the following error:
drivers/thermal/exynos_thermal.c:393:4: error: too few arguments to function
`thermal_zone_device_register'

Add the missing 'mask' argument.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos-fix-build-error drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos-fix-build-error
+++ a/drivers/thermal/exynos_thermal.c
@@ -389,7 +389,7 @@ static int exynos_register_thermal(struc
 	th_zone->cool_dev_size = count;
 
 	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
-			EXYNOS_ZONE_COUNT, NULL, &exynos_dev_ops, 0, 0, 0,
+			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, 0, 0, 0,
 			IDLE_INTERVAL);
 
 	if (IS_ERR(th_zone->therm_dev)) {
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

