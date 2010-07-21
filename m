From: akpm@linux-foundation.org
Subject: + rtc-isl12022-properly-handle-military-hour-format.patch added to -mm tree
Date: Wed, 21 Jul 2010 13:54:30 -0700
Message-ID: <201007212054.o6LKsU1T014647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358Ab0GUUyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 16:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roman.fietze@telemotive.de, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     rtc-isl12022: properly handle military hour format
has been added to the -mm tree.  Its filename is
     rtc-isl12022-properly-handle-military-hour-format.patch

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
Subject: rtc-isl12022: properly handle military hour format
From: Roman Fietze <roman.fietze@telemotive.de>

Mask out PM flag when reading the hour, always set MIL bit when
writing the hour.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-isl12022.c~rtc-isl12022-properly-handle-military-hour-format drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~rtc-isl12022-properly-handle-military-hour-format
+++ a/drivers/rtc/rtc-isl12022.c
@@ -135,7 +135,7 @@ static int isl12022_get_datetime(struct 
 
 	tm->tm_sec = bcd2bin(buf[ISL12022_REG_SC] & 0x7F);
 	tm->tm_min = bcd2bin(buf[ISL12022_REG_MN] & 0x7F);
-	tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x3F);
+	tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x1F);
 	tm->tm_mday = bcd2bin(buf[ISL12022_REG_DT] & 0x3F);
 	tm->tm_wday = buf[ISL12022_REG_DW] & 0x07;
 	tm->tm_mon = bcd2bin(buf[ISL12022_REG_MO] & 0x1F) - 1;
@@ -208,7 +208,7 @@ static int isl12022_set_datetime(struct 
 	/* hours, minutes and seconds */
 	buf[ISL12022_REG_SC] = bin2bcd(tm->tm_sec);
 	buf[ISL12022_REG_MN] = bin2bcd(tm->tm_min);
-	buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour);
+	buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour) | ISL12022_HR_MIL;
 
 	buf[ISL12022_REG_DT] = bin2bcd(tm->tm_mday);
 
_

Patches currently in -mm which might be from roman.fietze@telemotive.de are

rtc-add-intersil-isl12022-rtc-driver.patch
rtc-isl12022-properly-handle-military-hour-format.patch

