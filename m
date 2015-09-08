From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:05:02 -0700
Message-ID: <55ef234e.ACulqrLdcjgYQaCi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: avoid missing wakeups during refile in userfaultfd_read
has been removed from the -mm tree.  Its filename was
     userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: avoid missing wakeups during refile in userfaultfd_read

During the refile in userfaultfd_read both waitqueues could look empty to
the lockless wake_userfault().  Use a seqcount to prevent this false
negative that could leave an userfault blocked.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read
+++ a/fs/userfaultfd.c
@@ -45,6 +45,8 @@ struct userfaultfd_ctx {
 	wait_queue_head_t fault_wqh;
 	/* waitqueue head for the pseudo fd to wakeup poll/read */
 	wait_queue_head_t fd_wqh;
+	/* a refile sequence protected by fault_pending_wqh lock */
+	struct seqcount refile_seq;
 	/* pseudo fd refcounting */
 	atomic_t refcount;
 	/* userfaultfd syscall flags */
@@ -547,6 +549,15 @@ static ssize_t userfaultfd_ctx_read(stru
 		uwq = find_userfault(ctx);
 		if (uwq) {
 			/*
+			 * Use a seqcount to repeat the lockless check
+			 * in wake_userfault() to avoid missing
+			 * wakeups because during the refile both
+			 * waitqueue could become empty if this is the
+			 * only userfault.
+			 */
+			write_seqcount_begin(&ctx->refile_seq);
+
+			/*
 			 * The fault_pending_wqh.lock prevents the uwq
 			 * to disappear from under us.
 			 *
@@ -570,6 +581,8 @@ static ssize_t userfaultfd_ctx_read(stru
 			list_del(&uwq->wq.task_list);
 			__add_wait_queue(&ctx->fault_wqh, &uwq->wq);
 
+			write_seqcount_end(&ctx->refile_seq);
+
 			/* careful to always initialize msg if ret == 0 */
 			*msg = uwq->msg;
 			spin_unlock(&ctx->fault_pending_wqh.lock);
@@ -647,6 +660,9 @@ static void __wake_userfault(struct user
 static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
 					   struct userfaultfd_wake_range *range)
 {
+	unsigned seq;
+	bool need_wakeup;
+
 	/*
 	 * To be sure waitqueue_active() is not reordered by the CPU
 	 * before the pagetable update, use an explicit SMP memory
@@ -662,8 +678,13 @@ static __always_inline void wake_userfau
 	 * userfaults yet. So we take the spinlock only when we're
 	 * sure we've userfaults to wake.
 	 */
-	if (waitqueue_active(&ctx->fault_pending_wqh) ||
-	    waitqueue_active(&ctx->fault_wqh))
+	do {
+		seq = read_seqcount_begin(&ctx->refile_seq);
+		need_wakeup = waitqueue_active(&ctx->fault_pending_wqh) ||
+			waitqueue_active(&ctx->fault_wqh);
+		cond_resched();
+	} while (read_seqcount_retry(&ctx->refile_seq, seq));
+	if (need_wakeup)
 		__wake_userfault(ctx, range);
 }
 
@@ -1219,6 +1240,7 @@ static void init_once_userfaultfd_ctx(vo
 	init_waitqueue_head(&ctx->fault_pending_wqh);
 	init_waitqueue_head(&ctx->fault_wqh);
 	init_waitqueue_head(&ctx->fd_wqh);
+	seqcount_init(&ctx->refile_seq);
 }
 
 /**
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

