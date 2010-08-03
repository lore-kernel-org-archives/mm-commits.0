From: akpm@linux-foundation.org
Subject: + rtc-isl12022-properly-handle-military-hour-format-fix.patch added to -mm tree
Date: Tue, 03 Aug 2010 14:51:15 -0700
Message-ID: <201008032151.o73LpFsl013195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757797Ab0HCVwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roman.fietze@telemotive.de, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     rtc-isl12022-properly-handle-military-hour-format-fix.txt
has been added to the -mm tree.  Its filename is
     rtc-isl12022-properly-handle-military-hour-format-fix.patch

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
Subject: rtc-isl12022-properly-handle-military-hour-format-fix.txt
From: Roman Fietze <roman.fietze@telemotive.de>

The patch corrects a bug that could only be found after some testing,
because it happens only when reading the time between 20:00 and
24:00UTC.

Accidently my previous patch for this driver masks out the highest bit
of the BCD hour, which is also the AM/PM indicator if not in MIL mode,
always resulting in hours below 20. The error was not detected when
reviewing the patch, because the fact was missed, that ISL register
values are all BCD and not binary, and therefore a mask of 0x1F cannot
hold all values from 0..23.

The proper solution is to always set the MIL bit when writing the
hour, and of course masking with 0x3F, properly keeping both hour BCD
digits.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12022.c~rtc-isl12022-properly-handle-military-hour-format-fix drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~rtc-isl12022-properly-handle-military-hour-format-fix
+++ a/drivers/rtc/rtc-isl12022.c
@@ -135,7 +135,7 @@ static int isl12022_get_datetime(struct 
 
 	tm->tm_sec = bcd2bin(buf[ISL12022_REG_SC] & 0x7F);
 	tm->tm_min = bcd2bin(buf[ISL12022_REG_MN] & 0x7F);
-	tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x1F);
+	tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x3F);
 	tm->tm_mday = bcd2bin(buf[ISL12022_REG_DT] & 0x3F);
 	tm->tm_wday = buf[ISL12022_REG_DW] & 0x07;
 	tm->tm_mon = bcd2bin(buf[ISL12022_REG_MO] & 0x1F) - 1;
_

Patches currently in -mm which might be from roman.fietze@telemotive.de are

rtc-add-intersil-isl12022-rtc-driver.patch
rtc-isl12022-properly-handle-military-hour-format.patch
rtc-isl12022-properly-handle-military-hour-format-fix.patch

