From: akpm@linux-foundation.org
Subject: - clocksource-remove-redundant-code.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:42 -0800
Message-ID: <200802082014.m18KENFc010414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbYBHVDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: remove redundant code
has been removed from the -mm tree.  Its filename was
     clocksource-remove-redundant-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: remove redundant code
From: Li Zefan <lizf@cn.fujitsu.com>

Flag CLOCK_SOURCE_WATCHDOG is cleared twice.  Note clocksource_change_rating()
won't do anyting with the cs flag.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/time/clocksource.c~clocksource-remove-redundant-code kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-remove-redundant-code
+++ a/kernel/time/clocksource.c
@@ -91,7 +91,6 @@ static void clocksource_ratewd(struct cl
 	       cs->name, delta);
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
 	clocksource_change_rating(cs, 0);
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
 	list_del(&cs->wd_list);
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
