From: akpm@linux-foundation.org
Subject: [folded-merged] percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:45:11 -0800
Message-ID: <20121217234512.26AD682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:61986 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2LQXpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:45:13 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so693584qch.0
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:45:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ananth@in.ibm.com, anton@redhat.com, axboe@kernel.dk, mingo@elte.hu, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarilyfix
has been removed from the -mm tree.  Its filename was
     percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch

This patch was dropped because it was folded into percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarilyfix

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
+ * fast per-cpu counter. The writer uses synchronize_sched_expedited() to
+ * serialize with the preempt-disabled section below.
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
 	synchronize_sched_expedited();
 
@@ -116,8 +145,10 @@ void percpu_up_write(struct percpu_rw_se
 	/* allow the new readers, but only the slow-path */
 	up_write(&brw->rw_sem);
 
-	/* insert the barrier before the next fast-path in down_read */
+	/*
+	 * Insert the barrier before the next fast-path in down_read,
+	 * see W_R case in the comment above update_fast_ctr().
+	 */
 	synchronize_sched_expedited();
-
 	mutex_unlock(&brw->writer_mutex);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch
percpu_rw_semaphore-add-the-lockdep-annotations.patch
percpu_rw_semaphore-introduce-config_percpu_rwsem.patch
ptrace-introduce-ptrace_o_exitkill.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fs-epoll-add-procfs-fdinfo-helper-v2-fs-epoll-drop-enabled-field-from-fdinfo-output.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v7.patch
fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix.patch
fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch
fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

