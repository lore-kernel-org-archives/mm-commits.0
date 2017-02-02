From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch added to -mm tree
Date: Thu, 02 Feb 2017 14:55:16 -0800
Message-ID: <5893b8d4.flhx1uUrdSzpOSa0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbdBBWzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-non-cooperative-add-event-for-exit-notification-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch
userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch

