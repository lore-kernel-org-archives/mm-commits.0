From: akpm@linux-foundation.org
Subject: [merged]
 softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:53 -0800
Message-ID: <52e80081.5saTI1EhoqGueAsg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaA1TJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, fweisbec@gmail.com, joe@perches.com

Subject: [merged] softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch removed from -mm tree
To: joe@perches.com,fweisbec@gmail.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:53 -0800


The patch titled
     Subject: softirq: use const char * const for softirq_to_name, whitespace neatening
has been removed from the -mm tree.  Its filename was
     softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: softirq: use const char * const for softirq_to_name, whitespace neatening

Reduce data size a little.
Reduce checkpatch noise.

$ size kernel/softirq.o*
   text	   data	    bss	    dec	    hex	filename
  11554	   6013	   4008	  21575	   5447	kernel/softirq.o.new
  11474	   6093	   4008	  21575	   5447	kernel/softirq.o.old

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    2 +-
 kernel/softirq.c          |   25 +++++++++----------------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff -puN include/linux/interrupt.h~softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening include/linux/interrupt.h
--- a/include/linux/interrupt.h~softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening
+++ a/include/linux/interrupt.h
@@ -360,7 +360,7 @@ enum
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.
  */
-extern char *softirq_to_name[NR_SOFTIRQS];
+extern const char * const softirq_to_name[NR_SOFTIRQS];
 
 /* softirq mask and active fields moved to irq_cpustat_t in
  * asm/hardirq.h to get better cache usage.  KAO
diff -puN kernel/softirq.c~softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening kernel/softirq.c
--- a/kernel/softirq.c~softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening
+++ a/kernel/softirq.c
@@ -56,7 +56,7 @@ static struct softirq_action softirq_vec
 
 DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
-char *softirq_to_name[NR_SOFTIRQS] = {
+const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
@@ -138,7 +138,6 @@ void _local_bh_enable(void)
 	WARN_ON_ONCE(in_irq());
 	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
-
 EXPORT_SYMBOL(_local_bh_enable);
 
 void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
@@ -155,7 +154,7 @@ void __local_bh_enable_ip(unsigned long
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
- 	 */
+	 */
 	preempt_count_sub(cnt - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending())) {
@@ -436,8 +435,7 @@ void open_softirq(int nr, void (*action)
 /*
  * Tasklets
  */
-struct tasklet_head
-{
+struct tasklet_head {
 	struct tasklet_struct *head;
 	struct tasklet_struct **tail;
 };
@@ -456,7 +454,6 @@ void __tasklet_schedule(struct tasklet_s
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__tasklet_schedule);
 
 void __tasklet_hi_schedule(struct tasklet_struct *t)
@@ -470,7 +467,6 @@ void __tasklet_hi_schedule(struct taskle
 	raise_softirq_irqoff(HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
 void __tasklet_hi_schedule_first(struct tasklet_struct *t)
@@ -481,7 +477,6 @@ void __tasklet_hi_schedule_first(struct
 	__this_cpu_write(tasklet_hi_vec.head, t);
 	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
-
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
 
 static void tasklet_action(struct softirq_action *a)
@@ -501,7 +496,8 @@ static void tasklet_action(struct softir
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
+							&t->state))
 					BUG();
 				t->func(t->data);
 				tasklet_unlock(t);
@@ -536,7 +532,8 @@ static void tasklet_hi_action(struct sof
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
+							&t->state))
 					BUG();
 				t->func(t->data);
 				tasklet_unlock(t);
@@ -554,7 +551,6 @@ static void tasklet_hi_action(struct sof
 	}
 }
 
-
 void tasklet_init(struct tasklet_struct *t,
 		  void (*func)(unsigned long), unsigned long data)
 {
@@ -564,7 +560,6 @@ void tasklet_init(struct tasklet_struct
 	t->func = func;
 	t->data = data;
 }
-
 EXPORT_SYMBOL(tasklet_init);
 
 void tasklet_kill(struct tasklet_struct *t)
@@ -580,7 +575,6 @@ void tasklet_kill(struct tasklet_struct
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
 }
