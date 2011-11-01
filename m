From: akpm@linux-foundation.org
Subject: [merged] spinlock_debug-print-owner-on-spinlock-lockup.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:54 -0700
Message-ID: <201111012115.pA1LFsqS007679@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/spinlock_debug.c: print owner on spinlock lockup
has been removed from the -mm tree.  Its filename was
     spinlock_debug-print-owner-on-spinlock-lockup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: lib/spinlock_debug.c: print owner on spinlock lockup

When SPIN_BUG_ON is triggered, the lock owner information is reported. 
But it is omitted when spinlock lockup is detected.

This information is useful especially on the architectures which don't
implement trigger_all_cpu_backtrace() that is called just after detecting
lockup.  So report it and also avoid message format duplication.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/spinlock_debug.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN lib/spinlock_debug.c~spinlock_debug-print-owner-on-spinlock-lockup lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~spinlock_debug-print-owner-on-spinlock-lockup
+++ a/lib/spinlock_debug.c
@@ -49,13 +49,10 @@ void __rwlock_init(rwlock_t *lock, const
 
 EXPORT_SYMBOL(__rwlock_init);
 
-static void spin_bug(raw_spinlock_t *lock, const char *msg)
+static void spin_dump(raw_spinlock_t *lock, const char *msg)
 {
 	struct task_struct *owner = NULL;
 
-	if (!debug_locks_off())
-		return;
-
 	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
 		owner = lock->owner;
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
@@ -70,6 +67,14 @@ static void spin_bug(raw_spinlock_t *loc
 	dump_stack();
 }
 
+static void spin_bug(raw_spinlock_t *lock, const char *msg)
+{
+	if (!debug_locks_off())
+		return;
+
+	spin_dump(lock, msg);
+}
+
 #define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
 
 static inline void
@@ -113,11 +118,7 @@ static void __spin_lock_debug(raw_spinlo
 		/* lockup suspected: */
 		if (print_once) {
 			print_once = 0;
-			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
-					"%s/%d, %p\n",
-				raw_smp_processor_id(), current->comm,
-				task_pid_nr(current), lock);
-			dump_stack();
+			spin_dump(lock, "lockup");
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
 #endif
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

