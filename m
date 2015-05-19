From: akpm@linux-foundation.org
Subject: +
 userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
 added to -mm tree
Date: Tue, 19 May 2015 14:38:41 -0700
Message-ID: <555bad61.aYnaHx542uUpNYzm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbbESVim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-add-new-syscall-to-provide-memory-externalization-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch

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
Subject: userfaultfd-add-new-syscall-to-provide-memory-externalization-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-add-new-syscall-to-provide-memory-externalization-fix fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-add-new-syscall-to-provide-memory-externalization-fix
+++ a/fs/userfaultfd.c
@@ -478,6 +478,21 @@ static void __wake_userfault(struct user
 static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
 					   struct userfaultfd_wake_range *range)
 {
+	/*
+	 * To be sure waitqueue_active() is not reordered by the CPU
+	 * before the pagetable update, use an explicit SMP memory
+	 * barrier here. PT lock release or up_read(mmap_sem) still
+	 * have release semantics that can allow the
+	 * waitqueue_active() to be reordered before the pte update.
+	 */
+	smp_mb();
+
+	/*
+	 * Use waitqueue_active because it's very frequent to
+	 * change the address space atomically even if there are no
+	 * userfaults yet. So we take the spinlock only when we're
+	 * sure we've userfaults to wake.
+	 */
 	if (waitqueue_active(&ctx->fault_wqh))
 		__wake_userfault(ctx, range);
 }
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

