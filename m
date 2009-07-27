From: akpm@linux-foundation.org
Subject: [to-be-updated] slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients.patch removed from -mm tree
Date: Mon, 27 Jul 2009 16:15:09 -0700
Message-ID: <200907272315.n6RNF9Qe014047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbZG0XPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 19:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghaskins@novell.com, dhowells@redhat.com, mst@redhat.com, rusty@rustcorp.com.au, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     slow-work: add (module*)work->ops->owner to fix races with module clients
has been removed from the -mm tree.  Its filename was
     slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slow-work: add (module*)work->ops->owner to fix races with module clients
From: Gregory Haskins <ghaskins@novell.com>

The slow_work facility was designed to use reference counting instead of
barriers for synchronization.  The reference counting mechanism is
implemented as a vtable op (->get_ref, ->put_ref) callback.  This is
problematic for module use of the slow_work facility because it is
impossible to synchronize against the .text installed in the callbacks:
There is no way to ensure that the slow-work threads have completely
exited the .text in question and rmmod may yank it out from under the
slow_work thread.

This patch attempts to address this issue by mapping "struct module*
owner" to the slow_work_ops item, and maintaining a module reference count
coincident with the more externally visible reference count.  Since the
slow_work facility is resident in kernel, it should be a race-free
location to issue a module_put() call.  This will ensure that modules can
properly cleanup before exiting.

A module_get()/module_put() pair on slow_work_enqueue() and the subsequent
dequeue technically adds the overhead of the atomic operations for every
work item scheduled.  However, slow_work is designed for deferring
relatively long-running and/or sleepy tasks to begin with, so this
overhead will hopefully be negligible.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/slow-work.txt |   11 ++++++++++-
 fs/fscache/object.c         |    1 +
 fs/fscache/operation.c      |    1 +
 fs/gfs2/recovery.c          |    1 +
 include/linux/slow-work.h   |    3 +++
 kernel/slow-work.c          |   20 +++++++++++++++++++-
 6 files changed, 35 insertions(+), 2 deletions(-)

diff -puN Documentation/slow-work.txt~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients Documentation/slow-work.txt
--- a/Documentation/slow-work.txt~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients
+++ a/Documentation/slow-work.txt
@@ -80,6 +80,7 @@ Slow work items may then be set up by:
  (2) Declaring the operations to be used for this item:
 
 	struct slow_work_ops myitem_ops = {
+	        .owner   = THIS_MODULE,
 		.get_ref = myitem_get_ref,
 		.put_ref = myitem_put_ref,
 		.execute = myitem_execute,
@@ -102,7 +103,10 @@ A suitably set up work item can then be 
 	int ret = slow_work_enqueue(&myitem);
 
 This will return a -ve error if the thread pool is unable to gain a reference
-on the item, 0 otherwise.
+on the item, 0 otherwise.  Loadable modules may only enqueue work if at least
+one reference to the module is known to be held.  The slow-work infrastructure
+will acquire a reference to the module and hold it until after the item's
+reference is dropped, assuring the stability of the callback.
 
 
 The items are reference counted, so there ought to be no need for a flush
@@ -141,6 +145,11 @@ All members are required:
      it.  The thread pool will not touch the item again once this has been
      called.
 
+     This function must interpolate a general SMP memory barrier before freeing
+     or re-using the work struct as the caller may have read the module
+     pointer.  Implying a barrier with something like atomic_dec_and_test() is
+     sufficient.
+
  (*) Execute an item:
 
 	void (*execute)(struct slow_work *work);
diff -puN fs/fscache/object.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients fs/fscache/object.c
--- a/fs/fscache/object.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients
+++ a/fs/fscache/object.c
@@ -45,6 +45,7 @@ static void fscache_enqueue_dependents(s
 static void fscache_dequeue_object(struct fscache_object *);
 
 const struct slow_work_ops fscache_object_slow_work_ops = {
+	.owner		= THIS_MODULE,
 	.get_ref	= fscache_object_slow_work_get_ref,
 	.put_ref	= fscache_object_slow_work_put_ref,
 	.execute	= fscache_object_slow_work_execute,
diff -puN fs/fscache/operation.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients fs/fscache/operation.c
--- a/fs/fscache/operation.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients
+++ a/fs/fscache/operation.c
@@ -453,6 +453,7 @@ static void fscache_op_execute(struct sl
 }
 
 const struct slow_work_ops fscache_op_slow_work_ops = {
+	.owner		= THIS_MODULE,
 	.get_ref	= fscache_op_get_ref,
 	.put_ref	= fscache_op_put_ref,
 	.execute	= fscache_op_execute,
diff -puN fs/gfs2/recovery.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients fs/gfs2/recovery.c
--- a/fs/gfs2/recovery.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients
+++ a/fs/gfs2/recovery.c
@@ -593,6 +593,7 @@ fail:
 }
 
 struct slow_work_ops gfs2_recover_ops = {
+	.owner   = THIS_MODULE,
 	.get_ref = gfs2_recover_get_ref,
 	.put_ref = gfs2_recover_put_ref,
 	.execute = gfs2_recover_work,
diff -puN include/linux/slow-work.h~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients include/linux/slow-work.h
--- a/include/linux/slow-work.h~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients
+++ a/include/linux/slow-work.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_SLOW_WORK
 
 #include <linux/sysctl.h>
+#include <linux/module.h>
 
 struct slow_work;
 
@@ -24,6 +25,8 @@ struct slow_work;
  * The operations used to support slow work items
  */
 struct slow_work_ops {
+	struct module *owner;
+
 	/* get a ref on a work item
 	 * - return 0 if successful, -ve if not
 	 */
diff -puN kernel/slow-work.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients kernel/slow-work.c
--- a/kernel/slow-work.c~slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients
+++ a/kernel/slow-work.c
@@ -145,6 +145,15 @@ static unsigned slow_work_calc_vsmax(voi
 	return min(vsmax, slow_work_max_threads - 1);
 }
 
+static void slow_work_put(struct slow_work *work)
+{
+	/* cache values that are needed during/after pointer invalidation */
+	struct module *owner = work->ops->owner;
+
+	work->ops->put_ref(work);
+	module_put(owner);
+}
+
 /*
  * Attempt to execute stuff queued on a slow thread.  Return true if we managed
  * it, false if there was nothing to do.
@@ -219,7 +228,7 @@ static bool slow_work_execute(void)
 		spin_unlock_irq(&slow_work_queue_lock);
 	}
 
-	work->ops->put_ref(work);
+	slow_work_put(work);
 	return true;
 
 auto_requeue:
@@ -299,6 +308,14 @@ int slow_work_enqueue(struct slow_work *
 		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
 			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
 		} else {
+			/*
+			 * Callers must ensure that their module has at least
+			 * one reference held while the work is enqueued.  We
+			 * will acquire another reference here and drop it
+			 * once we do the last ops->put_ref()
+			 */
+			__module_get(work->ops->owner);
+
 			if (work->ops->get_ref(work) < 0)
 				goto cant_get_ref;
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
@@ -313,6 +330,7 @@ int slow_work_enqueue(struct slow_work *
 	return 0;
 
 cant_get_ref:
+	module_put(work->ops->owner);
 	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
 	return -EAGAIN;
 }
_

Patches currently in -mm which might be from ghaskins@novell.com are

linux-next.patch
slow-work-add-modulework-ops-owner-to-fix-races-with-module-clients.patch

