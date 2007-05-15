From: akpm@linux-foundation.org
Subject: - timekeeping-fix-mismerge.patch removed from -mm tree
Date: Tue, 15 May 2007 01:29:04 -0700
Message-ID: <200705150829.l4F8T4XL005108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657AbXEOI3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     timekeeping fix mismerge
has been removed from the -mm tree.  Its filename was
     timekeeping-fix-mismerge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: timekeeping fix mismerge
From: Thomas Gleixner <tglx@linutronix.de>

The time keeping code move to kernel/time/timekeeping.c broke the
clocksource resume logic patch.  Fix it up and move the
clocksource_resume() call to the appropriate place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    2 ++
 kernel/timer.c            |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time/timekeeping.c~timekeeping-fix-mismerge kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-fix-mismerge
+++ a/kernel/time/timekeeping.c
@@ -273,6 +273,8 @@ static int timekeeping_resume(struct sys
 	unsigned long flags;
 	unsigned long now = read_persistent_clock();
 
+	clocksource_resume();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
 
 	if (now && (now > timekeeping_suspend_time)) {
diff -puN kernel/timer.c~timekeeping-fix-mismerge kernel/timer.c
--- a/kernel/timer.c~timekeeping-fix-mismerge
+++ a/kernel/timer.c
@@ -1499,8 +1499,6 @@ unregister_time_interpolator(struct time
 		prev = &curr->next;
 	}
 
-	clocksource_resume();
-
 	write_seqlock_irqsave(&xtime_lock, flags);
 	if (ti == time_interpolator) {
 		/* we lost the best time-interpolator: */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
timekeeping-fix-mismerge.patch
clocksource-fix-lock-order-in-the-resume-path.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
clockevents-fix-resume-logic-updated-version.patch
