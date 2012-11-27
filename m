From: akpm@linux-foundation.org
Subject: + kcmp-selftests-make-run_tests-fix.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:41:59 -0800
Message-ID: <20121127204200.68CFE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:56890 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2K0UmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:42:02 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so668890fae.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:42:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, gorcunov@openvz.org, penberg@kernel.org


The patch titled
     Subject: kcmp selftests: make run_tests fix
has been added to the -mm tree.  Its filename is
     kcmp-selftests-make-run_tests-fix.patch

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
Subject: kcmp selftests: make run_tests fix

make run_tests need the target is run_tests instead of run-tests
Also gcc output should be kcmp_test. Fix these two issues.

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/kcmp/Makefile~kcmp-selftests-make-run_tests-fix tools/testing/selftests/kcmp/Makefile
--- a/tools/testing/selftests/kcmp/Makefile~kcmp-selftests-make-run_tests-fix
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -16,12 +16,12 @@ CFLAGS += -I../../../../arch/x86/include
 
 all:
 ifeq ($(ARCH),X86)
-	gcc $(CFLAGS) kcmp_test.c -o run_test
+	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
 else
 	echo "Not an x86 target, can't build kcmp selftest"
 endif
 
-run-tests: all
+run_tests: all
 	./kcmp_test
 
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

