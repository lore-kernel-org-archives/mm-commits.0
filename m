From: akpm@linux-foundation.org
Subject: + rtc-s3c-add-device_init_wakeup-invokation.patch added to -mm tree
Date: Tue, 28 Oct 2008 13:28:04 -0700
Message-ID: <200810282028.m9SKS41N018981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbYJ1U2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 16:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jekhor@gmail.com, a.zummo@towertech.it, ben-linux@fluff.org, david-b@pacbell.net


The patch titled
     rtc S3C: add device_init_wakeup() invokation
has been added to the -mm tree.  Its filename is
     rtc-s3c-add-device_init_wakeup-invokation.patch

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
Subject: rtc S3C: add device_init_wakeup() invokation
From: Yauhen Kharuzhy <jekhor@gmail.com>

tAdd adds device_init_wakeup() ivokation to probe function of
s3c2410_rtc_driver.  Without of this wakealarm sysfs attribute does not
initialise.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-add-device_init_wakeup-invokation drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-add-device_init_wakeup-invokation
+++ a/drivers/rtc/rtc-s3c.c
@@ -455,6 +455,8 @@ static int __devinit s3c_rtc_probe(struc
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	/* register RTC and exit */
 
 	rtc = rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
_

Patches currently in -mm which might be from jekhor@gmail.com are

rtc-s3c-fix-section-mismatch-warnings.patch
rtc-s3c-add-device_init_wakeup-invokation.patch

