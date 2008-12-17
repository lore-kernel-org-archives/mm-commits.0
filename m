From: akpm@linux-foundation.org
Subject: + rtc-rtc-isl1208-reject-invalid-dates.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:47:42 -0800
Message-ID: <200812172247.mBHMlgFU022854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYLQWsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:48:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: celston@katalix.com, a.zummo@towertech.it, david-b@pacbell.net, hvr@gnu.org


The patch titled
     rtc: rtc-isl1208: reject invalid dates
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl1208-reject-invalid-dates.patch

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
Subject: rtc: rtc-isl1208: reject invalid dates
From: Chris Elston <celston@katalix.com>

This patch for the rtc-isl1208 driver makes it reject invalid dates.

Signed-off-by: Chris Elston <celston@katalix.com>
[a.zummo@towertech.it: added comment explaining the check]
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Hebert Valerio Riedel <hvr@gnu.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rtc/rtc-isl1208.c~rtc-rtc-isl1208-reject-invalid-dates drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-rtc-isl1208-reject-invalid-dates
+++ a/drivers/rtc/rtc-isl1208.c
@@ -328,6 +328,13 @@ isl1208_i2c_set_time(struct i2c_client *
 	int sr;
 	u8 regs[ISL1208_RTC_SECTION_LEN] = { 0, };
 
+	/* The clock has an 8 bit wide bcd-coded register (they never learn)
+	 * for the year. tm_year is an offset from 1900 and we are interested
+	 * in the 2000-2099 range, so any value less than 100 is invalid.
+	 */
+	if (tm->tm_year < 100)
+		return -EINVAL;
+
 	regs[ISL1208_REG_SC] = bin2bcd(tm->tm_sec);
 	regs[ISL1208_REG_MN] = bin2bcd(tm->tm_min);
 	regs[ISL1208_REG_HR] = bin2bcd(tm->tm_hour) | ISL1208_REG_HR_MIL;
_

Patches currently in -mm which might be from celston@katalix.com are

rtc-rtc-isl1208-reject-invalid-dates.patch

