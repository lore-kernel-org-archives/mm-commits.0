From: akpm@linux-foundation.org
Subject: + thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal.patch added to -mm tree
Date: Thu, 27 Sep 2012 14:59:54 -0700
Message-ID: <20120927215954.B415B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53698 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0V74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 17:59:56 -0400
Received: by vcbfy27 with SMTP id fy27so289260vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 14:59:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, amit.kachhap@linaro.org, durgadoss.r@intel.com, len.brown@intel.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: fix NULL pointer dereference in exynos_unregister_thermal()
has been added to the -mm tree.  Its filename is
     thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal.patch

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
Subject: drivers/thermal/exynos_thermal.c: fix NULL pointer dereference in exynos_unregister_thermal()

exynos_unregister_thermal() is functional only when 'th_zone' is not NULL
(ensured by the NULL checks).  However, in the event it is NULL, it gets
dereferenced in the for loop.  This patch fixes this issue.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal
+++ a/drivers/thermal/exynos_thermal.c
@@ -475,11 +475,14 @@ static void exynos_unregister_thermal(vo
 {
 	int i;
 
-	if (th_zone && th_zone->therm_dev)
+	if (!th_zone)
+		return;
+
+	if (th_zone->therm_dev)
 		thermal_zone_device_unregister(th_zone->therm_dev);
 
 	for (i = 0; i < th_zone->cool_dev_size; i++) {
-		if (th_zone && th_zone->cool_dev[i])
+		if (th_zone->cool_dev[i])
 			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
 	}
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch
proc-use-null-instead-of-0-for-pointer.patch

