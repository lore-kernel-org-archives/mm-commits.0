From: akpm@linux-foundation.org
Subject: - xtime_lock-vs-update_process_times.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:44 -0500
Message-ID: <200802150227.m1F2R34m015285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758686AbYBOC3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, bryan.wu@analog.com, dhowells@redhat.com, gerg@uclinux.org, ink@jurassic.park.msu.ru, lethal@linux-sh.org, mingo@elte.hu, rth@twiddle.net, tglx@linutronix.de


The patch titled
     xtime_lock vs update_process_times
has been removed from the -mm tree.  Its filename was
     xtime_lock-vs-update_process_times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtime_lock vs update_process_times
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Commit: d3d74453c34f8fd87674a8cf5b8a327c68f22e99
Subject: hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ fallback

Broke several archs.  I have confirmation that the Alpha bit results in a
booting kernel.  That leaves: blackfin, frv, sh and sparc untested.

The deadlock in question was found by Russell:

  IRQ handle
    -> timer_tick() - xtime seqlock held for write
      -> update_process_times()
        -> run_local_timers()
          -> hrtimer_run_queues()
            -> hrtimer_get_softirq_time() - tries to get a read lock

Now, Thomas assures me the fix is trivial, only do_timer() needs to be
done under the xtime_lock, and update_process_times() can savely be removed
from under it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Richard Henderson <rth@twiddle.net>
Tested-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/time.c     |   15 ++++++++-------
 arch/blackfin/kernel/time.c  |    8 +++++---
 arch/frv/kernel/time.c       |    6 ++++--
 arch/m68knommu/kernel/time.c |   12 +++++++-----
 arch/sparc/kernel/pcic.c     |    2 +-
 arch/sparc/kernel/time.c     |    7 +++----
 6 files changed, 28 insertions(+), 22 deletions(-)

diff -puN arch/alpha/kernel/time.c~xtime_lock-vs-update_process_times arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~xtime_lock-vs-update_process_times
+++ a/arch/alpha/kernel/time.c
@@ -119,13 +119,8 @@ irqreturn_t timer_interrupt(int irq, voi
 	state.partial_tick = delta & ((1UL << FIX_SHIFT) - 1); 
 	nticks = delta >> FIX_SHIFT;
 
-	while (nticks > 0) {
-		do_timer(1);
-#ifndef CONFIG_SMP
-		update_process_times(user_mode(get_irq_regs()));
-#endif
-		nticks--;
-	}
+	if (nticks)
+		do_timer(nticks);
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -141,6 +136,12 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 
 	write_sequnlock(&xtime_lock);
+
+#ifndef CONFIG_SMP
+	while (nticks--)
+		update_process_times(user_mode(get_irq_regs()));
+#endif
+
 	return IRQ_HANDLED;
 }
 
diff -puN arch/blackfin/kernel/time.c~xtime_lock-vs-update_process_times arch/blackfin/kernel/time.c
--- a/arch/blackfin/kernel/time.c~xtime_lock-vs-update_process_times
+++ a/arch/blackfin/kernel/time.c
@@ -137,9 +137,6 @@ irqreturn_t timer_interrupt(int irq, voi
 
 	do_timer(1);
 
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
 	profile_tick(CPU_PROFILING);
 
 	/*
@@ -161,6 +158,11 @@ irqreturn_t timer_interrupt(int irq, voi
 			last_rtc_update = xtime.tv_sec - 600;
 	}
 	write_sequnlock(&xtime_lock);
+
+#ifndef CONFIG_SMP
+	update_process_times(user_mode(get_irq_regs()));
+#endif
+
 	return IRQ_HANDLED;
 }
 
diff -puN arch/frv/kernel/time.c~xtime_lock-vs-update_process_times arch/frv/kernel/time.c
--- a/arch/frv/kernel/time.c~xtime_lock-vs-update_process_times
+++ a/arch/frv/kernel/time.c
@@ -63,6 +63,7 @@ static irqreturn_t timer_interrupt(int i
 	/* last time the cmos clock got updated */
 	static long last_rtc_update = 0;
 
+	profile_tick(CPU_PROFILING);
 	/*
 	 * Here we are in the timer irq handler. We just have irqs locally
 	 * disabled but we don't know if the timer_bh is running on the other
@@ -73,8 +74,6 @@ static irqreturn_t timer_interrupt(int i
 	write_seqlock(&xtime_lock);
 
 	do_timer(1);
-	update_process_times(user_mode(get_irq_regs()));
-	profile_tick(CPU_PROFILING);
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -99,6 +98,9 @@ static irqreturn_t timer_interrupt(int i
 #endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
+
+	update_process_times(user_mode(get_irq_regs()));
+
 	return IRQ_HANDLED;
 }
 
diff -puN arch/m68knommu/kernel/time.c~xtime_lock-vs-update_process_times arch/m68knommu/kernel/time.c
--- a/arch/m68knommu/kernel/time.c~xtime_lock-vs-update_process_times
+++ a/arch/m68knommu/kernel/time.c
@@ -42,14 +42,12 @@ irqreturn_t arch_timer_interrupt(int irq
 	/* last time the cmos clock got updated */
 	static long last_rtc_update=0;
 
+	if (current->pid)
+		profile_tick(CPU_PROFILING);
+
 	write_seqlock(&xtime_lock);
 
 	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-	if (current->pid)
-		profile_tick(CPU_PROFILING);
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -67,6 +65,10 @@ irqreturn_t arch_timer_interrupt(int irq
 	}
 
 	write_sequnlock(&xtime_lock);
+
+#ifndef CONFIG_SMP
+	update_process_times(user_mode(get_irq_regs()));
+#endif
 	return(IRQ_HANDLED);
 }
 
diff -puN arch/sparc/kernel/pcic.c~xtime_lock-vs-update_process_times arch/sparc/kernel/pcic.c
--- a/arch/sparc/kernel/pcic.c~xtime_lock-vs-update_process_times
+++ a/arch/sparc/kernel/pcic.c
@@ -713,10 +713,10 @@ static irqreturn_t pcic_timer_handler (i
 	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
 	do_timer(1);
+	write_sequnlock(&xtime_lock);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
-	write_sequnlock(&xtime_lock);
 	return IRQ_HANDLED;
 }
 
diff -puN arch/sparc/kernel/time.c~xtime_lock-vs-update_process_times arch/sparc/kernel/time.c
--- a/arch/sparc/kernel/time.c~xtime_lock-vs-update_process_times
+++ a/arch/sparc/kernel/time.c
@@ -128,10 +128,6 @@ irqreturn_t timer_interrupt(int irq, voi
 	clear_clock_irq();
 
 	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-
 
 	/* Determine when to update the Mostek clock. */
 	if (ntp_synced() &&
@@ -145,6 +141,9 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 	write_sequnlock(&xtime_lock);
 
+#ifndef CONFIG_SMP
+	update_process_times(user_mode(get_irq_regs()));
+#endif
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
softlockup-workaround.patch
git-sched.patch
git-sh.patch
proc-add-rlimit_rttime-to-proc-pid-limits.patch
taint-kernel-after-warn_oncondition.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
