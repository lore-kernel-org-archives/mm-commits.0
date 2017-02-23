From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:13:52 -0800
Message-ID: <58af5090.2X8imDw30Qgujxnq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdBWVOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: wake userfaults after UFFDIO_UNREGISTER
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: wake userfaults after UFFDIO_UNREGISTER

Userfaults may still happen after the userfaultfd monitor thread received
a UFFD_EVENT_MADVDONTNEED until UFFDIO_UNREGISTER is run.

Wake any pending userfault within UFFDIO_UNREGISTER protected by the
mmap_sem for writing, so they will not be reported to userland leading to
UFFDIO_COPY returning -EINVAL (as the range was already unregistered) and
they will not hang permanently either.

Link: http://lkml.kernel.org/r/20161216144821.5183-16-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister
+++ a/fs/userfaultfd.c
@@ -1302,6 +1302,19 @@ static int userfaultfd_unregister(struct
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		if (userfaultfd_missing(vma)) {
+			/*
+			 * Wake any concurrent pending userfault while
+			 * we unregister, so they will not hang
+			 * permanently and it avoids userland to call
+			 * UFFDIO_WAKE explicitly.
+			 */
+			struct userfaultfd_wake_range range;
+			range.start = start;
+			range.len = vma_end - start;
+			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
+		}
+
 		new_flags = vma->vm_flags & ~(VM_UFFD_MISSING | VM_UFFD_WP);
 		prev = vma_merge(mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

