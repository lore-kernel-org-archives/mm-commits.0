Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EEDB65E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560209; cv=none; b=jDpNv4mjh3cwwCTDkiQiIBaUmtGZxZSOTIb1+S1mvyJvzsrRBfLI5FEEI0u0QlNAri3Kv7IXhA0xK66X0sKqEqTEC8bRqiKPYA1PMuC8CQxPNGEN63M3PU98aR06aEqgZpezgWLrAbiX8h2qjjHcygJYV2wJLMivc+/zHnwuSNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560209; c=relaxed/simple;
	bh=0VDDOmfc/eGzOu5eEGLBE+b0zAlf5tQEa++oTR1fW5E=;
	h=Date:To:From:Subject:Message-Id; b=e7wdc09z5Xw41BDxx9jc0Y6KxI8CaMENgVAL6sft5DO98UYY4sdtXbkln3ysaN6I3WUcCckfN9iXPnzYyqYi7wJtDHPB+EAfnLXKbodkBbLr3kjro0789fKfyGAZh3f/xdkzjKa/efNryqZ33vC5R2CSJ66qd0mTm2/+l4qG6a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DWHVgCWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DWHVgCWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A800C43399;
	Thu, 22 Feb 2024 00:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560209;
	bh=0VDDOmfc/eGzOu5eEGLBE+b0zAlf5tQEa++oTR1fW5E=;
	h=Date:To:From:Subject:From;
	b=DWHVgCWJZhc0IHze3sifDCavMSyoILzGw+lIaT1A2MKB9DuMSZHCILSlBB5bGH3Mw
	 ylJ8o9sNRrfRwYEKJfR9PtAb22NB4ThE1cnofPig8zjIkyrNXr+XYWlovqzBd0kun+
	 4+kHonsGEtBRI8SRR9qTW/67p1AfitcKzcyHkqrU=
Date: Wed, 21 Feb 2024 16:03:28 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch removed from -mm tree
Message-Id: <20240222000329.1A800C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add a test for a race between target_ids_read() and dbgfs_before_terminate()
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

