From: akpm@linux-foundation.org
Subject: - lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:18:08 -0700
Message-ID: <200710160218.l9G2I8FZ004265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757327AbXJPCSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:18:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghaskins@novell.com, a.p.zijlstra@chello.nl, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lockdep: fix mismatched lockdep_depth/curr_chain_hash
has been removed from the -mm tree.  Its filename was
     lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: fix mismatched lockdep_depth/curr_chain_hash
From: Gregory Haskins <ghaskins@novell.com>

It is possible for the current->curr_chain_key to become inconsistent with
the current index if the chain fails to validate.  The end result is that
future lock_acquire() operations may inadvertently fail to find a hit in
the cache resulting in a new node being added to the graph for every
acquire.

[ peterz: this might explain some of the lockdep is so _slow_ complaints. ]
[ mingo: this does not impact the correctness of validation, but may slow
  down future operations significantly, if the chain gets very long. ]

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/lockdep.c~lockdep-fix-mismatched-lockdep_depth-curr_chain_hash kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-fix-mismatched-lockdep_depth-curr_chain_hash
+++ a/kernel/lockdep.c
@@ -1521,7 +1521,7 @@ cache_hit:
 }
 
 static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
-	       	struct held_lock *hlock, int chain_head)
+	       	struct held_lock *hlock, int chain_head, u64 chain_key)
 {
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
@@ -1534,7 +1534,7 @@ static int validate_chain(struct task_st
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check == 2) &&
-			lookup_chain_cache(curr->curr_chain_key, hlock->class)) {
+			lookup_chain_cache(chain_key, hlock->class)) {
 		/*
 		 * Check whether last held lock:
 		 *
@@ -1576,7 +1576,7 @@ static int validate_chain(struct task_st
 #else
 static inline int validate_chain(struct task_struct *curr,
 	       	struct lockdep_map *lock, struct held_lock *hlock,
-		int chain_head)
+		int chain_head, u64 chain_key)
 {
 	return 1;
 }
@@ -2450,11 +2450,11 @@ static int __lock_acquire(struct lockdep
 		chain_head = 1;
 	}
 	chain_key = iterate_chain_key(chain_key, id);
-	curr->curr_chain_key = chain_key;
 
-	if (!validate_chain(curr, lock, hlock, chain_head))
+	if (!validate_chain(curr, lock, hlock, chain_head, chain_key))
 		return 0;
 
+	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 #ifdef CONFIG_DEBUG_LOCKDEP
_

Patches currently in -mm which might be from ghaskins@novell.com are

origin.patch
git-kvm.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
