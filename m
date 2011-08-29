From: akpm@linux-foundation.org
Subject: + block-document-blk-plug.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:48:51 -0700
Message-ID: <201108292148.p7TLmp94031643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235Ab1H2Vta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sjayaraman@suse.de, axboe@kernel.dk, corbet@lwn.net, shaohua.li@intel.com


The patch titled
     block: document blk-plug
has been added to the -mm tree.  Its filename is
     block-document-blk-plug.patch

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
Subject: block: document blk-plug
From: Suresh Jayaraman <sjayaraman@suse.de>

Thus spake Andrew Morton:

"And I have the usual maintainability whine.  If someone comes up to
vmscan.c and sees it calling blk_start_plug(), how are they supposed to
work out why that call is there?  They go look at the blk_start_plug()
definition and it is undocumented.  I think we can do better than this?"

Adapted from the LWN article - http://lwn.net/Articles/438256/ by Jens
Axboe and from an earlier attempt by Shaohua Li to document blk-plug.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c       |   14 ++++++++++++++
 include/linux/blkdev.h |   16 +++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff -puN block/blk-core.c~block-document-blk-plug block/blk-core.c
--- a/block/blk-core.c~block-document-blk-plug
+++ a/block/blk-core.c
@@ -2626,6 +2626,20 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_w
 
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
+ *   this kind of deadlocks.
+ */
 void blk_start_plug(struct blk_plug *plug)
 {
 	struct task_struct *tsk = current;
diff -puN include/linux/blkdev.h~block-document-blk-plug include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-document-blk-plug
+++ a/include/linux/blkdev.h
@@ -863,17 +863,23 @@ struct request_queue *blk_alloc_queue_no
 extern void blk_put_queue(struct request_queue *);
 
 /*
+ * blk_plug allows to build up a queue of related requests by holding the I/O
+ * fragments for a short period. This allows merging of sequential requests
+ * into single larger request. As the requests are moved from per-task list to
+ * the device's request_queue in a batch, this results in improved
+ * scalability as the lock contention for request_queue lock is reduced.
+ *
  * Note: Code in between changing the blk_plug list/cb_list or element of such
  * lists is preemptable, but such code can't do sleep (or be very careful),
  * otherwise data is corrupted. For details, please check schedule() where
  * blk_schedule_flush_plug() is called.
  */
 struct blk_plug {
-	unsigned long magic;
-	struct list_head list;
-	struct list_head cb_list;
-	unsigned int should_sort;
-	unsigned int count;
+	unsigned long magic; /* detect uninitialized use-cases */
+	struct list_head list; /* requests */
+	struct list_head cb_list; /* md requires an unplug callback */
+	unsigned int should_sort; /*list to be sorted before flushing? */
+	unsigned int count; /* request count to avoid list getting too big */
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
_

Patches currently in -mm which might be from sjayaraman@suse.de are

block-document-blk-plug.patch
block-document-blk-plug-fix.patch

