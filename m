From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:28:09 -0700
Message-ID: <55ea1af9.hF5xlXxYOyT+JUXM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-add-new-syscall-to-provide-memory-externalization-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch

This patch was dropped because it was folded into userfaultfd-add-new-syscall-to-provide-memory-externalization.patch

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
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
userfaultfd-require-uffdio_api-before-other-ioctls.patch
userfaultfd-allow-signals-to-interrupt-a-userfault.patch
userfaultfd-propagate-the-full-address-in-thp-faults.patch
userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
userfaultfd-selftest.patch

