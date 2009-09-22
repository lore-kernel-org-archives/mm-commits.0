From: akpm@linux-foundation.org
Subject: [folded] davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:51:31 -0700
Message-ID: <200909222151.n8MLpV2i016608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803AbZIVVwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, krzysztof.h1@wp.pl, pkiryukhin@ru.mvista.com, schen@mvista.com, sudhakar.raj@ti.com, mm-commits@vger.kernel.org


The patch titled
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup
has been removed from the -mm tree.  Its filename was
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch

This patch was dropped because it was folded into davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

simplify lcd_disable_raster()

Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Cc: Steve Chen <schen@mvista.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup
+++ a/drivers/video/da8xx-fb.c
@@ -201,8 +201,6 @@ static int lcd_disable_raster(struct da8
 		ret = wait_event_interruptible_timeout(par->da8xx_wq,
 						!lcdc_read(LCD_STAT_REG) &
 						LCD_END_OF_FRAME0, WSI_TIMEOUT);
-		if (ret < 0)
-			return ret;
 		if (ret == 0)
 			ret = -ETIMEDOUT;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

