From: akpm@linux-foundation.org
Subject: + selftests-run-test_printf-module.patch added to -mm tree
Date: Wed, 30 Sep 2015 15:14:22 -0700
Message-ID: <560c5ebe.RYc7PGjoS1hCYUIg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbbI3WOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 18:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: run lib/test_printf module
has been added to the -mm tree.  Its filename is
     selftests-run-test_printf-module.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-run-test_printf-module.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-run-test_printf-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: selftests: run lib/test_printf module

This runs the lib/test_printf module to make sure printf is operating
sanely.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile      |    1 +
 tools/testing/selftests/lib/Makefile  |    8 ++++++++
 tools/testing/selftests/lib/printf.sh |   10 ++++++++++
 3 files changed, 19 insertions(+)

diff -puN tools/testing/selftests/Makefile~selftests-run-test_printf-module tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-run-test_printf-module
+++ a/tools/testing/selftests/Makefile
@@ -6,6 +6,7 @@ TARGETS += firmware
 TARGETS += ftrace
 TARGETS += futex
 TARGETS += kcmp
+TARGETS += lib
 TARGETS += membarrier
 TARGETS += memfd
 TARGETS += memory-hotplug
diff -puN /dev/null tools/testing/selftests/lib/Makefile
--- /dev/null
+++ a/tools/testing/selftests/lib/Makefile
@@ -0,0 +1,8 @@
+# Makefile for lib/ function selftests
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
+all:
+
+TEST_PROGS := printf.sh
+
+include ../lib.mk
diff -puN /dev/null tools/testing/selftests/lib/printf.sh
--- /dev/null
+++ a/tools/testing/selftests/lib/printf.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+# Runs printf infrastructure using test_printf kernel module
+
+if /sbin/modprobe -q test_printf; then
+	/sbin/modprobe -q -r test_printf
+	echo "printf: ok"
+else
+	echo "printf: [FAIL]"
+	exit 1
+fi
_

Patches currently in -mm which might be from keescook@chromium.org are

fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix.patch
selftests-run-test_printf-module.patch

