From: akpm@linux-foundation.org
Subject: [merged] xtensa-fix-unnecessary-setting-of-xtime.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:39:03 -0400
Message-ID: <201004151840.o3FIefjB024445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab0DOSl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, chris@zankel.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     xtensa: fix unnecessary setting of xtime
has been removed from the -mm tree.  Its filename was
     xtensa-fix-unnecessary-setting-of-xtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: fix unnecessary setting of xtime
From: John Stultz <johnstul@us.ibm.com>

xtensa supports read_persisitent_clock(), so there is no reason for the
arch specific code to be setting xtime.  Setting xtime will be done by the
generic timekeeping code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/time.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/xtensa/kernel/time.c~xtensa-fix-unnecessary-setting-of-xtime arch/xtensa/kernel/time.c
--- a/arch/xtensa/kernel/time.c~xtensa-fix-unnecessary-setting-of-xtime
+++ a/arch/xtensa/kernel/time.c
@@ -60,11 +60,6 @@ static struct irqaction timer_irqaction 
 
 void __init time_init(void)
 {
-	/* FIXME: xtime&wall_to_monotonic are set in timekeeping_init. */
-	read_persistent_clock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
