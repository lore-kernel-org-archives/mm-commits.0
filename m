From: akpm@linux-foundation.org
Subject: [merged] thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:43 -0700
Message-ID: <20121001192844.3964E5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37797 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JAT2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:47 -0400
Received: by wibhr7 with SMTP id hr7so152732wib.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, amit.kachhap@linaro.org, durgadoss.r@intel.com, len.brown@intel.com, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: fix NULL pointer dereference in exynos_unregister_thermal()
has been removed from the -mm tree.  Its filename was
     thermal-exynos-fix-null-pointer-dereference-in-exynos_unregister_thermal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch
proc-use-null-instead-of-0-for-pointer.patch

