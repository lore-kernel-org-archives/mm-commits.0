Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27518827
	for <mm-commits@vger.kernel.org>; Wed,  1 Jan 2025 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735774774; cv=none; b=ahw4lsl1kzrifLYnKZSp4PXgaASb220o+g8p0VggUPk9zHXTZbeJvop2rGlGPyOWyydTUYItOecYR/B4cSUTpU4HVi9vJi5/b30zBl9r5rObUeqEZB1WNM5EqGmAjv4PmWxTnPqnPrqfT/mtLB93wG/dvLQAtjnHVHjKa+CIQa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735774774; c=relaxed/simple;
	bh=Ik5TsxYeESSLBwI6LQsJg4hf4fGnYC/0opN5PSNJJ9o=;
	h=Date:To:From:Subject:Message-Id; b=d+ZFmO0zMVWF1h4kLJ6+1EpmXrWlspQxhvrM7dILG5cRXoxEEBJ80cQc4zmRSJKHdTBA3KFqTnTmQ3PS7EiQ0wr9UIkMlBP5IAT3UaPwPXjqFTpoRoleTREZOiuEu6a2TTE/6x5QHjIZo1NvtxqoqnuAEsUd3tAsSbXD6KOqfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S2KtqbBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S2KtqbBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC28C4CECE;
	Wed,  1 Jan 2025 23:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735774773;
	bh=Ik5TsxYeESSLBwI6LQsJg4hf4fGnYC/0opN5PSNJJ9o=;
	h=Date:To:From:Subject:From;
	b=S2KtqbBir7QZpoocnEeqgnrE0T0iWTRQ+kFsy2IoyoxHEEc0OxSYlXJ2rZtAhwWzH
	 X7CaWt4i5fKfj68PU0Sdmsw3gn3o8Wr+Fw9ZwpcXPaXMMG2ZCokIoLTtpnzTi+zmhi
	 x/OfDKbqmaRGUyuBPP96BcPbVo06bi3E8Fd8BWsw=
Date: Wed, 01 Jan 2025 15:39:32 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-remove-tests-for-damon-debugfs-interface.patch added to mm-unstable branch
Message-Id: <20250101233933.4DC28C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: remove tests for DAMON debugfs interface
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-remove-tests-for-damon-debugfs-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-remove-tests-for-damon-debugfs-interface.patch

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
Subject: selftests/damon: remove tests for DAMON debugfs interface
Date: Wed, 1 Jan 2025 13:35:24 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Remove selftests for the interface, to prevent causing unnecessary test
failures.

Link: https://lkml.kernel.org/r/20250101213527.74203-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore                                       |    3 
 tools/testing/selftests/damon/Makefile                                         |   11 -
 tools/testing/selftests/damon/debugfs_attrs.sh                                 |   17 --
 tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh            |   27 ---
 tools/testing/selftests/damon/debugfs_empty_targets.sh                         |   21 --
 tools/testing/selftests/damon/debugfs_huge_count_read_write.sh                 |   22 --
 tools/testing/selftests/damon/debugfs_rm_non_contexts.sh                       |   19 --
 tools/testing/selftests/damon/debugfs_schemes.sh                               |   19 --
 tools/testing/selftests/damon/debugfs_target_ids.sh                            |   19 --
 tools/testing/selftests/damon/debugfs_target_ids_pid_leak.c                    |   68 --------
 tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh                   |   22 --
 tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.c  |   80 ----------
 tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh |   14 -
 tools/testing/selftests/damon/huge_count_read_write.c                          |   46 -----
 14 files changed, 1 insertion(+), 387 deletions(-)

diff --git a/tools/testing/selftests/damon/debugfs_attrs.sh a/tools/testing/selftests/damon/debugfs_attrs.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_attrs.sh
+++ /dev/null
@@ -1,17 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test attrs file
-# ===============
-
-file="$DBGFS/attrs"
-orig_content=$(cat "$file")
-
-test_write_succ "$file" "1 2 3 4 5" "$orig_content" "valid input"
-test_write_fail "$file" "1 2 3 4" "$orig_content" "no enough fields"
-test_write_fail "$file" "1 2 3 5 4" "$orig_content" \
-	"min_nr_regions > max_nr_regions"
-test_content "$file" "$orig_content" "1 2 3 4 5" "successfully written"
-echo "$orig_content" > "$file"
diff --git a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
+++ /dev/null
@@ -1,27 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test duplicated context creation
-# ================================
-
-if ! echo foo > "$DBGFS/mk_contexts"
-then
-	echo "context creation failed"
-	exit 1
-fi
-
-if echo foo > "$DBGFS/mk_contexts" 2> /dev/null
-then
-	echo "duplicate context creation success"
-	exit 1
-fi
-
-if ! echo foo > "$DBGFS/rm_contexts"
-then
-	echo "context deletion failed"
-	exit 1
-fi
-
-exit 0
diff --git a/tools/testing/selftests/damon/debugfs_empty_targets.sh a/tools/testing/selftests/damon/debugfs_empty_targets.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_empty_targets.sh
+++ /dev/null
@@ -1,21 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test empty targets case
-# =======================
-
-orig_target_ids=$(cat "$DBGFS/target_ids")
-echo "" > "$DBGFS/target_ids"
-
-if [ -f "$DBGFS/monitor_on_DEPRECATED" ]
-then
-	monitor_on_file="$DBGFS/monitor_on_DEPRECATED"
-else
-	monitor_on_file="$DBGFS/monitor_on"
-fi
-
-orig_monitor_on=$(cat "$monitor_on_file")
-test_write_fail "$monitor_on_file" "on" "orig_monitor_on" "empty target ids"
-echo "$orig_target_ids" > "$DBGFS/target_ids"
diff --git a/tools/testing/selftests/damon/debugfs_huge_count_read_write.sh a/tools/testing/selftests/damon/debugfs_huge_count_read_write.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_huge_count_read_write.sh
+++ /dev/null
@@ -1,22 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test huge count read write
-# ==========================
-
-dmesg -C
-
-for file in "$DBGFS/"*
-do
-	./huge_count_read_write "$file"
-done
-
-if dmesg | grep -q WARNING
-then
-	dmesg
-	exit 1
-else
-	exit 0
-fi
diff --git a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test putting non-ctx files/dirs to rm_contexts file
-# ===================================================
-
-dmesg -C
-
-for file in "$DBGFS/"*
-do
-	(echo "$(basename "$f")" > "$DBGFS/rm_contexts") &> /dev/null
-	if dmesg | grep -q BUG
-	then
-		dmesg
-		exit 1
-	fi
-done
diff --git a/tools/testing/selftests/damon/debugfs_schemes.sh a/tools/testing/selftests/damon/debugfs_schemes.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_schemes.sh
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test schemes file
-# =================
-
-file="$DBGFS/schemes"
-orig_content=$(cat "$file")
-
-test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0 1 2 3 1 100 3 2 1" \
-	"$orig_content" "valid input"
-test_write_fail "$file" "1 2
-3 4 5 6 3 0 0 0 1 2 3 1 100 3 2 1" "$orig_content" "multi lines"
-test_write_succ "$file" "" "$orig_content" "disabling"
-test_write_fail "$file" "2 1 2 1 10 1 3 10 1 1 1 1 1 1 1 1 2 3" \
-	"$orig_content" "wrong condition ranges"
-echo "$orig_content" > "$file"
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.c a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.c
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.c
+++ /dev/null
@@ -1,68 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Author: SeongJae Park <sj@kernel.org>
- */
-
-#define _GNU_SOURCE
-
-#include <fcntl.h>
-#include <stdbool.h>
-#include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/wait.h>
-#include <sys/time.h>
-#include <unistd.h>
-
-#define DBGFS_TARGET_IDS "/sys/kernel/debug/damon/target_ids"
-
-static void write_targetid_exit(void)
-{
-	int target_ids_fd = open(DBGFS_TARGET_IDS, O_RDWR);
-	char pid_str[128];
-
-	snprintf(pid_str, sizeof(pid_str), "%d", getpid());
-	write(target_ids_fd, pid_str, sizeof(pid_str));
-	close(target_ids_fd);
-	exit(0);
-}
-
-unsigned long msec_timestamp(void)
-{
-	struct timeval tv;
-
-	gettimeofday(&tv, NULL);
-	return tv.tv_sec * 1000UL + tv.tv_usec / 1000;
-}
-
-int main(int argc, char *argv[])
-{
-	unsigned long start_ms;
-	int time_to_run, nr_forks = 0;
-
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <msecs to run>\n", argv[0]);
-		exit(1);
-	}
-	time_to_run = atoi(argv[1]);
-
-	start_ms = msec_timestamp();
-	while (true) {
-		int pid = fork();
-
-		if (pid < 0) {
-			fprintf(stderr, "fork() failed\n");
-			exit(1);
-		}
-		if (pid == 0)
-			write_targetid_exit();
-		wait(NULL);
-		nr_forks++;
-
-		if (msec_timestamp() - start_ms > time_to_run)
-			break;
-	}
-	printf("%d\n", nr_forks);
-	return 0;
-}
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_target_ids_pid_leak.sh
+++ /dev/null
@@ -1,22 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-before=$(grep "^pid " /proc/slabinfo | awk '{print $2}')
-
-nr_leaks=$(./debugfs_target_ids_pid_leak 1000)
-expected_after_max=$((before + nr_leaks / 2))
-
-after=$(grep "^pid " /proc/slabinfo | awk '{print $2}')
-
-echo > /sys/kernel/debug/damon/target_ids
-
-echo "tried $nr_leaks pid leak"
-echo "number of active pid slabs: $before -> $after"
-echo "(up to $expected_after_max expected)"
-if [ $after -gt $expected_after_max ]
-then
-	echo "maybe pids are leaking"
-	exit 1
-else
-	exit 0
-fi
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.c a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.c
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.c
+++ /dev/null
@@ -1,80 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Author: SeongJae Park <sj@kernel.org>
- */
-#define _GNU_SOURCE
-
-#include <fcntl.h>
-#include <stdbool.h>
-#include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/wait.h>
-#include <time.h>
-#include <unistd.h>
-
-#define DBGFS_MONITOR_ON "/sys/kernel/debug/damon/monitor_on_DEPRECATED"
-#define DBGFS_TARGET_IDS "/sys/kernel/debug/damon/target_ids"
-
-static void turn_damon_on_exit(void)
-{
-	int target_ids_fd = open(DBGFS_TARGET_IDS, O_RDWR);
-	int monitor_on_fd = open(DBGFS_MONITOR_ON, O_RDWR);
-	char pid_str[128];
-
-	snprintf(pid_str, sizeof(pid_str), "%d", getpid());
-	write(target_ids_fd, pid_str, sizeof(pid_str));
-	write(monitor_on_fd, "on\n", 3);
-	close(target_ids_fd);
-	close(monitor_on_fd);
-	usleep(1000);
-	exit(0);
-}
-
-static void try_race(void)
-{
-	int target_ids_fd = open(DBGFS_TARGET_IDS, O_RDWR);
-	int pid = fork();
-	int buf[256];
-
-	if (pid < 0) {
-		fprintf(stderr, "fork() failed\n");
-		exit(1);
-	}
-	if (pid == 0)
-		turn_damon_on_exit();
-	while (true) {
-		int status;
-
-		read(target_ids_fd, buf, sizeof(buf));
-		if (waitpid(-1, &status, WNOHANG) == pid)
-			break;
-	}
-	close(target_ids_fd);
-}
-
-static inline uint64_t ts_to_ms(struct timespec *ts)
-{
-	return (uint64_t)ts->tv_sec * 1000 + (uint64_t)ts->tv_nsec / 1000000;
-}
-
-int main(int argc, char *argv[])
-{
-	struct timespec start_time, now;
-	int runtime_ms;
-
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <runtime in ms>\n", argv[0]);
-		exit(1);
-	}
-	runtime_ms = atoi(argv[1]);
-	clock_gettime(CLOCK_MONOTONIC, &start_time);
-	while (true) {
-		try_race();
-		clock_gettime(CLOCK_MONOTONIC, &now);
-		if (ts_to_ms(&now) - ts_to_ms(&start_time) > runtime_ms)
-			break;
-	}
-	return 0;
-}
diff --git a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_target_ids_read_before_terminate_race.sh
+++ /dev/null
@@ -1,14 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-dmesg -C
-
-./debugfs_target_ids_read_before_terminate_race 5000
-
-if dmesg | grep -q dbgfs_target_ids_read
-then
-	dmesg
-	exit 1
-else
-	exit 0
-fi
diff --git a/tools/testing/selftests/damon/debugfs_target_ids.sh a/tools/testing/selftests/damon/debugfs_target_ids.sh
deleted file mode 100644
--- a/tools/testing/selftests/damon/debugfs_target_ids.sh
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-source _debugfs_common.sh
-
-# Test target_ids file
-# ====================
-
-file="$DBGFS/target_ids"
-orig_content=$(cat "$file")
-
-test_write_succ "$file" "1 2 3 4" "$orig_content" "valid input"
-test_write_succ "$file" "1 2 abc 4" "$orig_content" "still valid input"
-test_content "$file" "$orig_content" "1 2" "non-integer was there"
-test_write_succ "$file" "abc 2 3" "$orig_content" "the file allows wrong input"
-test_content "$file" "$orig_content" "" "wrong input written"
-test_write_succ "$file" "" "$orig_content" "empty input"
-test_content "$file" "$orig_content" "" "empty input written"
-echo "$orig_content" > "$file"
--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-remove-tests-for-damon-debugfs-interface
+++ a/tools/testing/selftests/damon/.gitignore
@@ -1,6 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-huge_count_read_write
-debugfs_target_ids_read_before_terminate_race
-debugfs_target_ids_pid_leak
 access_memory
 access_memory_even
diff --git a/tools/testing/selftests/damon/huge_count_read_write.c a/tools/testing/selftests/damon/huge_count_read_write.c
deleted file mode 100644
--- a/tools/testing/selftests/damon/huge_count_read_write.c
+++ /dev/null
@@ -1,46 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Author: SeongJae Park <sj@kernel.org>
- */
-
-#include <fcntl.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <stdio.h>
-
-#pragma GCC diagnostic push
-#if __GNUC__ >= 11 && __GNUC_MINOR__ >= 1
-/* Ignore read(2) overflow and write(2) overread compile warnings */
-#pragma GCC diagnostic ignored "-Wstringop-overread"
-#pragma GCC diagnostic ignored "-Wstringop-overflow"
-#endif
-
-void write_read_with_huge_count(char *file)
-{
-	int filedesc = open(file, O_RDWR);
-	char buf[256];
-	int ret;
-
-	printf("%s %s\n", __func__, file);
-	if (filedesc < 0) {
-		fprintf(stderr, "failed opening %s\n", file);
-		exit(1);
-	}
-
-	write(filedesc, "", 0xfffffffful);
-	ret = read(filedesc, buf, 0xfffffffful);
-	close(filedesc);
-}
-
-#pragma GCC diagnostic pop
-
-int main(int argc, char *argv[])
-{
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
-		exit(1);
-	}
-	write_read_with_huge_count(argv[1]);
-
-	return 0;
-}
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-remove-tests-for-damon-debugfs-interface
+++ a/tools/testing/selftests/damon/Makefile
@@ -1,15 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for damon selftests
 
-TEST_GEN_FILES += huge_count_read_write
-TEST_GEN_FILES += debugfs_target_ids_read_before_terminate_race
-TEST_GEN_FILES += debugfs_target_ids_pid_leak
 TEST_GEN_FILES += access_memory access_memory_even
 
-TEST_FILES = _chk_dependency.sh _debugfs_common.sh _damon_sysfs.py
+TEST_FILES = _chk_dependency.sh _damon_sysfs.py
 
 # functionality tests
-TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
 TEST_PROGS += sysfs.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
@@ -17,11 +13,6 @@ TEST_PROGS += damos_tried_regions.py dam
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 # regression tests (reproducers of previously found bugs)
-TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
-TEST_PROGS += debugfs_duplicate_context_creation.sh
-TEST_PROGS += debugfs_rm_non_contexts.sh
-TEST_PROGS += debugfs_target_ids_read_before_terminate_race.sh
-TEST_PROGS += debugfs_target_ids_pid_leak.sh
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch

