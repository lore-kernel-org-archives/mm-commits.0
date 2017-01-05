From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
 added to -mm tree
Date: Wed, 04 Jan 2017 16:53:43 -0800
Message-ID: <586d9917.+COvfcdDtJi0VBaV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935666AbdAEAyU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: optimize mremap_userfaultfd_complete()
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: optimize mremap_userfaultfd_complete()

Optimize the mremap_userfaultfd_complete() interface to pass only the
vm_userfaultfd_ctx pointer through the stack as a microoptimization.

Link: http://lkml.kernel.org/r/20161216144821.5183-13-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |    4 ++--
 include/linux/userfaultfd_k.h |    4 ++--
 mm/mremap.c                   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete
+++ a/fs/userfaultfd.c
@@ -575,11 +575,11 @@ void mremap_userfaultfd_prep(struct vm_a
 	}
 }
 
-void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx vm_ctx,
+void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *vm_ctx,
 				 unsigned long from, unsigned long to,
 				 unsigned long len)
 {
-	struct userfaultfd_ctx *ctx = vm_ctx.ctx;
+	struct userfaultfd_ctx *ctx = vm_ctx->ctx;
 	struct userfaultfd_wait_queue ewq;
 
 	if (!ctx)
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete
+++ a/include/linux/userfaultfd_k.h
@@ -57,7 +57,7 @@ extern void dup_userfaultfd_complete(str
 
 extern void mremap_userfaultfd_prep(struct vm_area_struct *,
 				    struct vm_userfaultfd_ctx *);
-extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx,
+extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *,
 					unsigned long from, unsigned long to,
 					unsigned long len);
 
@@ -100,7 +100,7 @@ static inline void mremap_userfaultfd_pr
 {
 }
 
-static inline void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx ctx,
+static inline void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *ctx,
 					       unsigned long from,
 					       unsigned long to,
 					       unsigned long len)
diff -puN mm/mremap.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete mm/mremap.c
--- a/mm/mremap.c~userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete
+++ a/mm/mremap.c
@@ -608,6 +608,6 @@ out:
 	up_write(&current->mm->mmap_sem);
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
-	mremap_userfaultfd_complete(uf, addr, new_addr, old_len);
+	mremap_userfaultfd_complete(&uf, addr, new_addr, old_len);
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

