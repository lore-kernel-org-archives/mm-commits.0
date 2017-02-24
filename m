From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:37:56 -0800
Message-ID: <58b0b5c4.0NV28jBHtDBczx9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbdBXWh5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-non-cooperative-add-event-for-exit-notification-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch

This patch was dropped because it was folded into userfaultfd-non-cooperative-add-event-for-exit-notification.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd-non-cooperative-add-event-for-exit-notification-fix

add comment

Link: http://lkml.kernel.org/r/20170202135448.GB19804@rapoport-lnx
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-event-for-exit-notification-fix fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-event-for-exit-notification-fix
+++ a/fs/userfaultfd.c
@@ -778,6 +778,10 @@ void userfaultfd_exit(struct mm_struct *
 {
 	struct vm_area_struct *vma = mm->mmap;
 
+	/*
+	 * We can do the vma walk without locking because the caller
+	 * (exit_mm) knows it now has exclusive access
+	 */
 	while (vma) {
 		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
 
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch
userfaultfd-documentation-update.patch

