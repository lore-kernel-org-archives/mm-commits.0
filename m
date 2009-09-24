From: akpm@linux-foundation.org
Subject: + hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch added to -mm tree
Date: Thu, 24 Sep 2009 16:04:20 -0700
Message-ID: <200909242304.n8ON4KoE026619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbZIXXEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 19:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: feng.tang@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers: remove the "timer_stats_active" check when setting the start info
has been added to the -mm tree.  Its filename is
     hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch

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
@@ -752,7 +752,7 @@ static inline void hrtimer_init_timer_hr
 #ifdef CONFIG_TIMER_STATS
 void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
 {
-	if (timer->start_site)
+	if (timer->start_site == addr && timer->start_pid == current->pid)
 		return;
 
 	timer->start_site = addr;
_

Patches currently in -mm which might be from feng.tang@intel.com are

origin.patch
hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch

