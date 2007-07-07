From: akpm@linux-foundation.org
Subject: - port-of-blktrace-to-the-linux-kernel-markers.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:32:32 -0700
Message-ID: <200707070036.l670ahV3030026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbXGGAhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Port of blktrace to the Linux Kernel Markers
has been removed from the -mm tree.  Its filename was
     port-of-blktrace-to-the-linux-kernel-markers.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Port of blktrace to the Linux Kernel Markers
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is a proof of concept patch, for demonstration purpose, of moving
blktrace to the markers.

A few remarks : this patch has the positive effect of removing some code
from the block io tracing hot paths, minimizing the i-cache impact in a
system where the io tracing is compiled in but inactive.

It also moves the blk tracing code from a header (and therefore from the
body of the instrumented functions) to a separate C file.

There, as soon as one device has to be traced, every devices have to
fall into the tracing function call. This is slower than the previous
inline function which tested the condition quickly. If it becomes a
show stopper, it could be fixed by having the possibility to test a
supplementary condition, dependant of the marker context, at the marker
site, just after the enable/disable test.

It does not make the code smaller, since I left all the specialized
tracing functions for requests, bio, generic, remap, which would go away
once a generic infrastructure is in place to serialize the information
passed to the marker. This is mostly why I consider it a proof a
concept.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig                |    1 
 block/blktrace.c             |  281 ++++++++++++++++++++++++++++++++-
 block/elevator.c             |    6 
 block/ll_rw_blk.c            |   27 +--
 drivers/block/cciss.c        |    4 
 drivers/md/dm.c              |   14 -
 fs/bio.c                     |    4 
 include/linux/blktrace_api.h |  146 +----------------
 mm/bounce.c                  |    4 
 mm/highmem.c                 |    2 
 10 files changed, 322 insertions(+), 167 deletions(-)

diff -puN block/Kconfig~port-of-blktrace-to-the-linux-kernel-markers block/Kconfig
--- a/block/Kconfig~port-of-blktrace-to-the-linux-kernel-markers
+++ a/block/Kconfig
@@ -32,6 +32,7 @@ config BLK_DEV_IO_TRACE
 	depends on SYSFS
 	select RELAY
 	select DEBUG_FS
+	select MARKERS
 	help
 	  Say Y here, if you want to be able to trace the block layer actions
 	  on a given queue. Tracing allows you to see any traffic happening
diff -puN block/blktrace.c~port-of-blktrace-to-the-linux-kernel-markers block/blktrace.c
--- a/block/blktrace.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/block/blktrace.c
@@ -23,11 +23,19 @@
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/time.h>
+#include <linux/marker.h>
 #include <asm/uaccess.h>
 
 static DEFINE_PER_CPU(unsigned long long, blk_trace_cpu_offset) = { 0, };
 static unsigned int blktrace_seq __read_mostly = 1;
 
+/* Global reference count of probes */
+static DEFINE_MUTEX(blk_probe_mutex);
+static int blk_probes_ref;
+
+int blk_probe_arm(void);
+void blk_probe_disarm(void);
+
 /*
  * Send out a notify message.
  */
@@ -179,7 +187,7 @@ void __blk_add_trace(struct blk_trace *b
 EXPORT_SYMBOL_GPL(__blk_add_trace);
 
 static struct dentry *blk_tree_root;
-static struct mutex blk_tree_mutex;
+static DEFINE_MUTEX(blk_tree_mutex);
 static unsigned int root_users;
 
 static inline void blk_remove_root(void)
@@ -229,6 +237,10 @@ static void blk_trace_cleanup(struct blk
 	blk_remove_tree(bt->dir);
 	free_percpu(bt->sequence);
 	kfree(bt);
+	mutex_lock(&blk_probe_mutex);
+	if (--blk_probes_ref == 0)
+		blk_probe_disarm();
+	mutex_unlock(&blk_probe_mutex);
 }
 
 static int blk_trace_remove(request_queue_t *q)
@@ -386,6 +398,11 @@ static int blk_trace_setup(request_queue
 		goto err;
 	}
 
+	mutex_lock(&blk_probe_mutex);
+	if (!blk_probes_ref++)
+		blk_probe_arm();
+	mutex_unlock(&blk_probe_mutex);
+
 	return 0;
 err:
 	if (dir)
@@ -549,9 +566,269 @@ static void blk_trace_set_ht_offsets(voi
 #endif
 }
 
+/**
+ * blk_add_trace_rq - Add a trace for a request oriented action
+ * Expected variable arguments :
+ * @q:		queue the io is for
+ * @rq:		the source request
+ *
+ * Description:
+ *     Records an action against a request. Will log the bio offset + size.
+ *
+ **/
+static void blk_add_trace_rq(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+	va_list args;
+	u32 what;
+	struct blk_trace *bt;
+	int rw;
+	struct blk_probe_data *pinfo = mdata->pdata;
+	struct request_queue *q;
+	struct request *rq;
+
+	va_start(args, fmt);
+	q = va_arg(args, struct request_queue *);
+	rq = va_arg(args, struct request *);
+	va_end(args);
+
+	what = pinfo->flags;
+	bt = q->blk_trace;
+	rw = rq->cmd_flags & 0x03;
+
+	if (likely(!bt))
+		return;
+
+	if (blk_pc_request(rq)) {
+		what |= BLK_TC_ACT(BLK_TC_PC);
+		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors, sizeof(rq->cmd), rq->cmd);
+	} else  {
+		what |= BLK_TC_ACT(BLK_TC_FS);
+		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9, rw, what, rq->errors, 0, NULL);
+	}
+}
+
+/**
+ * blk_add_trace_bio - Add a trace for a bio oriented action
+ * Expected variable arguments :
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ *
+ * Description:
+ *     Records an action against a bio. Will log the bio offset + size.
+ *
+ **/
+static void blk_add_trace_bio(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+	va_list args;
+	u32 what;
+	struct blk_trace *bt;
+	struct blk_probe_data *pinfo = mdata->pdata;
+	struct request_queue *q;
+	struct bio *bio;
+
+	va_start(args, fmt);
+	q = va_arg(args, struct request_queue *);
+	bio = va_arg(args, struct bio *);
+	va_end(args);
+
+	what = pinfo->flags;
+	bt = q->blk_trace;
+
+	if (likely(!bt))
+		return;
+
+	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), 0, NULL);
+}
+
+/**
+ * blk_add_trace_generic - Add a trace for a generic action
+ * Expected variable arguments :
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ * @rw:		the data direction
+ *
+ * Description:
+ *     Records a simple trace
+ *
+ **/
+static void blk_add_trace_generic(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+	va_list args;
+	struct blk_trace *bt;
+	u32 what;
+	struct blk_probe_data *pinfo = mdata->pdata;
+	struct request_queue *q;
+	struct bio *bio;
+	int rw;
+
+	va_start(args, fmt);
+	q = va_arg(args, struct request_queue *);
+	bio = va_arg(args, struct bio *);
+	rw = va_arg(args, int);
+	va_end(args);
+
+	what = pinfo->flags;
+	bt = q->blk_trace;
+
+	if (likely(!bt))
+		return;
+
+	if (bio)
+		blk_add_trace_bio(mdata, "%p %p", q, bio);
+	else
+		__blk_add_trace(bt, 0, 0, rw, what, 0, 0, NULL);
+}
+
+/**
+ * blk_add_trace_pdu_int - Add a trace for a bio with an integer payload
+ * Expected variable arguments :
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ * @pdu:	the integer payload
+ *
+ * Description:
+ *     Adds a trace with some integer payload. This might be an unplug
+ *     option given as the action, with the depth at unplug time given
+ *     as the payload
+ *
+ **/
+static void blk_add_trace_pdu_int(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+	va_list args;
+	struct blk_trace *bt;
+	u32 what;
+	struct blk_probe_data *pinfo = mdata->pdata;
+	struct request_queue *q;
+	struct bio *bio;
+	unsigned int pdu;
+	__be64 rpdu;
+
+	va_start(args, fmt);
+	q = va_arg(args, struct request_queue *);
+	bio = va_arg(args, struct bio *);
+	pdu = va_arg(args, unsigned int);
+	va_end(args);
+
+	what = pinfo->flags;
+	bt = q->blk_trace;
+	rpdu = cpu_to_be64(pdu);
+
+	if (likely(!bt))
+		return;
+
+	if (bio)
+		__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), sizeof(rpdu), &rpdu);
+	else
+		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
+}
+
+/**
+ * blk_add_trace_remap - Add a trace for a remap operation
+ * Expected variable arguments :
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ * @dev:	target device
+ * @from:	source sector
+ * @to:		target sector
+ *
+ * Description:
+ *     Device mapper or raid target sometimes need to split a bio because
+ *     it spans a stripe (or similar). Add a trace for that action.
+ *
+ **/
+static void blk_add_trace_remap(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+	va_list args;
+	struct blk_trace *bt;
+	struct blk_io_trace_remap r;
+	u32 what;
+	struct blk_probe_data *pinfo = mdata->pdata;
+	struct request_queue *q;
+	struct bio *bio;
+	u64 dev, from, to;
+
+	va_start(args, fmt);
+	q = va_arg(args, struct request_queue *);
+	bio = va_arg(args, struct bio *);
+	dev = va_arg(args, u64);
+	from = va_arg(args, u64);
+	to = va_arg(args, u64);
+	va_end(args);
+
+	what = pinfo->flags;
+	bt = q->blk_trace;
+
+	if (likely(!bt))
+		return;
+
+	r.device = cpu_to_be32(dev);
+	r.sector = cpu_to_be64(to);
+
+	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+}
+
+#define FACILITY_NAME "blk"
+
+static struct blk_probe_data probe_array[] =
+{
+	{ "blk_bio_queue", "%p %p", BLK_TA_QUEUE, blk_add_trace_bio },
+	{ "blk_bio_backmerge", "%p %p", BLK_TA_BACKMERGE, blk_add_trace_bio },
+	{ "blk_bio_frontmerge", "%p %p", BLK_TA_FRONTMERGE, blk_add_trace_bio },
+	{ "blk_get_request", "%p %p %d", BLK_TA_GETRQ, blk_add_trace_generic },
+	{ "blk_sleep_request", "%p %p %d", BLK_TA_SLEEPRQ,
+		blk_add_trace_generic },
+	{ "blk_requeue", "%p %p", BLK_TA_REQUEUE, blk_add_trace_rq },
+	{ "blk_request_issue", "%p %p", BLK_TA_ISSUE, blk_add_trace_rq },
+	{ "blk_request_complete", "%p %p", BLK_TA_COMPLETE, blk_add_trace_rq },
+	{ "blk_plug_device", "%p %p %d", BLK_TA_PLUG, blk_add_trace_generic },
+	{ "blk_pdu_unplug_io", "%p %p %d", BLK_TA_UNPLUG_IO,
+		blk_add_trace_pdu_int },
+	{ "blk_pdu_unplug_timer", "%p %p %d", BLK_TA_UNPLUG_TIMER,
+		blk_add_trace_pdu_int },
+	{ "blk_request_insert", "%p %p", BLK_TA_INSERT,
+		blk_add_trace_rq },
+	{ "blk_pdu_split", "%p %p %d", BLK_TA_SPLIT,
+		blk_add_trace_pdu_int },
+	{ "blk_bio_bounce", "%p %p", BLK_TA_BOUNCE, blk_add_trace_bio },
+	{ "blk_remap", "%p %p %u %llu %llu", BLK_TA_REMAP,
+		blk_add_trace_remap },
+};
+
+
+int blk_probe_arm(void)
+{
+	int result;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		result = marker_arm_probe(probe_array[i].name,
+				probe_array[i].format,
+				probe_array[i].callback, &probe_array[i]);
+		if (result)
+			printk(KERN_INFO
+				"blktrace unable to register probe %s\n",
+				probe_array[i].name);
+	}
+	return 0;
+}
+
+void blk_probe_disarm(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		marker_disarm_probe(probe_array[i].name);
+	}
+}
+
+
 static __init int blk_trace_init(void)
 {
-	mutex_init(&blk_tree_mutex);
 	on_each_cpu(blk_trace_check_cpu_time, NULL, 1, 1);
 	blk_trace_set_ht_offsets();
 
diff -puN block/elevator.c~port-of-blktrace-to-the-linux-kernel-markers block/elevator.c
--- a/block/elevator.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/block/elevator.c
@@ -32,7 +32,7 @@
 #include <linux/init.h>
 #include <linux/compiler.h>
 #include <linux/delay.h>
-#include <linux/blktrace_api.h>
+#include <linux/marker.h>
 #include <linux/hash.h>
 
 #include <asm/uaccess.h>
@@ -547,7 +547,7 @@ void elv_insert(request_queue_t *q, stru
 	unsigned ordseq;
 	int unplug_it = 1;
 
-	blk_add_trace_rq(q, rq, BLK_TA_INSERT);
+	trace_mark(blk_request_insert, "%p %p", q, rq);
 
 	rq->q = q;
 
@@ -726,7 +726,7 @@ struct request *elv_next_request(request
 			 * not be passed by new incoming requests
 			 */
 			rq->cmd_flags |= REQ_STARTED;
-			blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
+			trace_mark(blk_request_issue, "%p %p", q, rq);
 		}
 
 		if (!q->boundary_rq || q->boundary_rq == rq) {
diff -puN block/ll_rw_blk.c~port-of-blktrace-to-the-linux-kernel-markers block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/block/ll_rw_blk.c
@@ -28,6 +28,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/marker.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 
@@ -1551,7 +1552,7 @@ void blk_plug_device(request_queue_t *q)
 
 	if (!test_and_set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
-		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
+		trace_mark(blk_plug_device, "%p %p %d", q, NULL, 0);
 	}
 }
 
@@ -1617,7 +1618,7 @@ static void blk_backing_dev_unplug(struc
 	 * devices don't necessarily have an ->unplug_fn defined
 	 */
 	if (q->unplug_fn) {
-		blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
+		trace_mark(blk_pdu_unplug_io, "%p %p %d", q, NULL,
 					q->rq.count[READ] + q->rq.count[WRITE]);
 
 		q->unplug_fn(q);
@@ -1628,7 +1629,7 @@ static void blk_unplug_work(struct work_
 {
 	request_queue_t *q = container_of(work, request_queue_t, unplug_work);
 
-	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
+	trace_mark(blk_pdu_unplug_io, "%p %p %d", q, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
 	q->unplug_fn(q);
@@ -1638,7 +1639,7 @@ static void blk_unplug_timeout(unsigned 
 {
 	request_queue_t *q = (request_queue_t *)data;
 
-	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
+	trace_mark(blk_pdu_unplug_timer, "%p %p %d", q, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
 	kblockd_schedule_work(&q->unplug_work);
@@ -2150,7 +2151,7 @@ rq_starved:
 	
 	rq_init(q, rq);
 
-	blk_add_trace_generic(q, bio, rw, BLK_TA_GETRQ);
+	trace_mark(blk_get_request, "%p %p %d", q, bio, rw);
 out:
 	return rq;
 }
@@ -2180,7 +2181,7 @@ static struct request *get_request_wait(
 		if (!rq) {
 			struct io_context *ioc;
 
-			blk_add_trace_generic(q, bio, rw, BLK_TA_SLEEPRQ);
+			trace_mark(blk_sleep_request, "%p %p %d", q, bio, rw);
 
 			__generic_unplug_device(q);
 			spin_unlock_irq(q->queue_lock);
@@ -2254,7 +2255,7 @@ EXPORT_SYMBOL(blk_start_queueing);
  */
 void blk_requeue_request(request_queue_t *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
+	trace_mark(blk_requeue, "%p %p", q, rq);
 
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
@@ -2940,7 +2941,7 @@ static int __make_request(request_queue_
 			if (!ll_back_merge_fn(q, req, bio))
 				break;
 
-			blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
+			trace_mark(blk_bio_backmerge, "%p %p", q, bio);
 
 			req->biotail->bi_next = bio;
 			req->biotail = bio;
@@ -2957,7 +2958,7 @@ static int __make_request(request_queue_
 			if (!ll_front_merge_fn(q, req, bio))
 				break;
 
-			blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
+			trace_mark(blk_bio_frontmerge, "%p %p", q, bio);
 
 			bio->bi_next = req->bio;
 			req->bio = bio;
@@ -3187,10 +3188,10 @@ end_io:
 		blk_partition_remap(bio);
 
 		if (old_sector != -1)
-			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector, 
-					    old_sector);
+			trace_mark(blk_remap, "%p %p %u %llu %llu", q, bio, old_dev,
+					(u64)bio->bi_sector, (u64)old_sector);
 
-		blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
+		trace_mark(blk_bio_queue, "%p %p", q, bio);
 
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
@@ -3383,7 +3384,7 @@ static int __end_that_request_first(stru
 	int total_bytes, bio_nbytes, error, next_idx = 0;
 	struct bio *bio;
 
-	blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
+	trace_mark(blk_request_complete, "%p %p", req->q, req);
 
 	/*
 	 * extend uptodate bool to allow < 0 value to be direct io error
diff -puN drivers/block/cciss.c~port-of-blktrace-to-the-linux-kernel-markers drivers/block/cciss.c
--- a/drivers/block/cciss.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/drivers/block/cciss.c
@@ -37,7 +37,7 @@
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
-#include <linux/blktrace_api.h>
+#include <linux/marker.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -2504,7 +2504,7 @@ after_error_processing:
 	}
 	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
-	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
+	trace_mark(blk_request_complete, "%p %p", cmd->rq->q, cmd->rq);
 	blk_complete_request(cmd->rq);
 }
 
diff -puN drivers/md/dm.c~port-of-blktrace-to-the-linux-kernel-markers drivers/md/dm.c
--- a/drivers/md/dm.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/drivers/md/dm.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
-#include <linux/blktrace_api.h>
+#include <linux/marker.h>
 #include <linux/smp_lock.h>
 
 #define DM_MSG_PREFIX "core"
@@ -487,8 +487,8 @@ static void dec_pending(struct dm_io *io
 			wake_up(&io->md->wait);
 
 		if (io->error != DM_ENDIO_REQUEUE) {
-			blk_add_trace_bio(io->md->queue, io->bio,
-					  BLK_TA_COMPLETE);
+			trace_mark(blk_request_complete, "%p %p",
+				io->md->queue, io->bio);
 
 			bio_endio(io->bio, io->bio->bi_size, io->error);
 		}
@@ -584,10 +584,10 @@ static void __map_bio(struct dm_target *
 	r = ti->type->map(ti, clone, &tio->info);
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
-
-		blk_add_trace_remap(bdev_get_queue(clone->bi_bdev), clone,
-				    tio->io->bio->bi_bdev->bd_dev, sector,
-				    clone->bi_sector);
+		trace_mark(blk_remap, "%p %p %u %llu %llu",
+			bdev_get_queue(clone->bi_bdev), clone,
+			(u64)tio->io->bio->bi_bdev->bd_dev, (u64)sector,
+			(u64)clone->bi_sector);
 
 		generic_make_request(clone);
 	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
diff -puN fs/bio.c~port-of-blktrace-to-the-linux-kernel-markers fs/bio.c
--- a/fs/bio.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/fs/bio.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
-#include <linux/blktrace_api.h>
+#include <linux/marker.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 #define BIO_POOL_SIZE 2
@@ -1081,7 +1081,7 @@ struct bio_pair *bio_split(struct bio *b
 	if (!bp)
 		return bp;
 
-	blk_add_trace_pdu_int(bdev_get_queue(bi->bi_bdev), BLK_TA_SPLIT, bi,
+	trace_mark(blk_pdu_split, "%p %p %d", bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
 
 	BUG_ON(bi->bi_vcnt != 1);
diff -puN include/linux/blktrace_api.h~port-of-blktrace-to-the-linux-kernel-markers include/linux/blktrace_api.h
--- a/include/linux/blktrace_api.h~port-of-blktrace-to-the-linux-kernel-markers
+++ a/include/linux/blktrace_api.h
@@ -3,6 +3,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/relay.h>
+#include <linux/marker.h>
 
 /*
  * Trace categories
@@ -142,149 +143,24 @@ struct blk_user_trace_setup {
 	u32 pid;
 };
 
+/* Probe data used for probe-marker connection */
+struct blk_probe_data {
+	const char *name;
+	const char *format;
+	u32 flags;
+	marker_probe_func *callback;
+};
+
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(request_queue_t *);
 extern void __blk_add_trace(struct blk_trace *, sector_t, int, int, u32, int, int, void *);
-
-/**
- * blk_add_trace_rq - Add a trace for a request oriented action
- * @q:		queue the io is for
- * @rq:		the source request
- * @what:	the action
- *
- * Description:
- *     Records an action against a request. Will log the bio offset + size.
- *
- **/
-static inline void blk_add_trace_rq(struct request_queue *q, struct request *rq,
-				    u32 what)
-{
-	struct blk_trace *bt = q->blk_trace;
-	int rw = rq->cmd_flags & 0x03;
-
-	if (likely(!bt))
-		return;
-
-	if (blk_pc_request(rq)) {
-		what |= BLK_TC_ACT(BLK_TC_PC);
-		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors, sizeof(rq->cmd), rq->cmd);
-	} else  {
-		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9, rw, what, rq->errors, 0, NULL);
-	}
-}
-
-/**
- * blk_add_trace_bio - Add a trace for a bio oriented action
- * @q:		queue the io is for
- * @bio:	the source bio
- * @what:	the action
- *
- * Description:
- *     Records an action against a bio. Will log the bio offset + size.
- *
- **/
-static inline void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
-				     u32 what)
-{
-	struct blk_trace *bt = q->blk_trace;
-
-	if (likely(!bt))
-		return;
-
-	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), 0, NULL);
-}
-
-/**
- * blk_add_trace_generic - Add a trace for a generic action
- * @q:		queue the io is for
- * @bio:	the source bio
- * @rw:		the data direction
- * @what:	the action
- *
- * Description:
- *     Records a simple trace
- *
- **/
-static inline void blk_add_trace_generic(struct request_queue *q,
-					 struct bio *bio, int rw, u32 what)
-{
-	struct blk_trace *bt = q->blk_trace;
-
-	if (likely(!bt))
-		return;
-
-	if (bio)
-		blk_add_trace_bio(q, bio, what);
-	else
-		__blk_add_trace(bt, 0, 0, rw, what, 0, 0, NULL);
-}
-
-/**
- * blk_add_trace_pdu_int - Add a trace for a bio with an integer payload
- * @q:		queue the io is for
- * @what:	the action
- * @bio:	the source bio
- * @pdu:	the integer payload
- *
- * Description:
- *     Adds a trace with some integer payload. This might be an unplug
- *     option given as the action, with the depth at unplug time given
- *     as the payload
- *
- **/
-static inline void blk_add_trace_pdu_int(struct request_queue *q, u32 what,
-					 struct bio *bio, unsigned int pdu)
-{
-	struct blk_trace *bt = q->blk_trace;
-	__be64 rpdu = cpu_to_be64(pdu);
-
-	if (likely(!bt))
-		return;
-
-	if (bio)
-		__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), sizeof(rpdu), &rpdu);
-	else
-		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
-}
-
-/**
- * blk_add_trace_remap - Add a trace for a remap operation
- * @q:		queue the io is for
- * @bio:	the source bio
- * @dev:	target device
- * @from:	source sector
- * @to:		target sector
- *
- * Description:
- *     Device mapper or raid target sometimes need to split a bio because
- *     it spans a stripe (or similar). Add a trace for that action.
- *
- **/
-static inline void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from, sector_t to)
-{
-	struct blk_trace *bt = q->blk_trace;
-	struct blk_io_trace_remap r;
-
-	if (likely(!bt))
-		return;
-
-	r.device = cpu_to_be32(dev);
-	r.sector = cpu_to_be64(to);
-
-	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
-}
+extern int blk_probe_connect(void);
+extern void blk_probe_disconnect(void);
 
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 #define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 #define blk_trace_shutdown(q)			do { } while (0)
-#define blk_add_trace_rq(q, rq, what)		do { } while (0)
-#define blk_add_trace_bio(q, rq, what)		do { } while (0)
-#define blk_add_trace_generic(q, rq, rw, what)	do { } while (0)
-#define blk_add_trace_pdu_int(q, what, bio, pdu)	do { } while (0)
-#define blk_add_trace_remap(q, bio, dev, f, t)	do {} while (0)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
 #endif
diff -puN mm/bounce.c~port-of-blktrace-to-the-linux-kernel-markers mm/bounce.c
--- a/mm/bounce.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/mm/bounce.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
-#include <linux/blktrace_api.h>
+#include <linux/marker.h>
 #include <asm/tlbflush.h>
 
 #define POOL_SIZE	64
@@ -237,7 +237,7 @@ static void __blk_queue_bounce(request_q
 	if (!bio)
 		return;
 
-	blk_add_trace_bio(q, *bio_orig, BLK_TA_BOUNCE);
+	trace_mark(blk_bio_bounce, "%p %p", q, *bio_orig);
 
 	/*
 	 * at least one page was bounced, fill in possible non-highmem
diff -puN mm/highmem.c~port-of-blktrace-to-the-linux-kernel-markers mm/highmem.c
--- a/mm/highmem.c~port-of-blktrace-to-the-linux-kernel-markers
+++ a/mm/highmem.c
@@ -26,7 +26,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
-#include <linux/blktrace_api.h>
+#include <linux/marker.h>
 #include <asm/tlbflush.h>
 
 /*
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
