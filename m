Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B043563C11
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 20:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g8HqhyLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D28C433C8;
	Tue, 12 Dec 2023 20:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702412962;
	bh=Y2NLRYyOvufcbVngqaXNgHRwmeHa6EGH5J1anucjAqM=;
	h=Date:To:From:Subject:From;
	b=g8HqhyLreGCvWGZzvCr9TCGEKfGUwYxhpCxLasnhY8+vEuUXTEZS2rlrPqdmslt5R
	 4SWrKuAyTYOa+3nYf67eIdmZ0b/4l+yxZ5IhMPqI9qwSItryZdC51eYEBJMrXqC4HE
	 d9rnin8rBRsPfgCj/WijvTPv1HnI92oMTf/lwW1s=
Date: Tue, 12 Dec 2023 12:29:21 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch added to mm-unstable branch
Message-Id: <20231212202922.69D28C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for update_schemes_tried_regions sysfs command
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch

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
Subject: selftests/damon: add a test for update_schemes_tried_regions sysfs command
Date: Tue, 12 Dec 2023 19:48:09 +0000

Add a selftest for verifying the accuracy of DAMON's access monitoring
functionality.  The test starts a program of artificial access pattern,
monitor the access pattern using DAMON, and check if DAMON finds expected
amount of hot data region (working set size) with only acceptable error
rate.

Note that the acceptable error rate is set with only naive assumptions and
small number of tests.  Hence failures of the test may not always mean
DAMON is broken.  Rather than that, those could be a signal to better
understand the real accuracy level of DAMON in wider environments.  Based
on further finding, we could optimize DAMON or adjust the expectation of
the test.

Link: https://lkml.kernel.org/r/20231212194810.54457-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                                             |    2 
 tools/testing/selftests/damon/access_memory.c                                      |   41 +++++++
 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |   55 ++++++++++
 3 files changed, 98 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/access_memory.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Artificial memory access program for testing DAMON.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+int main(int argc, char *argv[])
+{
+	char **regions;
+	clock_t start_clock;
+	int nr_regions;
+	int sz_region;
+	int access_time_ms;
+	int i;
+
+	if (argc != 4) {
+		printf("Usage: %s <number> <size (bytes)> <time (ms)>\n",
+				argv[0]);
+		return -1;
+	}
+
+	nr_regions = atoi(argv[1]);
+	sz_region = atoi(argv[2]);
+	access_time_ms = atoi(argv[3]);
+
+	regions = malloc(sizeof(*regions) * nr_regions);
+	for (i = 0; i < nr_regions; i++)
+		regions[i] = malloc(sz_region);
+
+	for (i = 0; i < nr_regions; i++) {
+		start_clock = clock();
+		while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC <
+				access_time_ms)
+			memset(regions[i], i, 1024 * 1024 * 10);
+	}
+	return 0;
+}
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command
+++ a/tools/testing/selftests/damon/Makefile
@@ -2,6 +2,7 @@
 # Makefile for damon selftests
 
 TEST_GEN_FILES += huge_count_read_write
+TEST_GEN_FILES += access_memory
 
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
@@ -9,6 +10,7 @@ TEST_PROGS += debugfs_empty_targets.sh d
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
+TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -0,0 +1,55 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import subprocess
+import time
+
+import _damon_sysfs
+
+def main():
+    # access two 10 MiB memory regions, 2 second per each
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    access_pattern=_damon_sysfs.DamosAccessPattern(
+                        # >= 25% access rate, >= 200ms age
+                        nr_accesses=[5, 20], age=[2, 2**64 - 1]))] # schemes
+                )] # contexts
+            )]) # kdamonds
+
+    err = kdamonds.start()
+    if err != None:
+        print('kdmaond start failed: %s' % err)
+        exit(1)
+
+    wss_collected = []
+    while proc.poll() == None:
+        time.sleep(0.1)
+        err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
+        if err != None:
+            print('tried bytes update failed: %s' % err)
+            exit(1)
+
+        wss_collected.append(
+                kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+
+    wss_collected.sort()
+    acceptable_error_rate = 0.2
+    for percentile in [50, 75]:
+        sample = wss_collected[int(len(wss_collected) * percentile / 100)]
+        error_rate = abs(sample - sz_region) / sz_region
+        print('%d-th percentile (%d) error %f' %
+                (percentile, sample, error_rate))
+        if error_rate > acceptable_error_rate:
+            print('the error rate is not acceptable (> %f)' %
+                    acceptable_error_rate)
+            print('samples are as below')
+            print('\n'.join(['%d' % wss for wss in wss_collected]))
+            exit(1)
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch
selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

