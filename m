From: akpm@linux-foundation.org
Subject: +
 userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch added to -mm tree
Date: Wed, 02 Aug 2017 14:29:40 -0700
Message-ID: <59824444.9fXgcomS9EWOPbbX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdHBV3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.perevalov@samsung.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: explicit failure if the SIGBUS test failed
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch

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
Subject: userfaultfd: selftest: explicit failure if the SIGBUS test failed

Showing zero in the output isn't very self explanatory as a successful
result. Show a more explicit error output if the test fails.

Link: http://lkml.kernel.org/r/20170802165145.22628-4-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -986,7 +986,9 @@ static int userfaultfd_sig_test(void)
 		return 1;
 
 	printf("done.\n");
-	printf(" Signal test userfaults: %ld\n", userfaults);
+	if (userfaults)
+		fprintf(stderr, "Signal test failed, userfaults: %ld\n",
+			userfaults);
 	close(uffd);
 	return userfaults != 0;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

