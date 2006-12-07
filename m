From: akpm@osdl.org
Subject: - lockdep-internal-locking-fixes.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:31 -0800
Message-ID: <200612072302.kB7N2VXD029860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163705AbWLGXCi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: internal locking fixes
has been removed from the -mm tree.  Its filename was
     lockdep-internal-locking-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: internal locking fixes
From: Jarek Poplawski <jarkao2@o2.pl>

Here are mainly some lockdep returns with 0 with unlocking fixes.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN kernel/lockdep.c~lockdep-internal-locking-fixes kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-internal-locking-fixes
+++ a/kernel/lockdep.c
@@ -237,8 +237,10 @@ e	   locks. */
 	trace->max_entries = trace->nr_entries;
 
 	nr_stack_trace_entries += trace->nr_entries;
-	if (DEBUG_LOCKS_WARN_ON(nr_stack_trace_entries > MAX_STACK_TRACE_ENTRIES))
+	if (DEBUG_LOCKS_WARN_ON(nr_stack_trace_entries > MAX_STACK_TRACE_ENTRIES)) {
+		__raw_spin_unlock(&hash_lock);
 		return 0;
+	}
 
 	if (nr_stack_trace_entries == MAX_STACK_TRACE_ENTRIES) {
 		__raw_spin_unlock(&hash_lock);
@@ -474,7 +476,8 @@ static int add_lock_to_list(struct lock_
 		return 0;
 
 	entry->class = this;
-	save_trace(&entry->trace);
+	if (!save_trace(&entry->trace))
+		return 0;
 
 	/*
 	 * Since we never remove from the dependency list, the list can
@@ -562,8 +565,12 @@ static noinline int print_circular_bug_t
 	if (debug_locks_silent)
 		return 0;
 
+	/* hash_lock unlocked by the header */
+	__raw_spin_lock(&hash_lock);
 	this.class = check_source->class;
-	save_trace(&this.trace);
+	if (!save_trace(&this.trace))
+		return 0;
+	__raw_spin_unlock(&hash_lock);
 	print_circular_bug_entry(&this, 0);
 
 	printk("\nother info that might help us debug this:\n\n");
@@ -959,6 +966,9 @@ check_prev_add(struct task_struct *curr,
 	}
 
 	/*
+	 * Return value of 2 signals 'dependency already added',
+	 * in that case we dont have to add the backlink either.
+	 *
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
@@ -966,15 +976,10 @@ check_prev_add(struct task_struct *curr,
 			       &prev->class->locks_after, next->acquire_ip);
 	if (!ret)
 		return 0;
-	/*
-	 * Return value of 2 signals 'dependency already added',
-	 * in that case we dont have to add the backlink either.
-	 */
-	if (ret == 2)
-		return 2;
 	ret = add_lock_to_list(next->class, prev->class,
 			       &next->class->locks_before, next->acquire_ip);
-
+	if (!ret)
+		return 0;
 	/*
 	 * Debugging printouts:
 	 */
@@ -1025,7 +1030,8 @@ check_prevs_add(struct task_struct *curr
 		 * added:
 		 */
 		if (hlock->read != 2) {
-			check_prev_add(curr, hlock, next);
+			if (!check_prev_add(curr, hlock, next))
+				return 0;
 			/*
 			 * Stop after the first non-trylock entry,
 			 * as non-trylock entries have added their
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch

