From: akpm@linux-foundation.org
Subject: + block-add-more-fix-some-block-kernel-doc.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:03:01 -0700
Message-ID: <200808182303.m7IN32jc017648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbYHRXDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com


The patch titled
     block: add more + fix some block kernel-doc
has been added to the -mm tree.  Its filename is
     block-add-more-fix-some-block-kernel-doc.patch

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
Subject: block: add more + fix some block kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add some block/ source files to the kernel-api docbook.
Fix kernel-doc notation in them as needed.
Fix changed function parameter names.
Fix typos/spellos.
In comments, change REQ_SPECIAL to REQ_TYPE_SPECIAL and
REQ_BLOCK_PC to REQ_TYPE_BLOCK_PC.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    4 +
 block/blk-core.c                      |   72 ++++++++++++------------
 block/blk-exec.c                      |    6 +-
 block/blk-integrity.c                 |    4 -
 block/blk-map.c                       |   16 ++---
 block/blk-settings.c                  |    8 +-
 block/blk-tag.c                       |    8 +-
 block/genhd.c                         |    5 +
 8 files changed, 64 insertions(+), 59 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~block-add-more-fix-some-block-kernel-doc Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~block-add-more-fix-some-block-kernel-doc
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -364,6 +364,10 @@ X!Edrivers/pnp/system.c
 !Eblock/blk-barrier.c
 !Eblock/blk-tag.c
 !Iblock/blk-tag.c
+!Eblock/blk-integrity.c
+!Iblock/blktrace.c
+!Iblock/genhd.c
+!Eblock/genhd.c
   </chapter>
 
   <chapter id="chrdev">
diff -puN block/blk-core.c~block-add-more-fix-some-block-kernel-doc block/blk-core.c
--- a/block/blk-core.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/blk-core.c
@@ -531,7 +531,7 @@ EXPORT_SYMBOL(blk_alloc_queue_node);
  *    request queue; this lock will be taken also from interrupt context, so irq
  *    disabling is needed for it.
  *
- *    Function returns a pointer to the initialized request queue, or NULL if
+ *    Function returns a pointer to the initialized request queue, or %NULL if
  *    it didn't succeed.
  *
  * Note:
@@ -911,7 +911,7 @@ void blk_requeue_request(struct request_
 EXPORT_SYMBOL(blk_requeue_request);
 
 /**
- * blk_insert_request - insert a special request in to a request queue
+ * blk_insert_request - insert a special request into a request queue
  * @q:		request queue where request should be inserted
  * @rq:		request to be inserted
  * @at_head:	insert request at head or tail of queue
@@ -921,8 +921,8 @@ EXPORT_SYMBOL(blk_requeue_request);
  *    Many block devices need to execute commands asynchronously, so they don't
  *    block the whole kernel from preemption during request execution.  This is
  *    accomplished normally by inserting aritficial requests tagged as
- *    REQ_SPECIAL in to the corresponding request queue, and letting them be
- *    scheduled for actual execution by the request queue.
+ *    REQ_TYPE_SPECIAL in to the corresponding request queue, and letting them
+ *    be scheduled for actual execution by the request queue.
  *
  *    We have the option of inserting the head or the tail of the queue.
  *    Typically we use the tail for new ioctls and so forth.  We use the head
@@ -1320,7 +1320,7 @@ static inline int bio_check_eod(struct b
 }
 
 /**
- * generic_make_request: hand a buffer to its device driver for I/O
+ * generic_make_request - hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
  *
  * generic_make_request() is used to make I/O requests of block
@@ -1478,13 +1478,13 @@ void generic_make_request(struct bio *bi
 EXPORT_SYMBOL(generic_make_request);
 
 /**
- * submit_bio: submit a bio to the block device layer for I/O
+ * submit_bio - submit a bio to the block device layer for I/O
  * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
  * @bio: The &struct bio which describes the I/O
  *
  * submit_bio() is very similar in purpose to generic_make_request(), and
  * uses that function to do most of the work. Both are fairly rough
- * interfaces, @bio must be presetup and ready for I/O.
+ * interfaces; @bio must be presetup and ready for I/O.
  *
  */
 void submit_bio(int rw, struct bio *bio)
@@ -1522,7 +1522,7 @@ EXPORT_SYMBOL(submit_bio);
 /**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
- * @error:    0 for success, < 0 for error
+ * @error:    %0 for success, < %0 for error
  * @nr_bytes: number of bytes to complete
  *
  * Description:
@@ -1530,8 +1530,8 @@ EXPORT_SYMBOL(submit_bio);
  *     for the next range of segments (if any) in the cluster.
  *
  * Return:
- *     0 - we are done with this request, call end_that_request_last()
- *     1 - still buffers pending for this request
+ *     %0 - we are done with this request, call end_that_request_last()
+ *     %1 - still buffers pending for this request
  **/
 static int __end_that_request_first(struct request *req, int error,
 				    int nr_bytes)
@@ -1542,7 +1542,7 @@ static int __end_that_request_first(stru
 	blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
 
 	/*
-	 * for a REQ_BLOCK_PC request, we want to carry any eventual
+	 * for a REQ_TYPE_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
 	 */
 	if (!blk_pc_request(req))
@@ -1808,11 +1808,11 @@ EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
 /**
  * end_queued_request - end all I/O on a queued request
  * @rq:		the request being processed
- * @uptodate:	error value or 0/1 uptodate flag
+ * @uptodate:	error value or %0/%1 uptodate flag
  *
  * Description:
  *     Ends all I/O on a request, and removes it from the block layer queues.
- *     Not suitable for normal IO completion, unless the driver still has
+ *     Not suitable for normal I/O completion, unless the driver still has
  *     the request attached to the block layer.
  *
  **/
@@ -1825,7 +1825,7 @@ EXPORT_SYMBOL(end_queued_request);
 /**
  * end_dequeued_request - end all I/O on a dequeued request
  * @rq:		the request being processed
- * @uptodate:	error value or 0/1 uptodate flag
+ * @uptodate:	error value or %0/%1 uptodate flag
  *
  * Description:
  *     Ends all I/O on a request. The request must already have been
@@ -1843,14 +1843,14 @@ EXPORT_SYMBOL(end_dequeued_request);
 /**
  * end_request - end I/O on the current segment of the request
  * @req:	the request being processed
- * @uptodate:	error value or 0/1 uptodate flag
+ * @uptodate:	error value or %0/%1 uptodate flag
  *
  * Description:
  *     Ends I/O on the current segment of a request. If that is the only
  *     remaining segment, the request is also completed and freed.
  *
- *     This is a remnant of how older block drivers handled IO completions.
- *     Modern drivers typically end IO on the full request in one go, unless
+ *     This is a remnant of how older block drivers handled I/O completions.
+ *     Modern drivers typically end I/O on the full request in one go, unless
  *     they have a residual value to account for. For that case this function
  *     isn't really useful, unless the residual just happens to be the
  *     full current segment. In other words, don't use this function in new
@@ -1868,12 +1868,12 @@ EXPORT_SYMBOL(end_request);
 /**
  * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
- * @error:        0 for success, < 0 for error
+ * @error:        %0 for success, < %0 for error
  * @nr_bytes:     number of bytes to complete @rq
  * @bidi_bytes:   number of bytes to complete @rq->next_rq
  * @drv_callback: function called between completion of bios in the request
  *                and completion of the request.
- *                If the callback returns non 0, this helper returns without
+ *                If the callback returns non %0, this helper returns without
  *                completion of the request.
  *
  * Description:
@@ -1881,8 +1881,8 @@ EXPORT_SYMBOL(end_request);
  *     If @rq has leftover, sets it up for the next range of segments.
  *
  * Return:
- *     0 - we are done with this request
- *     1 - this request is not freed yet, it still has pending buffers.
+ *     %0 - we are done with this request
+ *     %1 - this request is not freed yet, it still has pending buffers.
  **/
 static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
 		      unsigned int bidi_bytes,
@@ -1917,7 +1917,7 @@ static int blk_end_io(struct request *rq
 /**
  * blk_end_request - Helper function for drivers to complete the request.
  * @rq:       the request being processed
- * @error:    0 for success, < 0 for error
+ * @error:    %0 for success, < %0 for error
  * @nr_bytes: number of bytes to complete
  *
  * Description:
@@ -1925,8 +1925,8 @@ static int blk_end_io(struct request *rq
  *     If @rq has leftover, sets it up for the next range of segments.
  *
  * Return:
- *     0 - we are done with this request
- *     1 - still buffers pending for this request
+ *     %0 - we are done with this request
+ *     %1 - still buffers pending for this request
  **/
 int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
@@ -1937,15 +1937,15 @@ EXPORT_SYMBOL_GPL(blk_end_request);
 /**
  * __blk_end_request - Helper function for drivers to complete the request.
  * @rq:       the request being processed
- * @error:    0 for success, < 0 for error
+ * @error:    %0 for success, < %0 for error
  * @nr_bytes: number of bytes to complete
  *
  * Description:
  *     Must be called with queue lock held unlike blk_end_request().
  *
  * Return:
- *     0 - we are done with this request
- *     1 - still buffers pending for this request
+ *     %0 - we are done with this request
+ *     %1 - still buffers pending for this request
  **/
 int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
@@ -1964,7 +1964,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
 /**
  * blk_end_bidi_request - Helper function for drivers to complete bidi request.
  * @rq:         the bidi request being processed
- * @error:      0 for success, < 0 for error
+ * @error:      %0 for success, < %0 for error
  * @nr_bytes:   number of bytes to complete @rq
  * @bidi_bytes: number of bytes to complete @rq->next_rq
  *
@@ -1972,8 +1972,8 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
  *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
  *
  * Return:
- *     0 - we are done with this request
- *     1 - still buffers pending for this request
+ *     %0 - we are done with this request
+ *     %1 - still buffers pending for this request
  **/
 int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
 			 unsigned int bidi_bytes)
@@ -1985,11 +1985,11 @@ EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 /**
  * blk_end_request_callback - Special helper function for tricky drivers
  * @rq:           the request being processed
- * @error:        0 for success, < 0 for error
+ * @error:        %0 for success, < %0 for error
  * @nr_bytes:     number of bytes to complete
  * @drv_callback: function called between completion of bios in the request
  *                and completion of the request.
- *                If the callback returns non 0, this helper returns without
+ *                If the callback returns non %0, this helper returns without
  *                completion of the request.
  *
  * Description:
@@ -2002,10 +2002,10 @@ EXPORT_SYMBOL_GPL(blk_end_bidi_request);
  *     Don't use this interface in other places anymore.
  *
  * Return:
- *     0 - we are done with this request
- *     1 - this request is not freed yet.
- *         this request still has pending buffers or
- *         the driver doesn't want to finish this request yet.
+ *     %0 - we are done with this request
+ *     %1 - this request is not freed yet.
+ *          this request still has pending buffers or
+ *          the driver doesn't want to finish this request yet.
  **/
 int blk_end_request_callback(struct request *rq, int error,
 			     unsigned int nr_bytes,
diff -puN block/blk-exec.c~block-add-more-fix-some-block-kernel-doc block/blk-exec.c
--- a/block/blk-exec.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/blk-exec.c
@@ -16,7 +16,7 @@
 /**
  * blk_end_sync_rq - executes a completion event on a request
  * @rq: request to complete
- * @error: end io status of the request
+ * @error: end I/O status of the request
  */
 static void blk_end_sync_rq(struct request *rq, int error)
 {
@@ -41,7 +41,7 @@ static void blk_end_sync_rq(struct reque
  * @done:	I/O completion handler
  *
  * Description:
- *    Insert a fully prepared request at the back of the io scheduler queue
+ *    Insert a fully prepared request at the back of the I/O scheduler queue
  *    for execution.  Don't wait for completion.
  */
 void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
@@ -72,7 +72,7 @@ EXPORT_SYMBOL_GPL(blk_execute_rq_nowait)
  * @at_head:    insert request at head or tail of queue
  *
  * Description:
- *    Insert a fully prepared request at the back of the io scheduler queue
+ *    Insert a fully prepared request at the back of the I/O scheduler queue
  *    for execution and wait for completion.
  */
 int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
diff -puN block/blk-integrity.c~block-add-more-fix-some-block-kernel-doc block/blk-integrity.c
--- a/block/blk-integrity.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/blk-integrity.c
@@ -109,8 +109,8 @@ EXPORT_SYMBOL(blk_rq_map_integrity_sg);
 
 /**
  * blk_integrity_compare - Compare integrity profile of two block devices
- * @b1:		Device to compare
- * @b2:		Device to compare
+ * @bd1:	Device to compare
+ * @bd2:	Device to compare
  *
  * Description: Meta-devices like DM and MD need to verify that all
  * sub-devices use the same integrity format before advertising to
diff -puN block/blk-map.c~block-add-more-fix-some-block-kernel-doc block/blk-map.c
--- a/block/blk-map.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/blk-map.c
@@ -85,17 +85,17 @@ static int __blk_rq_map_user(struct requ
 }
 
 /**
- * blk_rq_map_user - map user data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request structure to fill
  * @ubuf:	the user buffer
  * @len:	length of user data
  *
  * Description:
- *    Data will be mapped directly for zero copy io, if possible. Otherwise
+ *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
  *    a kernel bounce buffer is used.
  *
- *    A matching blk_rq_unmap_user() must be issued at the end of io, while
+ *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
  *    still in process context.
  *
  *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
@@ -154,7 +154,7 @@ unmap_rq:
 EXPORT_SYMBOL(blk_rq_map_user);
 
 /**
- * blk_rq_map_user_iov - map user data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request to map data to
  * @iov:	pointer to the iovec
@@ -162,10 +162,10 @@ EXPORT_SYMBOL(blk_rq_map_user);
  * @len:	I/O byte count
  *
  * Description:
- *    Data will be mapped directly for zero copy io, if possible. Otherwise
+ *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
  *    a kernel bounce buffer is used.
  *
- *    A matching blk_rq_unmap_user() must be issued at the end of io, while
+ *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
  *    still in process context.
  *
  *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
@@ -224,7 +224,7 @@ int blk_rq_map_user_iov(struct request_q
  * Description:
  *    Unmap a rq previously mapped by blk_rq_map_user(). The caller must
  *    supply the original rq->bio from the blk_rq_map_user() return, since
- *    the io completion may have changed rq->bio.
+ *    the I/O completion may have changed rq->bio.
  */
 int blk_rq_unmap_user(struct bio *bio)
 {
@@ -250,7 +250,7 @@ int blk_rq_unmap_user(struct bio *bio)
 EXPORT_SYMBOL(blk_rq_unmap_user);
 
 /**
- * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request to fill
  * @kbuf:	the kernel buffer
diff -puN block/blk-settings.c~block-add-more-fix-some-block-kernel-doc block/blk-settings.c
--- a/block/blk-settings.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/blk-settings.c
@@ -144,7 +144,7 @@ EXPORT_SYMBOL(blk_queue_make_request);
  *    Different hardware can have different requirements as to what pages
  *    it can do I/O directly to. A low level driver can call
  *    blk_queue_bounce_limit to have lower memory pages allocated as bounce
- *    buffers for doing I/O to pages residing above @page.
+ *    buffers for doing I/O to pages residing above @dma_addr.
  **/
 void blk_queue_bounce_limit(struct request_queue *q, u64 dma_addr)
 {
@@ -229,7 +229,7 @@ EXPORT_SYMBOL(blk_queue_max_phys_segment
  * Description:
  *    Enables a low level driver to set an upper limit on the number of
  *    hw data segments in a request.  This would be the largest number of
- *    address/length pairs the host adapter can actually give as once
+ *    address/length pairs the host adapter can actually give at once
  *    to the device.
  **/
 void blk_queue_max_hw_segments(struct request_queue *q,
@@ -410,7 +410,7 @@ EXPORT_SYMBOL(blk_queue_segment_boundary
  * @mask:  alignment mask
  *
  * description:
- *    set required memory and length aligment for direct dma transactions.
+ *    set required memory and length alignment for direct dma transactions.
  *    this is used when buiding direct io requests for the queue.
  *
  **/
@@ -426,7 +426,7 @@ EXPORT_SYMBOL(blk_queue_dma_alignment);
  * @mask:  alignment mask
  *
  * description:
- *    update required memory and length aligment for direct dma transactions.
+ *    update required memory and length alignment for direct dma transactions.
  *    If the requested alignment is larger than the current alignment, then
  *    the current queue alignment is updated to the new value, otherwise it
  *    is left alone.  The design of this is to allow multiple objects
diff -puN block/blk-tag.c~block-add-more-fix-some-block-kernel-doc block/blk-tag.c
--- a/block/blk-tag.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/blk-tag.c
@@ -29,7 +29,7 @@ EXPORT_SYMBOL(blk_queue_find_tag);
  * __blk_free_tags - release a given set of tag maintenance info
  * @bqt:	the tag map to free
  *
- * Tries to free the specified @bqt@.  Returns true if it was
+ * Tries to free the specified @bqt.  Returns true if it was
  * actually freed and false if there are still references using it
  */
 static int __blk_free_tags(struct blk_queue_tag *bqt)
@@ -77,7 +77,7 @@ void __blk_queue_free_tags(struct reques
  * blk_free_tags - release a given set of tag maintenance info
  * @bqt:	the tag map to free
  *
- * For externally managed @bqt@ frees the map.  Callers of this
+ * For externally managed @bqt frees the map.  Callers of this
  * function must guarantee to have released all the queues that
  * might have been using this tag map.
  */
@@ -93,7 +93,7 @@ EXPORT_SYMBOL(blk_free_tags);
  * @q:  the request queue for the device
  *
  *  Notes:
- *	This is used to disabled tagged queuing to a device, yet leave
+ *	This is used to disable tagged queuing to a device, yet leave
  *	queue in function.
  **/
 void blk_queue_free_tags(struct request_queue *q)
@@ -271,7 +271,7 @@ EXPORT_SYMBOL(blk_queue_resize_tags);
  * @rq: the request that has completed
  *
  *  Description:
- *    Typically called when end_that_request_first() returns 0, meaning
+ *    Typically called when end_that_request_first() returns %0, meaning
  *    all transfers have been done for a request. It's important to call
  *    this function before end_that_request_last(), as that will put the
  *    request back on the free list thus corrupting the internal tag list.
diff -puN block/genhd.c~block-add-more-fix-some-block-kernel-doc block/genhd.c
--- a/block/genhd.c~block-add-more-fix-some-block-kernel-doc
+++ a/block/genhd.c
@@ -213,10 +213,11 @@ void unlink_gendisk(struct gendisk *disk
 
 /**
  * get_gendisk - get partitioning information for a given device
- * @dev: device to get partitioning information for
+ * @devt: device to get partitioning information for
+ * @part: returned partition index
  *
  * This function gets the structure containing partitioning
- * information for the given device @dev.
+ * information for the given device @devt.
  */
 struct gendisk *get_gendisk(dev_t devt, int *part)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

documentation-describe-bootmem_debug-kernel-parameter.patch
kernel-doc-allow-space-in-macro-define.patch
kernelh-fix-kernel-doc-for-might_sleep.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure.patch
block-add-more-fix-some-block-kernel-doc.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

