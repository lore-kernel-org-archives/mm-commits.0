From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:13:37 -0800
Message-ID: <58af5081.P0/m1odNubNXmqne%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdBWVOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: dup_userfaultfd: use mm_count instead of mm_users
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: dup_userfaultfd: use mm_count instead of mm_users

Since commit d2005e3f41d4 (userfaultfd: don't pin the user memory in
userfaultfd_file_create()) userfaultfd uses mm_count rather than mm_users
to pin mm_struct.  Make dup_userfaultfd consistent with this behaviour

Link: http://lkml.kernel.org/r/20161216144821.5183-11-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users
+++ a/fs/userfaultfd.c
@@ -558,7 +558,7 @@ int dup_userfaultfd(struct vm_area_struc
 		ctx->features = octx->features;
 		ctx->released = false;
 		ctx->mm = vma->vm_mm;
-		atomic_inc(&ctx->mm->mm_users);
+		atomic_inc(&ctx->mm->mm_count);
 
 		userfaultfd_ctx_get(octx);
 		fctx->orig = octx;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch
userfaultfd-documentation-update.patch

