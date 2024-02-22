Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9252BB65E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560210; cv=none; b=H0x9ChnALOeD6BAVurSvLglDhWXbfk3MOnH0Kymhz5MjTN5pRgKxoigHESGNNSveo6t9e+zNiAV3xpwZujlbVyfJpNpzuckNzX8C99HhCyUihpLPm7jMczNCpEmNo1WTe6k77HQCJfQInTsIUMeXJXBzsCRHAnje+I5RCHrEUOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560210; c=relaxed/simple;
	bh=a8yW61UaSS4cMTt/0L8RYL+ZSUFA4FH0ugovRzrzd2Y=;
	h=Date:To:From:Subject:Message-Id; b=WscDTEETbe7MvfJkt2tmMBIFKnBveD/swClvOHVOr+Yb1ptOUXMqhfTEfQRrQI/El1VEBCt9x6sx5smaum0OTvM/CgfLlPIA1n9xvVmNEPi/0k7wEMCVGzkkr2mIXTmIfz8mBDtbusbDtT61vvxB7gs9F58NFAM+BKw/tOlY2yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2U3eEadX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2U3eEadX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED6CC43394;
	Thu, 22 Feb 2024 00:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560210;
	bh=a8yW61UaSS4cMTt/0L8RYL+ZSUFA4FH0ugovRzrzd2Y=;
	h=Date:To:From:Subject:From;
	b=2U3eEadXUOGGFWtmfTgTQlIQmgbNB55/K0SoXWFOmiCP+dONHbaCj0xTJEFMQDQmS
	 3z/DU0XtEuyUAmIINRFUxaZ+eurj2a8IG1QY6KJtaUPYL4o7NPV7SIIjwYUGV5fgGV
	 cPBvKxh/qlhlMxNnThaAbdsivDh+fvMD7EuWk2I4=
Date: Wed, 21 Feb 2024 16:03:29 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch removed from -mm tree
Message-Id: <20240222000329.EED6CC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add a test for the pid leak of dbgfs_target_ids_write()
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

