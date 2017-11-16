From: akpm@linux-foundation.org
Subject: [patch 092/131] userfaultfd: use mmgrab instead of
 open-coded increment of mm_count
Date: Wed, 15 Nov 2017 17:36:56 -0800
Message-ID: <20171116013656.KQZUPvbCt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933052AbdKPBg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dgilbert@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org

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
