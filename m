From: akpm@linux-foundation.org
Subject: + fix-vsyscall-settimeofday.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:21:15 -0800
Message-ID: <200703060421.l264LFME011662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933935AbXCFEVo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:21:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     fix vsyscall settimeofday
has been added to the -mm tree.  Its filename is
     fix-vsyscall-settimeofday.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-vsyscall-settimeofday.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
