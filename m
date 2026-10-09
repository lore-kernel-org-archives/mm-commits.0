Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1BE3B4423
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525398; cv=none; b=LStWnlxNff3U2/pUl3iP63Z1SNNVx8Z6TE0js4u0Ipf2fvdm9vXs6IxOwk5TFCuOJi2B8wKVGjAxIBWeDNU+JJKXJ5Nde8619XOKii5KWKV4tXb58pG5PWA82cBQAn2xoJZ5w/mzcg46Vmh4RZYjDKyqtf4Ecl36lwxCOvEqiiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525398; c=relaxed/simple;
	bh=AbXNmugqzx70+QZAJAdWcNASlpCcU3Sp5oVTxTPlMbM=;
	h=Date:To:From:Subject:Message-Id; b=rG4EWfs+PVCUmdIPRbp0cm79nZtjNOvqEC7O9fXzCKRDzEmWUD4rlaDG65yJyyNALwE2+s48LO6htdUZm0lq9TNxpBp4rY/q/XaxKlUwZ8avCF8vy2jhQ9bk+HYtjK5E1/q7EUdv8BrszNPaS4kFFMYvxnjpjYsR/Lz8ILwV1iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krL+1Dmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krL+1Dmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F7E1F000FF;
	Fri,  9 Oct 2026 05:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525394;
	bh=H9nLyXONREbgYUPLtVbubSdmxn9FAtB6TGAE+WdvvKU=;
	h=Date:To:From:Subject;
	b=krL+1DmpDValuOn6zHfKkzpO7olL1hwu7f8AcYvCH93rvmthY4htbq+w9/ZN1J/lV
	 MMJOJGuYMnPHLY5yI0k7hsj3untQEqfZBUuzbcGoIrBrWG7MVT0iKTxO2lbS8TpARc
	 qWBBcaoByIMMmSeQYWna5dpMjS6AH3g99Gj/c318=
Date: Thu, 08 Oct 2026 22:56:34 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch removed from -mm tree
Message-Id: <20261009055634.83F7E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: remove unnecessary damon_call() param validation
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/lru_sort: remove unnecessary damon_call() param validation
Date: Wed, 2 Sep 2026 18:03:33 -0700

DAMON_LRU_SORT avoids passing NULL or unstarted damon_ctx to damon_call()
with its own validation.  The validation is no longer needed, because the
DAMON core layer now handles the corner cases itself.  Remove the
unnecessary check.

Link: https://lore.kernel.org/20260903010334.93622-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation
+++ a/mm/damon/lru_sort.c
@@ -344,8 +344,6 @@ static int damon_lru_sort_commit_inputs_
 	return damon_lru_sort_apply_parameters();
 }
 
-static bool damon_lru_sort_damon_has_started;
-
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -366,10 +364,6 @@ static int damon_lru_sort_commit_inputs_
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_lru_sort_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -420,8 +414,6 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_lru_sort_damon_has_started)
-		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
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

