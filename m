From: akpm@linux-foundation.org
Subject: [patch 012/124] userfaultfd: non-cooperative: selftest: enable
 REMOVE event test for shmem
Date: Fri, 24 Feb 2017 14:56:08 -0800
Message-ID: <58b0ba08.EOdGIAfk25zF22A1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com

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
