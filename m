Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2F36AF8
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467325; cv=none; b=EqnZ+7BZjFWjlqZ0pO66+3bJHb8iJcy1HWwuwn62p4Zl4ZRDiBc1QnA3+jcLfTbi3rvoPhs3HWajw/X2ikk95bF5YW+vTuj5VZydx6XihJ7EOoHe3gQE1rt1x8gOw0VkVJ1MV/l9Xdm1kSQax90hFqVBVGs9JeB+bR4BRx216eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467325; c=relaxed/simple;
	bh=rjbluM/NPI2OunwF1bDFoyhGhBrX145pqHzlwi1OlsY=;
	h=Date:To:From:Subject:Message-Id; b=Xt9/G86U/e1ezb9C7jQ7YSiWZODGGlImA3zBF7Z3O1bkH+Tni2weiyP6nJtXcPHXkDOuTHTrwnYJv3ugLm3u2UlIOAzvyw/oFj872WFLUd/U3Vqk6wWMLDd4aDVKEkcipAu6De7CgAb9FcbpehXawL4rdF731g1z8DWIZt7aSLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=unaf/qo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="unaf/qo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C82C32783;
	Sat, 11 May 2024 22:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467325;
	bh=rjbluM/NPI2OunwF1bDFoyhGhBrX145pqHzlwi1OlsY=;
	h=Date:To:From:Subject:From;
	b=unaf/qo2NBSg8pnGRYfEDcitUNyyxptCwTj8t6uBw1KjbW6lOcL/Cmgyk8lkNd0My
	 sg8YID3TTn8EB4thZo2NMhrZnsGm9KqaJwBhEPaR16OcU1aoRZ2cFmqq7QjzqmZD8W
	 lMKgpx8loX6zrX4aW2i1kVxOQ6865DIbZA7AH24E=
Date: Sat, 11 May 2024 15:42:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-a-test-for-damos-quota-goal.patch removed from -mm tree
Message-Id: <20240511224205.78C82C32783@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add a test for DAMOS quota goal
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-a-test-for-damos-quota-goal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add a test for DAMOS quota goal
Date: Thu, 2 May 2024 10:27:18 -0700

Add a selftest for DAMOS quota goal.  It tests the feature by setting a
user_input metric based goal, change the current feedback, and check if
the effective quota size is increased and decreased as expected.

Link: https://lkml.kernel.org/r/20240502172718.74166-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile            |    2 
 tools/testing/selftests/damon/damos_quota_goal.py |   77 ++++++++++++
 2 files changed, 78 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/damon/damos_quota_goal.py
@@ -0,0 +1,77 @@
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
+
+    goal = _damon_sysfs.DamosQuotaGoal(
+            metric=_damon_sysfs.qgoal_metric_user_input, target_value=10000)
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    action='stat',
+                    quota=_damon_sysfs.DamosQuota(
+                        goals=[goal], reset_interval_ms=100),
+                    )] # schemes
+                )] # contexts
+            )]) # kdamonds
+
+    err = kdamonds.start()
+    if err != None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    score_values_to_test = [0, 15000, 5000, 18000]
+    while proc.poll() == None:
+        if len(score_values_to_test) == 0:
+            time.sleep(0.1)
+            continue
+
+        goal.current_value = score_values_to_test.pop(0)
+        expect_increase = goal.current_value < goal.target_value
+
+        err = kdamonds.kdamonds[0].commit_schemes_quota_goals()
+        if err is not None:
+            print('commit_schemes_quota_goals failed: %s' % err)
+            exit(1)
+
+        err = kdamonds.kdamonds[0].update_schemes_effective_quotas()
+        if err is not None:
+            print('before-update_schemes_effective_quotas failed: %s' % err)
+            exit(1)
+        last_effective_bytes = goal.effective_bytes
+
+        time.sleep(0.5)
+
+        err = kdamonds.kdamonds[0].update_schemes_effective_quotas()
+        if err is not None:
+            print('after-update_schemes_effective_quotas failed: %s' % err)
+            exit(1)
+
+        print('score: %s, effective quota: %d -> %d (%.3fx)' % (
+            goal.current_value, last_effective_bytes, goal.effective_bytes,
+            goal.effective_bytes / last_effective_bytes
+            if last_effective_bytes != 0 else -1.0))
+
+        if last_effective_bytes == goal.effective_bytes:
+            print('efective bytes not changed: %d' % goal.effective_bytes)
+            exit(1)
+
+        increased = last_effective_bytes < goal.effective_bytes
+        if expect_increase != increased:
+            print('expectation of increase (%s) != increased (%s)' %
+                  (expect_increase, increased))
+            exit(1)
+        last_effective_bytes = goal.effective_bytes
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-damos-quota-goal
+++ a/tools/testing/selftests/damon/Makefile
@@ -16,7 +16,7 @@ TEST_PROGS += debugfs_target_ids_pid_lea
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
-TEST_PROGS += damos_quota.py damos_apply_interval.py
+TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
_

Patches currently in -mm which might be from sj@kernel.org are


