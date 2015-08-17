From: akpm@linux-foundation.org
Subject: + selftests-enhance-membarrier-syscall-test.patch added to -mm
 tree
Date: Mon, 17 Aug 2015 15:28:13 -0700
Message-ID: <55d25ffd.XZniKUarPDM/nhKk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbHQW2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 18:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, bobby.prani@gmail.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: enhance membarrier syscall test
has been added to the -mm tree.  Its filename is
     selftests-enhance-membarrier-syscall-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-enhance-membarrier-syscall-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-enhance-membarrier-syscall-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: selftests: enhance membarrier syscall test

Update the membarrier syscall self-test to match the membarrier interface.
 Extend coverage of the interface.  Consider ENOSYS as a "SKIP" test,
since it is a valid configuration, but does not allow testing the system
call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/membarrier/membarrier_test.c |  104 +++++++---
 1 file changed, 77 insertions(+), 27 deletions(-)

diff -puN tools/testing/selftests/membarrier/membarrier_test.c~selftests-enhance-membarrier-syscall-test tools/testing/selftests/membarrier/membarrier_test.c
--- a/tools/testing/selftests/membarrier/membarrier_test.c~selftests-enhance-membarrier-syscall-test
+++ a/tools/testing/selftests/membarrier/membarrier_test.c
@@ -10,62 +10,112 @@
 
 #include "../kselftest.h"
 
+enum test_membarrier_status {
+	TEST_MEMBARRIER_PASS = 0,
+	TEST_MEMBARRIER_FAIL,
+	TEST_MEMBARRIER_SKIP,
+};
+
 static int sys_membarrier(int cmd, int flags)
 {
 	return syscall(__NR_membarrier, cmd, flags);
 }
 
-static void test_membarrier_fail(void)
+static enum test_membarrier_status test_membarrier_cmd_fail(void)
 {
 	int cmd = -1, flags = 0;
 
 	if (sys_membarrier(cmd, flags) != -1) {
-		printf("membarrier: Should fail but passed\n");
-		ksft_exit_fail();
+		printf("membarrier: Wrong command should fail but passed.\n");
+		return TEST_MEMBARRIER_FAIL;
 	}
+	return TEST_MEMBARRIER_PASS;
 }
 
-static void test_membarrier_success(void)
+static enum test_membarrier_status test_membarrier_flags_fail(void)
 {
-	int flags = 0;
+	int cmd = MEMBARRIER_CMD_QUERY, flags = 1;
 
-	if (sys_membarrier(MEMBARRIER_CMD_SHARED, flags) != 0) {
-		printf("membarrier: Executing MEMBARRIER failed, %s\n",
-				strerror(errno));
-		ksft_exit_fail();
+	if (sys_membarrier(cmd, flags) != -1) {
+		printf("membarrier: Wrong flags should fail but passed.\n");
+		return TEST_MEMBARRIER_FAIL;
 	}
-
-	printf("membarrier: MEMBARRIER_CMD_SHARED success\n");
+	return TEST_MEMBARRIER_PASS;
 }
 
-static void test_membarrier(void)
+static enum test_membarrier_status test_membarrier_success(void)
 {
-	test_membarrier_fail();
-	test_membarrier_success();
+	int cmd = MEMBARRIER_CMD_SHARED, flags = 0;
+
+	if (sys_membarrier(cmd, flags) != 0) {
+		printf("membarrier: Executing MEMBARRIER_CMD_SHARED failed. %s.\n",
+				strerror(errno));
+		return TEST_MEMBARRIER_FAIL;
+	}
+
+	printf("membarrier: MEMBARRIER_CMD_SHARED success.\n");
+	return TEST_MEMBARRIER_PASS;
 }
 
-static int test_membarrier_exists(void)
+static enum test_membarrier_status test_membarrier(void)
 {
-	int flags = 0;
-
-	if (sys_membarrier(MEMBARRIER_CMD_QUERY, flags))
-		return 0;
+	enum test_membarrier_status status;
 
-	return 1;
+	status = test_membarrier_cmd_fail();
+	if (status)
+		return status;
+	status = test_membarrier_flags_fail();
+	if (status)
+		return status;
+	status = test_membarrier_success();
+	if (status)
+		return status;
+	return TEST_MEMBARRIER_PASS;
+}
+
+static enum test_membarrier_status test_membarrier_query(void)
+{
+	int flags = 0, ret;
+
+	printf("membarrier MEMBARRIER_CMD_QUERY ");
+	ret = sys_membarrier(MEMBARRIER_CMD_QUERY, flags);
+	if (ret < 0) {
+		printf("failed. %s.\n", strerror(errno));
+		switch (errno) {
+		case ENOSYS:
+			/*
+			 * It is valid to build a kernel with
+			 * CONFIG_MEMBARRIER=n. However, this skips the tests.
+			 */
+			return TEST_MEMBARRIER_SKIP;
+		case EINVAL:
+		default:
+			return TEST_MEMBARRIER_FAIL;
+		}
+	}
+	if (!(ret & MEMBARRIER_CMD_SHARED)) {
+		printf("command MEMBARRIER_CMD_SHARED is not supported.\n");
+		return TEST_MEMBARRIER_FAIL;
+	}
+	printf("syscall available.\n");
+	return TEST_MEMBARRIER_PASS;
 }
 
 int main(int argc, char **argv)
 {
-	printf("membarrier: MEMBARRIER_CMD_QUERY ");
-	if (test_membarrier_exists()) {
-		printf("syscall implemented\n");
-		test_membarrier();
-	} else {
-		printf("syscall not implemented!\n");
+	switch (test_membarrier_query()) {
+	case TEST_MEMBARRIER_FAIL:
 		return ksft_exit_fail();
+	case TEST_MEMBARRIER_SKIP:
+		return ksft_exit_skip();
+	}
+	switch (test_membarrier()) {
+	case TEST_MEMBARRIER_FAIL:
+		return ksft_exit_fail();
+	case TEST_MEMBARRIER_SKIP:
+		return ksft_exit_skip();
 	}
 
 	printf("membarrier: tests done!\n");
