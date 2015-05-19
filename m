From: akpm@linux-foundation.org
Subject: + userfaultfd-wake-pending-userfaults.patch added to -mm tree
Date: Tue, 19 May 2015 14:38:49 -0700
Message-ID: <555bad69.MET2Xqe0LCmWcXEN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbESViu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: wake pending userfaults
has been added to the -mm tree.  Its filename is
     userfaultfd-wake-pending-userfaults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-wake-pending-userfaults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-wake-pending-userfaults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -183,12 +184,14 @@ int handle_userfault(struct vm_area_stru
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
 
@@ -201,7 +204,7 @@ int handle_userfault(struct vm_area_stru
 	 * caller of handle_userfault to release the mmap_sem.
 	 */
 	if (unlikely(ACCESS_ONCE(ctx->released)))
-		return VM_FAULT_SIGBUS;
+		goto out;
 
 	/*
 	 * Check that we can return VM_FAULT_RETRY.
@@ -227,15 +230,16 @@ int handle_userfault(struct vm_area_stru
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
@@ -255,21 +259,23 @@ int handle_userfault(struct vm_area_stru
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
@@ -277,7 +283,8 @@ int handle_userfault(struct vm_area_stru
 	 */
 	userfaultfd_ctx_put(ctx);
 
-	return VM_FAULT_RETRY;
+out:
+	return ret;
 }
 
 static int userfaultfd_release(struct inode *inode, struct file *file)
@@ -391,6 +398,12 @@ static unsigned int userfaultfd_poll(str
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
@@ -821,11 +834,19 @@ out:
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

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

