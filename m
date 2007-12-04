From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:28:22 -0800
Message-ID: <200712042028.lB4KSMrF003501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbXLDU26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:28:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com


The patch titled
     Blackfin RTC driver: read_alarm() checks the enabled field, not the pending field.
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi-spi_bfin-dont-bypass-spi-framework.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
