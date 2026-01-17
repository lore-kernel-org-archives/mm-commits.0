Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAF7322A3F
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 02:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618247; cv=none; b=kcpFNCy/kLakD+nOYJWbgi3s1rNFPEKzlqrw1vCGmZ/Mgj9VqXNJeUThUeRuzmYpKueZOwCpU/1BDqiPAZqzH3icFIS384geSci6/y0Kx2dw3bfPP1R5hien2NKVDZIW3Y/f+YpY5C1ucXcyXEH7mCYMubT406uCFRVKI5cRepA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618247; c=relaxed/simple;
	bh=FIJbGRae7qXO7zgVjucsT1gVKVgmVA/4CNdj76mEihQ=;
	h=Date:To:From:Subject:Message-Id; b=FySg0C3cVoexl49TOKwc5kYrMI9VwqHiPYjykjnMEl+FA5nR61Xv99x1DZDx/R6WdrvepzhsswR1aaGVAbNcZLvQDY70txexWb/ai76w28pOzrCekjtWPtuX5kAAy6CdnZh8z++5LXEpM9+joBdFvrLz9sa3w59tQQDhpVGEKYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CVb3JO0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CVb3JO0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FF9C116C6;
	Sat, 17 Jan 2026 02:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768618246;
	bh=FIJbGRae7qXO7zgVjucsT1gVKVgmVA/4CNdj76mEihQ=;
	h=Date:To:From:Subject:From;
	b=CVb3JO0gaCLv/tRS7Hb2uMvvQeuWskJs92HwDYzxxSxZcPsvdnlOkT5asNF3MufVa
	 5Yd9rGbssoAE3rzOl7s3X8RajUKLPDpJiVjg5v00WKp3+eacGsZAe0LI5g81uXliVd
	 GTwF5kGzoZgfcuwzDKjWTe05v/J5Bls97Yc1X7Wk=
Date: Fri, 16 Jan 2026 18:50:46 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-access_memory-add-repeat-mode.patch added to mm-new branch
Message-Id: <20260117025046.C5FF9C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/access_memory: add repeat mode
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-access_memory-add-repeat-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-access_memory-add-repeat-mode.patch

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
Subject: selftests/damon/access_memory: add repeat mode
Date: Fri, 16 Jan 2026 18:07:26 -0800

'access_memory' is an artificial memory access generator program that is
used for a few DAMON selftests.  It accesses a given number of regions one
by one only once, and exits.  Depending on systems, the test workload may
exit faster than expected, making the tests unreliable.  For reliable
control of the artificial memory access pattern, add a mode to make it
repeat running.

Link: https://lkml.kernel.org/r/20260117020731.226785-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/access_memory.c |   29 +++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/damon/access_memory.c~selftests-damon-access_memory-add-repeat-mode
+++ a/tools/testing/selftests/damon/access_memory.c
@@ -8,6 +8,11 @@
 #include <string.h>
 #include <time.h>
 
+enum access_mode {
+	ACCESS_MODE_ONCE,
+	ACCESS_MODE_REPEAT,
+};
+
 int main(int argc, char *argv[])
 {
 	char **regions;
@@ -15,10 +20,12 @@ int main(int argc, char *argv[])
 	int nr_regions;
 	int sz_region;
 	int access_time_ms;
+	enum access_mode mode = ACCESS_MODE_ONCE;
+
 	int i;
 
-	if (argc != 4) {
-		printf("Usage: %s <number> <size (bytes)> <time (ms)>\n",
+	if (argc < 4) {
+		printf("Usage: %s <number> <size (bytes)> <time (ms)> [mode]\n",
 				argv[0]);
 		return -1;
 	}
@@ -27,15 +34,21 @@ int main(int argc, char *argv[])
 	sz_region = atoi(argv[2]);
 	access_time_ms = atoi(argv[3]);
 
+	if (argc > 4 && !strcmp(argv[4], "repeat"))
+		mode = ACCESS_MODE_REPEAT;
+
 	regions = malloc(sizeof(*regions) * nr_regions);
 	for (i = 0; i < nr_regions; i++)
 		regions[i] = malloc(sz_region);
 
-	for (i = 0; i < nr_regions; i++) {
-		start_clock = clock();
-		while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC <
-				access_time_ms)
-			memset(regions[i], i, sz_region);
-	}
+	do {
+		for (i = 0; i < nr_regions; i++) {
+			start_clock = clock();
+			while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC
+					< access_time_ms)
+				memset(regions[i], i, sz_region);
+		}
+	} while (mode == ACCESS_MODE_REPEAT);
+
 	return 0;
 }
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

