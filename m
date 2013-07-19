From: akpm@linux-foundation.org
Subject: [merged]
 lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
 removed from -mm tree
Date: Fri, 19 Jul 2013 12:11:28 -0700
Message-ID: <51e98f60.eSJS30SrlRqffZUJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GSTL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au, rostedt@goodmis.org, peterz@infradead.org, paulmck@us.ibm.com, oleg@redhat.com, mingo@redhat.com, laijs@cn.fujitsu.com, ak@linux.intel.com, walken@google.com

Subject: [merged] lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch removed from -mm tree
To: walken@google.com,ak@linux.intel.com,laijs@cn.fujitsu.com,mingo@redhat.com,oleg@redhat.com,paulmck@us.ibm.com,peterz@infradead.org,rostedt@goodmis.org,rusty@rustcorp.com.au,srivatsa.bhat@linux.vnet.ibm.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:11:28 -0700


The patch titled
     Subject: lglock: update lockdep annotations to report recursive local locks
has been removed from the -mm tree.  Its filename was
     lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: lglock: update lockdep annotations to report recursive local locks

Oleg Nesterov recently noticed that the lockdep annotations in lglock.c
are not sufficient to detect some obvious deadlocks, such as
lg_local_lock(LOCK) + lg_local_lock(LOCK) or spin_lock(X) +
lg_local_lock(Y) vs lg_local_lock(Y) + spin_lock(X).

Both issues are easily fixed by indicating to lockdep that lglock's local
locks are not recursive.  We shouldn't use the rwlock acquire/release
functions here, as lglock doesn't share the same semantics.  Instead we
can base our lockdep annotations on the lock_acquire_shared (for local
lglock) and lock_acquire_exclusive (for global lglock) helpers.

I am not proposing new lglock specific helpers as I don't see the point of
the existing second level of helpers :)

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lglock.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/lglock.c~lglock-update-lockdep-annotations-to-report-recursive-local-locks kernel/lglock.c
--- a/kernel/lglock.c~lglock-update-lockdep-annotations-to-report-recursive-local-locks
+++ a/kernel/lglock.c
@@ -21,7 +21,7 @@ void lg_local_lock(struct lglock *lg)
 	arch_spinlock_t *lock;
 
 	preempt_disable();
-	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	lock = this_cpu_ptr(lg->lock);
 	arch_spin_lock(lock);
 }
@@ -31,7 +31,7 @@ void lg_local_unlock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	lock = this_cpu_ptr(lg->lock);
 	arch_spin_unlock(lock);
 	preempt_enable();
@@ -43,7 +43,7 @@ void lg_local_lock_cpu(struct lglock *lg
 	arch_spinlock_t *lock;
 
 	preempt_disable();
-	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	lock = per_cpu_ptr(lg->lock, cpu);
 	arch_spin_lock(lock);
 }
@@ -53,7 +53,7 @@ void lg_local_unlock_cpu(struct lglock *
 {
 	arch_spinlock_t *lock;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	lock = per_cpu_ptr(lg->lock, cpu);
 	arch_spin_unlock(lock);
 	preempt_enable();
@@ -65,7 +65,7 @@ void lg_global_lock(struct lglock *lg)
 	int i;
 
 	preempt_disable();
-	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_exclusive(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	for_each_possible_cpu(i) {
 		arch_spinlock_t *lock;
 		lock = per_cpu_ptr(lg->lock, i);
@@ -78,7 +78,7 @@ void lg_global_unlock(struct lglock *lg)
 {
 	int i;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	for_each_possible_cpu(i) {
 		arch_spinlock_t *lock;
 		lock = per_cpu_ptr(lg->lock, i);
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mutex-subsystem-synchro-test-module.patch

