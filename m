From: akpm@linux-foundation.org
Subject: - timer-hrtimer-take-per-cpu-locks-in-sane-order.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:56:08 -0800
Message-ID: <200703052356.l25Nu84T005223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030AbXCEX5G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:57:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, cborntra@de.ibm.com, johnstul@us.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     timer/hrtimer: take per cpu locks in sane order
has been removed from the -mm tree.  Its filename was
     timer-hrtimer-take-per-cpu-locks-in-sane-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: timer/hrtimer: take per cpu locks in sane order
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Doing something like this on a two cpu system

# echo 0 > /sys/devices/system/cpu/cpu0/online
# echo 1 > /sys/devices/system/cpu/cpu0/online
# echo 0 > /sys/devices/system/cpu/cpu1/online

will give me this:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21-rc2-g562aa1d4-dirty #7
-------------------------------------------------------
bash/1282 is trying to acquire lock:
 (&cpu_base->lock_key){.+..}, at: [<000000000005f17e>] hrtimer_cpu_notify+0xc6/0x240

but task is already holding lock:
 (&cpu_base->lock_key#2){.+..}, at: [<000000000005f174>] hrtimer_cpu_notify+0xbc/0x240

which lock already depends on the new lock.

This happens because we have the following code in kernel/hrtimer.c:

migrate_hrtimers(int cpu)
[...]
old_base = &per_cpu(hrtimer_bases, cpu);
new_base = &get_cpu_var(hrtimer_bases);
[...]
spin_lock(&new_base->lock);
spin_lock(&old_base->lock);

Which means the spinlocks are taken in an order which depends on which cpu
gets shut down from which other cpu. Therefore lockdep complains that there
might be an ABBA deadlock. Since migrate_hrtimers() gets only called on
cpu hotplug it's safe to assume that it isn't executed concurrently on a

The same problem exists in kernel/timer.c: migrate_timers().

As pointed out by Christian Borntraeger one possible solution to avoid
the locking order complaints would be to make sure that the locks are
always taken in the same order. E.g. by taking the lock of the cpu with
the lower number first.

To achieve this we introduce two new spinlock functions double_spin_lock
and double_spin_unlock which lock or unlock two locks in a given order.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Christian Borntraeger <cborntra@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h |   37 +++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c         |    9 ++++-----
 kernel/timer.c           |    8 ++++----
 3 files changed, 45 insertions(+), 9 deletions(-)

diff -puN include/linux/spinlock.h~timer-hrtimer-take-per-cpu-locks-in-sane-order include/linux/spinlock.h
--- a/include/linux/spinlock.h~timer-hrtimer-take-per-cpu-locks-in-sane-order
+++ a/include/linux/spinlock.h
@@ -283,6 +283,43 @@ do {						\
 })
 
 /*
+ * Locks two spinlocks l1 and l2.
+ * l1_first indicates if spinlock l1 should be taken first.
+ */
+static inline void double_spin_lock(spinlock_t *l1, spinlock_t *l2,
+				    bool l1_first)
+	__acquires(l1)
+	__acquires(l2)
+{
+	if (l1_first) {
+		spin_lock(l1);
+		spin_lock(l2);
+	} else {
+		spin_lock(l2);
+		spin_lock(l1);
+	}
+}
+
+/*
+ * Unlocks two spinlocks l1 and l2.
+ * l1_taken_first indicates if spinlock l1 was taken first and therefore
+ * should be released after spinlock l2.
+ */
+static inline void double_spin_unlock(spinlock_t *l1, spinlock_t *l2,
+				      bool l1_taken_first)
+	__releases(l1)
+	__releases(l2)
+{
+	if (l1_taken_first) {
+		spin_unlock(l2);
+		spin_unlock(l1);
+	} else {
+		spin_unlock(l1);
+		spin_unlock(l2);
+	}
+}
+
+/*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */
diff -puN kernel/hrtimer.c~timer-hrtimer-take-per-cpu-locks-in-sane-order kernel/hrtimer.c
--- a/kernel/hrtimer.c~timer-hrtimer-take-per-cpu-locks-in-sane-order
+++ a/kernel/hrtimer.c
@@ -1355,17 +1355,16 @@ static void migrate_hrtimers(int cpu)
 	tick_cancel_sched_timer(cpu);
 
 	local_irq_disable();
-
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	double_spin_lock(&new_base->lock, &old_base->lock,
+			 smp_processor_id() < cpu);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
 
+	double_spin_unlock(&new_base->lock, &old_base->lock,
+			   smp_processor_id() < cpu);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
 }
diff -puN kernel/timer.c~timer-hrtimer-take-per-cpu-locks-in-sane-order kernel/timer.c
--- a/kernel/timer.c~timer-hrtimer-take-per-cpu-locks-in-sane-order
+++ a/kernel/timer.c
@@ -1651,8 +1651,8 @@ static void __devinit migrate_timers(int
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	spin_lock(&new_base->lock);
-	spin_lock(&old_base->lock);
+	double_spin_lock(&new_base->lock, &old_base->lock,
+			 smp_processor_id() < cpu);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1665,8 +1665,8 @@ static void __devinit migrate_timers(int
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
+	double_spin_unlock(&new_base->lock, &old_base->lock,
+			   smp_processor_id() < cpu);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
introduce-config_has_dma.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
