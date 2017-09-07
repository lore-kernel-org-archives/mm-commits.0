From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:41:04 -0700
Message-ID: <20170907184104.l8ENLPO1U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753606AbdIGSlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.perevalov@samsung.com, aarcange@redhat.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com


The patch titled
     Subject: userfaultfd: selftest: explicit failure if the SIGBUS test failed
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -987,7 +987,9 @@ static int userfaultfd_sig_test(void)
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

userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus.patch

