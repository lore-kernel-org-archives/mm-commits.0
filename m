From: akpm@linux-foundation.org
Subject: + percpu_rw_semaphore-add-the-lockdep-annotations.patch added to -mm tree
Date: Mon, 19 Nov 2012 15:06:06 -0800
Message-ID: <20121119230607.B712E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61221 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2KSXGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 18:06:12 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so357318eei.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 15:06:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton@redhat.com, mingo@elte.hu, mmarek@suse.cz, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org


The patch titled
     Subject: percpu_rw_semaphore: add lockdep annotations
has been added to the -mm tree.  Its filename is
     percpu_rw_semaphore-add-the-lockdep-annotations.patch

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
Subject: percpu_rw_semaphore: add lockdep annotations

Add lockdep annotations.  Not only this can help to find the potential
problems, we do not want the false warnings if, say, the task takes two
different percpu_rw_semaphore's for reading.  IOW, at least ->rw_sem
should not use a single class.

This patch exposes this internal lock to lockdep so that it represents the
whole percpu_rw_semaphore.  This way we do not need to add another "fake"
->lockdep_map and lock_class_key.  More importantly, this also makes the
output from lockdep much more understandable if it finds the problem.

In short, with this patch from lockdep pov percpu_down_read() and
percpu_up_read() acquire/release ->rw_sem for reading, this matches the
actual semantics.  This abuses __up_read() but I hope this is fine and in
fact I'd like to have down_read_no_lockdep() as well,
percpu_down_read_recursive_readers() will need it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-rwsem.h |   10 +++++++++-
 lib/percpu-rwsem.c           |   21 +++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff -puN include/linux/percpu-rwsem.h~percpu_rw_semaphore-add-the-lockdep-annotations include/linux/percpu-rwsem.h
--- a/include/linux/percpu-rwsem.h~percpu_rw_semaphore-add-the-lockdep-annotations
+++ a/include/linux/percpu-rwsem.h
@@ -5,6 +5,7 @@
 #include <linux/rwsem.h>
 #include <linux/percpu.h>
 #include <linux/wait.h>
+#include <linux/lockdep.h>
 
 struct percpu_rw_semaphore {
 	unsigned int __percpu	*fast_read_ctr;
@@ -20,7 +21,14 @@ extern void percpu_up_read(struct percpu
 extern void percpu_down_write(struct percpu_rw_semaphore *);
 extern void percpu_up_write(struct percpu_rw_semaphore *);
 
-extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
+extern int __percpu_init_rwsem(struct percpu_rw_semaphore *,
+				const char *, struct lock_class_key *);
 extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 
+#define percpu_init_rwsem(brw)	\
+({								\
+	static struct lock_class_key rwsem_key;			\
+	__percpu_init_rwsem(brw, #brw, &rwsem_key);		\
+})
+
 #endif
diff -puN lib/percpu-rwsem.c~percpu_rw_semaphore-add-the-lockdep-annotations lib/percpu-rwsem.c
--- a/lib/percpu-rwsem.c~percpu_rw_semaphore-add-the-lockdep-annotations
+++ a/lib/percpu-rwsem.c
@@ -2,18 +2,21 @@
 #include <linux/rwsem.h>
 #include <linux/percpu.h>
 #include <linux/wait.h>
+#include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
 
-int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
+int __percpu_init_rwsem(struct percpu_rw_semaphore *brw,
+			const char *name, struct lock_class_key *rwsem_key)
 {
 	brw->fast_read_ctr = alloc_percpu(int);
 	if (unlikely(!brw->fast_read_ctr))
 		return -ENOMEM;
 
-	init_rwsem(&brw->rw_sem);
+	/* ->rw_sem represents the whole percpu_rw_semaphore for lockdep */
+	__init_rwsem(&brw->rw_sem, name, rwsem_key);
 	atomic_set(&brw->write_ctr, 0);
 	atomic_set(&brw->slow_read_ctr, 0);
 	init_waitqueue_head(&brw->write_waitq);
@@ -66,19 +69,29 @@ static bool update_fast_ctr(struct percp
 /*
  * Like the normal down_read() this is not recursive, the writer can
  * come after the first percpu_down_read() and create the deadlock.
+ *
+ * Note: returns with lock_is_held(brw->rw_sem) == T for lockdep,
+ * percpu_up_read() does rwsem_release(). This pairs with the usage
+ * of ->rw_sem in percpu_down/up_write().
  */
 void percpu_down_read(struct percpu_rw_semaphore *brw)
 {
-	if (likely(update_fast_ctr(brw, +1)))
+	might_sleep();
+	if (likely(update_fast_ctr(brw, +1))) {
+		rwsem_acquire_read(&brw->rw_sem.dep_map, 0, 0, _RET_IP_);
 		return;
+	}
 
 	down_read(&brw->rw_sem);
 	atomic_inc(&brw->slow_read_ctr);
-	up_read(&brw->rw_sem);
+	/* avoid up_read()->rwsem_release() */
+	__up_read(&brw->rw_sem);
 }
 
 void percpu_up_read(struct percpu_rw_semaphore *brw)
 {
+	rwsem_release(&brw->rw_sem.dep_map, 1, _RET_IP_);
+
 	if (likely(update_fast_ctr(brw, -1)))
 		return;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch
percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch
percpu_rw_semaphore-add-the-lockdep-annotations.patch
percpu_rw_semaphore-introduce-config_percpu_rwsem.patch
uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race.patch
ptrace-introduce-ptrace_o_exitkill.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

