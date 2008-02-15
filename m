From: akpm@linux-foundation.org
Subject: + hrtimers-simplify-lockdep-stuff.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:56:52 -0800
Message-ID: <200802152056.m1FKuqAh023427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763532AbYBOU5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:57:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, arjan@linux.intel.com, heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers: simplify lockdep stuff
has been added to the -mm tree.  Its filename is
     hrtimers-simplify-lockdep-stuff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimers: simplify lockdep stuff
From: Oleg Nesterov <oleg@tv-sign.ru>

In order to avoid the false positive from lockdep, each per-cpu base->lock has
the separate lock class and migrate_hrtimers() uses double_spin_lock().

This is overcomplicated: except for migrate_hrtimers() we never take 2 locks
at once, and migrate_hrtimers() can use spin_lock_nested().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    2 --
 kernel/hrtimer.c        |    9 ++++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimers-simplify-lockdep-stuff include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-simplify-lockdep-stuff
+++ a/include/linux/hrtimer.h
@@ -173,7 +173,6 @@ struct hrtimer_clock_base {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
- * @lock_key:		the lock_class_key for use with lockdep
  * @clock_base:		array of clock bases for this cpu
  * @curr_timer:		the timer which is executing a callback right now
  * @expires_next:	absolute time of the next event which was scheduled
@@ -189,7 +188,6 @@ struct hrtimer_clock_base {
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
-	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 	struct list_head		cb_pending;
 #ifdef CONFIG_HIGH_RES_TIMERS
diff -puN kernel/hrtimer.c~hrtimers-simplify-lockdep-stuff kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-simplify-lockdep-stuff
+++ a/kernel/hrtimer.c
@@ -1420,7 +1420,6 @@ static void __cpuinit init_hrtimers_cpu(
 	int i;
 
 	spin_lock_init(&cpu_base->lock);
-	lockdep_set_class(&cpu_base->lock, &cpu_base->lock_key);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
@@ -1461,16 +1460,16 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
 
-	double_spin_unlock(&new_base->lock, &old_base->lock,
-			   smp_processor_id() < cpu);
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
