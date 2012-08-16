From: akpm@linux-foundation.org
Subject: + thermal-exynos-fix-build-error.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:39:54 -0700
Message-ID: <20120816183955.4F105100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:45829 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2HPSj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:39:56 -0400
Received: by obbwc20 with SMTP id wc20so2143350obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:39:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, guenter.roeck@ericsson.com, len.brown@intel.com, lenb@kernel.org, sachin.kamat@samsung.com


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: fix build error
has been added to the -mm tree.  Its filename is
     thermal-exynos-fix-build-error.patch

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

origin.patch
linux-next.patch
thermal-exynos-fix-build-error.patch
thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch
thermal-exynos-use-devm_-functions.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

