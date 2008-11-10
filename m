From: akpm@linux-foundation.org
Subject: - rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:31:53 -0800
Message-ID: <200811102031.mAAKVrSP023639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021AbYKJUck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: fix handling of missing tm_year data when reading alarms
has been removed from the -mm tree.  Its filename was
     rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix handling of missing tm_year data when reading alarms
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

When fixing up invalid years rtc_read_alarm() was calling rtc_valid_tm()
as a boolean but rtc_valid_tm() returns zero on success or a negative
number if the time is not valid so the test was inverted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
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
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

