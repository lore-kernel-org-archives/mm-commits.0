From: akpm@linux-foundation.org
Subject: [folded] backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:47:48 -0800
Message-ID: <20120110224748.970641003D2@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:46038 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab2AJWrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:47:49 -0500
Received: by ggnk3 with SMTP id k3so15044ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:47:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-convert-pwm_bl-to-dev_pm_ops-fix
has been removed from the -mm tree.  Its filename was
     backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch

This patch was dropped because it was folded into backlight-convert-pwm_bl-to-dev_pm_ops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-convert-pwm_bl-to-dev_pm_ops-fix

Fix CONFIG_PM=n build

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-convert-pwm_bl-to-dev_pm_ops-fix drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-convert-pwm_bl-to-dev_pm_ops-fix
+++ a/drivers/video/backlight/pwm_bl.c
@@ -194,15 +194,15 @@ static int pwm_backlight_resume(struct d
 static SIMPLE_DEV_PM_OPS(pwm_backlight_pm_ops, pwm_backlight_suspend,
 			 pwm_backlight_resume);
 
-#else
-#define pwm_backlight_pm_ops	NULL
 #endif
 
 static struct platform_driver pwm_backlight_driver = {
 	.driver		= {
 		.name	= "pwm-backlight",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
 		.pm	= &pwm_backlight_pm_ops,
+#endif
 	},
 	.probe		= pwm_backlight_probe,
 	.remove		= pwm_backlight_remove,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

