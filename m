From: akpm@linux-foundation.org
Subject: + selftests-launch-individual-selftests-from-the-main-makefile.patch added to -mm tree
Date: Wed, 08 Feb 2012 15:20:30 -0800
Message-ID: <20120208232031.27A71A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:49279 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab2BHXUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 18:20:32 -0500
Received: by yhgm50 with SMTP id m50so121990yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 15:20:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, cl@linux.com, dyoung@redhat.com


The patch titled
     Subject: selftests: launch individual selftests from the main Makefile
has been added to the -mm tree.  Its filename is
     selftests-launch-individual-selftests-from-the-main-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
