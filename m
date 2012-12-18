From: akpm@linux-foundation.org
Subject: [merged] mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:05 -0800
Message-ID: <20121218201206.1DD4E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52278 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2LRUMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:07 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so126337vcq.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mqueue selftests: print failure status instead of cause make error
has been removed from the -mm tree.  Its filename was
     mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: mqueue selftests: print failure status instead of cause make error

Original behavior:
  bash-4.1$ make -C mqueue run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
  ./mq_open_tests /test1
  Not running as root, but almost all tests require root in order to modify
  system settings.  Exiting.
  make: *** [run_tests] Error 1
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'

After applying the patch:
  bash-4.1$ make -C mqueue run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
  Not running as root, but almost all tests require root in order to modify
  system settings.  Exiting.
  mq_open_tests: [FAIL]
  Not running as root, but almost all tests require root in order to modify
  system settings.  Exiting.
  mq_perf_tests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mqueue/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/mqueue/Makefile~mqueue-selftests-print-failure-status-instead-of-cause-make-error tools/testing/selftests/mqueue/Makefile
--- a/tools/testing/selftests/mqueue/Makefile~mqueue-selftests-print-failure-status-instead-of-cause-make-error
+++ a/tools/testing/selftests/mqueue/Makefile
@@ -3,8 +3,8 @@ all:
 	gcc -O2 -lrt -lpthread -lpopt -o mq_perf_tests mq_perf_tests.c
 
 run_tests:
-	./mq_open_tests /test1
-	./mq_perf_tests
+	@./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
+	@./mq_perf_tests || echo "mq_perf_tests: [FAIL]"
 
 clean:
 	rm -f mq_open_tests mq_perf_tests
_

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch

