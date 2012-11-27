From: akpm@linux-foundation.org
Subject: + mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:41:55 -0800
Message-ID: <20121127204156.A217820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:56890 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2K0Ul7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:41:59 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so668890fae.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:41:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, penberg@kernel.org


The patch titled
     Subject: mem-hotplug selftests: print failure status instead of cause make error
has been added to the -mm tree.  Its filename is
     mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch

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

vm-selftests-print-failure-status-instead-of-cause-make-error.patch
mqueue-selftests-print-failure-status-instead-of-cause-make-error.patch
cpu-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
mem-hotplug-selftests-print-failure-status-instead-of-cause-make-error.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
breakpoint-selftests-print-failure-status-instead-of-cause-make-error.patch

