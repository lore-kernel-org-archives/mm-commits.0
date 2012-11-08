From: akpm@linux-foundation.org
Subject: + percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:28:24 -0800
Message-ID: <20121108202824.ABB88100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37418 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2KHU20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:28:26 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so373004qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:28:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ananth@in.ibm.com, anton@redhat.com, axboe@kernel.dk, mingo@elte.hu, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org


The patch titled
     Subject: percpu_rw_semaphore: reimplement to not block the readers unnecessarily
has been added to the -mm tree.  Its filename is
     percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: percpu_rw_semaphore: reimplement to not block the readers unnecessarily

Currently the writer does msleep() plus synchronize_sched() 3 times to
acquire/release the semaphore, and during this time the readers are
blocked completely.  Even if the "write" section was not actually started
or if it was already finished.

With this patch down_write/up_write does synchronize_sched() twice and
down_read/up_read are still possible during this time, just they use the
slow path.

percpu_down_write() first forces the readers to use rw_semaphore and
increment the "slow" counter to take the lock for reading, then it
takes that rw_semaphore for writing and blocks the readers.

Also.  With this patch the code relies on the documented behaviour of
synchronize_sched(), it doesn't try to pair synchronize_sched() with
barrier.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-rwsem.h |   85 +++-------------------
 lib/Makefile                 |    2 
 lib/percpu-rwsem.c           |  123 +++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+), 72 deletions(-)

diff -puN include/linux/percpu-rwsem.h~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily include/linux/percpu-rwsem.h
--- a/include/linux/percpu-rwsem.h~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily
+++ a/include/linux/percpu-rwsem.h
@@ -2,82 +2,25 @@
 #define _LINUX_PERCPU_RWSEM_H
 
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/percpu.h>
-#include <linux/rcupdate.h>
-#include <linux/delay.h>
+#include <linux/wait.h>
 
 struct percpu_rw_semaphore {
-	unsigned __percpu *counters;
-	bool locked;
-	struct mutex mtx;
+	unsigned int __percpu	*fast_read_ctr;
+	struct mutex		writer_mutex;
+	struct rw_semaphore	rw_sem;
+	atomic_t		slow_read_ctr;
+	wait_queue_head_t	write_waitq;
 };
 
-#define light_mb()	barrier()
-#define heavy_mb()	synchronize_sched()
+extern void percpu_down_read(struct percpu_rw_semaphore *);
+extern void percpu_up_read(struct percpu_rw_semaphore *);
 
-static inline void percpu_down_read(struct percpu_rw_semaphore *p)
-{
-	rcu_read_lock_sched();
-	if (unlikely(p->locked)) {
-		rcu_read_unlock_sched();
-		mutex_lock(&p->mtx);
-		this_cpu_inc(*p->counters);
-		mutex_unlock(&p->mtx);
-		return;
-	}
-	this_cpu_inc(*p->counters);
-	rcu_read_unlock_sched();
-	light_mb(); /* A, between read of p->locked and read of data, paired with D */
-}
-
-static inline void percpu_up_read(struct percpu_rw_semaphore *p)
-{
-	light_mb(); /* B, between read of the data and write to p->counter, paired with C */
-	this_cpu_dec(*p->counters);
-}
-
-static inline unsigned __percpu_count(unsigned __percpu *counters)
-{
-	unsigned total = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		total += ACCESS_ONCE(*per_cpu_ptr(counters, cpu));
-
-	return total;
-}
-
-static inline void percpu_down_write(struct percpu_rw_semaphore *p)
-{
-	mutex_lock(&p->mtx);
-	p->locked = true;
-	synchronize_sched(); /* make sure that all readers exit the rcu_read_lock_sched region */
-	while (__percpu_count(p->counters))
-		msleep(1);
-	heavy_mb(); /* C, between read of p->counter and write to data, paired with B */
-}
-
-static inline void percpu_up_write(struct percpu_rw_semaphore *p)
-{
-	heavy_mb(); /* D, between write to data and write to p->locked, paired with A */
-	p->locked = false;
-	mutex_unlock(&p->mtx);
-}
-
-static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
-{
-	p->counters = alloc_percpu(unsigned);
-	if (unlikely(!p->counters))
-		return -ENOMEM;
-	p->locked = false;
-	mutex_init(&p->mtx);
-	return 0;
-}
-
-static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
-{
-	free_percpu(p->counters);
-	p->counters = NULL; /* catch use after free bugs */
-}
+extern void percpu_down_write(struct percpu_rw_semaphore *);
+extern void percpu_up_write(struct percpu_rw_semaphore *);
+
+extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
+extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 
 #endif
diff -puN lib/Makefile~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily lib/Makefile
--- a/lib/Makefile~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o earlycpio.o
+	 is_single_threaded.o plist.o decompress.o earlycpio.o percpu-rwsem.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/percpu-rwsem.c
--- /dev/null
+++ a/lib/percpu-rwsem.c
@@ -0,0 +1,123 @@
+#include <linux/percpu-rwsem.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+
+int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
+{
+	brw->fast_read_ctr = alloc_percpu(int);
+	if (unlikely(!brw->fast_read_ctr))
+		return -ENOMEM;
+
+	mutex_init(&brw->writer_mutex);
+	init_rwsem(&brw->rw_sem);
+	atomic_set(&brw->slow_read_ctr, 0);
+	init_waitqueue_head(&brw->write_waitq);
+	return 0;
+}
+
+void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
+{
+	free_percpu(brw->fast_read_ctr);
+	brw->fast_read_ctr = NULL; /* catch use after free bugs */
+}
+
+static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
+{
+	bool success = false;
+
+	preempt_disable();
+	if (likely(!mutex_is_locked(&brw->writer_mutex))) {
+		__this_cpu_add(*brw->fast_read_ctr, val);
+		success = true;
+	}
+	preempt_enable();
+
+	return success;
+}
+
+/*
+ * Like the normal down_read() this is not recursive, the writer can
+ * come after the first percpu_down_read() and create the deadlock.
+ */
+void percpu_down_read(struct percpu_rw_semaphore *brw)
+{
+	if (likely(update_fast_ctr(brw, +1)))
+		return;
+
+	down_read(&brw->rw_sem);
+	atomic_inc(&brw->slow_read_ctr);
+	up_read(&brw->rw_sem);
+}
+
+void percpu_up_read(struct percpu_rw_semaphore *brw)
+{
+	if (likely(update_fast_ctr(brw, -1)))
+		return;
+
+	/* false-positive is possible but harmless */
+	if (atomic_dec_and_test(&brw->slow_read_ctr))
+		wake_up_all(&brw->write_waitq);
+}
+
+static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
+{
+	unsigned int sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		sum += per_cpu(*brw->fast_read_ctr, cpu);
+		per_cpu(*brw->fast_read_ctr, cpu) = 0;
+	}
+
+	return sum;
+}
+
+/*
+ * A writer takes ->writer_mutex to exclude other writers and to force the
+ * readers to switch to the slow mode, note the mutex_is_locked() check in
+ * update_fast_ctr().
+ *
+ * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
+ * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
+ * counter it represents the number of active readers.
+ *
+ * Finally the writer takes ->rw_sem for writing and blocks the new readers,
+ * then waits until the slow counter becomes zero.
+ */
+void percpu_down_write(struct percpu_rw_semaphore *brw)
+{
+	/* also blocks update_fast_ctr() which checks mutex_is_locked() */
+	mutex_lock(&brw->writer_mutex);
+
+	/*
+	 * 1. Ensures mutex_is_locked() is visible to any down_read/up_read
+	 *    so that update_fast_ctr() can't succeed.
+	 *
+	 * 2. Ensures we see the result of every previous this_cpu_add() in
+	 *    update_fast_ctr().
+	 *
+	 * 3. Ensures that if any reader has exited its critical section via
+	 *    fast-path, it executes a full memory barrier before we return.
+	 */
+	synchronize_sched();
+
+	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
+	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
+
+	/* block the new readers completely */
+	down_write(&brw->rw_sem);
+
+	/* wait for all readers to complete their percpu_up_read() */
+	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
+}
+
+void percpu_up_write(struct percpu_rw_semaphore *brw)
+{
+	/* allow the new readers, but only the slow-path */
+	up_write(&brw->rw_sem);
+
+	/* insert the barrier before the next fast-path in down_read */
+	synchronize_sched();
+
+	mutex_unlock(&brw->writer_mutex);
+}
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch

