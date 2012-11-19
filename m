From: akpm@linux-foundation.org
Subject: + percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch added to -mm tree
Date: Mon, 19 Nov 2012 15:06:02 -0800
Message-ID: <20121119230603.095BA200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:43110 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2KSXGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 18:06:06 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so355210lag.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 15:06:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton@redhat.com, mingo@elte.hu, mmarek@suse.cz, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org


The patch titled
     Subject: percpu_rw_semaphore: kill ->writer_mutex, add ->write_ctr
has been added to the -mm tree.  Its filename is
     percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch

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
Subject: percpu_rw_semaphore: kill ->writer_mutex, add ->write_ctr

percpu_rw_semaphore->writer_mutex was only added to simplify the initial
rewrite, the only thing it protects is clear_fast_ctr() which otherwise
could be called by multiple writers.  ->rw_sem is enough to serialize the
writers.

Kill this mutex and add "atomic_t write_ctr" instead.  The writers
increment/decrement this counter, the readers check it is zero instead of
mutex_is_locked().

Move atomic_add(clear_fast_ctr(), slow_read_ctr) under down_write() to
avoid the race with other writers.  This is a bit sub-optimal, only the
first writer needs this and we do not need to exclude the readers at this
stage.  But this is simple, we do not want another internal lock until we
add more features.

And this speeds up the write-contended case.  Before this patch the racing
writers sleep in synchronize_sched() sequentially, with this patch
multiple synchronize_sched's can "overlap" with each other.  Note: we can
do more optimizations, this is only the first step.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-rwsem.h |    4 +--
 lib/percpu-rwsem.c           |   34 +++++++++++++++------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff -puN include/linux/percpu-rwsem.h~percpu_rw_semaphore-kill-writer_mutex-add-write_ctr include/linux/percpu-rwsem.h
--- a/include/linux/percpu-rwsem.h~percpu_rw_semaphore-kill-writer_mutex-add-write_ctr
+++ a/include/linux/percpu-rwsem.h
@@ -1,14 +1,14 @@
 #ifndef _LINUX_PERCPU_RWSEM_H
 #define _LINUX_PERCPU_RWSEM_H
 
-#include <linux/mutex.h>
+#include <linux/atomic.h>
 #include <linux/rwsem.h>
 #include <linux/percpu.h>
 #include <linux/wait.h>
 
 struct percpu_rw_semaphore {
 	unsigned int __percpu	*fast_read_ctr;
-	struct mutex		writer_mutex;
+	atomic_t		write_ctr;
 	struct rw_semaphore	rw_sem;
 	atomic_t		slow_read_ctr;
 	wait_queue_head_t	write_waitq;
diff -puN lib/percpu-rwsem.c~percpu_rw_semaphore-kill-writer_mutex-add-write_ctr lib/percpu-rwsem.c
--- a/lib/percpu-rwsem.c~percpu_rw_semaphore-kill-writer_mutex-add-write_ctr
+++ a/lib/percpu-rwsem.c
@@ -1,4 +1,4 @@
-#include <linux/mutex.h>
+#include <linux/atomic.h>
 #include <linux/rwsem.h>
 #include <linux/percpu.h>
 #include <linux/wait.h>
@@ -13,8 +13,8 @@ int percpu_init_rwsem(struct percpu_rw_s
 	if (unlikely(!brw->fast_read_ctr))
 		return -ENOMEM;
 
-	mutex_init(&brw->writer_mutex);
 	init_rwsem(&brw->rw_sem);
+	atomic_set(&brw->write_ctr, 0);
 	atomic_set(&brw->slow_read_ctr, 0);
 	init_waitqueue_head(&brw->write_waitq);
 	return 0;
@@ -28,7 +28,7 @@ void percpu_free_rwsem(struct percpu_rw_
 
 /*
  * This is the fast-path for down_read/up_read, it only needs to ensure
- * there is no pending writer (!mutex_is_locked() check) and inc/dec the
+ * there is no pending writer (atomic_read(write_ctr) == 0) and inc/dec the
  * fast per-cpu counter. The writer uses synchronize_sched() to serialize
  * with the preempt-disabled section below.
  *
@@ -44,7 +44,7 @@ void percpu_free_rwsem(struct percpu_rw_
  * If this helper fails the callers rely on the normal rw_semaphore and
  * atomic_dec_and_test(), so in this case we have the necessary barriers.
  *
- * But if it succeeds we do not have any barriers, mutex_is_locked() or
+ * But if it succeeds we do not have any barriers, atomic_read(write_ctr) or
  * __this_cpu_add() below can be reordered with any LOAD/STORE done by the
  * reader inside the critical section. See the comments in down_write and
  * up_write below.
@@ -54,7 +54,7 @@ static bool update_fast_ctr(struct percp
 	bool success = false;
 
 	preempt_disable();
-	if (likely(!mutex_is_locked(&brw->writer_mutex))) {
+	if (likely(!atomic_read(&brw->write_ctr))) {
 		__this_cpu_add(*brw->fast_read_ctr, val);
 		success = true;
 	}
@@ -101,9 +101,8 @@ static int clear_fast_ctr(struct percpu_
 }
 
 /*
- * A writer takes ->writer_mutex to exclude other writers and to force the
- * readers to switch to the slow mode, note the mutex_is_locked() check in
- * update_fast_ctr().
+ * A writer increments ->write_ctr to force the readers to switch to the
+ * slow mode, note the atomic_read() check in update_fast_ctr().
  *
  * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
  * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
@@ -114,11 +113,10 @@ static int clear_fast_ctr(struct percpu_
  */
 void percpu_down_write(struct percpu_rw_semaphore *brw)
 {
-	/* also blocks update_fast_ctr() which checks mutex_is_locked() */
-	mutex_lock(&brw->writer_mutex);
-
+	/* tell update_fast_ctr() there is a pending writer */
+	atomic_inc(&brw->write_ctr);
 	/*
-	 * 1. Ensures mutex_is_locked() is visible to any down_read/up_read
+	 * 1. Ensures that write_ctr != 0 is visible to any down_read/up_read
 	 *    so that update_fast_ctr() can't succeed.
 	 *
 	 * 2. Ensures we see the result of every previous this_cpu_add() in
@@ -130,25 +128,25 @@ void percpu_down_write(struct percpu_rw_
 	 */
 	synchronize_sched();
 
+	/* exclude other writers, and block the new readers completely */
+	down_write(&brw->rw_sem);
+
 	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
 	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
 
-	/* block the new readers completely */
-	down_write(&brw->rw_sem);
-
 	/* wait for all readers to complete their percpu_up_read() */
 	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
 }
 
 void percpu_up_write(struct percpu_rw_semaphore *brw)
 {
-	/* allow the new readers, but only the slow-path */
+	/* release the lock, but the readers can't use the fast-path */
 	up_write(&brw->rw_sem);
-
 	/*
 	 * Insert the barrier before the next fast-path in down_read,
 	 * see W_R case in the comment above update_fast_ctr().
 	 */
 	synchronize_sched();
-	mutex_unlock(&brw->writer_mutex);
+	/* the last writer unblocks update_fast_ctr() */
+	atomic_dec(&brw->write_ctr);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch
percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch
percpu_rw_semaphore-add-the-lockdep-annotations.patch
percpu_rw_semaphore-introduce-config_percpu_rwsem.patch
uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race.patch
ptrace-introduce-ptrace_o_exitkill.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

