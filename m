From: akpm@linux-foundation.org
Subject: + lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:52:25 -0700
Message-ID: <200710052352.l95NqPcU031359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759640AbXJEXwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ghaskins@novell.com, a.p.zijlstra@chello.nl, mingo@elte.hu, stable@kernel.org


The patch titled
     lockdep: fix mismatched lockdep_depth/curr_chain_hash
has been added to the -mm tree.  Its filename is
     lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch
