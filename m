From: akpm@linux-foundation.org
Subject: [merged]
 lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch removed from -mm tree
Date: Fri, 19 Jul 2013 12:11:26 -0700
Message-ID: <51e98f5e.UyNUuZbNaqgm7hZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GSTL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au, rostedt@goodmis.org, peterz@infradead.org, paulmck@us.ibm.com, oleg@redhat.com, mingo@redhat.com, laijs@cn.fujitsu.com, ak@linux.intel.com, walken@google.com

Subject: [merged] lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch removed from -mm tree
To: walken@google.com,ak@linux.intel.com,laijs@cn.fujitsu.com,mingo@redhat.com,oleg@redhat.com,paulmck@us.ibm.com,peterz@infradead.org,rostedt@goodmis.org,rusty@rustcorp.com.au,srivatsa.bhat@linux.vnet.ibm.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:11:26 -0700


The patch titled
     Subject: lockdep: introduce lock_acquire_exclusive/shared helper macros
has been removed from the -mm tree.  Its filename was
     lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: lockdep: introduce lock_acquire_exclusive/shared helper macros

In lockdep.h, the spinlock/mutex/rwsem/rwlock/lock_map acquire macros have
different definitions based on the value of CONFIG_PROVE_LOCKING.  We have
separate ifdefs for each of these definitions, which seems redundant.

Introduce lock_acquire_{exclusive,shared,shared_recursive} helpers which
will have different definitions based on CONFIG_PROVE_LOCKING.  Then all
other helper macros can be defined based on the above ones, which reduces
the amount of ifdefined code.

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

 include/linux/lockdep.h |  102 ++++++++++----------------------------
 1 file changed, 28 insertions(+), 74 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-introduce-lock_acquire_exclusive-shared-helper-macros include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-introduce-lock_acquire_exclusive-shared-helper-macros
+++ a/include/linux/lockdep.h
@@ -365,7 +365,7 @@ extern void lockdep_trace_alloc(gfp_t ma
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
-#else /* !LOCKDEP */
+#else /* !CONFIG_LOCKDEP */
 
 static inline void lockdep_off(void)
 {
@@ -479,82 +479,36 @@ static inline void print_irqtrace_events
  * on the per lock-class debug mode:
  */
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
-# endif
-# define spin_release(l, n, i)			lock_release(l, n, i)
-#else
-# define spin_acquire(l, s, t, i)		do { } while (0)
-# define spin_release(l, n, i)			do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
-# else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
-# endif
-# define rwlock_release(l, n, i)		lock_release(l, n, i)
-#else
-# define rwlock_acquire(l, s, t, i)		do { } while (0)
-# define rwlock_acquire_read(l, s, t, i)	do { } while (0)
-# define rwlock_release(l, n, i)		do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
-# endif
-# define mutex_release(l, n, i)			lock_release(l, n, i)
-#else
-# define mutex_acquire(l, s, t, i)		do { } while (0)
-# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
-# define mutex_release(l, n, i)			do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
-# else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
-# endif
+#ifdef CONFIG_PROVE_LOCKING
+ #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
+ #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
+ #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
+#else
+ #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
+ #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
+ #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
+#endif
+
+#define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define spin_release(l, n, i)			lock_release(l, n, i)
+
+#define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
+#define rwlock_release(l, n, i)			lock_release(l, n, i)
+
+#define mutex_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define mutex_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define mutex_release(l, n, i)			lock_release(l, n, i)
+
+#define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
-#else
-# define rwsem_acquire(l, s, t, i)		do { } while (0)
-# define rwsem_acquire_nest(l, s, t, n, i)	do { } while (0)
-# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
-# define rwsem_release(l, n, i)			do { } while (0)
-#endif
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
-#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
-# else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
-#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
-# endif
+#define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
+#define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
-#else
-# define lock_map_acquire(l)			do { } while (0)
-# define lock_map_acquire_read(l)		do { } while (0)
-# define lock_map_release(l)			do { } while (0)
-#endif
 
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock) 						\
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mutex-subsystem-synchro-test-module.patch

