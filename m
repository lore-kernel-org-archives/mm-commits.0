From: akpm@linux-foundation.org
Subject: - fix-vsyscall-settimeofday.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:23 -0800
Message-ID: <200703070421.l274LNGD018897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161318AbXCGEVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     fix vsyscall settimeofday
has been removed from the -mm tree.  Its filename was
     fix-vsyscall-settimeofday.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix vsyscall settimeofday
From: Daniel Walker <dwalker@mvista.com>

I've only seen this on x86_64.

The vsyscall state only gets updated when a timer interrupts comes in.  So
if the time is set long before the next timer, there will be a period when
a gettimeofday() won't reflect the correct time.

I added an explicit update_vsyscall() during the settimeofday(), that way
the vsyscall state doesn't get stale.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/timer.c~fix-vsyscall-settimeofday kernel/timer.c
--- a/kernel/timer.c~fix-vsyscall-settimeofday
+++ a/kernel/timer.c
@@ -862,6 +862,8 @@ int do_settimeofday(struct timespec *tv)
 	clock->error = 0;
 	ntp_clear();
 
+	update_vsyscall(&xtime, clock);
+
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
