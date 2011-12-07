From: akpm@linux-foundation.org
Subject: + rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3.patch added to -mm tree
Date: Wed, 07 Dec 2011 14:49:07 -0800
Message-ID: <201112072249.pB7Mn7XW017418@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53241 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab1LGWtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 17:49:16 -0500
Received: by eekc14 with SMTP id c14so24302eek.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 14:49:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.godfrey@stericsson.com, a.zummo@towertech.it, linus.walleij@stericsson.com, plagnioj@jcrosoft.com


The patch titled
     Subject: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3
has been added to the -mm tree.  Its filename is
     rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3.patch

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
From: Mark Godfrey <mark.godfrey@stericsson.com>
Subject: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3

ChangeLog v2->v3:
- back to square 1. 0x80 is not allowed because the representation
  is not two's complement but bit 7 is a sign bit, thus 0x80 is
  just another way to say "zero". Sorry for the mess, clarified this
  with a comment in the code.

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Mark Godfrey <mark.godfrey@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3 drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3
+++ a/drivers/rtc/rtc-ab8500.c
@@ -265,8 +265,11 @@ static int ab8500_rtc_set_calibration(st
 	u8  rtccal = 0;
 
 	/*
-	 * Check that the calibration value (which is in units of 0.5 parts-per-million)
-	 * is in the AB8500's range for RtcCalibration register.
+	 * Check that the calibration value (which is in units of 0.5
+	 * parts-per-million) is in the AB8500's range for RtcCalibration
+	 * register. -128 (0x80) is not permitted because the AB8500 uses
+	 * a sign-bit rather than two's complement, so 0x80 is just another
+	 * representation of zero.
 	 */
 	if ((calibration < -127) || (calibration > 127)) {
 		dev_err(dev, "RtcCalibration value outside permitted range\n");
@@ -281,7 +284,7 @@ static int ab8500_rtc_set_calibration(st
 	if (calibration >= 0)
 		rtccal = 0x7F & calibration;
 	else
-		rtccal = ~(calibration - 1) | 0x80;
+		rtccal = ~(calibration -1) | 0x80;
 
 	retval = abx500_set_register_interruptible(dev, AB8500_RTC,
 			AB8500_RTC_CALIB_REG, rtccal);
_
Subject: Subject: rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3

Patches currently in -mm which might be from mark.godfrey@stericsson.com are

rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3.patch

