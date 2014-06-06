From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:02:53 -0700
Message-ID: <53922c7d.xDta4UVgraFncG7g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaFFVCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:02:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, alnovak@suse.cz

Subject: [folded-merged] drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm-fix.patch removed from -mm tree
To: alnovak@suse.cz,a.zummo@towertech.it,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:02:52 -0700


The patch titled
     Subject: drivers/rtc/interface.c: fix for fix of alarm initialization
has been removed from the -mm tree.  Its filename was
     drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm-fix.patch

This patch was dropped because it was folded into drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch

------------------------------------------------------
From: Ales Novak <alnovak@suse.cz>
Subject: drivers/rtc/interface.c: fix for fix of alarm initialization

Seems the previous patch "fix infinite loop in initializing the alarm"
did break the infinite loop in alarm initialization, but not in the right
way. The loop indeed should walk through the not-leap years and stop on
the leap one.

This patch does apply on top of the previous one.

Signed-off-by: Ales Novak <alnovak@suse.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm-fix drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm-fix
+++ a/drivers/rtc/interface.c
@@ -292,8 +292,7 @@ int __rtc_read_alarm(struct rtc_device *
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (alarm->time.tm_mon == 1
-			&& is_leap_year(alarm->time.tm_year + 1900)
+		} while (!is_leap_year(alarm->time.tm_year + 1900)
 			&& rtc_valid_tm(&alarm->time) != 0);
 		break;
 
_

Patches currently in -mm which might be from alnovak@suse.cz are

drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm.patch
drivers-rtc-rtc-bfinc-do-not-abort-when-requesting-irq-fails.patch

