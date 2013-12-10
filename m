From: akpm@linux-foundation.org
Subject: +
 softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:54:27 -0800
Message-ID: <52a7a9b3.zeTwMNiMxCClgeVf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LJXy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:54:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, fweisbec@gmail.com, joe@perches.com

Subject: + softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch added to -mm tree
To: joe@perches.com,fweisbec@gmail.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:54:27 -0800


The patch titled
     Subject: softirq: use const char * const for softirq_to_name, whitespace neatening
has been added to the -mm tree.  Its filename is
     softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 kernel/softirq.c          |   28 +++++++++-------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

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
@@ -128,7 +128,6 @@ void local_bh_disable(void)
 {
 	__local_bh_disable(_RET_IP_, SOFTIRQ_DISABLE_OFFSET);
 }
-
 EXPORT_SYMBOL(local_bh_disable);
 
 static void __local_bh_enable(unsigned int cnt)
@@ -150,7 +149,6 @@ void _local_bh_enable(void)
 	WARN_ON_ONCE(in_irq());
 	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
-
 EXPORT_SYMBOL(_local_bh_enable);
 
 static inline void _local_bh_enable_ip(unsigned long ip)
@@ -167,7 +165,7 @@ static inline void _local_bh_enable_ip(u
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
- 	 */
+	 */
 	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending())) {
@@ -289,8 +287,6 @@ restart:
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-
-
 asmlinkage void do_softirq(void)
 {
 	__u32 pending;
@@ -430,8 +426,7 @@ void open_softirq(int nr, void (*action)
 /*
  * Tasklets
  */
-struct tasklet_head
-{
+struct tasklet_head {
 	struct tasklet_struct *head;
 	struct tasklet_struct **tail;
 };
@@ -450,7 +445,6 @@ void __tasklet_schedule(struct tasklet_s
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__tasklet_schedule);
 
 void __tasklet_hi_schedule(struct tasklet_struct *t)
@@ -464,7 +458,6 @@ void __tasklet_hi_schedule(struct taskle
 	raise_softirq_irqoff(HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
 void __tasklet_hi_schedule_first(struct tasklet_struct *t)
@@ -475,7 +468,6 @@ void __tasklet_hi_schedule_first(struct
 	__this_cpu_write(tasklet_hi_vec.head, t);
 	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
-
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
 
 static void tasklet_action(struct softirq_action *a)
@@ -495,7 +487,8 @@ static void tasklet_action(struct softir
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
+							&t->state))
 					BUG();
 				t->func(t->data);
 				tasklet_unlock(t);
@@ -530,7 +523,8 @@ static void tasklet_hi_action(struct sof
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
-				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
+				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
+							&t->state))
 					BUG();
 				t->func(t->data);
 				tasklet_unlock(t);
@@ -548,7 +542,6 @@ static void tasklet_hi_action(struct sof
 	}
 }
 
-
 void tasklet_init(struct tasklet_struct *t,
 		  void (*func)(unsigned long), unsigned long data)
 {
@@ -558,7 +551,6 @@ void tasklet_init(struct tasklet_struct
 	t->func = func;
 	t->data = data;
 }
-
 EXPORT_SYMBOL(tasklet_init);
 
 void tasklet_kill(struct tasklet_struct *t)
@@ -574,7 +566,6 @@ void tasklet_kill(struct tasklet_struct
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
 }
-
 EXPORT_SYMBOL(tasklet_kill);
 
 /*
@@ -724,9 +715,8 @@ static void takeover_tasklets(unsigned i
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static int cpu_callback(struct notifier_block *nfb,
-				  unsigned long action,
-				  void *hcpu)
+static int cpu_callback(struct notifier_block *nfb, unsigned long action,
+			void *hcpu)
 {
 	switch (action) {
 #ifdef CONFIG_HOTPLUG_CPU
_

Patches currently in -mm which might be from joe@perches.com are

softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch

