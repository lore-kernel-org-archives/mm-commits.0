Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FE03C1D6C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525390; cv=none; b=FI62z35W8+z/zZTIfmQiMVHsl3qi8lEoMgOrmsMoVJMOPyzigIYzs5eL57pPf6ttVkE1l+3p9xNUnotPLp+pARJ9EJYb8MNWGQql4oiWghXp541VNyPagSWmAbcxs0x2cCyHbn0TaTuNMSKobdTVs7uEHG5S59XnrNur051aEKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525390; c=relaxed/simple;
	bh=JusB2plwESga7RG/Wb+7gjjU2aFxJalqe4G9QiJRl/c=;
	h=Date:To:From:Subject:Message-Id; b=m0Hx0lJwyjcSnies/LNMtdC64SFaGez0nEt9xK3pjGFmVTEuyIUgj+4rjrmfuJK1+rieV3j1E60dE4agNJ+P4XXMS1lApvPGgsgzdCMmyCJkrcHLMXS4P2tBC8wRKLn7pw0H7fIZnqZFHRpMrTOHUOqP+Rnd6s3i4XFOWogk/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QAqm+7Tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QAqm+7Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB91F1F00893;
	Fri,  9 Oct 2026 05:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525388;
	bh=KITljMjDHpekHhyML/rJaVjoQ8q4Y9Wn0YX9++3b02Y=;
	h=Date:To:From:Subject;
	b=QAqm+7Tth/XvOYimXky2C9SMfli7S3WPCkEil/BhhQw83QQoWyF+8A9P2v5P7k83J
	 uL43vwstMVp8bfLthv7RAe6/8f/E61OapFBdHzgTVz1ANSRpCpyEQhuZ4D5KpUvwL+
	 d4X+Tvc00hJi4BdGbavRQyKx8+uPv7ldSOKqD/L8=
Date: Thu, 08 Oct 2026 22:56:28 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch removed from -mm tree
Message-Id: <20261009055628.CB91F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
has been removed from the -mm tree.  Its filename was
     revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
Date: Wed, 2 Sep 2026 18:07:20 -0700

This reverts commit 06befa61c427e74319781e6f35a364cfc32dbae8.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero target_value. 
The corner case handling in DAMON_LRU_SORT is hence no more needed. 
Remove it.

Note that this slightly changes the user behavior.  It still disallows
active_mem_bp of 10,002.  But now it allows other >10,000 active_mem_bp
values.  Setting >10,000 active_mem_bp makes not much sense.  But it
doesn't cause critical problems such as memory leak or crash, either. 
Arguably that doesn't deserve additional code complexity.  Just allow it.

Link: https://lore.kernel.org/20260903010722.94244-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/lru_sort.c~revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp
+++ a/mm/damon/lru_sort.c
@@ -233,8 +233,6 @@ static int damon_lru_sort_add_quota_goal
 
 	if (!active_mem_bp)
 		return 0;
-	if (10000 < active_mem_bp)
-		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

