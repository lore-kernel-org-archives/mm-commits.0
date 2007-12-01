From: akpm@linux-foundation.org
Subject: - more-timer-related-cleanups.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:57 -0800
Message-ID: <200712010023.lB10NvF0032023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343AbXLAA22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:28:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, johnstul@us.ibm.com, mingo@elte.hu, pavel@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: more timer related cleanups
has been removed from the -mm tree.  Its filename was
     more-timer-related-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: time: more timer related cleanups
From: Pavel Machek <pavel@ucw.cz>

I was confused by FSEC = 10^15 NSEC statement, plus small whitespace
fixes. When there's copyright, there should be GPL.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c       |    3 ++-
 arch/x86/kernel/process_64.c |    2 +-
 kernel/softirq.c             |    4 +++-
 kernel/time/tick-sched.c     |    2 +-
 kernel/time/timer_stats.c    |    2 +-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/hpet.c~more-timer-related-cleanups arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~more-timer-related-cleanups
+++ a/arch/x86/kernel/hpet.c
@@ -16,7 +16,8 @@
 #define HPET_MASK	CLOCKSOURCE_MASK(32)
 #define HPET_SHIFT	22
 
-/* FSEC = 10^-15 NSEC = 10^-9 */
+/* FSEC = 10^-15
+   NSEC = 10^-9 */
 #define FSEC_PER_NSEC	1000000
 
 /*
diff -puN arch/x86/kernel/process_64.c~more-timer-related-cleanups arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~more-timer-related-cleanups
+++ a/arch/x86/kernel/process_64.c
@@ -196,7 +196,7 @@ static inline void play_dead(void)
  * low exit latency (ie sit in a loop waiting for
  * somebody to say that they'd like to reschedule)
  */
-void cpu_idle (void)
+void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
diff -puN kernel/softirq.c~more-timer-related-cleanups kernel/softirq.c
--- a/kernel/softirq.c~more-timer-related-cleanups
+++ a/kernel/softirq.c
@@ -3,7 +3,9 @@
  *
  *	Copyright (C) 1992 Linus Torvalds
  *
- * Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
+ *	Distribute under GPLv2.
+ *
+ *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
  */
 
 #include <linux/module.h>
diff -puN kernel/time/tick-sched.c~more-timer-related-cleanups kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~more-timer-related-cleanups
+++ a/kernel/time/tick-sched.c
@@ -9,7 +9,7 @@
  *
  *  Started by: Thomas Gleixner and Ingo Molnar
  *
- *  For licencing details see kernel-base/COPYING
+ *  Distribute under GPLv2.
  */
 #include <linux/cpu.h>
 #include <linux/err.h>
diff -puN kernel/time/timer_stats.c~more-timer-related-cleanups kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~more-timer-related-cleanups
+++ a/kernel/time/timer_stats.c
@@ -26,7 +26,7 @@
  * the pid and cmdline from the owner process if applicable.
  *
  * Start/stop data collection:
- * # echo 1[0] >/proc/timer_stats
+ * # echo [1|0] >/proc/timer_stats
  *
  * Display the information collected so far:
  * # cat /proc/timer_stats
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-x86.patch
fix-proc-net-breakage.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
