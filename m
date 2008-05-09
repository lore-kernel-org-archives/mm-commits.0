From: akpm@linux-foundation.org
Subject: + rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch added to -mm tree
Date: Fri, 09 May 2008 15:51:08 -0700
Message-ID: <200805092251.m49Mp8Rr029673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519AbYEIWvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 18:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, wim@iguana.be


The patch titled
     RTC/watchdog: M41T80: fix a potential use of unitialized data
has been added to the -mm tree.  Its filename is
     rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RTC/watchdog: M41T80: fix a potential use of unitialized data
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Watchdog handlers within the driver make use of "save_client" -- make sure it
has been initalized before the handlers are registered.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Bigga <ab@mycable.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data
+++ a/drivers/rtc/rtc-m41t80.c
@@ -803,6 +803,7 @@ static int m41t80_probe(struct i2c_clien
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
+		save_client = client;
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -811,7 +812,6 @@ static int m41t80_probe(struct i2c_clien
 			misc_deregister(&wdt_dev);
 			goto exit;
 		}
-		save_client = client;
 	}
 #endif
 	return 0;
_

Patches currently in -mm which might be from macro@linux-mips.org are

rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch
linux-next.patch

