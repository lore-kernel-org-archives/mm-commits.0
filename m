From: akpm@linux-foundation.org
Subject: +
 userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
 added to -mm tree
Date: Wed, 08 Jul 2015 15:42:16 -0700
Message-ID: <559da748.I8P/Sut3puc5TYgm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbGHWmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: avoid missing wakeups during refile in userfaultfd_read
has been added to the -mm tree.  Its filename is
     userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch

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

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt-fix.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-activate-syscall-fix.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
userfaultfd-require-uffdio_api-before-other-ioctls.patch
userfaultfd-allow-signals-to-interrupt-a-userfault.patch
userfaultfd-propagate-the-full-address-in-thp-faults.patch
userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
userfaultfd-selftest.patch
fs-userfaultfdc-work-around-i386-build-error.patch
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

