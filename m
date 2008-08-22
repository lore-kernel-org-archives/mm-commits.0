From: akpm@linux-foundation.org
Subject: - nohz-fix-wrong-event-handler-after-online-an-offlined-cpu.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:56:08 -0700
Message-ID: <200808222256.m7MMu8Ys020891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289AbYHVXEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 19:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     nohz: fix wrong event handler after online an offlined cpu
has been removed from the -mm tree.  Its filename was
     nohz-fix-wrong-event-handler-after-online-an-offlined-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nohz: fix wrong event handler after online an offlined cpu
From: Miao Xie <miaox@cn.fujitsu.com>

On the tickless system(CONFIG_NO_HZ=y and CONFIG_HIGH_RES_TIMERS=n), after
I made an offlined cpu online, I found this cpu's event handler was
tick_handle_periodic, not tick_nohz_handler.

After debuging, I found this bug was caused by the wrong tick mode.  the
tick mode is not changed to NOHZ_MODE_INACTIVE when the cpu is offline.

This patch fixes this bug.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h     |    5 ++++-
 kernel/time/tick-sched.c |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/tick.h~nohz-fix-wrong-event-handler-after-online-an-offlined-cpu include/linux/tick.h
--- a/include/linux/tick.h~nohz-fix-wrong-event-handler-after-online-an-offlined-cpu
+++ a/include/linux/tick.h
@@ -74,10 +74,13 @@ extern struct tick_device *tick_get_devi
 extern int tick_init_highres(void);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_setup_sched_timer(void);
+# endif
+
+# if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
 extern void tick_cancel_sched_timer(int cpu);
 # else
 static inline void tick_cancel_sched_timer(int cpu) { }
-# endif /* HIGHRES */
+# endif
 
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern struct tick_device *tick_get_broadcast_device(void);
diff -puN kernel/time/tick-sched.c~nohz-fix-wrong-event-handler-after-online-an-offlined-cpu kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~nohz-fix-wrong-event-handler-after-online-an-offlined-cpu
+++ a/kernel/time/tick-sched.c
@@ -659,17 +659,21 @@ void tick_setup_sched_timer(void)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
 #endif
 }
+#endif /* HIGH_RES_TIMERS */
 
+#if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
 void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
+# ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
+# endif
 
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
-#endif /* HIGH_RES_TIMERS */
+#endif
 
 /**
  * Async notification about clocksource changes
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch

