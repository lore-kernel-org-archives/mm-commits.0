From: akpm@linux-foundation.org
Subject: + rtc-s3c-initialize-s3c_rtc_cpu_type-before-using-it.patch added to -mm tree
Date: Thu, 27 May 2010 14:53:14 -0700
Message-ID: <201005272153.o4RLrEbk016345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535Ab0E0Vxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 May 2010 17:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, a.zummo@towertech.it, jiri.pinkava@vscht.cz, p_gortmaker@yahoo.com


The patch titled
     rtc: s3c: initialize s3c_rtc_cpu_type before using it
has been added to the -mm tree.  Its filename is
     rtc-s3c-initialize-s3c_rtc_cpu_type-before-using-it.patch

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
Subject: rtc: s3c: initialize s3c_rtc_cpu_type before using it
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

Make sure s3c_rtc_cpu_type is initialised _before_ it's used in an if()
check.

Reported-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Maurus Cuelenaere <mcuelenaere@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-initialize-s3c_rtc_cpu_type-before-using-it drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-initialize-s3c_rtc_cpu_type-before-using-it
+++ a/drivers/rtc/rtc-s3c.c
@@ -508,13 +508,13 @@ static int __devinit s3c_rtc_probe(struc
 		goto err_nortc;
 	}
 
+	s3c_rtc_cpu_type = platform_get_device_id(pdev)->driver_data;
+
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		rtc->max_user_freq = 32768;
 	else
 		rtc->max_user_freq = 128;
 
-	s3c_rtc_cpu_type = platform_get_device_id(pdev)->driver_data;
