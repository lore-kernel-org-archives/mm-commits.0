From: akpm@google.com
Subject: [merged] block-document-blk-plug.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:30 -0700
Message-ID: <201109222100.p8ML0Ulk003698@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:34636 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1IVVAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjayaraman@suse.de, axboe@kernel.dk, corbet@lwn.net, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: document blk-plug
has been removed from the -mm tree.  Its filename was
     block-document-blk-plug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: block: document blk-plug

Thus spake Andrew Morton:

"And I have the usual maintainability whine.  If someone comes up to
vmscan.c and sees it calling blk_start_plug(), how are they supposed to
work out why that call is there?  They go look at the blk_start_plug()
definition and it is undocumented.  I think we can do better than this?"

Adapted from the LWN article - http://lwn.net/Articles/438256/ by Jens
Axboe and from an earlier attempt by Shaohua Li to document blk-plug.

[akpm@linux-foundation.org: grammatical and spelling tweaks]
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 block/blk-core.c       |   14 ++++++++++++++
 include/linux/blkdev.h |   22 ++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff -puN block/blk-core.c~block-document-blk-plug block/blk-core.c
--- a/block/blk-core.c~block-document-blk-plug
+++ a/block/blk-core.c
@@ -2629,6 +2629,20 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_w
 
 #define PLUG_MAGIC	0x91827364
 
+/**
+ * blk_start_plug - initialize blk_plug and track it inside the task_struct
+ * @plug:	The &struct blk_plug that needs to be initialized
+ *
+ * Description:
+ *   Tracking blk_plug inside the task_struct will help with auto-flushing the
+ *   pending I/O should the task end up blocking between blk_start_plug() and
+ *   blk_finish_plug(). This is important from a performance perspective, but
+ *   also ensures that we don't deadlock. For instance, if the task is blocking
+ *   for a memory allocation, memory reclaim could end up wanting to free a
+ *   page belonging to that request that is currently residing in our private
+ *   plug. By flushing the pending I/O when the process goes to sleep, we avoid
+ *   this kind of deadlock.
+ */
 void blk_start_plug(struct blk_plug *plug)
 {
 	struct task_struct *tsk = current;
diff -puN include/linux/blkdev.h~block-document-blk-plug include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-document-blk-plug
+++ a/include/linux/blkdev.h
@@ -863,16 +863,22 @@ struct request_queue *blk_alloc_queue_no
 extern void blk_put_queue(struct request_queue *);
 
 /*
- * Note: Code in between changing the blk_plug list/cb_list or element of such
- * lists is preemptable, but such code can't do sleep (or be very careful),
- * otherwise data is corrupted. For details, please check schedule() where
- * blk_schedule_flush_plug() is called.
+ * blk_plug permits building a queue of related requests by holding the I/O
+ * fragments for a short period. This allows merging of sequential requests
+ * into single larger request. As the requests are moved from a per-task list to
+ * the device's request_queue in a batch, this results in improved scalability
+ * as the lock contention for request_queue lock is reduced.
+ *
+ * It is ok not to disable preemption when adding the request to the plug list
+ * or when attempting a merge, because blk_schedule_flush_list() will only flush
+ * the plug list when the task sleeps by itself. For details, please see
+ * schedule() where blk_schedule_flush_plug() is called.
  */
 struct blk_plug {
-	unsigned long magic;
-	struct list_head list;
-	struct list_head cb_list;
-	unsigned int should_sort;
+	unsigned long magic; /* detect uninitialized use-cases */
+	struct list_head list; /* requests */
+	struct list_head cb_list; /* md requires an unplug callback */
+	unsigned int should_sort; /*list to be sorted before flushing? */
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
_

Patches currently in -mm which might be from sjayaraman@suse.de are

linux-next.patch

