From: akpm@linux-foundation.org
Subject: + rtc-pcf50633-fix-month-off-by-one-error.patch added to -mm tree
Date: Tue, 10 Nov 2009 14:50:39 -0800
Message-ID: <200911102250.nAAModbY009225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbZKJWvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 17:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rask@sygehus.dk, a.zummo@towertech.it, balajirrao@openmoko.org, fercerpav@gmail.com, p_gortmaker@yahoo.com


The patch titled
     rtc: pcf50633: fix month off-by-one error
has been added to the -mm tree.  Its filename is
     rtc-pcf50633-fix-month-off-by-one-error.patch

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
Subject: rtc: pcf50633: fix month off-by-one error
From: Rask Ingemann Lambertsen <rask@sygehus.dk>

The PCF50633 stores a month value of 1-12, but the kernel wants 0-11.

Signed-off-by: Rask Ingemann Lambertsen <rask@sygehus.dk>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-pcf50633.c~rtc-pcf50633-fix-month-off-by-one-error drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~rtc-pcf50633-fix-month-off-by-one-error
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -70,7 +70,7 @@ static void pcf2rtc_time(struct rtc_time
 	rtc->tm_hour = bcd2bin(pcf->time[PCF50633_TI_HOUR]);
 	rtc->tm_wday = bcd2bin(pcf->time[PCF50633_TI_WKDAY]);
 	rtc->tm_mday = bcd2bin(pcf->time[PCF50633_TI_DAY]);
-	rtc->tm_mon = bcd2bin(pcf->time[PCF50633_TI_MONTH]);
+	rtc->tm_mon = bcd2bin(pcf->time[PCF50633_TI_MONTH]) - 1;
 	rtc->tm_year = bcd2bin(pcf->time[PCF50633_TI_YEAR]) + 100;
 }
 
@@ -81,7 +81,7 @@ static void rtc2pcf_time(struct pcf50633
 	pcf->time[PCF50633_TI_HOUR] = bin2bcd(rtc->tm_hour);
 	pcf->time[PCF50633_TI_WKDAY] = bin2bcd(rtc->tm_wday);
 	pcf->time[PCF50633_TI_DAY] = bin2bcd(rtc->tm_mday);
-	pcf->time[PCF50633_TI_MONTH] = bin2bcd(rtc->tm_mon);
+	pcf->time[PCF50633_TI_MONTH] = bin2bcd(rtc->tm_mon + 1);
 	pcf->time[PCF50633_TI_YEAR] = bin2bcd(rtc->tm_year % 100);
 }
 
_

Patches currently in -mm which might be from rask@sygehus.dk are

rtc-pcf50633-fix-month-off-by-one-error.patch

