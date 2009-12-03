From: akpm@linux-foundation.org
Subject: [merged] rtc-x1205-fix-rtc_time-to-y2k-register-value-conversion.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:36:04 -0800
Message-ID: <200912032036.nB3Ka4HR011456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbZLCUgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:36:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, a.zummo@towertech.it, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     rtc-x1205: fix rtc_time to y2k register value conversion
has been removed from the -mm tree.  Its filename was
     rtc-x1205-fix-rtc_time-to-y2k-register-value-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-x1205: fix rtc_time to y2k register value conversion
From: Johannes Weiner <jw@emlix.com>

The possible CCR_Y2K register values are 19 or 20 and struct rtc_time's
tm_year is in years since 1900.

The function translating rtc_time to register values assumes tm_year to be
years since first christmas, though, and we end up storing 0 or 1 in the
CCR_Y2K register, which the hardware does not refuse to do.

A subsequent probing of the clock fails due to the invalid value range in
the register, though.

[ And if it didn't, reading the clock would yield a bogus year because
  the function translating registers to tm_year is assuming a register
  value of 19 or 20. ]

This fixes the conversion from years since 1900 in tm_year to the
corresponding CCR_Y2K value of 19 or 20.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-x1205.c~rtc-x1205-fix-rtc_time-to-y2k-register-value-conversion drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-x1205-fix-rtc_time-to-y2k-register-value-conversion
+++ a/drivers/rtc/rtc-x1205.c
@@ -195,7 +195,7 @@ static int x1205_set_datetime(struct i2c
 		/* year, since the rtc epoch*/
 		buf[CCR_YEAR] = bin2bcd(tm->tm_year % 100);
 		buf[CCR_WDAY] = tm->tm_wday & 0x07;
-		buf[CCR_Y2K] = bin2bcd(tm->tm_year / 100);
+		buf[CCR_Y2K] = bin2bcd((tm->tm_year + 1900) / 100);
 	}
 
 	/* If writing alarm registers, set compare bits on registers 0-4 */
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-use-generic-sys_pipe.patch
rtc-x1205-unconditionally-set-date-when-setting-clock.patch

