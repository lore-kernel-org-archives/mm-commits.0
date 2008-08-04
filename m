From: akpm@linux-foundation.org
Subject: + lockdep-re-annotate-scheduler-runqueues.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:35:06 -0700
Message-ID: <200808042135.m74LZ7Dm032201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759085AbYHDVfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lockdep: re-annotate scheduler runqueues
has been added to the -mm tree.  Its filename is
     lockdep-re-annotate-scheduler-runqueues.patch

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
Subject: lockdep: re-annotate scheduler runqueues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Instead of using a per-rq lock class, use the regular nesting operations.

However, take extra care with double_lock_balance() as it can release the
already held rq->lock (and therefore change its nesting class).

So what can happen is:

 spin_lock(rq->lock);	// this rq subclass 0

 double_lock_balance(rq, other_rq);
   // release rq
   // acquire other_rq->lock subclass 0
   // acquire rq->lock subclass 1

 spin_unlock(other_rq->lock);

leaving you with rq->lock in subclass 1

So a subsequent double_lock_balance() call can try to nest a subclass 1
lock while already holding a subclass 1 lock.

Fix this by introducing double_unlock_balance() which releases the other
rq's lock, but also re-sets the subclass for this rq's lock to 0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c    |   21 +++++++++++++--------
 kernel/sched_rt.c |    8 +++++---
 2 files changed, 18 insertions(+), 11 deletions(-)

diff -puN kernel/sched.c~lockdep-re-annotate-scheduler-runqueues kernel/sched.c
--- a/kernel/sched.c~lockdep-re-annotate-scheduler-runqueues
+++ a/kernel/sched.c
@@ -600,7 +600,6 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
-	struct lock_class_key rq_lock_key;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2756,10 +2755,10 @@ static void double_rq_lock(struct rq *rq
 	} else {
 		if (rq1 < rq2) {
 			spin_lock(&rq1->lock);
-			spin_lock(&rq2->lock);
+			spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
 		} else {
 			spin_lock(&rq2->lock);
-			spin_lock(&rq1->lock);
+			spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 	update_rq_clock(rq1);
@@ -2802,14 +2801,21 @@ static int double_lock_balance(struct rq
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
 			spin_lock(&busiest->lock);
-			spin_lock(&this_rq->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			spin_lock(&busiest->lock);
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
 	}
 	return ret;
 }
 
+static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
+
 /*
  * If dest_cpu is allowed for this process, migrate the task to it.
  * This is accomplished by forcing the cpu_allowed mask to only
@@ -3634,7 +3640,7 @@ redo:
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 					imbalance, sd, CPU_NEWLY_IDLE,
 					&all_pinned);
-		spin_unlock(&busiest->lock);
+		double_unlock_balance(this_rq, busiest);
 
 		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), *cpus);
@@ -3749,7 +3755,7 @@ static void active_load_balance(struct r
 		else
 			schedstat_inc(sd, alb_failed);
 	}
-	spin_unlock(&target_rq->lock);
+	double_unlock_balance(busiest_rq, target_rq);
 }
 
 #ifdef CONFIG_NO_HZ
@@ -7987,7 +7993,6 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
-		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
diff -puN kernel/sched_rt.c~lockdep-re-annotate-scheduler-runqueues kernel/sched_rt.c
--- a/kernel/sched_rt.c~lockdep-re-annotate-scheduler-runqueues
+++ a/kernel/sched_rt.c
@@ -861,6 +861,8 @@ static void put_prev_task_rt(struct rq *
 #define RT_MAX_TRIES 3
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
+static void double_unlock_balance(struct rq *this_rq, struct rq *busiest);
+
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
@@ -1022,7 +1024,7 @@ static struct rq *find_lock_lowest_rq(st
 			break;
 
 		/* try again */
-		spin_unlock(&lowest_rq->lock);
+		double_unlock_balance(rq, lowest_rq);
 		lowest_rq = NULL;
 	}
 
@@ -1091,7 +1093,7 @@ static int push_rt_task(struct rq *rq)
 
 	resched_task(lowest_rq->curr);
 
-	spin_unlock(&lowest_rq->lock);
+	double_unlock_balance(rq, lowest_rq);
 
 	ret = 1;
 out:
@@ -1197,7 +1199,7 @@ static int pull_rt_task(struct rq *this_
 
 		}
  skip:
-		spin_unlock(&src_rq->lock);
+		double_unlock_balance(this_rq, src_rq);
 	}
 
 	return ret;
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

