From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:38 -0800
Message-ID: <586d9912.kGR3sJRztrbCO/tF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36182 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935169AbdAEAyU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: dup_userfaultfd: use mm_count instead of mm_users
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch

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
@@ -525,7 +525,7 @@ int dup_userfaultfd(struct vm_area_struc
 		ctx->features = octx->features;
 		ctx->released = false;
 		ctx->mm = vma->vm_mm;
-		atomic_inc(&ctx->mm->mm_users);
+		atomic_inc(&ctx->mm->mm_count);
 
 		userfaultfd_ctx_get(octx);
 		fctx->orig = octx;
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

