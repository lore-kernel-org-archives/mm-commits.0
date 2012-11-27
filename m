From: akpm@linux-foundation.org
Subject: + mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:41:49 -0800
Message-ID: <20121127204149.96310100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59800 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2K0Ulu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:41:50 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so405148ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:41:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, penberg@kernel.org


The patch titled
     Subject: mqueue selftests: print failure status instead of cause make error
has been added to the -mm tree.  Its filename is
     mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vm-selftests-print-failure-status-instead-of-cause-make-error.patch
mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch
cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
breakpoint-selftests-print-failure-status-instead-of-cause-make-error.patch

