Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589F52FE592
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 02:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618243; cv=none; b=lpdQuZz6zBUZtuFeXRzAgJjx3YXQ8qnBU9OenT6Hre5DO+3nie3ibxTgOX2HM2vSEcNUpVpWsvWUODHIEZaVHv2lLNCMHA2Jw0+Xx+H1AnmqcM6TI6jCpRAAASgNBJXE2T2pl50ch1eYWuidFZTeOM4O/8tXyyH2l6cyXAFaGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618243; c=relaxed/simple;
	bh=BaWjyOqGfR48U2+I0BibpVbkcrfSPl4Ca86Pk9KLxHk=;
	h=Date:To:From:Subject:Message-Id; b=IIiwUGproszK7RBY4CMrL2TH2aBgQp6As/SllL7cAR93vkPfgFhVOhm+mSSvQjD2zQFlYRd+Yz/9/aR5RPi+4PEaD8Yc00Lo76jmmHAh6OO+YWGHSxe52QLmzWhSsR4Ps0Yg2VuOtpXJmviotMKAl/mmEID2anU1fi4Ke2hxiGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRqOEoGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRqOEoGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE3C116C6;
	Sat, 17 Jan 2026 02:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768618242;
	bh=BaWjyOqGfR48U2+I0BibpVbkcrfSPl4Ca86Pk9KLxHk=;
	h=Date:To:From:Subject:From;
	b=VRqOEoGU1rBOY3ZXwaKBSm0CNkXV2TNCc6lngg+hR9q1ysej2DcyQ0eSjlJ/kPBrb
	 XWg/1U0w15iZMC56sFKParEO1gX3T0LTm7k2qfj8aewQnGvpfedzvl/8idXcb105g2
	 Va89IqhIVHuv9wwSdCRiH3WrX+1iPgxF0l+YpLwc=
Date: Fri, 16 Jan 2026 18:50:42 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch added to mm-new branch
Message-Id: <20260117025042.DBFE3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch

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
Subject: selftests/damon/sysfs_memcg_path_leak.sh: use kmemleak
Date: Fri, 16 Jan 2026 18:07:24 -0800

Patch series "selftests/damon: improve leak detection and wss estimation
reliability".

Two DAMON selftets, namely 'sysfs_memcg_leak' and
'sysfs_update_schemes_tried_regions_wss_estimation' frequently show
intermittent failures due to their unreliable leak detection and working
set size estimation.  Make those more reliable.


This patch (of 5):

sysfs_memcg_path_leak.sh determines if the memory leak has happened by
seeing if Slab size on /proc/meminfo increases more than expected after an
action.  Depending on the system and background workloads, the reasonable
expectation varies.  For the reason, the test frequently shows
intermittent failures.  Use kmemleak, which is much more reliable and
correct, instead.

Link: https://lkml.kernel.org/r/20260117020731.226785-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260117020731.226785-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh |   26 +++++-----
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh~selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak
+++ a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -14,6 +14,13 @@ then
 	exit $ksft_skip
 fi
 
+kmemleak="/sys/kernel/debug/kmemleak"
+if [ ! -f "$kmemleak" ]
+then
+	echo "$kmemleak not found"
+	exit $ksft_skip
+fi
+
 # ensure filter directory
 echo 1 > "$damon_sysfs/kdamonds/nr_kdamonds"
 echo 1 > "$damon_sysfs/kdamonds/0/contexts/nr_contexts"
@@ -22,22 +29,17 @@ echo 1 > "$damon_sysfs/kdamonds/0/contex
 
 filter_dir="$damon_sysfs/kdamonds/0/contexts/0/schemes/0/filters/0"
 
-before_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
-
-# try to leak 3000 KiB
-for i in {1..102400};
+# try to leak 128 times
+for i in {1..128};
 do
 	echo "012345678901234567890123456789" > "$filter_dir/memcg_path"
 done
 
-after_kb=$(grep Slab /proc/meminfo | awk '{print $2}')
-# expect up to 1500 KiB free from other tasks memory
-expected_after_kb_max=$((before_kb + 1500))
-
-if [ "$after_kb" -gt "$expected_after_kb_max" ]
+echo scan > "$kmemleak"
+kmemleak_report=$(cat "$kmemleak")
+if [ "$kmemleak_report" = "" ]
 then
-	echo "maybe memcg_path are leaking: $before_kb -> $after_kb"
-	exit 1
-else
 	exit 0
 fi
+echo "$kmemleak_report"
+exit 1
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

