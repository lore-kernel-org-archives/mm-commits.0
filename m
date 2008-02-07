From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:30 -0800
Message-ID: <200802070027.m170RBG0006997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761681AbYBGApO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin RTC driver: shave off another memcpy() by using assignment.
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin RTC driver: shave off another memcpy() by using assignment.
From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment
+++ a/drivers/rtc/rtc-bfin.c
@@ -325,7 +325,7 @@ static int bfin_rtc_read_alarm(struct de
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
-	memcpy(&alrm->time, &rtc->rtc_alarm, sizeof(struct rtc_time));
+	alrm->time = rtc->rtc_alarm;
 	alrm->enabled = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 	return 0;
 }
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

origin.patch
git-watchdog.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
