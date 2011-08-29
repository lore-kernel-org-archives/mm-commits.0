From: akpm@linux-foundation.org
Subject: + spinlock_debug-print-owner-on-spinlock-lockup.patch added to -mm tree
Date: Mon, 29 Aug 2011 15:42:42 -0700
Message-ID: <201108292242.p7TMggbR004743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412Ab1H2WnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 18:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, mingo@redhat.com


The patch titled
     lib/spinlock_debug.c: print owner on spinlock lockup
has been added to the -mm tree.  Its filename is
     spinlock_debug-print-owner-on-spinlock-lockup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/spinlock_debug.c: print owner on spinlock lockup
From: Akinobu Mita <akinobu.mita@gmail.com>

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

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch
lib-stringc-introduce-memchr_inv.patch
lib-stringc-introduce-memchr_inv-fix-kernel-doc-for-memchr_inv.patch
mm-debug-pageallocc-use-memchr_inv.patch
debug-pagealloc-add-support-for-highmem-pages.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
spinlock_debug-print-owner-on-spinlock-lockup.patch

