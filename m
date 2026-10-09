Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF43B05BF
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525391; cv=none; b=UdDgLkj6oRNtoOcYz45skzBsfTZ65jK/r9fIL2IoPZ978hoo5pTq2agTxnTkEmyP/1gfOq3ojlBRqB/xX8oLvQ9z5xYl3hSBgq/n3SxR7UZEY6gKHriQq7z+5coEUHIKZbWU4Rqk7V9u2cReo02Va1IsjLGQ+qOi8CBRVO7CIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525391; c=relaxed/simple;
	bh=X8Sue6V3SDvK3w9hjLTt0I6sDk8J62uf7Jo6itO87KI=;
	h=Date:To:From:Subject:Message-Id; b=bwE5aSmLkHOAdB9UDRx4jqL/OX5Ma3UkGJvy1gHSaLhuKH9cKTX8b2USrxVoyYGvg8w0Qv7tnI5FsFsZqi2m4964xiR0g+RETTwze1vVbO7xJcXFurPQqPLD3O+IL1eTxqJb//2v0tSSic3M1JpZYJxd6m0ZpBBcPbVUL1X4HsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OI+48Dtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OI+48Dtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CFC1F000FF;
	Fri,  9 Oct 2026 05:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525390;
	bh=FpQUDblUTKSN15A6nnb5R3XwQKDy8Y2eoA6YvCjwbfk=;
	h=Date:To:From:Subject;
	b=OI+48DtbFZChHY3eIK1RrCogYBgcM1n1s6vtkw+WBPkpjlICObEX+w0badAbW//hv
	 UgOQ8uKBZqiIegCuVpRirl8omWcebua7Q6eHhj1FZz1WwpV34LoydR/7FF9QpK+tIw
	 viysk+zHSu1W7i4AJNAql/ufJKOH462BdJ3ha3j8=
Date: Thu, 08 Oct 2026 22:56:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch removed from -mm tree
Message-Id: <20261009055629.F0CFC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "samples/damon/mtier: error out for zero quota goal target values"
has been removed from the -mm tree.  Its filename was
     revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Revert "samples/damon/mtier: error out for zero quota goal target values"
Date: Wed, 2 Sep 2026 18:07:21 -0700

This reverts commit a16fd3ad9d89b05475864da97327870464611736.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero target_value. 
The corner case handling in DAMON_SAMPLE_MTIER is hence no more needed. 
Remove it.

Link: https://lore.kernel.org/20260903010722.94244-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/samples/damon/mtier.c~revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values
+++ a/samples/damon/mtier.c
@@ -161,9 +161,6 @@ static struct damon_ctx *damon_sample_mt
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
-	/* zero target value causes division by zero in damos_quota_store() */
-	if (!node0_mem_used_bp || !node0_mem_free_bp)
-		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
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

