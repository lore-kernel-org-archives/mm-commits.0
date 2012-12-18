From: akpm@linux-foundation.org
Subject: [merged] mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:11 -0800
Message-ID: <20121218201212.12B5D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58680 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2LRUMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:12 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so126287ggn.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug selftests: print failure status instead of cause make error
has been removed from the -mm tree.  Its filename was
     mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: mem-hotplug selftests: print failure status instead of cause make error

  bash-4.1$ make -C memory-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
  ./on-off-test.sh
  make: execvp: ./on-off-test.sh: Permission denied
  make: *** [run_tests] Error 127
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'

After applying the patch:
  bash-4.1$ make -C memory-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
  /bin/sh: ./on-off-test.sh: Permission denied
  memory-hotplug selftests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memory-hotplug/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/memory-hotplug/Makefile~mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error tools/testing/selftests/memory-hotplug/Makefile
--- a/tools/testing/selftests/memory-hotplug/Makefile~mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error
+++ a/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	./on-off-test.sh
+	@./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
_

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch

