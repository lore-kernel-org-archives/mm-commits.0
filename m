From: akpm@osdl.org
Subject: - aio-streamline-read-events-after-woken-up.patch removed from -mm tree
Date: Tue, 02 Jan 2007 17:10:15 -0800
Message-ID: <200701030110.l031AcWs003706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbXACBLq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 20:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: streamline read events after woken up
has been removed from the -mm tree.  Its filename was
     aio-streamline-read-events-after-woken-up.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: aio: streamline read events after woken up
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

The read event loop in the blocking path is also inefficient. For every
event it reap (if not blocking), it does the following in a loop:

      while (i < nr) {
            prepare_to_wait_exclusive
            aio_read_evt
            finish_wait
            ...
      }

Given the previous patch "aio: add per task aio wait event condition"
that we properly wake up event waiting process knowing that we have
enough events to reap, it's just plain waste of time to insert itself
into a wait queue, and then immediately remove itself from the wait
queue for *every* event reap iteration.

This patch factors out the wait queue insertion/deletion out of the event
reap loop, streamlines the event reaping after the process wakes up.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |   54 +++++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff -puN fs/aio.c~aio-streamline-read-events-after-woken-up fs/aio.c
--- a/fs/aio.c~aio-streamline-read-events-after-woken-up
+++ a/fs/aio.c
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
aio-streamline-read-events-after-woken-up.patch
aio-remove-spurious-ring-head-index-modulo-info-nr.patch
aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
