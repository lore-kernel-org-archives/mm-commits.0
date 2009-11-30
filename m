From: akpm@linux-foundation.org
Subject: [merged] hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:26 -0800
Message-ID: <200911302033.nAUKXQVW021013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZK3Udt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: feng.tang@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimers: remove the "timer_stats_active" check when setting the start info
has been removed from the -mm tree.  Its filename was
     hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimers: remove the "timer_stats_active" check when setting the start info
From: Feng Tang <feng.tang@intel.com>

Recent hrtimer code will set the start info to a hrtimer only when that
flag is set, then the start info of all hrtimers will always be
uninitialised before a "echo 1 > /proc/timer_stats", thus the
/proc/timer_lists will have something like:

active timers:
 #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
 # expires at 91062000000-91062000000 nsecs [in 156071 to 156071 nsecs]
 #1: <efb81b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91062300331-91062350331 nsecs [in 456402 to 506402 nsecs]
 #2: <efac9b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91068699811-91068749811 nsecs [in 6855882 to 6905882 nsecs]
 #3: <efacdb6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91068755511-91068805511 nsecs [in 6911582 to 6961582 nsecs]
 #4: <efa95b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91068806066-91068856066 nsecs [in 6962137 to 7012137 nsecs]
 .....

This patch fixes it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    2 --
 kernel/hrtimer.c        |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info
+++ a/include/linux/hrtimer.h
@@ -457,8 +457,6 @@ extern void __timer_stats_hrtimer_set_st
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
-	if (likely(!timer_stats_active))
-		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 
diff -puN kernel/hrtimer.c~hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info
+++ a/kernel/hrtimer.c
@@ -750,7 +750,7 @@ static inline void hrtimer_init_timer_hr
 #ifdef CONFIG_TIMER_STATS
 void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
 {
-	if (timer->start_site)
+	if (timer->start_site == addr && timer->start_pid == current->pid)
 		return;
 
 	timer->start_site = addr;
_

Patches currently in -mm which might be from feng.tang@intel.com are

linux-next.patch
spi-controller-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch

