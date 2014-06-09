From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:28:12 -0700
Message-ID: <53960acc.0DvrYxE4zfUJhlX1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbaFIT2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbohac@suse.cz, a.zummo@towertech.it, alnovak@suse.cz

Subject: [merged] drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch removed from -mm tree
To: alnovak@suse.cz,a.zummo@towertech.it,jbohac@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:12 -0700


The patch titled
     Subject: drivers/rtc/interface.c: fix infinite loop in initializing the alarm
has been removed from the -mm tree.  Its filename was
     drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reported-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm
+++ a/drivers/rtc/interface.c
@@ -292,7 +292,8 @@ int __rtc_read_alarm(struct rtc_device *
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (rtc_valid_tm(&alarm->time) != 0);
+		} while (!is_leap_year(alarm->time.tm_year + 1900)
+			&& rtc_valid_tm(&alarm->time) != 0);
 		break;
 
 	default:
@@ -300,7 +301,16 @@ int __rtc_read_alarm(struct rtc_device *
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

