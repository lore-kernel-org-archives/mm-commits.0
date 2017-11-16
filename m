From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:03:33 -0800
Message-ID: <20171116200333.6BbBQyCQg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935293AbdKPUDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com


The patch titled
     Subject: userfaultfd: use mmgrab instead of open-coded increment of mm_count
has been removed from the -mm tree.  Its filename was
     userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: use mmgrab instead of open-coded increment of mm_count

Link: http://lkml.kernel.org/r/1508132478-7738-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count
+++ a/fs/userfaultfd.c
@@ -668,7 +668,7 @@ int dup_userfaultfd(struct vm_area_struc
 		ctx->features = octx->features;
 		ctx->released = false;
 		ctx->mm = vma->vm_mm;
-		atomic_inc(&ctx->mm->mm_count);
+		mmgrab(ctx->mm);
 
 		userfaultfd_ctx_get(octx);
 		fctx->orig = octx;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


