From: akpm@linux-foundation.org
Subject: + rtc-s3c-initialize-driver-data-before-using-it.patch added to -mm tree
Date: Thu, 27 May 2010 14:53:12 -0700
Message-ID: <201005272153.o4RLrCex016342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535Ab0E0Vx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 May 2010 17:53:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, a.zummo@towertech.it, p_gortmaker@yahoo.com, stable@kernel.org


The patch titled
     rtc: s3c: initialize driver data before using it
has been added to the -mm tree.  Its filename is
     rtc-s3c-initialize-driver-data-before-using-it.patch

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
Subject: rtc: s3c: initialize driver data before using it
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

s3c_rtc_setfreq() uses the platform driver data to derive struct rtc_device,
so make sure drvdata is set _before_ s3c_rtc_setfreq() is called.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-initialize-driver-data-before-using-it drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-initialize-driver-data-before-using-it
+++ a/drivers/rtc/rtc-s3c.c
@@ -495,8 +495,6 @@ static int __devinit s3c_rtc_probe(struc
  	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
 		 readb(s3c_rtc_base + S3C2410_RTCCON));
 
-	s3c_rtc_setfreq(&pdev->dev, 1);
