From: akpm@linux-foundation.org
Subject: [merged] selftests-run-test_printf-module.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 11:45:58 -0800
Message-ID: <5640f7f6.6tGLJLH7cgwPPuMC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbKITp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: run lib/test_printf module
has been removed from the -mm tree.  Its filename was
     selftests-run-test_printf-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


