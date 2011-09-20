From: akpm@google.com
Subject: [folded] block-document-blk-plug-v3.patch removed from -mm tree
Date: Tue, 20 Sep 2011 14:21:48 -0700
Message-ID: <201109202121.p8KLLmlP003289@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1ITVV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 17:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjayaraman@suse.de, axboe@kernel.dk, corbet@lwn.net, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block-document-blk-plug-v3
has been removed from the -mm tree.  Its filename was
     block-document-blk-plug-v3.patch

This patch was dropped because it was folded into block-document-blk-plug.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: block-document-blk-plug-v3

  * clarify why we need not disable preemption while modifying the plug list.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 block/blk-core.c       |    2 +-
 include/linux/blkdev.h |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN block/blk-core.c~block-document-blk-plug-v3 block/blk-core.c
--- a/block/blk-core.c~block-document-blk-plug-v3
+++ a/block/blk-core.c
@@ -2641,7 +2641,7 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_w
  *   for a memory allocation, memory reclaim could end up wanting to free a
  *   page belonging to that request that is currently residing in our private
  *   plug. By flushing the pending I/O when the process goes to sleep, we avoid
- *   this kind of deadlock.
+ *   this kind of deadlocks.
  */
 void blk_start_plug(struct blk_plug *plug)
 {
diff -puN include/linux/blkdev.h~block-document-blk-plug-v3 include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-document-blk-plug-v3
+++ a/include/linux/blkdev.h
@@ -863,16 +863,16 @@ struct request_queue *blk_alloc_queue_no
 extern void blk_put_queue(struct request_queue *);
 
 /*
- * blk_plug permits building a queue of related requests by holding the I/O
+ * blk_plug allows to build up a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
- * into single larger request. As the requests are moved from a per-task list to
- * the device's request_queue in a batch, this results in improved scalability
- * as the lock contention for request_queue lock is reduced.
+ * into single larger request. As the requests are moved from per-task list to
+ * the device's request_queue in a batch, this results in improved
+ * scalability as the lock contention for request_queue lock is reduced.
  *
- * Note: code in between changing the blk_plug list/cb_list or an element of
- * these lists is preemptible, but such code cannot sleep (or must be very
- * careful), otherwise data is corrupted. For details, please check schedule()
- * where blk_schedule_flush_plug() is called.
+ * It is ok not to disable preemption when adding the request to the plug list
+ * or when attempting merge, because blk_schedule_flush_list() will only flush
+ * the plug list when the task sleeps by itself. For details, please check
+ * schedule() where blk_schedule_flush_plug() is called.
  */
 struct blk_plug {
 	unsigned long magic; /* detect uninitialized use-cases */
_

Patches currently in -mm which might be from sjayaraman@suse.de are

block-document-blk-plug.patch
block-document-blk-plug-v3-fix.patch

