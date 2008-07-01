From: akpm@linux-foundation.org
Subject: + debugobjects-fix-lockdep-warning.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:19:41 -0700
Message-ID: <200807010519.m615Jftp010449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYGAFTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, a.p.zijlstra@chello.nl, daniel.blueman@gmail.com, tglx@linutronix.de


The patch titled
     debugobjects: fix lockdep warning
has been added to the -mm tree.  Its filename is
     debugobjects-fix-lockdep-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: debugobjects: fix lockdep warning
From: Vegard Nossum <vegard.nossum@gmail.com>

Daniel J Blueman reported:
| =======================================================
| [ INFO: possible circular locking dependency detected ]
| 2.6.26-rc5-201c #1
| -------------------------------------------------------
| nscd/3669 is trying to acquire lock:
|  (&n->list_lock){.+..}, at: [<ffffffff802bab03>] deactivate_slab+0x173/0x1e0
|
| but task is already holding lock:
|  (&obj_hash[i].lock){++..}, at: [<ffffffff803fa56f>]
| __debug_object_init+0x2f/0x350
|
| which lock already depends on the new lock.

There are two locks involved here; the first is a SLUB-local lock, and
the second is a debugobjects-local lock. They are basically taken in two

1. SLUB { debugobjects { ... } }
2. debugobjects { SLUB { ... } }

This patch changes pattern #2 by trying to fill the memory pool (e.g.
the call into SLUB/kmalloc()) outside the debugobjects lock, so now the
two patterns look like this:

1. SLUB { debugobjects { ... } }
2. SLUB { } debugobjects { ... }

Reviewed-by: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-fix-lockdep-warning lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-fix-lockdep-warning
+++ a/lib/debugobjects.c
@@ -110,16 +110,13 @@ static struct debug_obj *lookup_object(v
 }
 
 /*
- * Allocate a new object. If the pool is empty and no refill possible,
- * switch off the debugger.
+ * Allocate a new object. If the pool is empty, switch off the debugger.
  */
 static struct debug_obj *
 alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 {
 	struct debug_obj *obj = NULL;
-	int retry = 0;
 
-repeat:
 	spin_lock(&pool_lock);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
@@ -141,9 +138,6 @@ repeat:
 	}
 	spin_unlock(&pool_lock);
 
-	if (fill_pool() && !obj && !retry++)
-		goto repeat;
-
 	return obj;
 }
 
@@ -261,6 +255,8 @@ __debug_object_init(void *addr, struct d
 	struct debug_obj *obj;
 	unsigned long flags;
 
+	fill_pool();
+
 	db = get_bucket((unsigned long) addr);
 
 	spin_lock_irqsave(&db->lock, flags);
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

debugobjects-fix-lockdep-warning.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
mm-remove-initialization-of-static-per-cpu-variables.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
kallsyms-unify-32-and-64-bit-code.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
taskstats-remove-initialization-of-static-per-cpu-variable.patch

