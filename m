Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415CD37999D
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622965; cv=none; b=bJ0NeX/Qu+qrQv8nB+NEgYGaMzxPrOpX+ekJkUcC8tP+8FlMtG0Xkm5GyrEMqvnXPJaKaPP7WngYIUB31gHHpMOsBM3M9c4kXHRXUj4YHrq7IVyHUc5vMZeqP5dAz7h4fMS1kVppCDoGwcj1kA2jo6swLNZKne6uOyJDSaFap9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622965; c=relaxed/simple;
	bh=GMeM87fP8ZIE3U4o1MoX7cTfJ4IXCIFNdQYpXWyJI5c=;
	h=Date:To:From:Subject:Message-Id; b=DbAFZMC16999BQCxzm9NeBsws5poruxtBMJorSL5gXKDhxAS/VNCGvvRr/sUL39t0HWp/S1M/zbIVi2vaD/L267vCF9mvX1QKSY7pq2PvoZXxRL68he0Apx5+IXb1FIlk0EYGXSv5Mo89RQFwJ8rHYrw4DaytveT+l7cExSMNRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUJP/j87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUJP/j87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BB01F00A3E;
	Tue, 25 Aug 2026 01:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622963;
	bh=Uw7VA/cpiDT3XMl3OjaSk/Rnj8fqSsIKvLcapq4pu/E=;
	h=Date:To:From:Subject;
	b=nUJP/j878TrYvS3KgqYdDAbhBVfT9n5f14IAh1a3smkFOAoTlEVUs0aJZLJl3cCq2
	 JcoJtzXmWHeo+nEmk+QGSRsTC1oO/Ke02liKXN3UBIWUrXbBmR9DoTEGpFkXZDtGD/
	 hPMDdX1nQneD7XhOD4q3Cq5h5llHap53QuJLzBfg=
Date: Mon, 24 Aug 2026 18:56:02 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] locking-lockdep-add-sequence-counter-to-held_lock.patch removed from -mm tree
Message-Id: <20260825015603.15BB01F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: locking/lockdep: add sequence counter to held_lock
has been removed from the -mm tree.  Its filename was
     locking-lockdep-add-sequence-counter-to-held_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


