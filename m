From: akpm@linux-foundation.org
Subject: + rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch added to -mm tree
Date: Sun, 26 Oct 2008 22:11:05 -0700
Message-ID: <200810270511.m9R5B5tR028428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbYJ0FLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 01:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: fix handling of missing tm_year data when reading alarms
has been added to the -mm tree.  Its filename is
     rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch

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
Subject: rtc: fix handling of missing tm_year data when reading alarms
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

When fixing up invalid years rtc_read_alarm() was calling rtc_valid_tm()
as a boolean but rtc_valid_tm() returns zero on success or a negative
number if the time is not valid so the test was inverted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/interface.c~rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms
+++ a/drivers/rtc/interface.c
@@ -271,7 +271,7 @@ int rtc_read_alarm(struct rtc_device *rt
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (!rtc_valid_tm(&alarm->time));
+		} while (rtc_valid_tm(&alarm->time) != 0);
 		break;
 
 	default:
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

