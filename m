From: akpm@linux-foundation.org
Subject: + rtc-wm8350-retries-will-reach-1.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:13:15 -0800
Message-ID: <200901302113.n0ULDFni013153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZA3VNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com


The patch titled
     rtc-wm8350: retries will reach -1
has been added to the -mm tree.  Its filename is
     rtc-wm8350-retries-will-reach-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
dvb-negative-internal-sub_range-wont-get-noticed.patch
paride-pgc-xs-confusion.patch
virtio-fix-bad_ring-start_us-and-end_use-macros.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
rtc-wm8350-retries-will-reach-1.patch
ufs-sector_t-cannot-be-negative.patch

