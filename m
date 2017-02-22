From: akpm@linux-foundation.org
Subject: [patch 055/142] userfaultfd: non-cooperative: dup_userfaultfd:
 use mm_count instead of mm_users
Date: Wed, 22 Feb 2017 15:42:30 -0800
Message-ID: <58ae21e6.GRabmZvgyQmfQMzK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934638AbdBVXmo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com

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
