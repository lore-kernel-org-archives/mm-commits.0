Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AAF3B47E6
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352215; cv=none; b=c5/5jvlfX2ZWlajUJmaIQfCzyD6vw8Z+vgfJyzINHno2PpujdeFNawyqouiOfOteh5gazENyIKo9C+lqr5gvpfpOLKVB3JuzfDabkF7k99VwewyoIKP9G2THXm4FfPAE8+tWBIotwOBk7zF8nindB/EMfy9wP6RAr1vFYCcf5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352215; c=relaxed/simple;
	bh=e9U4/y8Htzd+Utk3dZOr78HsLfjun9zZbWPJKav5Gvs=;
	h=Date:To:From:Subject:Message-Id; b=YfjwHovPgdAQSZ7b8T8eVlhc+1zHeBNq+KNhmky1pU+jByZ8CZx1JUdNWcK0CCfFSqKa4/VhW5uG6uVL63naI+7nMLc54kELwVoq2LRlbgZ4eodWltwfy22FzlF2GspGfDJdsOq8imcDrjGOlvBam72hL75e/Z3k++WC5AEsY8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3MRGZEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3MRGZEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC0F1F000E9;
	Fri, 21 Aug 2026 22:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352213;
	bh=l2EF3C7CUM7bfboEDNYb2iEgzzE9unsybntcYh0Kh0Y=;
	h=Date:To:From:Subject;
	b=J3MRGZEjEEjeptWiPsDbk2K0VMVEqpnJPl+7FhrkJddvNmRaOxvmkeEqIDKVHRv0Y
	 jLWGGRwK+3ZGe/lddUZiREcpE/hSgJrsw1JLTiocpq5uGVFfKF3asEhX6Jn3RTMXpg
	 t70jA0MI8pxwzp1QrvkiYxqODzv7rwy214vogvKA=
Date: Fri, 21 Aug 2026 15:43:32 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + locking-lockdep-add-sequence-counter-to-held_lock.patch added to mm-unstable branch
Message-Id: <20260821224333.3CC0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: locking/lockdep: add sequence counter to held_lock
has been added to the -mm mm-unstable branch.  Its filename is
     locking-lockdep-add-sequence-counter-to-held_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/locking-lockdep-add-sequence-counter-to-held_lock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: locking/lockdep: add sequence counter to held_lock
Date: Fri, 21 Aug 2026 15:26:10 -0400

Add an 8 bit small sequence counter to the held_lock struct to detect if
the lock as been dropped and reacquired.  This is useful when a data
structure depends on a constant locking context, but is not able to detect
locking and unlocking of the lock through its own API.

Since the __lock_unpin_lock() will no longer detect underflow by casting
the unsigned int to a signed int, update the casting code to use a temp
variable for calculations using a signed int.

Link: https://lore.kernel.org/20260821192627.4085470-3-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/all/h3tpnj5kzcrxms5picmimtkpg4aypcpip5wbd6bt2rpdj5k7eb@nhtzs3lefrkq/
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h       |    3 +
 include/linux/lockdep_types.h |    3 +
 include/linux/sched.h         |    1 
 kernel/locking/lockdep.c      |   58 ++++++++++++++++++++++++++++----
 4 files changed, 57 insertions(+), 8 deletions(-)

--- a/include/linux/lockdep.h~locking-lockdep-add-sequence-counter-to-held_lock
+++ a/include/linux/lockdep.h
@@ -273,6 +273,9 @@ extern struct pin_cookie lock_pin_lock(s
 extern void lock_repin_lock(struct lockdep_map *lock, struct pin_cookie);
 extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 
+extern u32 lock_sequence(struct lockdep_map *lock);
+#define lockdep_sequence(lock)	lock_sequence(&(lock)->dep_map)
+
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
 #define lockdep_assert(cond)		\
--- a/include/linux/lockdep_types.h~locking-lockdep-add-sequence-counter-to-held_lock
+++ a/include/linux/lockdep_types.h
@@ -253,7 +253,8 @@ struct held_lock {
 	unsigned int hardirqs_off:1;
 	unsigned int sync:1;
 	unsigned int references:11;					/* 32 bits */
-	unsigned int pin_count;
+	unsigned int pin_count:24;
+	unsigned int seq_count:8;
 };
 
 #else /* !CONFIG_LOCKDEP */
--- a/include/linux/sched.h~locking-lockdep-add-sequence-counter-to-held_lock
+++ a/include/linux/sched.h
@@ -1288,6 +1288,7 @@ struct task_struct {
 	u64				curr_chain_key;
 	int				lockdep_depth;
 	unsigned int			lockdep_recursion;
+	unsigned int			lockdep_seq;
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
--- a/kernel/locking/lockdep.c~locking-lockdep-add-sequence-counter-to-held_lock
+++ a/kernel/locking/lockdep.c
@@ -5077,7 +5077,7 @@ static int __lock_is_held(const struct l
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
 			  struct lockdep_map *nest_lock, unsigned long ip,
-			  int references, int pin_count, int sync)
+			  int references, int pin_count, int sync, int seq)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -5183,6 +5183,7 @@ static int __lock_acquire(struct lockdep
 	hlock->holdtime_stamp = lockstat_clock();
 #endif
 	hlock->pin_count = pin_count;
+	hlock->seq_count = seq;
 
 	if (check_wait_context(curr, hlock))
 		return 0;
@@ -5388,7 +5389,7 @@ static int reacquire_held_locks(struct t
 				    hlock->read, hlock->check,
 				    hlock->hardirqs_off,
 				    hlock->nest_lock, hlock->acquire_ip,
-				    hlock->references, hlock->pin_count, 0)) {
+				    hlock->references, hlock->pin_count, 0, hlock->seq_count)) {
 		case 0:
 			return 1;
 		case 1:
@@ -5669,14 +5670,17 @@ static void __lock_unpin_lock(struct loc
 		struct held_lock *hlock = curr->held_locks + i;
 
 		if (match_held_lock(hlock, lock)) {
+			int pin_count;
+
 			if (WARN(!hlock->pin_count, "unpinning an unpinned lock\n"))
 				return;
 
-			hlock->pin_count -= cookie.val;
+			pin_count = hlock->pin_count - cookie.val;
 
-			if (WARN((int)hlock->pin_count < 0, "pin count corrupted\n"))
-				hlock->pin_count = 0;
+			if (WARN(pin_count < 0, "pin count corrupted\n"))
+				pin_count = 0;
 
+			hlock->pin_count = pin_count;
 			return;
 		}
 	}
@@ -5684,6 +5688,24 @@ static void __lock_unpin_lock(struct loc
 	WARN(1, "unpinning an unheld lock\n");
 }
 
+static u32 __lock_sequence(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	int i;
+
+	if (unlikely(!debug_locks))
+		return ~0;
+
+	for (i = 0; i < curr->lockdep_depth; i++) {
+		struct held_lock *hlock = curr->held_locks + i;
+
+		if (match_held_lock(hlock, lock))
+			return hlock->seq_count;
+	}
+
+	return ~0;
+}
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -5866,7 +5888,8 @@ void lock_acquire(struct lockdep_map *lo
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0,
+		       ++current->lockdep_seq);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
@@ -5914,7 +5937,8 @@ void lock_sync(struct lockdep_map *lock,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, 0, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1,
+		       ++current->lockdep_seq);
 	check_chain_key(current);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -6000,6 +6024,26 @@ void lock_unpin_lock(struct lockdep_map
 }
 EXPORT_SYMBOL_GPL(lock_unpin_lock);
 
+u32 lock_sequence(struct lockdep_map *lock)
+{
+	unsigned long flags;
+	u32 seq = ~0;
+
+	if (unlikely(!lockdep_enabled()))
+		return seq;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	lockdep_recursion_inc();
+	seq = __lock_sequence(lock);
+	lockdep_recursion_finish();
+	raw_local_irq_restore(flags);
+
+	return seq;
+}
+EXPORT_SYMBOL_GPL(lock_sequence);
+
 #ifdef CONFIG_LOCK_STAT
 static void print_lock_contention_bug(struct task_struct *curr,
 				      struct lockdep_map *lock,
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

