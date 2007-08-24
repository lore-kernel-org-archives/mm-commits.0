From: akpm@linux-foundation.org
Subject: - posix-timers-fix-deletion-race.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:24 -0700
Message-ID: <200708242056.l7OKuORO014058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760205AbXHXVIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: fix deletion race
has been removed from the -mm tree.  Its filename was
     posix-timers-fix-deletion-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: posix-timers: fix deletion race
From: Thomas Gleixner <tglx@linutronix.de>

timer_delete does:
lock_timer();
timer->it_process = NULL;
unlock_timer();
release_posix_timer();

timer->it_process is checked in lock_timer() to prevent access to a
timer, which is on the way to be deleted, but the check happens after
idr_lock is dropped. This allows release_posix_timer() to delete the
timer before the lock code can check the timer:

CPU 0				CPU 1
lock_timer();
timer->it_process = NULL;
unlock_timer();
				lock_timer()
					spin_lock(idr_lock);
					timer = idr_find();
					spin_lock(timer->lock);
					spin_unlock(idr_lock);
release_posix_timer();
	spin_lock(idr_lock);
	idr_remove(timer);
	spin_unlock(idr_lock);
	free_timer(timer);
					if (timer->......)

Change the locking to prevent this.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-fix-deletion-race kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-fix-deletion-race
+++ a/kernel/posix-timers.c
@@ -605,13 +605,14 @@ static struct k_itimer * lock_timer(time
 	timr = (struct k_itimer *) idr_find(&posix_timers_id, (int) timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		spin_unlock(&idr_lock);
 
 		if ((timr->it_id != timer_id) || !(timr->it_process) ||
 				timr->it_process->tgid != current->tgid) {
-			unlock_timer(timr, *flags);
+			spin_unlock(&timr->it_lock);
+			spin_unlock_irqrestore(&idr_lock, *flags);
 			timr = NULL;
-		}
+		} else
+			spin_unlock(&idr_lock);
 	} else
 		spin_unlock_irqrestore(&idr_lock, *flags);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
git-acpi.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
