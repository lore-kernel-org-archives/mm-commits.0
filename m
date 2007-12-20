From: akpm@linux-foundation.org
Subject: + clocksourcec-use-init_timer_deferrable-for-clocksource_watchdog.patch added to -mm tree
Date: Wed, 19 Dec 2007 16:21:41 -0800
Message-ID: <200712200021.lBK0LfSW026762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbXLTAXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Dec 2007 19:23:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource.c: use init_timer_deferrable for clocksource_watchdog
has been added to the -mm tree.  Its filename is
     clocksourcec-use-init_timer_deferrable-for-clocksource_watchdog.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clocksource.c: use init_timer_deferrable for clocksource_watchdog
From: Parag Warudkar <parag.warudkar@gmail.com>

clocksource_watchdog can use a deferrable timer - reduces wakeups from
idle per second.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/clocksource.c~clocksourcec-use-init_timer_deferrable-for-clocksource_watchdog kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksourcec-use-init_timer_deferrable-for-clocksource_watchdog
+++ a/kernel/time/clocksource.c
@@ -175,7 +175,7 @@ static void clocksource_check_watchdog(s
 			if (watchdog)
 				del_timer(&watchdog_timer);
 			watchdog = cs;
-			init_timer(&watchdog_timer);
+			init_timer_deferrable(&watchdog_timer);
 			watchdog_timer.function = clocksource_watchdog;
 
 			/* Reset watchdog cycles */
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

clocksourcec-use-init_timer_deferrable-for-clocksource_watchdog.patch
