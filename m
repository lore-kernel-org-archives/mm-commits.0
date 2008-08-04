From: akpm@linux-foundation.org
Subject: + lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:35:04 -0700
Message-ID: <200808042135.m74LZ4J8032197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765036AbYHDVfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     lockdep: lock_set_subclass - reset a held locks subclass
has been added to the -mm tree.  Its filename is
     lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch

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
Subject: lockdep: lock_set_subclass - reset a held locks subclass
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

This can be used to reset a held lock's subclass, for arbitrary-depth
iterated data structures such as trees or lists which have per-node locks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    4 ++
 kernel/lockdep.c        |   69 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff -puN include/linux/lockdep.h~lockdep-lock_set_subclass-reset-a-held-locks-subclass include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-lock_set_subclass-reset-a-held-locks-subclass
+++ a/include/linux/lockdep.h
@@ -300,6 +300,9 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
+			      unsigned long ip);
+
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
@@ -316,6 +319,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, i)		do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
diff -puN kernel/lockdep.c~lockdep-lock_set_subclass-reset-a-held-locks-subclass kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-lock_set_subclass-reset-a-held-locks-subclass
+++ a/kernel/lockdep.c
@@ -2658,6 +2658,55 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+static int
+__lock_set_subclass(struct lockdep_map *lock,
+		    unsigned int subclass, unsigned long ip)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class *class;
+	unsigned int depth;
+	int i;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
+		return 0;
+
+	prev_hlock = NULL;
+	for (i = depth-1; i >= 0; i--) {
+		hlock = curr->held_locks + i;
+		/*
+		 * We must not cross into another context:
+		 */
+		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
+			break;
+		if (hlock->instance == lock)
+			goto found_it;
+		prev_hlock = hlock;
+	}
+	return print_unlock_inbalance_bug(curr, lock, ip);
+
+found_it:
+	class = register_lock_class(lock, subclass, 0);
+	hlock->class = class;
+
+	curr->lockdep_depth = i;
+	curr->curr_chain_key = hlock->prev_chain_key;
+
+	for (; i < depth; i++) {
+		hlock = curr->held_locks + i;
+		if (!__lock_acquire(hlock->instance,
+			hlock->class->subclass, hlock->trylock,
+				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->acquire_ip))
+			return 0;
+	}
+
+	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
+		return 0;
+	return 1;
+}
+
 /*
  * Remove the lock to the list of currently held locks in a
  * potentially non-nested (out of order) manner. This is a
@@ -2822,6 +2871,26 @@ static void check_flags(unsigned long fl
 #endif
 }
 
+void
+lock_set_subclass(struct lockdep_map *lock,
+		  unsigned int subclass, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
+	check_flags(flags);
+	if (__lock_set_subclass(lock, subclass, ip))
+		check_chain_key(current);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
+EXPORT_SYMBOL_GPL(lock_set_subclass);
+
 /*
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
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

