From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:34 -0800
Message-ID: <586d994a.cwIWs2jxJkbtbQht%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937517AbdAEAya (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: avoid leaking blocks and used blocks in UFFDIO_COPY
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch

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
Subject: userfaultfd: shmem: avoid leaking blocks and used blocks in UFFDIO_COPY

If the atomic copy_user fails because of a real dangling userland
pointer, we won't go back into the shmem method, so when the method
returns it must not leave anything charged up, except the page itself.

Link: http://lkml.kernel.org/r/20161216144821.5183-37-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/shmem.c~userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy
+++ a/mm/shmem.c
@@ -2207,17 +2207,17 @@ int shmem_mcopy_atomic_pte(struct mm_str
 	pte_t _dst_pte, *dst_pte;
 	int ret;
 
-	if (!*pagep) {
-		ret = -ENOMEM;
-		if (shmem_acct_block(info->flags, 1))
-			goto out;
-		if (sbinfo->max_blocks) {
-			if (percpu_counter_compare(&sbinfo->used_blocks,
-						   sbinfo->max_blocks) >= 0)
-				goto out_unacct_blocks;
-			percpu_counter_inc(&sbinfo->used_blocks);
-		}
+	ret = -ENOMEM;
+	if (shmem_acct_block(info->flags, 1))
+		goto out;
+	if (sbinfo->max_blocks) {
+		if (percpu_counter_compare(&sbinfo->used_blocks,
+					   sbinfo->max_blocks) >= 0)
+			goto out_unacct_blocks;
+		percpu_counter_inc(&sbinfo->used_blocks);
+	}
 
+	if (!*pagep) {
 		page = shmem_alloc_page(gfp, info, pgoff);
 		if (!page)
 			goto out_dec_used_blocks;
@@ -2230,6 +2230,9 @@ int shmem_mcopy_atomic_pte(struct mm_str
 		/* fallback to copy_from_user outside mmap_sem */
 		if (unlikely(ret)) {
 			*pagep = page;
+			if (sbinfo->max_blocks)
+				percpu_counter_add(&sbinfo->used_blocks, -1);
+			shmem_unacct_blocks(info->flags, 1);
 			/* don't free the page */
 			return -EFAULT;
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

