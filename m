Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FD013959D
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 03:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736219677; cv=none; b=oQpqXizhYLoHs83M/f5SEq2lLfBWeJ70BdV/L4wVFQIRVpF+yhzcegM/NFBgjO6I1yC211T+O2wIdF5rWqT6VGSpgxgRpB21E/lDmcLNsknXn69J7oLmQiHHPfs/XqAVexS5OUzaHUZyhbCrjDklvR0qLqIv/JNeMBhQH4jqSsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736219677; c=relaxed/simple;
	bh=mMjMfn1A5Mskctqa1HR7oAHC5kcMcDO0tDphzCI92VU=;
	h=Date:To:From:Subject:Message-Id; b=Pv2YxX74HqRzqlwxHWlE/XE6nR6Co3SFb8G6I+z0DxlnSuzFl9zPgyGI0dUJQxlNpvKTTVQQenwcLJ09cLYj9t5Bseh3ybplIEH6RM8mxaDESkdRMN8OxyRjJ991ayhAfBIXYW5W++WHgOgR/hmrDyrccoM2V1+VKLFrdQZeAQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eajhkp5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eajhkp5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C866DC4CED2;
	Tue,  7 Jan 2025 03:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736219676;
	bh=mMjMfn1A5Mskctqa1HR7oAHC5kcMcDO0tDphzCI92VU=;
	h=Date:To:From:Subject:From;
	b=Eajhkp5M7exsb4cibskeXsjaJrQWjpXgu5tq0B5yQJHhwR54OMmf0Rt9XVatDi+H2
	 syIFTmZxRQm4s9Q5zWcyKfHDOOnO0ZD7DumF2nKL/wE1QMdf/sVPOAQ8dV89UQ4wem
	 6+JNQAl/vfGOSu3SloopG0NOONl+uzsVrPQMZt+Q=
Date: Mon, 06 Jan 2025 19:14:36 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,oleg@redhat.com,kees@kernel.org,john.ogness@linutronix.de,ebiederm@xmission.com,dylanbhatch@google.com,namcao@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-coredump-add-stackdump-test.patch removed from -mm tree
Message-Id: <20250107031436.C866DC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: coredump: add stackdump test
has been removed from the -mm tree.  Its filename was
     selftests-coredump-add-stackdump-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nam Cao <namcao@linutronix.de>
Subject: selftests: coredump: add stackdump test
Date: Thu, 2 Jan 2025 09:22:57 +0100

Add a test which checks that the kstkesp field in /proc/pid/stat can be
read for all threads of a coredumping process.

For full details including the motivation for this test and how it works,
see the README file added by this commit.

Link: https://lkml.kernel.org/r/50e737b6576208566d14efcf1934fe840de6b1f4.1735805772.git.namcao@linutronix.de
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Cc: Dylan Hatch <dylanbhatch@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/coredump/Makefile         |    7 
 tools/testing/selftests/coredump/README.rst       |   50 +++
 tools/testing/selftests/coredump/stackdump        |   14 +
 tools/testing/selftests/coredump/stackdump_test.c |  151 ++++++++++++
 4 files changed, 222 insertions(+)

diff --git a/tools/testing/selftests/coredump/Makefile a/tools/testing/selftests/coredump/Makefile
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/coredump/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+CFLAGS = $(KHDR_INCLUDES)
+
+TEST_GEN_PROGS := stackdump_test
+TEST_FILES := stackdump
+
+include ../lib.mk
diff --git a/tools/testing/selftests/coredump/README.rst a/tools/testing/selftests/coredump/README.rst
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/coredump/README.rst
@@ -0,0 +1,50 @@
+coredump selftest
+=================
+
+Background context
+------------------
+
+`coredump` is a feature which dumps a process's memory space when the process terminates
+unexpectedly (e.g. due to segmentation fault), which can be useful for debugging. By default,
+`coredump` dumps the memory to the file named `core`, but this behavior can be changed by writing a
+different file name to `/proc/sys/kernel/core_pattern`. Furthermore, `coredump` can be piped to a
+user-space program by writing the pipe symbol (`|`) followed by the command to be executed to
+`/proc/sys/kernel/core_pattern`. For the full description, see `man 5 core`.
+
+The piped user program may be interested in reading the stack pointers of the crashed process. The
+crashed process's stack pointers can be read from `procfs`: it is the `kstkesp` field in
+`/proc/$PID/stat`. See `man 5 proc` for all the details.
+
+The problem
+-----------
+While a thread is active, the stack pointer is unsafe to read and therefore the `kstkesp` field
+reads zero. But when the thread is dead (e.g. during a coredump), this field should have valid
+value.
+
+However, this was broken in the past and `kstkesp` was zero even during coredump:
+
+* commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in /proc/PID/stat") changed kstkesp to
+  always be zero
+
+* commit fd7d56270b52 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping") fixed it for the
+  coredumping thread. However, other threads in a coredumping process still had the problem.
+
+* commit cb8f381f1613 ("fs/proc/array.c: allow reporting eip/esp for all coredumping threads") fixed
+  for all threads in a coredumping process.
+
+* commit 92307383082d ("coredump:  Don't perform any cleanups before dumping core") broke it again
+  for the other threads in a coredumping process.
+
+The problem has been fixed now, but considering the history, it may appear again in the future.
+
+The goal of this test
+---------------------
+This test detects problem with reading `kstkesp` during coredump by doing the following:
+
+#. Tell the kernel to execute the "stackdump" script when a coredump happens. This script
+   reads the stack pointers of all threads of crashed processes.
+
+#. Spawn a child process who creates some threads and then crashes.
+
+#. Read the output from the "stackdump" script, and make sure all stack pointer values are
+   non-zero.
diff --git a/tools/testing/selftests/coredump/stackdump a/tools/testing/selftests/coredump/stackdump
new file mode 100755
--- /dev/null
+++ a/tools/testing/selftests/coredump/stackdump
@@ -0,0 +1,14 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+CRASH_PROGRAM_ID=$1
+STACKDUMP_FILE=$2
+
+TMP=$(mktemp)
+
+for t in /proc/$CRASH_PROGRAM_ID/task/*; do
+	tid=$(basename $t)
+	cat /proc/$tid/stat | awk '{print $29}' >> $TMP
+done
+
+mv $TMP $STACKDUMP_FILE
diff --git a/tools/testing/selftests/coredump/stackdump_test.c a/tools/testing/selftests/coredump/stackdump_test.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/coredump/stackdump_test.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <fcntl.h>
+#include <libgen.h>
+#include <linux/limits.h>
+#include <pthread.h>
+#include <string.h>
+#include <sys/resource.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define STACKDUMP_FILE "stack_values"
+#define STACKDUMP_SCRIPT "stackdump"
+#define NUM_THREAD_SPAWN 128
+
+static void *do_nothing(void *)
+{
+	while (1)
+		pause();
+}
+
+static void crashing_child(void)
+{
+	pthread_t thread;
+	int i;
+
+	for (i = 0; i < NUM_THREAD_SPAWN; ++i)
+		pthread_create(&thread, NULL, do_nothing, NULL);
+
+	/* crash on purpose */
+	i = *(int *)NULL;
+}
+
+FIXTURE(coredump)
+{
+	char original_core_pattern[256];
+};
+
+FIXTURE_SETUP(coredump)
+{
+	char buf[PATH_MAX];
+	FILE *file;
+	char *dir;
+	int ret;
+
+	file = fopen("/proc/sys/kernel/core_pattern", "r");
+	ASSERT_NE(NULL, file);
+
+	ret = fread(self->original_core_pattern, 1, sizeof(self->original_core_pattern), file);
+	ASSERT_TRUE(ret || feof(file));
+	ASSERT_LT(ret, sizeof(self->original_core_pattern));
+
+	self->original_core_pattern[ret] = '\0';
+
+	ret = fclose(file);
+	ASSERT_EQ(0, ret);
+}
+
+FIXTURE_TEARDOWN(coredump)
+{
+	const char *reason;
+	FILE *file;
+	int ret;
+
+	unlink(STACKDUMP_FILE);
+
+	file = fopen("/proc/sys/kernel/core_pattern", "w");
+	if (!file) {
+		reason = "Unable to open core_pattern";
+		goto fail;
+	}
+
+	ret = fprintf(file, "%s", self->original_core_pattern);
+	if (ret < 0) {
+		reason = "Unable to write to core_pattern";
+		goto fail;
+	}
+
+	ret = fclose(file);
+	if (ret) {
+		reason = "Unable to close core_pattern";
+		goto fail;
+	}
+
+	return;
+fail:
+	/* This should never happen */
+	fprintf(stderr, "Failed to cleanup stackdump test: %s\n", reason);
+}
+
+TEST_F(coredump, stackdump)
+{
+	struct sigaction action = {};
+	unsigned long long stack;
+	char *test_dir, *line;
+	size_t line_length;
+	char buf[PATH_MAX];
+	int ret, i;
+	FILE *file;
+	pid_t pid;
+
+	/*
+	 * Step 1: Setup core_pattern so that the stackdump script is executed when the child
+	 * process crashes
+	 */
+	ret = readlink("/proc/self/exe", buf, sizeof(buf));
+	ASSERT_NE(-1, ret);
+	ASSERT_LT(ret, sizeof(buf));
+	buf[ret] = '\0';
+
+	test_dir = dirname(buf);
+
+	file = fopen("/proc/sys/kernel/core_pattern", "w");
+	ASSERT_NE(NULL, file);
+
+	ret = fprintf(file, "|%1$s/%2$s %%P %1$s/%3$s", test_dir, STACKDUMP_SCRIPT, STACKDUMP_FILE);
+	ASSERT_LT(0, ret);
+
+	ret = fclose(file);
+	ASSERT_EQ(0, ret);
+
+	/* Step 2: Create a process who spawns some threads then crashes */
+	pid = fork();
+	ASSERT_TRUE(pid >= 0);
+	if (pid == 0)
+		crashing_child();
+
+	/*
+	 * Step 3: Wait for the stackdump script to write the stack pointers to the stackdump file
+	 */
+	for (i = 0; i < 10; ++i) {
+		file = fopen(STACKDUMP_FILE, "r");
+		if (file)
+			break;
+		sleep(1);
+	}
+	ASSERT_NE(file, NULL);
+
+	/* Step 4: Make sure all stack pointer values are non-zero */
+	for (i = 0; -1 != getline(&line, &line_length, file); ++i) {
+		stack = strtoull(line, NULL, 10);
+		ASSERT_NE(stack, 0);
+	}
+
+	ASSERT_EQ(i, 1 + NUM_THREAD_SPAWN);
+
+	fclose(file);
+}
+
+TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from namcao@linutronix.de are

fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch

