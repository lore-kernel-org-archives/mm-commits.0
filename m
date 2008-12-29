From: akpm@linux-foundation.org
Subject: - rtc-rtc-isl1208-reject-invalid-dates.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:13 -0800
Message-ID: <200812291918.mBTJIDae030577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYL2TTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: celston@katalix.com, a.zummo@towertech.it, david-b@pacbell.net, hvr@gnu.org, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-isl1208: reject invalid dates
has been removed from the -mm tree.  Its filename was
     rtc-rtc-isl1208-reject-invalid-dates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


