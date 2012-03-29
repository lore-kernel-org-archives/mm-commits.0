From: akpm@linux-foundation.org
Subject: [merged] selftests-launch-individual-selftests-from-the-main-makefile.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:20 -0700
Message-ID: <20120329191420.77566A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65312 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759Ab2C2TOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:21 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so303047yen.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: launch individual selftests from the main Makefile
has been removed from the -mm tree.  Its filename was
     selftests-launch-individual-selftests-from-the-main-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: selftests: launch individual selftests from the main Makefile

Remove the run_tests script and launch the selftests by calling "make
run_tests" from the selftests top directory instead.  This delegates to
the Makefile in each selftest directory, where it is decided how to launch
the local test.

This removes the need to add each selftest directory to the now removed
"run_tests" top script.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile             |    5 +++++
 tools/testing/selftests/breakpoints/Makefile |    7 +++++--
 tools/testing/selftests/run_tests            |    8 --------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN tools/testing/selftests/Makefile~selftests-launch-individual-selftests-from-the-main-makefile tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-launch-individual-selftests-from-the-main-makefile
+++ a/tools/testing/selftests/Makefile
@@ -5,6 +5,11 @@ all:
 		make -C $$TARGET; \
 	done;
 
+run_tests:
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET run_tests; \
+	done;
+
 clean:
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET clean; \
diff -puN tools/testing/selftests/breakpoints/Makefile~selftests-launch-individual-selftests-from-the-main-makefile tools/testing/selftests/breakpoints/Makefile
--- a/tools/testing/selftests/breakpoints/Makefile~selftests-launch-individual-selftests-from-the-main-makefile
+++ a/tools/testing/selftests/breakpoints/Makefile
@@ -11,10 +11,13 @@ endif
 
 all:
 ifeq ($(ARCH),x86)
-	gcc breakpoint_test.c -o run_test
+	gcc breakpoint_test.c -o breakpoint_test
 else
 	echo "Not an x86 target, can't build breakpoints selftests"
 endif
 
+run_tests:
+	./breakpoint_test
+
 clean:
-	rm -fr run_test
+	rm -fr breakpoint_test
diff -puN tools/testing/selftests/run_tests~selftests-launch-individual-selftests-from-the-main-makefile /dev/null
--- a/tools/testing/selftests/run_tests
+++ /dev/null
@@ -1,8 +0,0 @@
-#!/bin/bash
-
-TARGETS=breakpoints
