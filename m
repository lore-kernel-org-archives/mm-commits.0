From: akpm@linux-foundation.org
Subject: + time-clean-up-warp_clock.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:51:50 -0800
Message-ID: <201003042151.o24LpoiQ032043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab0CDVwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: clean up warp_clock()
has been added to the -mm tree.  Its filename is
     time-clean-up-warp_clock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -133,12 +133,11 @@ SYSCALL_DEFINE2(gettimeofday, struct tim
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

origin.patch
linux-next.patch
arm-convert-arm-to-arch_gettimeoffset.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
time-clean-up-warp_clock.patch
time-cleanup-direct-xtime-usage-in-xen.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
cris-convert-to-use-arch_gettimeoffset.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
time-kill-off-config_generic_time.patch
xtensa-fix-unnecessary-setting-of-xtime.patch

