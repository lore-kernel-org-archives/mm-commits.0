From: akpm@linux-foundation.org
Subject: [folded-merged] userfaultfd-uapi-add-missing-include-typesh.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:27:50 -0700
Message-ID: <55ea1ae6.hyzNCqA6WN/1faYM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: uAPI: add missing include/types.h
has been removed from the -mm tree.  Its filename was
     userfaultfd-uapi-add-missing-include-typesh.patch

This patch was dropped because it was folded into userfaultfd-uapi.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: uAPI: add missing include/types.h

This will avoid the below warning:

./usr/include/linux/userfaultfd.h:14: found __[us]{8,16,32,64} type
without #include <linux/types.h>

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-uapi-add-missing-include-typesh include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-uapi-add-missing-include-typesh
+++ a/include/uapi/linux/userfaultfd.h
@@ -9,6 +9,8 @@
 #ifndef _LINUX_USERFAULTFD_H
 #define _LINUX_USERFAULTFD_H
 
+#include <linux/types.h>
+
 #define UFFD_API ((__u64)0xAA)
 /* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
 #define UFFD_API_BITS (UFFD_BIT_WRITE)
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

