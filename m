Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C5831A7F8
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 02:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618245; cv=none; b=JxkOZrPTgrc7gxCwjYUz/vTD/ynvnZ8VMB2f7rAHG1JdmIZmUyEh6qAVAfG+r2omWArBHRmNczFd8ttf29f+hIIc+Knp6e20YvTnK7jHrIXD/AVJn8ohxLyCMrrzdTH2/iin+4zNbwWqNjT+NMGVo4RK9QlLZ6k2c7+SMArr1kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618245; c=relaxed/simple;
	bh=nPjBpSb7fcispyAskq+QuBrL+Kngm2LpXBdEfWCCaHM=;
	h=Date:To:From:Subject:Message-Id; b=J58x5BVpwU8PWOHJ4IEi2/twyXqgUA7fL9lSJAOCO9+WYaRR0+w7j/6J3xMMh2jvVWLKfckk2yM1Y18hFNwwyIn3YyMYuu5M90z+gnenJf0bpWHNnAiy77D6rkH98hglxgaJ38+2il6CHBk/VtWC8uwuLbjTly7E5vxInKetYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VEMdW85G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VEMdW85G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52A4C116C6;
	Sat, 17 Jan 2026 02:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768618244;
	bh=nPjBpSb7fcispyAskq+QuBrL+Kngm2LpXBdEfWCCaHM=;
	h=Date:To:From:Subject:From;
	b=VEMdW85GoxFrkt9feisISVGK5mGmZY+TGoAZYl3dKPv2SEl5FWwPRKlu5jmzjquqO
	 UZiM4RpL9rw4UCJDMtcNEIYzm23UAonqIa50Bwy0WrpBZ//JokAgY93BlXCxvAx0ho
	 G+KNGCU+Jnq4Eytj9nHqN+/Vy68UTEGqYVCE3h7I=
Date: Fri, 16 Jan 2026 18:50:44 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch added to mm-new branch
Message-Id: <20260117025044.D52A4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/wss_estimation: test for up to 160 MiB working set size
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/wss_estimation: test for up to 160 MiB working set size
Date: Fri, 16 Jan 2026 18:07:25 -0800

DAMON reads and writes Accessed bits of page tables without manual TLB
flush for two reasons.  First, it minimizes the overhead.  Second, real
systems that need DAMON are expected to be memory intensive enough to
cause periodic TLB flushes.  For test setups that use small test
workloads, however, the system's TLB could be big enough to cover whole or
most accesses of the test workload.  In this case, no page table walk
happens and DAMON cannot show any access from the test workload.

The test workload for DAMON's working set size estimation selftest is such
a case.  It accesses only 10 MiB working set, and it turned out there are
test setups that have TLBs large enough to cover the 10 MiB data accesses.
As a result, the test fails depending on the test machine.

Make it more reliable by trying larger working sets up to 160 MiB when it
fails.

Link: https://lkml.kernel.org/r/20260117020731.226785-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |   29 +++++++---
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -6,9 +6,8 @@ import time
 
 import _damon_sysfs
 
-def main():
-    # access two 10 MiB memory regions, 2 second per each
-    sz_region = 10 * 1024 * 1024
+def pass_wss_estimation(sz_region):
+    # access two regions of given size, 2 seocnds per each region
     proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
             contexts=[_damon_sysfs.DamonCtx(
@@ -36,20 +35,38 @@ def main():
 
         wss_collected.append(
                 kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+    err = kdamonds.stop()
+    if err is not None:
+        print('kdamond stop failed: %s' % err)
+        exit(1)
 
     wss_collected.sort()
     acceptable_error_rate = 0.2
     for percentile in [50, 75]:
         sample = wss_collected[int(len(wss_collected) * percentile / 100)]
         error_rate = abs(sample - sz_region) / sz_region
-        print('%d-th percentile (%d) error %f' %
-                (percentile, sample, error_rate))
+        print('%d-th percentile error %f (expect %d, result %d)' %
+                (percentile, error_rate, sz_region, sample))
         if error_rate > acceptable_error_rate:
             print('the error rate is not acceptable (> %f)' %
                     acceptable_error_rate)
             print('samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
-            exit(1)
+            return False
+    return True
+
+def main():
+    # DAMON doesn't flush TLB.  If the system has large TLB that can cover
+    # whole test working set, DAMON cannot see the access.  Test up to 160 MiB
+    # test working set.
+    sz_region_mb = 10
+    max_sz_region_mb = 160
+    while sz_region_mb <= max_sz_region_mb:
+        test_pass = pass_wss_estimation(sz_region_mb * 1024 * 1024)
+        if test_pass is True:
+            exit(0)
+        sz_region_mb *= 2
+    exit(1)
 
 if __name__ == '__main__':
     main()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch

