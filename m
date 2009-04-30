From: akpm@linux-foundation.org
Subject: + block-prevent-possible-io_context-refcount-overflow.patch added to -mm tree
Date: Thu, 30 Apr 2009 14:31:19 -0700
Message-ID: <200904302131.n3ULVKXX028339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbZD3Vdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 17:33:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@novell.com, jens.axboe@oracle.com, knikanth@suse.de


The patch titled
     block: prevent possible io_context->refcount overflow
has been added to the -mm tree.  Its filename is
     block-prevent-possible-io_context-refcount-overflow.patch

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
Subject: block: prevent possible io_context->refcount overflow
From: Nikanth Karthikesan <knikanth@novell.com>

Currently io_context has an atomic_t(32-bit) as refcount.  In the case of
cfq, for each device against whcih a task does I/O, a reference to the
io_context would be taken.  And when there are multiple process sharing
io_contexts(CLONE_IO) would also have a reference to the same io_context. 

Theoretically the possible maximum number of processes sharing the same
io_context + the number of disks/cfq_data referring to the same io_context
can overflow the 32-bit counter on a very high-end machine.

Even though it is an improbable case, let us make it atomic_long_t.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-ioc.c           |   12 ++++++------
 block/cfq-iosched.c       |    2 +-
 include/linux/iocontext.h |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN block/blk-ioc.c~block-prevent-possible-io_context-refcount-overflow block/blk-ioc.c
--- a/block/blk-ioc.c~block-prevent-possible-io_context-refcount-overflow
+++ a/block/blk-ioc.c
@@ -35,9 +35,9 @@ int put_io_context(struct io_context *io
 	if (ioc == NULL)
 		return 1;
 
-	BUG_ON(atomic_read(&ioc->refcount) == 0);
+	BUG_ON(atomic_long_read(&ioc->refcount) == 0);
 
-	if (atomic_dec_and_test(&ioc->refcount)) {
+	if (atomic_long_dec_and_test(&ioc->refcount)) {
 		rcu_read_lock();
 		if (ioc->aic && ioc->aic->dtor)
 			ioc->aic->dtor(ioc->aic);
@@ -90,7 +90,7 @@ struct io_context *alloc_io_context(gfp_
 
 	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
 	if (ret) {
-		atomic_set(&ret->refcount, 1);
+		atomic_long_set(&ret->refcount, 1);
 		atomic_set(&ret->nr_tasks, 1);
 		spin_lock_init(&ret->lock);
 		ret->ioprio_changed = 0;
@@ -151,7 +151,7 @@ struct io_context *get_io_context(gfp_t 
 		ret = current_io_context(gfp_flags, node);
 		if (unlikely(!ret))
 			break;
-	} while (!atomic_inc_not_zero(&ret->refcount));
+	} while (!atomic_long_inc_not_zero(&ret->refcount));
 
 	return ret;
 }
@@ -163,8 +163,8 @@ void copy_io_context(struct io_context *
 	struct io_context *dst = *pdst;
 
 	if (src) {
-		BUG_ON(atomic_read(&src->refcount) == 0);
-		atomic_inc(&src->refcount);
+		BUG_ON(atomic_long_read(&src->refcount) == 0);
+		atomic_long_inc(&src->refcount);
 		put_io_context(dst);
 		*pdst = src;
 	}
diff -puN block/cfq-iosched.c~block-prevent-possible-io_context-refcount-overflow block/cfq-iosched.c
--- a/block/cfq-iosched.c~block-prevent-possible-io_context-refcount-overflow
+++ a/block/cfq-iosched.c
@@ -1282,7 +1282,7 @@ static void cfq_dispatch_request(struct 
 	if (!cfqd->active_cic) {
 		struct cfq_io_context *cic = RQ_CIC(rq);
 
-		atomic_inc(&cic->ioc->refcount);
+		atomic_long_inc(&cic->ioc->refcount);
 		cfqd->active_cic = cic;
 	}
 }
diff -puN include/linux/iocontext.h~block-prevent-possible-io_context-refcount-overflow include/linux/iocontext.h
--- a/include/linux/iocontext.h~block-prevent-possible-io_context-refcount-overflow
+++ a/include/linux/iocontext.h
@@ -64,7 +64,7 @@ struct cfq_io_context {
  * and kmalloc'ed. These could be shared between processes.
  */
 struct io_context {
-	atomic_t refcount;
+	atomic_long_t refcount;
 	atomic_t nr_tasks;
 
 	/* all the fields below are protected by this lock */
@@ -91,8 +91,8 @@ static inline struct io_context *ioc_tas
 	 * if ref count is zero, don't allow sharing (ioc is going away, it's
 	 * a race).
 	 */
-	if (ioc && atomic_inc_not_zero(&ioc->refcount)) {
-		atomic_inc(&ioc->nr_tasks);
+	if (ioc && atomic_long_inc_not_zero(&ioc->refcount)) {
+		atomic_long_inc(&ioc->refcount);
 		return ioc;
 	}
 
_

Patches currently in -mm which might be from knikanth@novell.com are

block-prevent-possible-io_context-refcount-overflow.patch

