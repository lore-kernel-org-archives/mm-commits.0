From: akpm@linux-foundation.org
Subject: +
 userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch
 added to -mm tree
Date: Mon, 16 Oct 2017 15:19:26 -0700
Message-ID: <59e5306e.k4QZcXWk32Ltd2D/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932531AbdJPWT1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: use mmgrab instead of open-coded increment of mm_count
has been added to the -mm tree.  Its filename is
     userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch

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

userfaultfd-use-mmgrab-instead-of-open-coded-increment-of-mm_count.patch

