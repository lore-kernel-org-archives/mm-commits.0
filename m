From: akpm@linux-foundation.org
Subject: + kernel-add-mutex_lock_killable.patch added to -mm tree
Date: Thu, 29 Nov 2007 14:07:03 -0800
Message-ID: <200711292207.lATM74IY009585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934086AbXK2WIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 17:08:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: howlett@gmail.com, a.p.zijlstra@chello.nl, bfields@fieldses.org, hch@lst.de, mingo@elte.hu, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, willy@linux.intel.com


The patch titled
     Kernel: add mutex_lock_killable()
has been added to the -mm tree.  Its filename is
     kernel-add-mutex_lock_killable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kernel: add mutex_lock_killable()
From: "Liam R. Howlett" <howlett@gmail.com>

This series of patches add the ability to make mutex locks killable instead of
uninterruptable.

This patch set builds on Willy's 5 patches for TASK_KILLABLE.

The first patch adds the mutex_lock_killable to the kernel/mutex.c and
kernel/mutex.h.

The second patch is a use of the mutex_lock_killable to fs/readdir.c to use
the new mutex_lock_killable.  This was enough for a small test application to
be killable once the ethernet was pulled on an nfs mount (please note that
this does not allow a normal ls to be killed yet).


This patch:

Addition of mutex_lock_killable for mutex.c and mutex.h

Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Acked-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |    5 +++++
 kernel/mutex.c        |   36 +++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff -puN include/linux/mutex.h~kernel-add-mutex_lock_killable include/linux/mutex.h
--- a/include/linux/mutex.h~kernel-add-mutex_lock_killable
+++ a/include/linux/mutex.h
@@ -125,15 +125,20 @@ static inline int fastcall mutex_is_lock
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
+extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
+					unsigned int subclass);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
+#define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
 #else
 extern void fastcall mutex_lock(struct mutex *lock);
 extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
+extern int __must_check fastcall mutex_lock_killable(struct mutex *lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
+# define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 #endif
 
 /*
diff -puN kernel/mutex.c~kernel-add-mutex_lock_killable kernel/mutex.c
--- a/kernel/mutex.c~kernel-add-mutex_lock_killable
+++ a/kernel/mutex.c
@@ -166,9 +166,12 @@ __mutex_lock_common(struct mutex *lock, 
 		 * got a signal? (This code gets eliminated in the
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
-		if (unlikely(state == TASK_INTERRUPTIBLE &&
-						signal_pending(task))) {
-			mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+		if (unlikely((state == TASK_INTERRUPTIBLE &&
+					signal_pending(task)) ||
+			      (state == TASK_KILLABLE &&
+					fatal_signal_pending(task)))) {
+			mutex_remove_waiter(lock, &waiter,
+					    task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, ip);
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
@@ -211,6 +214,14 @@ mutex_lock_nested(struct mutex *lock, un
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
 
 int __sched
+mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
+{
+	might_sleep();
+	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+}
+EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
+
+int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
@@ -272,6 +283,9 @@ __mutex_unlock_slowpath(atomic_t *lock_c
  * mutex_lock_interruptible() and mutex_trylock().
  */
 static int fastcall noinline __sched
+__mutex_lock_killable_slowpath(atomic_t *lock_count);
+
+static noinline int fastcall __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
 /***
@@ -294,6 +308,14 @@ int fastcall __sched mutex_lock_interrup
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
+int fastcall __sched mutex_lock_killable(struct mutex *lock)
+{
+	might_sleep();
+	return __mutex_fastpath_lock_retval
+			(&lock->count, __mutex_lock_killable_slowpath);
+}
+EXPORT_SYMBOL(mutex_lock_killable);
+
 static void fastcall noinline __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
@@ -303,6 +325,14 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 }
 
 static int fastcall noinline __sched
+__mutex_lock_killable_slowpath(atomic_t *lock_count)
+{
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+}
+
+static noinline int fastcall __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
_

Patches currently in -mm which might be from howlett@gmail.com are

kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
