From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch
 added to -mm tree
Date: Wed, 09 Apr 2014 14:08:26 -0700
Message-ID: <5345b6ca.f49rTiAXzaxJr2R6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124AbaDIVI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 17:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, alnovak@suse.cz

Subject: + drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch added to -mm tree
To: alnovak@suse.cz,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 14:08:26 -0700


The patch titled
     Subject: drivers/rtc/interface.c: fix infinite loop in initializing the alarm
has been added to the -mm tree.  Its filename is
     drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ales Novak <alnovak@suse.cz>
Subject: drivers/rtc/interface.c: fix infinite loop in initializing the alarm

In __rtc_read_alarm(), if the alarm time retrieved by
rtc_read_alarm_internal() from the device contains invalid values (e.g. 
month=2,mday=31) and the year not set (=-1), the initialization will loop
infinitely because the year-fixing loop expects the time being invalid due
to leap year.

Fix reduces the loop to the leap years and adds final validity check.

Signed-off-by: Ales Novak <alnovak@suse.cz>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm
+++ a/drivers/rtc/interface.c
@@ -292,7 +292,9 @@ int __rtc_read_alarm(struct rtc_device *
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (rtc_valid_tm(&alarm->time) != 0);
+		} while (alarm->time.tm_mon == 1
+			&& is_leap_year(alarm->time.tm_year + 1900)
+			&& rtc_valid_tm(&alarm->time) != 0);
 		break;
 
 	default:
@@ -300,7 +302,16 @@ int __rtc_read_alarm(struct rtc_device *
 	}
 
 done:
-	return 0;
+	err = rtc_valid_tm(&alarm->time);
+
+	if (err) {
+		dev_warn(&rtc->dev, "invalid alarm value: %d-%d-%d %d:%d:%d\n",
+			alarm->time.tm_year + 1900, alarm->time.tm_mon + 1,
+			alarm->time.tm_mday, alarm->time.tm_hour, alarm->time.tm_min,
+			alarm->time.tm_sec);
+	}
+
+	return err;
 }
 
 int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
_

Patches currently in -mm which might be from alnovak@suse.cz are

origin.patch
drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch

