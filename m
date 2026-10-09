Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F4F3F927B
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525393; cv=none; b=EW0e+9JlKhldp8cCPQ8JhhGwQAJPkLw5u0jTJIRqQwi/Is3jnUOFLG6PrWP3LhH1uNrLmMOWay2q03BdGe5KYPvoYxjaoeUBks7z4M87jfYkyY4Pjp/HzcPw2IzOrnDVapcoQVOdunA4ly4dAIos35KDDLakA3pWgg0pPWMObYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525393; c=relaxed/simple;
	bh=EIrOfjzZ1MenHy9m+qajvRi7BlrG2Gkpr0eZj7nwskg=;
	h=Date:To:From:Subject:Message-Id; b=A+eFIdTgPU1lDapwAP2c+JeU68+JLJSFI64qol6PtmAJpueCO7zUgBDbIfVE7jbV7D7LHuZ8pO0YueCY8fhhRrTi7Mg1rc3k9aYi3OYR3kiNc269BnFlkF47SVJSlkKgJ7sAl8ilAPVpyXbryyWX0xVdyZpk7QLbn1OJlcCguoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xaM1osaQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xaM1osaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AF11F000FF;
	Fri,  9 Oct 2026 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525392;
	bh=8wpD7Q5ub1HdQWaxYDGmgoFPXSRbiXP2cHNQTVqpc/0=;
	h=Date:To:From:Subject;
	b=xaM1osaQZ9Z8lEO7RKMFRxzuBY5XVBPwwciycPI92PJfWb7sBOS9d0SAz3NpV4T8X
	 7ipBqYIugVV9TrOhaRVdtgwvaU9esxpsQ3D8wH0boJGNjhBn+T55DqTZpUpSIPPjj4
	 cbLIn9QJam35V29L/b/8BaMpOkctQNXUIpUsKbfw=
Date: Thu, 08 Oct 2026 22:56:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch removed from -mm tree
Message-Id: <20261009055632.47AF11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
Date: Wed, 2 Sep 2026 18:03:31 -0700

damon_ctx->call_controls_obsolete is used to disallow damon_call()
requests when the request cannot be served.  The field is unset and set
when the context execution is started and terminated, respectively.  The
intention is to allow damon_call() requests only while the context is
actively being executed.

damon_ctx constructor, damon_new_ctx() unsets the field, though.  As a
result, passing the damon_ctx parameter that never successfully
damon_start()-ed to damon_call() can indefinitely hang.  The callers
should ensure to avoid the case.  Such parameter validation is not always
simple.  Actually such bugs in DAMON_RECLAIM and DAMON_LRU_SORT have been
found and fixed [1].

Set the field in damon_new_ctx(), so that DAMON API callers can pass the
context parameter to damon_call() without the additional check.

Link: https://lore.kernel.org/20260903010334.93622-3-sj@kernel.org
Link: https://lore.kernel.org/20260803134646.16640-1-sj@kernel.org [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx
+++ a/mm/damon/core.c
@@ -933,6 +933,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	ctx->call_controls_obsolete = true;
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
@@ -2206,10 +2207,6 @@ int damon_kdamond_pid(struct damon_ctx *
  * synchronization.  The return value of the function will be saved in
  * &damon_call_control->return_code.
  *
- * Note that this function should be called only after damon_start() with the
- * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
- * wait.
- *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
  * Return: 0 on success, negative error code otherwise.
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

