Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A638BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560208; cv=none; b=sDm69BsKgOFWk3hpMNnqAuszusF9vHdarjw1vFUrEi8GHC7kNJS5XSJAdEN6tYfx63IVwx2djNpv86gYDDfK/JxRA83wvGtsuXht41bWUJHj+qmL6wJzCP5N+n3hxyM0pbzw0ElP6y9xyGNlFzvd+yE2SCVr5v4q1ENhoNMVvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560208; c=relaxed/simple;
	bh=jze/GGQHrCpg+a5Rhtwx/X/DXuiKDaM3ZEJxRYC7BR0=;
	h=Date:To:From:Subject:Message-Id; b=b2DryI346yUaceiCfvTIy7nzq/cBRAV1xVJBriFDkMXkItduzW8NXkty/4e2U8E9cojfm7tUuw6XgQsWZFYuwvED9fMIklavjIvUwR40wh/Hp4+oSL//DAghDkwPtHmKo2d4M2GuqQFGsgyAfb1bZMDwViPNIRC8wy974w1orBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KnCKI1OD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KnCKI1OD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B29CC433C7;
	Thu, 22 Feb 2024 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560208;
	bh=jze/GGQHrCpg+a5Rhtwx/X/DXuiKDaM3ZEJxRYC7BR0=;
	h=Date:To:From:Subject:From;
	b=KnCKI1ODeOUe4zJqOMWQRxlshg+vWrzEOsWrVNdpHCUCnRQ1pqplXxpOqpqSLcUP2
	 qRMBicxeNoUpPd2i6AMtHyQAGcF8NKSMYErtHCfth6y6DEY8r+iO6NvVP1vO1SCluk
	 9e3XHtwTCFmpywuLMzdrj52ots7XrTtNOWQTfQGQ=
Date: Wed, 21 Feb 2024 16:03:27 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-a-test-for-damos-apply-intervals.patch removed from -mm tree
Message-Id: <20240222000328.3B29CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add a test for DAMOS apply intervals
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-a-test-for-damos-apply-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add a test for DAMOS apply intervals
Date: Wed, 7 Feb 2024 12:31:31 -0800

Add a selftest for DAMOS apply intervals.  It runs two schemes having
different apply interval agains an artificial memory access workload, and
check if the scheme with smaller apply interval was applied more
frequently.

Link: https://lkml.kernel.org/r/20240207203134.69976-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                |    2 
 tools/testing/selftests/damon/damos_apply_interval.py |   67 ++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/damon/damos_apply_interval.py
@@ -0,0 +1,67 @@
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
+    # Set quota up to 1 MiB per 100 ms
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[
+                    _damon_sysfs.Damos(
+                        access_pattern=_damon_sysfs.DamosAccessPattern(
+                            # >= 25% access rate, >= 200ms age
+                            nr_accesses=[5, 20], age=[2, 2**64 - 1]),
+                        # aggregation interval (100 ms) is used
+                        apply_interval_us=0),
+                    # use 10ms apply interval
+                    _damon_sysfs.Damos(
+                        access_pattern=_damon_sysfs.DamosAccessPattern(
+                            # >= 25% access rate, >= 200ms age
+                            nr_accesses=[5, 20], age=[2, 2**64 - 1]),
+                        # explicitly set 10 ms apply interval
+                        apply_interval_us=10 * 1000)
+                    ] # schemes
+                )] # contexts
+            )]) # kdamonds
+
+    err = kdamonds.start()
+    if err != None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    wss_collected = []
+    nr_quota_exceeds = 0
+    while proc.poll() == None:
+        time.sleep(0.1)
+        err = kdamonds.kdamonds[0].update_schemes_stats()
+        if err != None:
+            print('stats update failed: %s' % err)
+            exit(1)
+    schemes = kdamonds.kdamonds[0].contexts[0].schemes
+    nr_tried_stats = [s.stats.nr_tried for s in schemes]
+    if nr_tried_stats[0] == 0 or nr_tried_stats[1] == 0:
+        print('scheme(s) are not tried')
+        exit(1)
+
+    # Because the second scheme was having the apply interval that is ten times
+    # lower than that of the first scheme, the second scheme should be tried
+    # about ten times more frequently than the first scheme.  For possible
+    # timing errors, check if it was at least nine times more freuqnetly tried.
+    ratio = nr_tried_stats[1] / nr_tried_stats[0]
+    if ratio < 9:
+        print('%d / %d = %f (< 9)' %
+              (nr_tried_stats[1], nr_tried_stats[0], ratio))
+        exit(1)
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-damos-apply-intervals
+++ a/tools/testing/selftests/damon/Makefile
@@ -12,7 +12,7 @@ TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
-TEST_PROGS += damos_quota.py
+TEST_PROGS += damos_quota.py damos_apply_interval.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
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

