From: akpm@osdl.org
Subject: + aio-remove-spurious-ring-head-index-modulo-info-nr.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:34:19 -0800
Message-ID: <200701022134.l02LYJpZ030474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34297 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbXABVfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: remove spurious ring head index modulo info->nr
has been added to the -mm tree.  Its filename is
     aio-remove-spurious-ring-head-index-modulo-info-nr.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: remove spurious ring head index modulo info->nr
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

In aio_read_evt(), the ring->head will never wrap info->nr because
we already does the wrap when updating the ring head index:

        if (head != ring->tail) {
                ...
                head = (head + 1) % info->nr;
                ring->head = head;
        }

This makes the modulo of ring->head into local variable head unnecessary.
This patch removes that bogus code.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c      |    4 +--
 fs/aio.c.orig |   54 +++++++++++++++++++++++-------------------------
 2 files changed, 28 insertions(+), 30 deletions(-)

diff -puN fs/aio.c~aio-remove-spurious-ring-head-index-modulo-info-nr fs/aio.c
--- a/fs/aio.c~aio-remove-spurious-ring-head-index-modulo-info-nr
+++ a/fs/aio.c
@@ -1036,7 +1036,7 @@ static int aio_read_evt(struct kioctx *i
 {
 	struct aio_ring_info *info = &ioctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
+	unsigned int head;
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
@@ -1049,7 +1049,7 @@ static int aio_read_evt(struct kioctx *i
 
 	spin_lock(&info->ring_lock);
 
-	head = ring->head % info->nr;
+	head = ring->head;
 	if (head != ring->tail) {
 		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
 		*ent = *evp;
diff -puN fs/aio.c.orig~aio-remove-spurious-ring-head-index-modulo-info-nr fs/aio.c.orig
--- a/fs/aio.c.orig~aio-remove-spurious-ring-head-index-modulo-info-nr
+++ a/fs/aio.c.orig
@@ -1172,42 +1172,40 @@ retry:
 	}
 
 	aio_init_wait(&wait);
+wait:
+	prepare_to_wait_exclusive(&ctx->wait, &wait.wait, TASK_INTERRUPTIBLE);
+	ret = aio_read_evt(ctx, &ent);
+	if (!ret) {
+		wait.nr_wait = min_nr - i;
+		schedule();
+		if (signal_pending(tsk))
+			ret = -EINTR;
+	}
+	finish_wait(&ctx->wait, &wait.wait);
+
+	if (ret < 0)
+		goto out_cleanup;
+
 	while (likely(i < nr)) {
-		do {
-			prepare_to_wait_exclusive(&ctx->wait, &wait.wait,
-						  TASK_INTERRUPTIBLE);
-			ret = aio_read_evt(ctx, &ent);
-			if (ret)
-				break;
-			if (min_nr <= i)
-				break;
-			ret = 0;
-			if (to.timed_out)	/* Only check after read evt */
-				break;
-			wait.nr_wait = min_nr - i;
-			schedule();
-			if (signal_pending(tsk)) {
-				ret = -EINTR;
+		if (ret) {
+			if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
+				dprintk("aio: lost an event due to EFAULT.\n");
+				ret = -EFAULT;
 				break;
 			}
-			/*ret = aio_read_evt(ctx, &ent);*/
-		} while (1) ;
-		finish_wait(&ctx->wait, &wait.wait);
-
-		if (unlikely(ret <= 0))
-			break;
+			event++;
+			i++;
+		}
 
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+		ret = aio_read_evt(ctx, &ent);
+		if (unlikely(!ret)) {
+			if (i < min_nr && !to.timed_out)
+				goto wait;
 			break;
 		}
-
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
 	}
 
+out_cleanup:
 	if (timeout)
 		clear_timeout(&to);
 out:
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
aio-add-per-task-aio-wait-event-condition.patch
aio-streamline-read-events-after-woken-up.patch
aio-remove-spurious-ring-head-index-modulo-info-nr.patch
aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
