From: akpm@linux-foundation.org
Subject: + lockdep-map_acquire.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:35:15 -0700
Message-ID: <200808042135.m74LZFa1032210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764361AbYHDVfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lockdep: map_acquire
has been added to the -mm tree.  Its filename is
     lockdep-map_acquire.patch

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
Subject: lockdep: map_acquire
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Most the free-standing lock_acquire() usages look remarkably similar, sweep
them into a new helper.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c    |    4 ++--
 fs/jbd2/transaction.c   |    4 ++--
 include/linux/lockdep.h |   12 ++++++++++++
 kernel/workqueue.c      |   24 ++++++++++++------------
 4 files changed, 28 insertions(+), 16 deletions(-)

diff -puN fs/jbd/transaction.c~lockdep-map_acquire fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~lockdep-map_acquire
+++ a/fs/jbd/transaction.c
@@ -291,7 +291,7 @@ handle_t *journal_start(journal_t *journ
 		goto out;
 	}
 
-	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	map_acquire(&handle->h_lockdep_map);
 
 out:
 	return handle;
@@ -1448,7 +1448,7 @@ int journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+	map_release(&handle->h_lockdep_map);
 
 	jbd_free_handle(handle);
 	return err;
diff -puN fs/jbd2/transaction.c~lockdep-map_acquire fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~lockdep-map_acquire
+++ a/fs/jbd2/transaction.c
@@ -301,7 +301,7 @@ handle_t *jbd2_journal_start(journal_t *
 		goto out;
 	}
 
-	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	map_acquire(&handle->h_lockdep_map);
 out:
 	return handle;
 }
@@ -1279,7 +1279,7 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+	map_release(&handle->h_lockdep_map);
 
 	jbd2_free_handle(handle);
 	return err;
diff -puN include/linux/lockdep.h~lockdep-map_acquire include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-map_acquire
+++ a/include/linux/lockdep.h
@@ -459,4 +459,16 @@ static inline void print_irqtrace_events
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, _THIS_IP_)
+# else
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, _THIS_IP_)
+# endif
+# define map_release(l)			lock_release(l, 1, _THIS_IP_)
+#else
+# define map_acquire(l)			do { } while (0)
+# define map_release(l)			do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff -puN kernel/workqueue.c~lockdep-map_acquire kernel/workqueue.c
--- a/kernel/workqueue.c~lockdep-map_acquire
+++ a/kernel/workqueue.c
@@ -290,11 +290,11 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
-		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		map_acquire(&cwq->wq->lockdep_map);
+		map_acquire(&lockdep_map);
 		f(work);
-		lock_release(&lockdep_map, 1, _THIS_IP_);
-		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+		map_release(&lockdep_map);
+		map_release(&cwq->wq->lockdep_map);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -413,8 +413,8 @@ void flush_workqueue(struct workqueue_st
 	int cpu;
 
 	might_sleep();
-	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&wq->lockdep_map);
+	map_release(&wq->lockdep_map);
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -441,8 +441,8 @@ int flush_work(struct work_struct *work)
 	if (!cwq)
 		return 0;
 
-	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&cwq->wq->lockdep_map);
+	map_release(&cwq->wq->lockdep_map);
 
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
@@ -536,8 +536,8 @@ static void wait_on_work(struct work_str
 
 	might_sleep();
 
-	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&work->lockdep_map);
+	map_release(&work->lockdep_map);
 
 	cwq = get_wq_data(work);
 	if (!cwq)
@@ -872,8 +872,8 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
-	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&cwq->wq->lockdep_map);
+	map_release(&cwq->wq->lockdep_map);
 
 	flush_cpu_workqueue(cwq);
 	/*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
sched-type-fix.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
lockdep-shrink-held_lock-structure.patch
lockdep-map_acquire.patch
lockdep-lock-protection-locks.patch
lockdep-spin_lock_nest_lock.patch

