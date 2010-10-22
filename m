From: akpm@linux-foundation.org
Subject: + percpu_counter-add-percpu_counter_add_fast.patch added to -mm tree
Date: Thu, 21 Oct 2010 17:14:48 -0700
Message-ID: <201010220014.o9M0EmiX013034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab0JVAPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 20:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, cl@linux-foundation.org, david@fromorbit.com, npiggin@kernel.dk


The patch titled
     percpu_counter: add percpu_counter_add_fast()
has been added to the -mm tree.  Its filename is
     percpu_counter-add-percpu_counter_add_fast.patch

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
Subject: percpu_counter: add percpu_counter_add_fast()
From: Eric Dumazet <eric.dumazet@gmail.com>

The current way to change a percpu_counter is to call
percpu_counter_add(), which is a bit expensive, mainly because of function
entry/exit overhead.

When we dont need to maintain the approximate value of the percpu_counter
(aka fbc->count), and dont need a "s64" wide counter but a regular "int"
or "long" one, we can use this new function : percpu_counter_add_fast()

This function is pretty fast :
- One instruction on x86 SMP, no register pressure.
- Is safe in preempt enabled contexts.
- No lock acquisition, less false sharing.

Users of this percpu_counter variant should not use percpu_counter_read()
or percpu_counter_read_positive() anymore, only
percpu_counter_sum{_positive}() variant.

We could add later irqsafe variant, still one instruction on x86 SMP...

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   36 +++++++++++++++++++++++++++----
 lib/percpu_counter.c           |   12 +++++-----
 2 files changed, 38 insertions(+), 10 deletions(-)

diff -puN include/linux/percpu_counter.h~percpu_counter-add-percpu_counter_add_fast include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counter-add-percpu_counter_add_fast
+++ a/include/linux/percpu_counter.h
@@ -3,7 +3,9 @@
 /*
  * A simple "approximate counter" for use in ext2 and ext3 superblocks.
  *
- * WARNING: these things are HUGE.  4 kbytes per counter on 32-way P4.
+ * WARNING: these things are big.  sizeof(long) bytes per possible cpu per counter.
+ * For a 64 cpus 64bit machine :
+ *	64*8 (512) bytes + sizeof(struct percpu_counter)
  */
 
 #include <linux/spinlock.h>
@@ -21,7 +23,7 @@ struct percpu_counter {
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
-	s32 __percpu *counters;
+	long __percpu *counters;
 };
 
 extern int percpu_counter_batch;
@@ -38,7 +40,7 @@ int __percpu_counter_init(struct percpu_
 
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
-void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
@@ -47,6 +49,24 @@ static inline void percpu_counter_add(st
 	__percpu_counter_add(fbc, amount, percpu_counter_batch);
 }
 
+/**
+ * percpu_counter_add_fast - fast variant of percpu_counter_add
+ * @fbc: pointer to percpu_counter
+ * @amount: value to add to counter
+ *
+ * Add amount to a percpu_counter object, without approximate (fbc->count)
+ * estimation / correction.
+ * Notes :
+ * - This fast version is limited to "long" counters, not "s64".
+ * - It is preempt safe, but not IRQ safe (on UP)
+ * - Use of percpu_counter_read{_positive}() is discouraged.
+ * - fbc->count accumulates the counters from offlined cpus.
+ */
+static inline void percpu_counter_add_fast(struct percpu_counter *fbc, long amount)
+{
+	this_cpu_add(*fbc->counters, amount);
+}
+
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
 {
 	s64 ret = __percpu_counter_sum(fbc);
@@ -118,7 +138,15 @@ percpu_counter_add(struct percpu_counter
 }
 
 static inline void
-__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+percpu_counter_add_fast(struct percpu_counter *fbc, long amount)
+{
+	preempt_disable();
+	fbc->count += amount;
+	preempt_enable();
+}
+
+static inline void
+__percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch)
 {
 	percpu_counter_add(fbc, amount);
 }
diff -puN lib/percpu_counter.c~percpu_counter-add-percpu_counter_add_fast lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counter-add-percpu_counter_add_fast
+++ a/lib/percpu_counter.c
@@ -61,7 +61,7 @@ void percpu_counter_set(struct percpu_co
 
 	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		long *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
@@ -69,10 +69,10 @@ void percpu_counter_set(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
-void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, long batch)
 {
 	s64 count;
-	s32 *pcount;
+	long *pcount;
 
 	preempt_disable();
 	pcount = this_cpu_ptr(fbc->counters);
@@ -101,7 +101,7 @@ s64 __percpu_counter_sum(struct percpu_c
 	spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		long *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
@@ -115,7 +115,7 @@ int __percpu_counter_init(struct percpu_
 	spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+	fbc->counters = alloc_percpu(long);
 	if (!fbc->counters)
 		return -ENOMEM;
 
@@ -172,7 +172,7 @@ static int __cpuinit percpu_counter_hotc
 	cpu = (unsigned long)hcpu;
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
-		s32 *pcount;
+		long *pcount;
 		unsigned long flags;
 
 		spin_lock_irqsave(&fbc->lock, flags);
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

ipmi-proper-spinlocks-initializations.patch
linux-next.patch
net-avoid-limits-overflow.patch
fs-allow-for-more-than-231-files.patch
percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch
percpu_counter-add-percpu_counter_add_fast.patch
signals-annotate-lock_task_sighand.patch

