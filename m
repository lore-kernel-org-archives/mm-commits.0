From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-wake-pending-userfaults.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 11:04:26 -0700
Message-ID: <55ef232a.xD93JmWF7NXAtK4Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbbIHSE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: wake pending userfaults
has been removed from the -mm tree.  Its filename was
     userfaultfd-wake-pending-userfaults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: wake pending userfaults

This is an optimization but it's a userland visible one and it affects
the API.

The downside of this optimization is that if you call poll() and you
get POLLIN, read(ufd) may still return -EAGAIN. The blocked userfault
may be waken by a different thread, before read(ufd) comes
around. This in short means that poll() isn't really usable if the
userfaultfd is opened in blocking mode.

userfaults won't wait in "pending" state to be read anymore and any
UFFDIO_WAKE or similar operations that has the objective of waking
userfaults after their resolution, will wake all blocked userfaults
for the resolved range, including those that haven't been read() by
userland yet.

The behavior of poll() becomes not standard, but this obviates the
need of "spurious" UFFDIO_WAKE and it lets the userland threads to
restart immediately without requiring an UFFDIO_WAKE. This is even
more significant in case of repeated faults on the same address from
multiple threads.

This optimization is justified by the measurement that the number of
spurious UFFDIO_WAKE accounts for 5% and 10% of the total
userfaults for heavy workloads, so it's worth optimizing those away.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   65 +++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-wake-pending-userfaults fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-wake-pending-userfaults
+++ a/fs/userfaultfd.c
@@ -52,6 +52,10 @@ struct userfaultfd_ctx {
 struct userfaultfd_wait_queue {
 	struct uffd_msg msg;
 	wait_queue_t wq;
+	/*
+	 * Only relevant when queued in fault_wqh and only used by the
+	 * read operation to avoid reading the same userfault twice.
+	 */
 	bool pending;
 	struct userfaultfd_ctx *ctx;
 };
@@ -71,9 +75,6 @@ static int userfaultfd_wake_function(wai
 
 	uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
 	ret = 0;
-	/* don't wake the pending ones to avoid reads to block */
-	if (uwq->pending && !ACCESS_ONCE(uwq->ctx->released))
-		goto out;
 	/* len == 0 means wake all */
 	start = range->start;
 	len = range->len;
@@ -196,12 +197,14 @@ int handle_userfault(struct vm_area_stru
 	struct mm_struct *mm = vma->vm_mm;
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue uwq;
+	int ret;
 
 	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
+	ret = VM_FAULT_SIGBUS;
 	ctx = vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx)
-		return VM_FAULT_SIGBUS;
+		goto out;
 
 	BUG_ON(ctx->mm != mm);
 
@@ -214,7 +217,7 @@ int handle_userfault(struct vm_area_stru
 	 * caller of handle_userfault to release the mmap_sem.
 	 */
 	if (unlikely(ACCESS_ONCE(ctx->released)))
-		return VM_FAULT_SIGBUS;
+		goto out;
 
 	/*
 	 * Check that we can return VM_FAULT_RETRY.
@@ -240,15 +243,16 @@ int handle_userfault(struct vm_area_stru
 			dump_stack();
 		}
 #endif
-		return VM_FAULT_SIGBUS;
+		goto out;
 	}
 
 	/*
 	 * Handle nowait, not much to do other than tell it to retry
 	 * and wait.
 	 */
+	ret = VM_FAULT_RETRY;
 	if (flags & FAULT_FLAG_RETRY_NOWAIT)
-		return VM_FAULT_RETRY;
+		goto out;
 
 	/* take the reference before dropping the mmap_sem */
 	userfaultfd_ctx_get(ctx);
@@ -268,21 +272,23 @@ int handle_userfault(struct vm_area_stru
 	 * through poll/read().
 	 */
 	__add_wait_queue(&ctx->fault_wqh, &uwq.wq);
-	for (;;) {
-		set_current_state(TASK_KILLABLE);
-		if (!uwq.pending || ACCESS_ONCE(ctx->released) ||
-		    fatal_signal_pending(current))
-			break;
-		spin_unlock(&ctx->fault_wqh.lock);
+	set_current_state(TASK_KILLABLE);
+	spin_unlock(&ctx->fault_wqh.lock);
 
+	if (likely(!ACCESS_ONCE(ctx->released) &&
+		   !fatal_signal_pending(current))) {
 		wake_up_poll(&ctx->fd_wqh, POLLIN);
 		schedule();
+		ret |= VM_FAULT_MAJOR;
+	}
 
+	__set_current_state(TASK_RUNNING);
+	/* see finish_wait() comment for why list_empty_careful() */
+	if (!list_empty_careful(&uwq.wq.task_list)) {
 		spin_lock(&ctx->fault_wqh.lock);
+		list_del_init(&uwq.wq.task_list);
+		spin_unlock(&ctx->fault_wqh.lock);
 	}
-	__remove_wait_queue(&ctx->fault_wqh, &uwq.wq);
-	__set_current_state(TASK_RUNNING);
-	spin_unlock(&ctx->fault_wqh.lock);
 
 	/*
 	 * ctx may go away after this if the userfault pseudo fd is
@@ -290,7 +296,8 @@ int handle_userfault(struct vm_area_stru
 	 */
 	userfaultfd_ctx_put(ctx);
 
-	return VM_FAULT_RETRY;
+out:
+	return ret;
 }
 
 static int userfaultfd_release(struct inode *inode, struct file *file)
@@ -404,6 +411,12 @@ static unsigned int userfaultfd_poll(str
 	case UFFD_STATE_WAIT_API:
 		return POLLERR;
 	case UFFD_STATE_RUNNING:
+		/*
+		 * poll() never guarantees that read won't block.
+		 * userfaults can be waken before they're read().
+		 */
+		if (unlikely(!(file->f_flags & O_NONBLOCK)))
+			return POLLERR;
 		spin_lock(&ctx->fault_wqh.lock);
 		ret = find_userfault(ctx, NULL);
 		spin_unlock(&ctx->fault_wqh.lock);
@@ -834,11 +847,19 @@ out:
 }
 
 /*
- * This is mostly needed to re-wakeup those userfaults that were still
- * pending when userland wake them up the first time. We don't wake
- * the pending one to avoid blocking reads to block, or non blocking
- * read to return -EAGAIN, if used with POLLIN, to avoid userland
- * doubts on why POLLIN wasn't reliable.
+ * userfaultfd_wake is needed in case an userfault is in flight by the
+ * time a UFFDIO_COPY (or other ioctl variants) completes. The page
+ * may be well get mapped and the page fault if repeated wouldn't lead
+ * to a userfault anymore, but before scheduling in TASK_KILLABLE mode
+ * handle_userfault() doesn't recheck the pagetables and it doesn't
+ * serialize against UFFDO_COPY (or other ioctl variants). Ultimately
+ * the knowledge of which pages are mapped is left to userland who is
+ * responsible for handling the race between read() userfaults and
+ * background UFFDIO_COPY (or other ioctl variants), if done by
+ * separate concurrent threads.
+ *
+ * userfaultfd_wake may be used in combination with the
+ * UFFDIO_*_MODE_DONTWAKE to wakeup userfaults in batches.
  */
 static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
 			    unsigned long arg)
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

