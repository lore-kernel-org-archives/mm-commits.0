From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ab3100c-add-missing-platform_set_drvdata-in-ab3100_rtc_probe.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:30:57 -0700
Message-ID: <201009212230.o8LMUvDS006512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905Ab0IUWbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, linus.walleij@stericsson.com, mcuos.com@gmail.com


The patch titled
     drivers/rtc/rtc-ab3100.c: add missing platform_set_drvdata() in ab3100_rtc_probe()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ab3100c-add-missing-platform_set_drvdata-in-ab3100_rtc_probe.patch

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
Subject: drivers/rtc/rtc-ab3100.c: add missing platform_set_drvdata() in ab3100_rtc_probe()
From: Axel Lin <axel.lin@gmail.com>

Otherwise, calling platform_get_drvdata() in ab3100_rtc_remove() returns
NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by:Wan ZongShun <mcuos.com@gmail.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab3100.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-ab3100.c~drivers-rtc-rtc-ab3100c-add-missing-platform_set_drvdata-in-ab3100_rtc_probe drivers/rtc/rtc-ab3100.c
--- a/drivers/rtc/rtc-ab3100.c~drivers-rtc-rtc-ab3100c-add-missing-platform_set_drvdata-in-ab3100_rtc_probe
+++ a/drivers/rtc/rtc-ab3100.c
@@ -235,6 +235,7 @@ static int __init ab3100_rtc_probe(struc
 		err = PTR_ERR(rtc);
 		return err;
 	}
+	platform_set_drvdata(pdev, rtc);
 
 	return 0;
 }
@@ -244,6 +245,7 @@ static int __exit ab3100_rtc_remove(stru
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
 	rtc_device_unregister(rtc);
+	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

drivers-rtc-rtc-ab3100c-add-missing-platform_set_drvdata-in-ab3100_rtc_probe.patch
linux-next.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch
backlight-s6e63m0-fix-section-mismatch.patch

