From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:28 -0800
Message-ID: <200802070027.m170R9co006994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760154AbYBGApZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin RTC driver: read_alarm() checks the enabled field, not the pending field.
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin RTC driver: read_alarm() checks the enabled field, not the pending field.
From: Mike Frysinger <michael.frysinger@analog.com>

also, dont bother using memcpy since we can just do an assignment of the same structure.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field
+++ a/drivers/rtc/rtc-bfin.c
@@ -326,7 +326,7 @@ static int bfin_rtc_read_alarm(struct de
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
 	memcpy(&alrm->time, &rtc->rtc_alarm, sizeof(struct rtc_time));
-	alrm->pending = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+	alrm->enabled = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 	return 0;
 }
 
@@ -334,7 +334,7 @@ static int bfin_rtc_set_alarm(struct dev
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
-	memcpy(&rtc->rtc_alarm, &alrm->time, sizeof(struct rtc_time));
+	rtc->rtc_alarm = alrm->time;
 	return 0;
 }
 
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

origin.patch
git-watchdog.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
