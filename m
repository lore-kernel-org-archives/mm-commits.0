From: akpm@linux-foundation.org
Subject: + timekeeping-fix-mismerge.patch added to -mm tree
Date: Mon, 14 May 2007 11:58:54 -0700
Message-ID: <200705141858.l4EIwsDi023559@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708AbXENTBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, stable@kernel.org


The patch titled
     timekeeping fix mismerge
has been added to the -mm tree.  Its filename is
     timekeeping-fix-mismerge.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

timekeeping-fix-mismerge.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
clockevents-fix-resume-logic-updated-version.patch
