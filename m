Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E98C8BF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560207; cv=none; b=mz7cSgXBpSmkPzsz0Xrgz2UE8vkibtPzCQpqgurSizWH3Zb/CCQ0fFbKkag/UJnxEpc+8M273A9CpZxf8s2za8l+Fai0mjj6xVDiFHG5jt1dnDXvDYbAeUFmIHDXWi2eVR3rscyxb11knPzIyzcKCwxR9jKvnDggqLVESA6RXFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560207; c=relaxed/simple;
	bh=K6+nI0FjbP3aRJ1/dvVHdGDf/tbknRrNSl7k1gvxBkQ=;
	h=Date:To:From:Subject:Message-Id; b=f0iYF5UcAEhkIIltFknqyswQEjdi4qBz+GSCZrojetMhyJnbUEKjcc/XAjOOobMZ43CK05JgHugSC4zxcc8LEO1TZD2ZT8GCHaaOsz51ZzteSahHs7UbQIJkw9j1tAea9+TbZb5x9FEWk14hl/A/PX1WosrepQeADDAw4jPS5tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=stwFVjk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="stwFVjk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562ABC43390;
	Thu, 22 Feb 2024 00:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560207;
	bh=K6+nI0FjbP3aRJ1/dvVHdGDf/tbknRrNSl7k1gvxBkQ=;
	h=Date:To:From:Subject:From;
	b=stwFVjk5BGGwCI7cfrq1WnQmHYNesLI7kOBhje3qmg6C/Gh2BxTsntEnCWvLE5eFo
	 KK5dZMaLJm3UukFAWOUf6lcZ5ZVhHsDp2m1NYJDbXEB5SUlD3sy7wiS8sctg6FrFSq
	 EnFEgv6AHqB9zsBScNv1h8UeIaCMubz0z8On6CJ8=
Date: Wed, 21 Feb 2024 16:03:26 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-a-test-for-damos-quota.patch removed from -mm tree
Message-Id: <20240222000327.562ABC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add a test for DAMOS quota
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-a-test-for-damos-quota.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add a test for DAMOS quota
Date: Wed, 7 Feb 2024 12:31:30 -0800

Add a selftest for verifying the DAMOS quota feature.  The test is very
similar to sysfs_update_schemes_tried_regions_wss_estimation.py.  It
starts an artificial workload of 20 MiB working set, run DAMON to find the
working set size, but with 1 MiB/100 ms size quota.  Then, it collect the
DAMON-found working set size every 100 ms and check if the quota was
always applied as expected.  For the confirmation, the tests shows the
stat-applied region size and the qt_exceeds stat.

Link: https://lkml.kernel.org/r/20240207203134.69976-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile       |    1 
 tools/testing/selftests/damon/damos_quota.py |   67 +++++++++++++++++
 2 files changed, 68 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/damos_quota.py
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
+    sz_quota = 1024 * 1024 # 1 MiB
+    quota_reset_interval = 100 # 100 ms
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    access_pattern=_damon_sysfs.DamosAccessPattern(
+                        # >= 25% access rate, >= 200ms age
+                        nr_accesses=[5, 20], age=[2, 2**64 - 1]),
+                    quota=_damon_sysfs.DamosQuota(
+                        sz=sz_quota, reset_interval_ms=quota_reset_interval)
+                    )] # schemes
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
+        err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
+        if err != None:
+            print('tried bytes update failed: %s' % err)
+            exit(1)
+        err = kdamonds.kdamonds[0].update_schemes_stats()
+        if err != None:
+            print('stats update failed: %s' % err)
+            exit(1)
+
+        scheme = kdamonds.kdamonds[0].contexts[0].schemes[0]
+        wss_collected.append(scheme.tried_bytes)
+        nr_quota_exceeds = scheme.stats.qt_exceeds
+
+    wss_collected.sort()
+    for wss in wss_collected:
+        if wss > sz_quota:
+            print('quota is not kept: %s > %s' % (wss, sz_quota))
+            print('collected samples are as below')
+            print('\n'.join(['%d' % wss for wss in wss_collected]))
+            exit(1)
+
+    if nr_quota_exceeds < len(wss_collected):
+        print('quota is not always exceeded: %d > %d' %
+              (len(wss_collected), nr_quota_exceeds))
+        exit(1)
+
+if __name__ == '__main__':
+    main()
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-add-a-test-for-damos-quota
+++ a/tools/testing/selftests/damon/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
+TEST_PROGS += damos_quota.py
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

