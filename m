From: akpm@linux-foundation.org
Subject: + drivers-thermal-user_spacec-add-missing-static-storage-class-specifiers.patch added to -mm tree
Date: Thu, 27 Sep 2012 15:04:12 -0700
Message-ID: <20120927220412.B672B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:46255 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2I0WEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 18:04:14 -0400
Received: by vbis24 with SMTP id s24so289755vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 15:04:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, amit.kachhap@linaro.org, durgadoss.r@intel.com, len.brown@intel.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     Subject: drivers/thermal/user_space.c: add missing static storage class specifiers
has been added to the -mm tree.  Its filename is
     drivers-thermal-user_spacec-add-missing-static-storage-class-specifiers.patch

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
Subject: drivers/thermal/user_space.c: add missing static storage class specifiers

Fixes the following sparse warnings:
drivers/thermal/user_space.c:38:5: warning:
symbol 'notify_user_space' was not declared. Should it be static?
drivers/thermal/user_space.c:46:25: warning:
symbol 'thermal_gov_user_space' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/user_space.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/user_space.c~drivers-thermal-user_spacec-add-missing-static-storage-class-specifiers drivers/thermal/user_space.c
--- a/drivers/thermal/user_space.c~drivers-thermal-user_spacec-add-missing-static-storage-class-specifiers
+++ a/drivers/thermal/user_space.c
@@ -35,7 +35,7 @@
  *
  * This function notifies the user space through UEvents.
  */
-int notify_user_space(struct thermal_zone_device *tz, int trip)
+static int notify_user_space(struct thermal_zone_device *tz, int trip)
 {
 	mutex_lock(&tz->lock);
 	kobject_uevent(&tz->device.kobj, KOBJ_CHANGE);
@@ -43,7 +43,7 @@ int notify_user_space(struct thermal_zon
 	return 0;
 }
 
-struct thermal_governor thermal_gov_user_space = {
+static struct thermal_governor thermal_gov_user_space = {
 	.name		= "user_space",
 	.throttle	= notify_user_space,
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

