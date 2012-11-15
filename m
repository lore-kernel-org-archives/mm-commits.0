From: akpm@linux-foundation.org
Subject: + percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch added to -mm tree
Date: Thu, 15 Nov 2012 12:24:29 -0800
Message-ID: <20121115202430.4ECF8200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60458 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768917Ab2KOUYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 15:24:34 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so137187wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 12:24:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ananth@in.ibm.com, anton@redhat.com, axboe@kernel.dk, mingo@elte.hu, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org


The patch titled
     Subject: percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix
has been added to the -mm tree.  Its filename is
     percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix

More include's and more comments, no changes in code.

To remind, once/if I am sure you agree with this patch I'll send 2 additional
and simple patches:

	1. lockdep annotations

	2. CONFIG_PERCPU_RWSEM

It seems that we can do much more improvements to a) speedup the writers and
b) make percpu_rw_semaphore more useful, but not right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-rwsem.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff -puN lib/percpu-rwsem.c~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix lib/percpu-rwsem.c
--- a/lib/percpu-rwsem.c~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix
+++ a/lib/percpu-rwsem.c
@@ -1,6 +1,11 @@
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/percpu.h>
+#include <linux/wait.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/errno.h>
 
 int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
 {
@@ -21,6 +26,29 @@ void percpu_free_rwsem(struct percpu_rw_
 	brw->fast_read_ctr = NULL; /* catch use after free bugs */
 }
 
+/*
+ * This is the fast-path for down_read/up_read, it only needs to ensure
+ * there is no pending writer (!mutex_is_locked() check) and inc/dec the
+ * fast per-cpu counter. The writer uses synchronize_sched() to serialize
+ * with the preempt-disabled section below.
+ *
+ * The nontrivial part is that we should guarantee acquire/release semantics
+ * in case when
+ *
+ *	R_W: down_write() comes after up_read(), the writer should see all
+ *	     changes done by the reader
+ * or
+ *	W_R: down_read() comes after up_write(), the reader should see all
+ *	     changes done by the writer
+ *
+ * If this helper fails the callers rely on the normal rw_semaphore and
+ * atomic_dec_and_test(), so in this case we have the necessary barriers.
+ *
+ * But if it succeeds we do not have any barriers, mutex_is_locked() or
+ * __this_cpu_add() below can be reordered with any LOAD/STORE done by the
+ * reader inside the critical section. See the comments in down_write and
+ * up_write below.
+ */
 static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
 {
 	bool success = false;
@@ -98,6 +126,7 @@ void percpu_down_write(struct percpu_rw_
 	 *
 	 * 3. Ensures that if any reader has exited its critical section via
 	 *    fast-path, it executes a full memory barrier before we return.
+	 *    See R_W case in the comment above update_fast_ctr().
 	 */
 	synchronize_sched();
 
@@ -116,8 +145,10 @@ void percpu_up_write(struct percpu_rw_se
 	/* allow the new readers, but only the slow-path */
 	up_write(&brw->rw_sem);
 
-	/* insert the barrier before the next fast-path in down_read */
+	/*
+	 * Insert the barrier before the next fast-path in down_read,
+	 * see W_R case in the comment above update_fast_ctr().
+	 */
 	synchronize_sched();
