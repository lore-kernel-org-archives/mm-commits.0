From: akpm@linux-foundation.org
Subject: + userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
 added to -mm tree
Date: Wed, 04 Jan 2017 16:54:22 -0800
Message-ID: <586d993e.Hle7BdpbB1mTb0pp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935064AbdAEAy0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add tlbflush.h header for microblaze
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch

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
Subject: userfaultfd: shmem: add tlbflush.h header for microblaze

It resolves this build error:

All errors (new ones prefixed by >>):

   mm/shmem.c: In function 'shmem_mcopy_atomic_pte':
   >> mm/shmem.c:2228:2: error: implicit declaration of function
   'update_mmu_cache' [-Werror=implicit-function-declaration]
        update_mmu_cache(dst_vma, dst_addr, dst_pte);

microblaze may have to be also updated to define it in asm/pgtable.h like
the other archs, then this header inclusion can be removed.

Link: http://lkml.kernel.org/r/20161216144821.5183-31-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/shmem.c~userfaultfd-shmem-add-tlbflushh-header-for-microblaze mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-add-tlbflushh-header-for-microblaze
+++ a/mm/shmem.c
@@ -34,6 +34,8 @@
 #include <linux/uio.h>
 #include <linux/khugepaged.h>
 
+#include <asm/tlbflush.h> /* for arch/microblaze update_mmu_cache() */
+
 static struct vfsmount *shm_mnt;
 
 #ifdef CONFIG_SHMEM
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

