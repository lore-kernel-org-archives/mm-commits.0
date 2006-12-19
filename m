From: akpm@osdl.org
Subject: + lockdep-more-unlock-on-error-fixes.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:47:27 -0800
Message-ID: <200612190047.kBJ0lRtG018572@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbWLSArk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, mingo@elte.hu


The patch titled
     lockdep: more unlock-on-error fixes
has been added to the -mm tree.  Its filename is
     lockdep-more-unlock-on-error-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep: more unlock-on-error fixes
From: Jarek Poplawski <jarkao2@o2.pl>

- returns after DEBUG_LOCKS_WARN_ON added in 3 places

- debug_locks checking after lookup_chain_cache() added in
  __lock_acquire()

- locking for testing and changing global variable max_lockdep_depth
  added in __lock_acquire()

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff -puN kernel/lockdep.c~lockdep-more-unlock-on-error-fixes kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-more-unlock-on-error-fixes
+++ a/kernel/lockdep.c
@@ -1293,7 +1293,8 @@ out_unlock_set:
 	if (!subclass || force)
 		lock->class_cache = class;
 
-	DEBUG_LOCKS_WARN_ON(class->subclass != subclass);
+	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
+		return NULL;
 
 	return class;
 }
@@ -1308,7 +1309,8 @@ static inline int lookup_chain_cache(u64
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 
-	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return 0;
 	/*
 	 * We can walk it lock-free, because entries only get added
 	 * to the hash:
@@ -1390,7 +1392,9 @@ static void check_chain_key(struct task_
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
@@ -2200,19 +2204,24 @@ out_calc_hash:
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
 				return 0;
-		graph_unlock();
-	}
+	} else
+		/* after lookup_chain_cache(): */
+		if (unlikely(!debug_locks))
+			return 0;
+
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
-		debug_locks_off();
+		debug_locks_off_graph_unlock();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		return 0;
 	}
+
 	if (unlikely(curr->lockdep_depth > max_lockdep_depth))
 		max_lockdep_depth = curr->lockdep_depth;
 
+	graph_unlock();
 	return 1;
 }
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

lockdep-more-unlock-on-error-fixes.patch

