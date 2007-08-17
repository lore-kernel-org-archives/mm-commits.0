From: akpm@linux-foundation.org
Subject: + make-rcutorture-rng-use-temporal-entropy.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:53:11 -0700
Message-ID: <200708171853.l7HIrBMH024485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbXHQSxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     Make rcutorture RNG use temporal entropy
has been added to the -mm tree.  Its filename is
     make-rcutorture-rng-use-temporal-entropy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make rcutorture RNG use temporal entropy
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Repost of http://lkml.org/lkml/2007/8/10/472 made available by request.

The locking used by get_random_bytes() can conflict with the
preempt_disable() and synchronize_sched() form of RCU.  This patch changes
rcutorture's RNG to gather entropy from the new cpu_clock() interface
(relying on interrupts, preemption, daemons, and rcutorture's reader
thread's rock-bottom scheduling priority to provide useful entropy), and
also adds and EXPORT_SYMBOL_GPL() to make that interface available to GPLed
kernel modules such as rcutorture.

Passes several hours of rcutorture.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    8 ++------
 kernel/sched.c      |    2 ++
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/rcutorture.c~make-rcutorture-rng-use-temporal-entropy kernel/rcutorture.c
--- a/kernel/rcutorture.c~make-rcutorture-rng-use-temporal-entropy
+++ a/kernel/rcutorture.c
@@ -42,7 +42,6 @@
 #include <linux/notifier.h>
 #include <linux/freezer.h>
 #include <linux/cpu.h>
-#include <linux/random.h>
 #include <linux/delay.h>
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
@@ -166,16 +165,13 @@ struct rcu_random_state {
 
 /*
  * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from get_random_bytes().
+ * generator, with occasional help from cpu_clock().
  */
 static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
-	long refresh;
-
 	if (--rrsp->rrs_count < 0) {
-		get_random_bytes(&refresh, sizeof(refresh));
-		rrsp->rrs_state += refresh;
+		rrsp->rrs_state += (unsigned long)cpu_clock(smp_processor_id());
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
diff -puN kernel/sched.c~make-rcutorture-rng-use-temporal-entropy kernel/sched.c
--- a/kernel/sched.c~make-rcutorture-rng-use-temporal-entropy
+++ a/kernel/sched.c
@@ -399,6 +399,8 @@ unsigned long long cpu_clock(int cpu)
 	return now;
 }
 
+EXPORT_SYMBOL_GPL(cpu_clock);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /* Change a task's ->cfs_rq if it moves across CPUs */
 static inline void set_task_cfs_rq(struct task_struct *p)
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
clean-up-duplicate-includes-in-kernel.patch
make-rcutorture-rng-use-temporal-entropy.patch
make-access-to-tasks-nsproxy-lighter.patch
