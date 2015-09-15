From: akpm@linux-foundation.org
Subject: +
 userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch added to
 -mm tree
Date: Tue, 15 Sep 2015 13:04:41 -0700
Message-ID: <55f879d9.QsNAFr3XW3E9AKel%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbIOUEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 16:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: return an error if BOUNCE_VERIFY fails
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch

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
Subject: userfaultfd: selftest: return an error if BOUNCE_VERIFY fails

This will report the error in the exit code, in addition of the
fprintf.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-return-an-error-if-bounce_verify-fails tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-return-an-error-if-bounce_verify-fails
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -422,7 +422,7 @@ static int userfaultfd_stress(void)
 	struct uffdio_register uffdio_register;
 	struct uffdio_api uffdio_api;
 	unsigned long cpu;
-	int uffd_flags;
+	int uffd_flags, err;
 	unsigned long userfaults[nr_cpus];
 
 	if (posix_memalign(&area, page_size, nr_pages * page_size)) {
@@ -499,6 +499,7 @@ static int userfaultfd_stress(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
 
+	err = 0;
 	while (bounces--) {
 		unsigned long expected_ioctls;
 
@@ -583,8 +584,9 @@ static int userfaultfd_stress(void)
 					    area_dst + nr * page_size,
 					    sizeof(pthread_mutex_t))) {
 					fprintf(stderr,
-						"error mutex 2 %lu\n",
+						"error mutex %lu\n",
 						nr);
+					err = 1;
 					bounces = 0;
 				}
 				if (*area_count(area_dst, nr) != count_verify[nr]) {
@@ -593,6 +595,7 @@ static int userfaultfd_stress(void)
 						*area_count(area_src, nr),
 						count_verify[nr],
 						nr);
+					err = 1;
 					bounces = 0;
 				}
 			}
@@ -609,7 +612,7 @@ static int userfaultfd_stress(void)
 		printf("\n");
 	}
 
-	return 0;
+	return err;
 }
 
 int main(int argc, char **argv)
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-selftest-headers-fixup.patch
userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc.patch
userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch
userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch

