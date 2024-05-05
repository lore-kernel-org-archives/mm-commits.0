Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B246B76036
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942878; cv=none; b=T8ocJs2axXwYGDiepBLAub3qJ0tYW5BGV7dEozaklQPgFVcD+y6Sc1DalMyX5IuYZmo2GD7kedGF/fNVULWaAFasD4dbURDgmyMIg7uhUU6Z35yLOwzjAJkEVq9Y402vagi7FF4a7zDLG5Bw3XoOblBtCCQNTrkYWEh1QcDJ+y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942878; c=relaxed/simple;
	bh=TqwirhasMoVT8koULD6gYpLC86YZXRSlFz1+BcRztWk=;
	h=Date:To:From:Subject:Message-Id; b=lzKiQDizZo2mxKKixGMN26e2bIsuOrkFKZUurgGJNTmn38R/vpfGr5hyRhuF4WPYe6mmEUDCciBg38AbgzHkfZFywCcwL2MfRwSbDwCeNlKHg0Y7ayN/ly7c/fA9dP5JhGFXuu1oO4Q9A1rjKUJYidruGxbbbf8+88bUgF7HbNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQQv7Lc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQQv7Lc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B62FC113CC;
	Sun,  5 May 2024 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942878;
	bh=TqwirhasMoVT8koULD6gYpLC86YZXRSlFz1+BcRztWk=;
	h=Date:To:From:Subject:From;
	b=pQQv7Lc/RE6wRiqJcElxfNLug1cBUs3cqKBTk93T65uPIqcel8UkIONgffjhZ7TcG
	 VFqazo4WIRKhJ+D8fmyqitTJ5SMg4UdT7KlK3/T3kVWpWg3s3ETZnjkKZKpyn07Lxp
	 ETynE1c5BQ9p+3vqIRMmZFDeD2LEWr32tSikF6lU=
Date: Sun, 05 May 2024 14:01:17 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-a-test-for-damos-quota-goal.patch added to mm-unstable branch
Message-Id: <20240505210118.3B62FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add a test for DAMOS quota goal
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-a-test-for-damos-quota-goal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-a-test-for-damos-quota-goal.patch

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

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

