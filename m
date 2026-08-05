Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888103BFE3C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896673; cv=none; b=L0QF5dqvh/eHaz4tHwGxY93kTaAJj/VH/EERO7572pv2Xg56cogLirb4IImQK69TKU39HTjA7ovy67hqUCc5S8lbaRcMqRF62mBmvnHJxgU6DWhspraZj0JgLkgjl9ki3XodmR5y6+QfuxqMBaO/yCpWQSYURRLhJYAbiLY0KbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896673; c=relaxed/simple;
	bh=OSUWT/m0chEKDT0rBFJcKqjKNW9uQ7l0zM5+sOjCh6c=;
	h=Date:To:From:Subject:Message-Id; b=M1MTSdKrphDswYY4s42Aay7uGInM6Uu51vACbgPLXC80xRFyXvtpJXjb7psFAvmvIk9mut8LPLY5oCmXqhh3V3BRRVVjQv4kOiZdnIxEpZ1VZa+S3p/8b57DRxVqrL6M8t2qvHo8vYPxiu+/qvd8Kbws/AvYX7hqxcyGNVk9mOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LGQ97AEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LGQ97AEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF96D1F00A3A;
	Wed,  5 Aug 2026 02:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896669;
	bh=OlD8iuN4i0huwnMMpFToBmh+ziZYrsqljskHi1BSYsQ=;
	h=Date:To:From:Subject;
	b=LGQ97AEJ9aNw4UZ0Wvwwo1FK/XytsTN5b9ddSjYlpUrcdwt6oxb/I9bHcJdkpyj0B
	 o49gTyzMra9peuHZPGtT1P0whJkORQBz2CvLyljcJ0nP8/H/p++DtfZZh8L5bey7uh
	 2YPwIOJ4IfEvTxKCxeG4b4R/8lh+/m4vmlrDDX+U=
Date: Tue, 04 Aug 2026 19:24:28 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch removed from -mm tree
Message-Id: <20260805022428.EF96D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
has been removed from the -mm tree.  Its filename was
     mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
Date: Wed, 8 Jul 2026 06:53:53 -0700

accesses_bp_to_nr_accesses() actually converts a positive samples ratio to
the count.  Rename it to better describe what it really does and not
confusing for more general uses.

Link: https://lore.kernel.org/20260708135359.122587-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count
+++ a/mm/damon/core.c
@@ -876,11 +876,11 @@ static unsigned int damon_age_for_new_at
 	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
 }
 
-/* convert access ratio in bp (per 10,000) to nr_accesses */
-static unsigned int damon_accesses_bp_to_nr_accesses(
-		unsigned int accesses_bp, struct damon_attrs *attrs)
+/* convert sample ratio in bp (per 10,000) to count */
+static unsigned int damon_sample_bp_to_count(
+		unsigned int bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
+	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
@@ -893,7 +893,7 @@ static unsigned int damon_nr_accesses_to
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
-	return damon_accesses_bp_to_nr_accesses(
+	return damon_sample_bp_to_count(
 			damon_nr_accesses_to_accesses_bp(
 				nr_accesses, old_attrs),
 			new_attrs);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

