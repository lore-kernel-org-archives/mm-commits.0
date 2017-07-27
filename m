From: akpm@linux-foundation.org
Subject: +
 userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch
 added to -mm tree
Date: Thu, 27 Jul 2017 16:42:08 -0700
Message-ID: <597a7a50.zwSDIGD9B3hmTQ4H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37962 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdG0XmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: enable testing of UFFDIO_ZEROPAGE for shmem
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

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
Subject: userfaultfd: selftest: enable testing of UFFDIO_ZEROPAGE for shmem

Link: http://lkml.kernel.org/r/1497939652-16528-8-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -198,7 +198,7 @@ static struct uffd_test_ops anon_uffd_te
 };
 
 static struct uffd_test_ops shmem_uffd_test_ops = {
-	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC,
+	.expected_ioctls = ANON_EXPECTED_IOCTLS,
 	.allocate_area	= shmem_allocate_area,
 	.release_pages	= shmem_release_pages,
 };
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch
userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch
shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update.patch
shmem-introduce-shmem_inode_acct_block.patch
userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support.patch
userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch
userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch
userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

