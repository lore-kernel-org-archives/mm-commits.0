From: akpm@linux-foundation.org
Subject: [merged] time-clean-up-warp_clock.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:37 -0400
Message-ID: <201004151840.o3FIeFCx024379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501Ab0DOSlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: clean up warp_clock()
has been removed from the -mm tree.  Its filename was
     time-clean-up-warp_clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: clean up warp_clock()
From: John Stultz <johnstul@us.ibm.com>

warp_clock() currently accesses timekeeping internal state directly, which
is unnecessary.  Convert it to use the proper timekeeping interfaces.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/time.c~time-clean-up-warp_clock kernel/time.c
--- a/kernel/time.c~time-clean-up-warp_clock
+++ a/kernel/time.c
@@ -132,12 +132,11 @@ SYSCALL_DEFINE2(gettimeofday, struct tim
  */
 static inline void warp_clock(void)
 {
-	write_seqlock_irq(&xtime_lock);
-	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
-	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
+	struct timespec delta, adjust;
+	delta.tv_sec = sys_tz.tz_minuteswest * 60;
+	delta.tv_nsec = 0;
+	adjust = timespec_add_safe(current_kernel_time(), delta);
+	do_settimeofday(&adjust);
 }
 
 /*
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch
time-remove-xtime_cache-take-2.patch
hangcheck-timer-fix-x86_32-bugs.patch
time-kill-off-config_generic_time.patch

