From: akpm@linux-foundation.org
Subject: - lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:25 -0700
Message-ID: <200705090251.l492pPRC009455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032191AbXEICvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, jarkao@o2.pl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: removed unused ip argument in mark_lock & mark_held_locks
has been removed from the -mm tree.  Its filename was
     lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: removed unused ip argument in mark_lock & mark_held_locks
From: Jarek Poplawski <jarkao2@o2.pl>

It looks like a remainder from designing...

Signed-off-by: Jarek Poplawski <jarkao@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff -puN kernel/lockdep.c~lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks
+++ a/kernel/lockdep.c
@@ -1574,7 +1574,7 @@ valid_state(struct task_struct *curr, st
  * Mark a lock with a usage bit, and validate the state transition:
  */
 static int mark_lock(struct task_struct *curr, struct held_lock *this,
-		     enum lock_usage_bit new_bit, unsigned long ip)
+		     enum lock_usage_bit new_bit)
 {
 	unsigned int new_mask = 1 << new_bit, ret = 1;
 
@@ -1597,14 +1597,6 @@ static int mark_lock(struct task_struct 
 
 	this->class->usage_mask |= new_mask;
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-	if (new_bit == LOCK_ENABLED_HARDIRQS ||
-			new_bit == LOCK_ENABLED_HARDIRQS_READ)
-		ip = curr->hardirq_enable_ip;
-	else if (new_bit == LOCK_ENABLED_SOFTIRQS ||
-			new_bit == LOCK_ENABLED_SOFTIRQS_READ)
-		ip = curr->softirq_enable_ip;
-#endif
 	if (!save_trace(this->class->usage_traces + new_bit))
 		return 0;
 
@@ -1803,7 +1795,7 @@ static int mark_lock(struct task_struct 
  * Mark all held locks with a usage bit:
  */
 static int
-mark_held_locks(struct task_struct *curr, int hardirq, unsigned long ip)
+mark_held_locks(struct task_struct *curr, int hardirq)
 {
 	enum lock_usage_bit usage_bit;
 	struct held_lock *hlock;
@@ -1823,7 +1815,7 @@ mark_held_locks(struct task_struct *curr
 			else
 				usage_bit = LOCK_ENABLED_SOFTIRQS;
 		}
-		if (!mark_lock(curr, hlock, usage_bit, ip))
+		if (!mark_lock(curr, hlock, usage_bit))
 			return 0;
 	}
 
@@ -1876,7 +1868,7 @@ void trace_hardirqs_on(void)
 	 * We are going to turn hardirqs on, so set the
 	 * usage bit for all held locks:
 	 */
-	if (!mark_held_locks(curr, 1, ip))
+	if (!mark_held_locks(curr, 1))
 		return;
 	/*
 	 * If we have softirqs enabled, then set the usage
@@ -1884,7 +1876,7 @@ void trace_hardirqs_on(void)
 	 * this bit from being set before)
 	 */
 	if (curr->softirqs_enabled)
-		if (!mark_held_locks(curr, 0, ip))
+		if (!mark_held_locks(curr, 0))
 			return;
 
 	curr->hardirq_enable_ip = ip;
@@ -1952,7 +1944,7 @@ void trace_softirqs_on(unsigned long ip)
 	 * enabled too:
 	 */
 	if (curr->hardirqs_enabled)
-		mark_held_locks(curr, 0, ip);
+		mark_held_locks(curr, 0);
 }
 
 /*
@@ -2090,43 +2082,43 @@ static int __lock_acquire(struct lockdep
 		if (read) {
 			if (curr->hardirq_context)
 				if (!mark_lock(curr, hlock,
-						LOCK_USED_IN_HARDIRQ_READ, ip))
+						LOCK_USED_IN_HARDIRQ_READ))
 					return 0;
 			if (curr->softirq_context)
 				if (!mark_lock(curr, hlock,
-						LOCK_USED_IN_SOFTIRQ_READ, ip))
+						LOCK_USED_IN_SOFTIRQ_READ))
 					return 0;
 		} else {
 			if (curr->hardirq_context)
-				if (!mark_lock(curr, hlock, LOCK_USED_IN_HARDIRQ, ip))
+				if (!mark_lock(curr, hlock, LOCK_USED_IN_HARDIRQ))
 					return 0;
 			if (curr->softirq_context)
-				if (!mark_lock(curr, hlock, LOCK_USED_IN_SOFTIRQ, ip))
+				if (!mark_lock(curr, hlock, LOCK_USED_IN_SOFTIRQ))
 					return 0;
 		}
 	}
 	if (!hardirqs_off) {
 		if (read) {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS_READ, ip))
+					LOCK_ENABLED_HARDIRQS_READ))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS_READ, ip))
+						LOCK_ENABLED_SOFTIRQS_READ))
 					return 0;
 		} else {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS, ip))
+					LOCK_ENABLED_HARDIRQS))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS, ip))
+						LOCK_ENABLED_SOFTIRQS))
 					return 0;
 		}
 	}
 #endif
 	/* mark it as used: */
-	if (!mark_lock(curr, hlock, LOCK_USED, ip))
+	if (!mark_lock(curr, hlock, LOCK_USED))
 		return 0;
 out_calc_hash:
 	/*
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
ppp_generic-fix-lockdep-warning.patch
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
