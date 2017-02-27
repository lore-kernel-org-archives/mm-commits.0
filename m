From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:37 -0800
Message-ID: <58b48b05.KxLCqtSJV5zniCJS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdB0UYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: selftest: enable REMOVE event test for shmem
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: selftest: enable REMOVE event test for shmem

Now when madvise(MADV_REMOVE) notifies uffd reader, we should verify that
appliciation actually sees zeros at the removed range.

Link: http://lkml.kernel.org/r/1484814154-1557-4-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -569,9 +569,9 @@ static int userfaultfd_open(int features
  * part is accessed after mremap. Since hugetlbfs does not support
  * mremap, the entire monitored area is accessed in a single pass for
  * HUGETLB_TEST.
- * The release of the pages currently generates event only for
+ * The release of the pages currently generates event for shmem and
  * anonymous memory (UFFD_EVENT_REMOVE), hence it is not checked
- * for hugetlb and shmem.
+ * for hugetlb.
  */
 static int faulting_process(void)
 {
@@ -610,7 +610,6 @@ static int faulting_process(void)
 		}
 	}
 
-#ifndef SHMEM_TEST
 	if (release_pages(area_dst))
 		return 1;
 
@@ -618,7 +617,6 @@ static int faulting_process(void)
 		if (my_bcmp(area_dst + nr * page_size, zeropage, page_size))
 			fprintf(stderr, "nr %lu is not zero\n", nr), exit(1);
 	}
-#endif /* SHMEM_TEST */
 
 #endif /* HUGETLB_TEST */
 
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


