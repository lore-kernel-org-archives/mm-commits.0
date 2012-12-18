From: akpm@linux-foundation.org
Subject: [merged] cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:08 -0800
Message-ID: <20121218201209.17687100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36887 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2LRUMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:10 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so126276qcq.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu-hotplug selftests: print failure status instead of cause make error
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: cpu-hotplug selftests: print failure status instead of cause make error

  bash-4.1$ make -C cpu-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
  ./on-off-test.sh
  make: execvp: ./on-off-test.sh: Permission denied
  make: *** [run_tests] Error 127
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'

After applying the patch:
  bash-4.1$ make -C cpu-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
  /bin/sh: ./on-off-test.sh: Permission denied
  cpu-hotplug selftests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cpu-hotplug/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/cpu-hotplug/Makefile~cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error tools/testing/selftests/cpu-hotplug/Makefile
--- a/tools/testing/selftests/cpu-hotplug/Makefile~cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error
+++ a/tools/testing/selftests/cpu-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	./on-off-test.sh
+	@./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
 clean:
_

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch

