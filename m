Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484DF1CF9C
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346517; cv=none; b=s7o6EiII6/29z4kyt3R4Oi+quh5X87LRH3JfCsrwPI4BDZgK4JZl4Z6NZNEtqcJZhTGRmCIjWBFX+F6pF4ZYfVMyaNv4DJ171OgelvVFLBQbxak4WDumZHk/SXGGC9MOJ6zyYPcUtBIFudQvKmsjO0pt1ZKcGSivrYtV0h4OAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346517; c=relaxed/simple;
	bh=MFs6oJzs2J3O0B+OeCRwa3FSTkn2k9rbfYzmzlzVkQo=;
	h=Date:To:From:Subject:Message-Id; b=KRa9inRQtZtP58CXng0A18Hg3A2Bx2O6nz31WAAu51PHM0qYs7SAWMrVuFou2nIR0VRxt99XczftYay2Y73qjV1wv6cAvp1p74WsqIZBCbQLl+Y9JQ9AR5m/HvEBk4Db0IvdohNysZuXpeAsCc2WQ6R6l1Yw6ppS2xoMoBxemic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p1xmExRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p1xmExRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9032C43390;
	Wed,  7 Feb 2024 22:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707346516;
	bh=MFs6oJzs2J3O0B+OeCRwa3FSTkn2k9rbfYzmzlzVkQo=;
	h=Date:To:From:Subject:From;
	b=p1xmExRLnyhlIDxXBuMBOvgqwc/GRVcgdWqkdRiy23YHapcFR3VOua10G1kPySpZ0
	 L7wyIFPF8MCHs+t/1Aobb7V2lXEymHoOMjl0kOfkKpYiVC65O5nA9uepwskra44UBx
	 uA1uXbXO5aLOxxG4zAmcCtJZpx2yQIagg8dqu9Fg=
Date: Wed, 07 Feb 2024 14:55:16 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch added to mm-unstable branch
Message-Id: <20240207225516.C9032C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for the pid leak of dbgfs_target_ids_write()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch

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
Subject: selftests/damon: add a test for the pid leak of dbgfs_target_ids_write()
Date: Wed, 7 Feb 2024 12:31:33 -0800

Commit ebb3f994dd92 ("mm/damon/dbgfs: fix 'struct pid' leaks in
'dbgfs_target_ids_write()'") fixes a pid leak bug in DAMON debugfs
interface, namely dbgfs_target_ids_write() function.  Add a selftest for
the issue to prevent the problem from mistakenly recurring.

Link: https://lkml.kernel.org/r/20240207203134.69976-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore                     |    1 
 tools/testing/selftests/damon/Makefile                       |    2 
 tools/testing/selftests/damon/debugfs_target_ids_pid_leak.c  |   68 ++++++++++
 tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh |   22 +++
 4 files changed, 93 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#define _GNU_SOURCE
+
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/time.h>
+#include <unistd.h>
+
+#define DBGFS_TARGET_IDS "/sys/kernel/debug/damon/target_ids"
+
+static void write_targetid_exit(void)
+{
+	int target_ids_fd = open(DBGFS_TARGET_IDS, O_RDWR);
+	char pid_str[128];
+
+	snprintf(pid_str, sizeof(pid_str), "%d", getpid());
+	write(target_ids_fd, pid_str, sizeof(pid_str));
+	close(target_ids_fd);
+	exit(0);
+}
+
+unsigned long msec_timestamp(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return tv.tv_sec * 1000UL + tv.tv_usec / 1000;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long start_ms;
+	int time_to_run, nr_forks = 0;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <msecs to run>\n", argv[0]);
+		exit(1);
+	}
+	time_to_run = atoi(argv[1]);
+
+	start_ms = msec_timestamp();
+	while (true) {
+		int pid = fork();
+
+		if (pid < 0) {
+			fprintf(stderr, "fork() failed\n");
+			exit(1);
+		}
+		if (pid == 0)
+			write_targetid_exit();
+		wait(NULL);
+		nr_forks++;
+
+		if (msec_timestamp() - start_ms > time_to_run)
+			break;
+	}
+	printf("%d\n", nr_forks);
+	return 0;
+}
--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+before=$(grep "^pid " /proc/slabinfo | awk '{print $2}')
+
+nr_leaks=$(./debugfs_target_ids_pid_leak 1000)
+expected_after_max=$((before + nr_leaks / 2))
+
+after=$(grep "^pid " /proc/slabinfo | awk '{print $2}')
+
+echo > /sys/kernel/debug/damon/target_ids
+
+echo "tried $nr_leaks pid leak"
+echo "number of active pid slabs: $before -> $after"
+echo "(up to $expected_after_max expected)"
+if [ $after -gt $expected_after_max ]
+then
+	echo "maybe pids are leaking"
+	exit 1
+else
+	exit 0
+fi
--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write
+++ a/tools/testing/selftests/damon/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 huge_count_read_write
 debugfs_target_ids_read_before_terminate_race
+debugfs_target_ids_pid_leak
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write
+++ a/tools/testing/selftests/damon/Makefile
@@ -3,6 +3,7 @@
 
 TEST_GEN_FILES += huge_count_read_write
 TEST_GEN_FILES += debugfs_target_ids_read_before_terminate_race
+TEST_GEN_FILES += debugfs_target_ids_pid_leak
 TEST_GEN_FILES += access_memory
 
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
@@ -11,6 +12,7 @@ TEST_PROGS += debugfs_empty_targets.sh d
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += debugfs_target_ids_read_before_terminate_race.sh
+TEST_PROGS += debugfs_target_ids_pid_leak.sh
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

