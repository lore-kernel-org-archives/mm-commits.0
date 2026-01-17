Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373BC2FE592
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 02:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618249; cv=none; b=ZY08l9eu4CzMmwbtLwxDXoLg1hXMao636MapW3i8UaXZ13bl0+Dn4tb+AVEThDvFiP4ERIe1zyU+eD6QfYuX3scz4UpNCZ6Z48p8apHQ6t1uC4ap8XLr3ihPBO6VLLlh179VBok+soxxqmcpUxj/gOzsWjWGu7YWI41SD1pAU94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618249; c=relaxed/simple;
	bh=IqfUNW2z7vFqyH0TtoLIZbo+4eEDWoJLqLx3V0KKmO8=;
	h=Date:To:From:Subject:Message-Id; b=fwO/cpmEeF/uP71Mdb4GprADRbrgWry2CL3AC+z0z5y+o7FfLV+Y9lMeSWZfdzJgtvLtkx5rKr4lTcnWDcNjmNMWePauRtefUDVPdH7Qz2RmG/hO2NOA99Q72DEGwaQcufzLdU8b3ntgGjqJ3MhBQcnOdh9WhRl90yxlwTiL9/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DqTWhZk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DqTWhZk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED332C116C6;
	Sat, 17 Jan 2026 02:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768618249;
	bh=IqfUNW2z7vFqyH0TtoLIZbo+4eEDWoJLqLx3V0KKmO8=;
	h=Date:To:From:Subject:From;
	b=DqTWhZk53LspA8afnNh8Q4LtPMBrFjm5cfPzS8rHG2kG0VkTpw1pY3v+iRGeyfinH
	 BiwbgJiQ4KpX+7njlN62/pGcCw95enz6DKO0Dsi6R84cUSatQtWpaADAXgJbfrbHjD
	 Njmr1i5sYVnfu8u1Iiy/pj0ERlmDbLRsEWzbOmLc=
Date: Fri, 16 Jan 2026 18:50:48 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch added to mm-new branch
Message-Id: <20260117025048.ED332C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/wss_estimation: ensure number of collected wss
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch

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
Subject: selftests/damon/wss_estimation: ensure number of collected wss
Date: Fri, 16 Jan 2026 18:07:27 -0800

DAMON selftest for working set size estimation collects DAMON's working
set size measurements of the running artificial memory access generator
program until the program is finished.  Depending on how quickly the
program finishes, and how quickly DAMON starts, the number of collected
working set size measurements may vary, and make the test results
unreliable.  Ensure it collects 40 measurements by using the repeat mode
of the artificial memory access generator program, and finish the
measurements only after the desired number of collections are made.

Link: https://lkml.kernel.org/r/20260117020731.226785-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-wss_estimation-ensure-number-of-collected-wss
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -8,7 +8,8 @@ import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
     # access two regions of given size, 2 seocnds per each region
-    proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
+    proc = subprocess.Popen(
+            ['./access_memory', '2', '%d' % sz_region, '2000', 'repeat'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
             contexts=[_damon_sysfs.DamonCtx(
                 ops='vaddr',
@@ -26,7 +27,7 @@ def pass_wss_estimation(sz_region):
         exit(1)
 
     wss_collected = []
-    while proc.poll() == None:
+    while proc.poll() is None and len(wss_collected) < 40:
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
         if err != None:
@@ -35,6 +36,7 @@ def pass_wss_estimation(sz_region):
 
         wss_collected.append(
                 kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+    proc.terminate()
     err = kdamonds.stop()
     if err is not None:
         print('kdamond stop failed: %s' % err)
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

