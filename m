From: akpm@linux-foundation.org
Subject: [merged] kcmp-selftests-make-run_tests-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:14 -0800
Message-ID: <20121218201214.A708F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43702 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LRUMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:15 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so157764qaq.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, gorcunov@openvz.org, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kcmp selftests: make run_tests fix
has been removed from the -mm tree.  Its filename was
     kcmp-selftests-make-run_tests-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

