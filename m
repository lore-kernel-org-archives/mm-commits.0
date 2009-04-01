From: akpm@linux-foundation.org
Subject: [merged] rtc-wm8350-retries-will-reach-1.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:12 -0700
Message-ID: <200904011842.n31IgCjK009628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760438AbZDAT3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     rtc-wm8350: retries will reach -1
has been removed from the -mm tree.  Its filename was
     rtc-wm8350-retries-will-reach-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-wm8350: retries will reach -1
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement retries will reach -1 rather than 0, so the
warning and error-out will not occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-wm8350-retries-will-reach-1 drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-wm8350-retries-will-reach-1
+++ a/drivers/rtc/rtc-wm8350.c
@@ -122,7 +122,7 @@ static int wm8350_rtc_settime(struct dev
 	do {
 		rtc_ctrl = wm8350_reg_read(wm8350, WM8350_RTC_TIME_CONTROL);
 		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
-	} while (retries-- && !(rtc_ctrl & WM8350_RTC_STS));
+	} while (--retries && !(rtc_ctrl & WM8350_RTC_STS));
 
 	if (!retries) {
 		dev_err(dev, "timed out on set confirmation\n");
@@ -437,7 +437,7 @@ static int wm8350_rtc_probe(struct platf
 		do {
 			timectl = wm8350_reg_read(wm8350,
 						  WM8350_RTC_TIME_CONTROL);
-		} while (timectl & WM8350_RTC_STS && retries--);
+		} while (timectl & WM8350_RTC_STS && --retries);
 
 		if (retries == 0) {
 			dev_err(&pdev->dev, "failed to start: timeout\n");
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

