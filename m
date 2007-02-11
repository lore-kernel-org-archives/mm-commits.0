From: akpm@linux-foundation.org
Subject: - lockdep-more-unlock-on-error-fixes.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:53 -0800
Message-ID: <200702112250.l1BMorHE015900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754AbXBKWvP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: more unlock-on-error fixes
has been removed from the -mm tree.  Its filename was
     lockdep-more-unlock-on-error-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: more unlock-on-error fixes
From: Jarek Poplawski <jarkao2@o2.pl>

- returns after DEBUG_LOCKS_WARN_ON added in 3 places

- debug_locks checking after lookup_chain_cache() added in
  __lock_acquire()

- locking for testing and changing global variable max_lockdep_depth
  added in __lock_acquire()


My __acquire_lock() cleanup introduced a locking bug: on SMP systems we'd
release a non-owned graph lock.  Fix this by moving the graph unlock back,
and by leaving the max_lockdep_depth variable update possibly racy.  (we
dont care, it's just statistics)

Also add some minimal debugging code to graph_unlock()/graph_lock(),
which caught this locking bug.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN kernel/lockdep.c~lockdep-more-unlock-on-error-fixes kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-more-unlock-on-error-fixes
+++ a/kernel/lockdep.c
@@ -70,6 +70,9 @@ static int graph_lock(void)
 
 static inline int graph_unlock(void)
 {
+	if (debug_locks && !__raw_spin_is_locked(&lockdep_lock))
+		return DEBUG_LOCKS_WARN_ON(1);
+
 	__raw_spin_unlock(&lockdep_lock);
 	return 0;
 }
@@ -712,6 +715,9 @@ find_usage_backwards(struct lock_class *
 	struct lock_list *entry;
 	int ret;
 
+	if (!__raw_spin_is_locked(&lockdep_lock))
+		return DEBUG_LOCKS_WARN_ON(1);
+
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -1293,7 +1299,8 @@ out_unlock_set:
 	if (!subclass || force)
 		lock->class_cache = class;
 
-	DEBUG_LOCKS_WARN_ON(class->subclass != subclass);
+	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
+		return NULL;
 
 	return class;
 }
@@ -1308,7 +1315,8 @@ static inline int lookup_chain_cache(u64
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 
-	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return 0;
 	/*
 	 * We can walk it lock-free, because entries only get added
 	 * to the hash:
@@ -1394,7 +1402,9 @@ static void check_chain_key(struct task_
 			return;
 		}
 		id = hlock->class - lock_classes;
-		DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS);
+		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
+			return;
+
 		if (prev_hlock && (prev_hlock->irq_context !=
 							hlock->irq_context))
 			chain_key = 0;
@@ -2205,7 +2215,11 @@ out_calc_hash:
 			if (!check_prevs_add(curr, hlock))
 				return 0;
 		graph_unlock();
-	}
+	} else
+		/* after lookup_chain_cache(): */
+		if (unlikely(!debug_locks))
+			return 0;
+
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
@@ -2214,6 +2228,7 @@ out_calc_hash:
 		printk("turning off the locking correctness validator.\n");
 		return 0;
 	}
+
 	if (unlikely(curr->lockdep_depth > max_lockdep_depth))
 		max_lockdep_depth = curr->lockdep_depth;
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
