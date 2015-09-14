From: akpm@linux-foundation.org
Subject: [merged] selftests-add-membarrier-syscall-test.patch removed from -mm tree
Date: Mon, 14 Sep 2015 10:28:44 -0700
Message-ID: <55f703cc.yTqswXwe5FnXc4FH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbINR2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, mathieu.desnoyers@efficios.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add membarrier syscall test
has been removed from the -mm tree.  Its filename was
     selftests-add-membarrier-syscall-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: selftests: add membarrier syscall test

Add a self test for the membarrier system call.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                     |    1 
 tools/testing/selftests/membarrier/.gitignore        |    1 
 tools/testing/selftests/membarrier/Makefile          |   11 +
 tools/testing/selftests/membarrier/membarrier_test.c |   71 ++++++++++
 4 files changed, 84 insertions(+)

diff -puN tools/testing/selftests/Makefile~selftests-add-membarrier-syscall-test tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-add-membarrier-syscall-test
+++ a/tools/testing/selftests/Makefile
@@ -6,6 +6,7 @@ TARGETS += firmware
 TARGETS += ftrace
 TARGETS += futex
 TARGETS += kcmp
+TARGETS += membarrier
 TARGETS += memfd
 TARGETS += memory-hotplug
 TARGETS += mount
diff -puN /dev/null tools/testing/selftests/membarrier/.gitignore
--- /dev/null
+++ a/tools/testing/selftests/membarrier/.gitignore
@@ -0,0 +1 @@
+membarrier_test
diff -puN /dev/null tools/testing/selftests/membarrier/Makefile
--- /dev/null
+++ a/tools/testing/selftests/membarrier/Makefile
@@ -0,0 +1,11 @@
+CFLAGS += -g -I../../../../usr/include/
+
+all:
+	$(CC) $(CFLAGS) membarrier_test.c -o membarrier_test
+
+TEST_PROGS := membarrier_test
+
+include ../lib.mk
+
+clean:
+	$(RM) membarrier_test
diff -puN /dev/null tools/testing/selftests/membarrier/membarrier_test.c
--- /dev/null
+++ a/tools/testing/selftests/membarrier/membarrier_test.c
@@ -0,0 +1,71 @@
+#define _GNU_SOURCE
+#define __EXPORTED_HEADERS__
+
+#include <linux/membarrier.h>
+#include <asm-generic/unistd.h>
+#include <sys/syscall.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include "../kselftest.h"
+
+static int sys_membarrier(int cmd, int flags)
+{
+	return syscall(__NR_membarrier, cmd, flags);
+}
+
+static void test_membarrier_fail(void)
+{
+	int cmd = -1, flags = 0;
+
+	if (sys_membarrier(cmd, flags) != -1) {
+		printf("membarrier: Should fail but passed\n");
+		ksft_exit_fail();
+	}
+}
+
+static void test_membarrier_success(void)
+{
+	int flags = 0;
+
+	if (sys_membarrier(MEMBARRIER_CMD_SHARED, flags) != 0) {
+		printf("membarrier: Executing MEMBARRIER failed, %s\n",
+				strerror(errno));
+		ksft_exit_fail();
+	}
+
+	printf("membarrier: MEMBARRIER_CMD_SHARED success\n");
+}
+
+static void test_membarrier(void)
+{
+	test_membarrier_fail();
+	test_membarrier_success();
+}
+
+static int test_membarrier_exists(void)
+{
+	int flags = 0;
+
+	if (sys_membarrier(MEMBARRIER_CMD_QUERY, flags))
+		return 0;
+
+	return 1;
+}
+
+int main(int argc, char **argv)
+{
+	printf("membarrier: MEMBARRIER_CMD_QUERY ");
+	if (test_membarrier_exists()) {
+		printf("syscall implemented\n");
+		test_membarrier();
+	} else {
+		printf("syscall not implemented!\n");
+		return ksft_exit_fail();
+	}
+
+	printf("membarrier: tests done!\n");
+
+	return ksft_exit_pass();
+}
_

Patches currently in -mm which might be from bobby.prani@gmail.com are


