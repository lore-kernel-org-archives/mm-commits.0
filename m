From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc.patch
 removed from -mm tree
Date: Mon, 28 Sep 2015 11:15:48 -0700
Message-ID: <560983d4.Z0kfQMWlnGYYbn2V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: avoid my_bcmp false positives with powerpc
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: avoid my_bcmp false positives with powerpc

Keep a non-zero placeholder after the count, for the my_bcmp comparison of
the page against the zeropage.  The lockless increment between 255 to 256
against a lockless my_bcmp could otherwise return false positives on
ppc32le.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -465,6 +465,14 @@ static int userfaultfd_stress(void)
 		*area_mutex(area_src, nr) = (pthread_mutex_t)
 			PTHREAD_MUTEX_INITIALIZER;
 		count_verify[nr] = *area_count(area_src, nr) = 1;
+		/*
+		 * In the transition between 255 to 256, powerpc will
+		 * read out of order in my_bcmp and see both bytes as
+		 * zero, so leave a placeholder below always non-zero
+		 * after the count, to avoid my_bcmp to trigger false
+		 * positives.
+		 */
+		*(area_count(area_src, nr) + 1) = 1;
 	}
 
 	pipefd = malloc(sizeof(int) * nr_cpus * 2);
@@ -610,8 +618,8 @@ int main(int argc, char **argv)
 		fprintf(stderr, "Usage: <MiB> <bounces>\n"), exit(1);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	page_size = sysconf(_SC_PAGE_SIZE);
-	if ((unsigned long) area_count(NULL, 0) + sizeof(unsigned long long) >
-	    page_size)
+	if ((unsigned long) area_count(NULL, 0) + sizeof(unsigned long long) * 2
+	    > page_size)
 		fprintf(stderr, "Impossible to run this test\n"), exit(2);
 	nr_pages_per_cpu = atol(argv[1]) * 1024*1024 / page_size /
 		nr_cpus;
_

Patches currently in -mm which might be from aarcange@redhat.com are


