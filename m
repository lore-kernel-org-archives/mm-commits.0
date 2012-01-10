From: akpm@linux-foundation.org
Subject: [folded] rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:53:59 -0800
Message-ID: <20120110225400.10D311E007A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:44786 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJWyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:54:01 -0500
Received: by ggnk3 with SMTP id k3so16345ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:54:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, linus.walleij@stericsson.com, mark.godfrey@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes

Cc: Alessandro Zummo <a.zummo@towertech.it>

WARNING: line over 80 characters
#48: FILE: drivers/rtc/rtc-ab8500.c:268:
+	 * Check that the calibration value (which is in units of 0.5 parts-per-million)

ERROR: need consistent spacing around '-' (ctx:WxV)
#64: FILE: drivers/rtc/rtc-ab8500.c:284:
+		rtccal = ~(calibration -1) | 0x80;
 		                       ^

total: 1 errors, 1 warnings, 139 lines checked

./patches/rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Godfrey <mark.godfrey@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes
+++ a/drivers/rtc/rtc-ab8500.c
@@ -281,7 +281,7 @@ static int ab8500_rtc_set_calibration(st
 	if (calibration >= 0)
 		rtccal = 0x7F & calibration;
 	else
-		rtccal = ~(calibration -1) | 0x80;
+		rtccal = ~(calibration - 1) | 0x80;
 
 	retval = abx500_set_register_interruptible(dev, AB8500_RTC,
 			AB8500_RTC_CALIB_REG, rtccal);
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
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch
drivers-rtc-rtc-mxcc-make-alarm-work.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

