Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D321CD3B
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346515; cv=none; b=abdrNY3OyNixZfWt7/lT+r5iAf4O4OXVTTSSTl58a8FAWx5blRybFdQS6Po4jnfMUewx5LIZkBBhLkw37tTHrnDxwzsiXM5yJY3ziRUVQm9IXamhJltF7RJ60gR4F9Eh6jTMnzdFEd6NVaszwUEItcyBFE0dWG/pf+VtZfznD/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346515; c=relaxed/simple;
	bh=PyLOh+N//1Upwd1Dc6a5+8K5oj6riWe75YNt39W8xp0=;
	h=Date:To:From:Subject:Message-Id; b=mr0YVntz5IJibxrbAB3+mmBjJ033uexgWwI2wu/kX1cdAWdULii+CWotAVBCvBQhHeFNbiKO2pCNetJsFN9BnesZ0XUKwpsWpIeU2vd8ctN8VX0svR/ocRpj9tGnIpbAVvy4QyS59vU27wIbjlfYuRloHOI3RiV6vhXpEE6non0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIIL4KiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIIL4KiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED93BC433C7;
	Wed,  7 Feb 2024 22:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346515;
	bh=PyLOh+N//1Upwd1Dc6a5+8K5oj6riWe75YNt39W8xp0=;
	h=Date:To:From:Subject:From;
	b=cIIL4KiLruVv6rm8Db1cqQ3v+3m0fEiH54XFFAZceEbsRQ2GzUJHq6NtO/kVhKSBV
	 hY81pLbWg+mIvfu9PqPpHEJY4vlKT+eqmBQPSsJog7dRLF0CM+TTDdPfSpzkIv2LjM
	 3xO900zXBLboCZRiStHR/cM8y5NEAKgzsGLIz3g4=
Date: Wed, 07 Feb 2024 14:55:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch added to mm-unstable branch
Message-Id: <20240207225514.ED93BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for a race between target_ids_read() and dbgfs_before_terminate()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add a test for a race between target_ids_read() and dbgfs_before_terminate()
Date: Wed, 7 Feb 2024 12:31:32 -0800

commit 34796417964b ("mm/damon/dbgfs: protect targets destructions with
kdamond_lock") fixed a race of DAMON debugfs interface.  Specifically, the
race was happening between target_ids_read() and dbgfs_before_terminate().
Add a test for the issue to prevent the problem from accidentally
recurring.

Link: https://lkml.kernel.org/r/20240207203134.69976-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore                                       |    1 
 tools/testing/selftests/damon/Makefile                                         |    2 
 tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.c  |   80 ++++++++++
 tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh |   14 +
 4 files changed, 97 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+#define _GNU_SOURCE
+
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#define DBGFS_MONITOR_ON "/sys/kernel/debug/damon/monitor_on_DEPRECATED"
+#define DBGFS_TARGET_IDS "/sys/kernel/debug/damon/target_ids"
+
+static void turn_damon_on_exit(void)
+{
+	int target_ids_fd = open(DBGFS_TARGET_IDS, O_RDWR);
+	int monitor_on_fd = open(DBGFS_MONITOR_ON, O_RDWR);
+	char pid_str[128];
+
+	snprintf(pid_str, sizeof(pid_str), "%d", getpid());
+	write(target_ids_fd, pid_str, sizeof(pid_str));
+	write(monitor_on_fd, "on\n", 3);
+	close(target_ids_fd);
+	close(monitor_on_fd);
+	usleep(1000);
+	exit(0);
+}
+
+static void try_race(void)
+{
+	int target_ids_fd = open(DBGFS_TARGET_IDS, O_RDWR);
+	int pid = fork();
+	int buf[256];
+
+	if (pid < 0) {
+		fprintf(stderr, "fork() failed\n");
+		exit(1);
+	}
+	if (pid == 0)
+		turn_damon_on_exit();
+	while (true) {
+		int status;
+
+		read(target_ids_fd, buf, sizeof(buf));
+		if (waitpid(-1, &status, WNOHANG) == pid)
+			break;
+	}
+	close(target_ids_fd);
+}
+
+static inline uint64_t ts_to_ms(struct timespec *ts)
+{
+	return (uint64_t)ts->tv_sec * 1000 + (uint64_t)ts->tv_nsec / 1000000;
+}
+
+int main(int argc, char *argv[])
+{
+	struct timespec start_time, now;
+	int runtime_ms;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <runtime in ms>\n", argv[0]);
+		exit(1);
+	}
+	runtime_ms = atoi(argv[1]);
+	clock_gettime(CLOCK_MONOTONIC, &start_time);
+	while (true) {
+		try_race();
+		clock_gettime(CLOCK_MONOTONIC, &now);
+		if (ts_to_ms(&now) - ts_to_ms(&start_time) > runtime_ms)
+			break;
+	}
+	return 0;
+}
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+dmesg -C
+
+./debugfs_target_ids_read_before_terminate_race 5000
+
+if dmesg | grep -q dbgfs_target_ids_read
+then
+	dmesg
+	exit 1
+else
+	exit 0
+fi
--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate
+++ a/tools/testing/selftests/damon/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 huge_count_read_write
+debugfs_target_ids_read_before_terminate_race
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate
+++ a/tools/testing/selftests/damon/Makefile
@@ -2,6 +2,7 @@
 # Makefile for damon selftests
 
 TEST_GEN_FILES += huge_count_read_write
+TEST_GEN_FILES += debugfs_target_ids_read_before_terminate_race
 TEST_GEN_FILES += access_memory
 
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
@@ -9,6 +10,7 @@ TEST_PROGS = debugfs_attrs.sh debugfs_sc
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
+TEST_PROGS += debugfs_target_ids_read_before_terminate_race.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

