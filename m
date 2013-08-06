From: akpm@linux-foundation.org
Subject: + selftests-add-support-files-for-powerpc-tests.patch added to
 -mm tree
Date: Tue, 06 Aug 2013 14:47:35 -0700
Message-ID: <52016ef7.4dnPi1yf1ypqYji5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3HFVrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 17:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mikey@neuling.org, jk@ozlabs.org, benh@kernel.crashing.org, anton@samba.org, michael@ellerman.id.au

Subject: + selftests-add-support-files-for-powerpc-tests.patch added to -mm tree
To: michael@ellerman.id.au,anton@samba.org,benh@kernel.crashing.org,jk@ozlabs.org,mikey@neuling.org
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 14:47:35 -0700


The patch titled
     Subject: selftests: add support files for powerpc tests
has been added to the -mm tree.  Its filename is
     selftests-add-support-files-for-powerpc-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-add-support-files-for-powerpc-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-support-files-for-powerpc-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Ellerman <michael@ellerman.id.au>
Subject: selftests: add support files for powerpc tests

Add support code used by upcoming powerpc tests.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/powerpc/harness.c |  105 ++++++++++++++++++++
 tools/testing/selftests/powerpc/subunit.h |   47 ++++++++
 tools/testing/selftests/powerpc/utils.h   |   34 ++++++
 3 files changed, 186 insertions(+)

diff -puN /dev/null tools/testing/selftests/powerpc/harness.c
--- /dev/null
+++ a/tools/testing/selftests/powerpc/harness.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#include <errno.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "subunit.h"
+#include "utils.h"
+
+#define TIMEOUT		120
+#define KILL_TIMEOUT	5
+
+
+int run_test(int (test_function)(void), char *name)
+{
+	bool terminated;
+	int rc, status;
+	pid_t pid;
+
+	/* Make sure output is flushed before forking */
+	fflush(stdout);
+
+	pid = fork();
+	if (pid == 0) {
+		exit(test_function());
+	} else if (pid == -1) {
+		perror("fork");
+		return 1;
+	}
+
+	/* Wake us up in timeout seconds */
+	alarm(TIMEOUT);
+	terminated = false;
+
+wait:
+	rc = waitpid(pid, &status, 0);
+	if (rc == -1) {
+		if (errno != EINTR) {
+			printf("unknown error from waitpid\n");
+			return 1;
+		}
+
+		if (terminated) {
+			printf("!! force killing %s\n", name);
+			kill(pid, SIGKILL);
+			return 1;
+		} else {
+			printf("!! killing %s\n", name);
+			kill(pid, SIGTERM);
+			terminated = true;
+			alarm(KILL_TIMEOUT);
+			goto wait;
+		}
+	}
+
+	if (WIFEXITED(status))
+		status = WEXITSTATUS(status);
+	else {
+		if (WIFSIGNALED(status))
+			printf("!! child died by signal %d\n", WTERMSIG(status));
+		else
+			printf("!! child died by unknown cause\n");
+
+		status = 1; /* Signal or other */
+	}
+
+	return status;
+}
+
+static void alarm_handler(int signum)
+{
+	/* Jut wake us up from waitpid */
+}
+
+static struct sigaction alarm_action = {
+	.sa_handler = alarm_handler,
+};
+
+int test_harness(int (test_function)(void), char *name)
+{
+	int rc;
+
+	test_start(name);
+	test_set_git_version(GIT_VERSION);
+
+	if (sigaction(SIGALRM, &alarm_action, NULL)) {
+		perror("sigaction");
+		test_error(name);
+		return 1;
+	}
+
+	rc = run_test(test_function, name);
+
+	test_finish(name, rc);
+
+	return rc;
+}
diff -puN /dev/null tools/testing/selftests/powerpc/subunit.h
--- /dev/null
+++ a/tools/testing/selftests/powerpc/subunit.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#ifndef _SELFTESTS_POWERPC_SUBUNIT_H
+#define _SELFTESTS_POWERPC_SUBUNIT_H
+
+static inline void test_start(char *name)
+{
+	printf("test: %s\n", name);
+}
+
+static inline void test_failure_detail(char *name, char *detail)
+{
+	printf("failure: %s [%s]\n", name, detail);
+}
+
+static inline void test_failure(char *name)
+{
+	printf("failure: %s\n", name);
+}
+
+static inline void test_error(char *name)
+{
+	printf("error: %s\n", name);
+}
+
+static inline void test_success(char *name)
+{
+	printf("success: %s\n", name);
+}
+
+static inline void test_finish(char *name, int status)
+{
+	if (status)
+		test_failure(name);
+	else
+		test_success(name);
+}
+
+static inline void test_set_git_version(char *value)
+{
+	printf("tags: git_version:%s\n", value);
+}
+
+#endif /* _SELFTESTS_POWERPC_SUBUNIT_H */
diff -puN /dev/null tools/testing/selftests/powerpc/utils.h
--- /dev/null
+++ a/tools/testing/selftests/powerpc/utils.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#ifndef _SELFTESTS_POWERPC_UTILS_H
+#define _SELFTESTS_POWERPC_UTILS_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+/* Avoid headaches with PRI?64 - just use %ll? always */
+typedef unsigned long long u64;
+typedef   signed long long s64;
+
+/* Just for familiarity */
+typedef uint32_t u32;
+typedef uint8_t u8;
+
+
+int test_harness(int (test_function)(void), char *name);
+
+
+/* Yes, this is evil */
+#define FAIL_IF(x)						\
+do {								\
+	if ((x)) {						\
+		fprintf(stderr,					\
+		"[FAIL] Test FAILED on line %d\n", __LINE__);	\
+		return 1;					\
+	}							\
+} while (0)
+
+#endif /* _SELFTESTS_POWERPC_UTILS_H */
_

Patches currently in -mm which might be from michael@ellerman.id.au are

selftests-add-infrastructure-for-powerpc-selftests.patch
selftests-add-support-files-for-powerpc-tests.patch
selftests-add-test-of-pmu-instruction-counting-on-powerpc.patch
linux-next.patch

