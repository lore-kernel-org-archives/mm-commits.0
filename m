From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-linux-documentation-vm-userfaultfdtxt-fix.patch removed from
 -mm tree
Date: Fri, 04 Sep 2015 15:27:25 -0700
Message-ID: <55ea1acd.qVL10gea05NCV7gF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: documentation update
has been removed from the -mm tree.  Its filename was
     userfaultfd-linux-documentation-vm-userfaultfdtxt-fix.patch

This patch was dropped because it was folded into userfaultfd-linux-documentation-vm-userfaultfdtxt.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: documentation update

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/userfaultfd.txt~userfaultfd-linux-documentation-vm-userfaultfdtxt-fix Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~userfaultfd-linux-documentation-vm-userfaultfdtxt-fix
+++ a/Documentation/vm/userfaultfd.txt
@@ -3,8 +3,8 @@
 == Objective ==
 
 Userfaults allow the implementation of on-demand paging from userland
-and more generally they allow userland to take control various memory
-page faults, something otherwise only the kernel code could do.
+and more generally they allow userland to take control of various
+memory page faults, something otherwise only the kernel code could do.
 
 For example userfaults allows a proper and more optimal implementation
 of the PROT_NONE+SIGSEGV trick.
@@ -75,7 +75,9 @@ The primary ioctl to resolve userfaults
 atomically copies a page into the userfault registered range and wakes
 up the blocked userfaults (unless uffdio_copy.mode &
 UFFDIO_COPY_MODE_DONTWAKE is set). Other ioctl works similarly to
-UFFDIO_COPY.
+UFFDIO_COPY. They're atomic as in guaranteeing that nothing can see an
+half copied page since it'll keep userfaulting until the copy has
+finished.
 
 == QEMU/KVM ==
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
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

