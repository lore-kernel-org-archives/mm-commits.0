Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520633D9667
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525392; cv=none; b=oK1NRxiH1GTRFCmAR3xa29bruFs/ZG/v+efAqqRG/+aAYvMRUhz9bX2VCMeFOuL4aXv+qcl/2TfUlUP7A0XwNZXZLl+Up3uiZShxpDsTXyE5FcacPvE/T+W/NcW6qrdSNcfr+6tVcjLIMrk+gCtdNzHHwhjx03aSwMxxva87cpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525392; c=relaxed/simple;
	bh=17GabNM9iwy88GmrGQ3aQZtko/FofYviK/vpPo0+pJ0=;
	h=Date:To:From:Subject:Message-Id; b=L54N0vuxpWoWPuXg596qEmfNM5P51zRCHoeule9le+lgCSqTawgssO02YgPwK9mdeb0aIFxuTvFw/pJ8TS0pH4UEadAeWVLAbBS25jay1rDtvaepYlu4gJ08LWsMla/dhltNBq+e8ARjJUO6mA18e17fifT6imRazk0OPusyCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hi6oh+pn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hi6oh+pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249201F00893;
	Fri,  9 Oct 2026 05:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525391;
	bh=R8IA4vwjlEkKzEnKf6zUNRbhTO+DG+4q8efIfsNy0mw=;
	h=Date:To:From:Subject;
	b=hi6oh+pnACXwTJBmvhXZzF4BxZFgYvvHP3if3ihj4VkAolhG3F0J/bqZQeXWSkYd3
	 TuKvdFlEUNwNpS/gaP3jT75lY9r7Kv4V7+NzBC+DKTCb0WdLoVOmsZCFASseqy+ob0
	 g3Iw1R/0bgBFHOlBnLnnkqGFbh1RAzrV3ZUFZAYI=
Date: Thu, 08 Oct 2026 22:56:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch removed from -mm tree
Message-Id: <20261009055631.249201F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle NULL ctx parameter in damon_call()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle NULL ctx parameter in damon_call()
Date: Wed, 2 Sep 2026 18:03:30 -0700

Patch series "mm/damon: allow NULL or unstarted damon_ctx parameter for
damon_call()".

Callers of damon_call() should validate the damon_ctx object parameter. 
If it is NULL or never damon_start()-ed object, damon_call() could
dereference the NULL pointer or indefinitely hang.  Ensuring all callers
doing the validation correctly has turned out to be difficult.  Handle the
corner cases inside the core layer and remove callers' validations.

Patches 1 and 2 respectively allow passing NULL and not yet
damon_start()-ed ctx parameter to damon_call().  Patches 3 and 4 remove
the callers side validations in DMON_RECLAIM and DASMON_LRU_SORT,
respectively.


This patch (of 4):

When NULL damon_ctx pointer parameter is passed, damon_call() could do
NULL dereference.  The caller is responsible to avoid that.  It is easy to
forget, and there are many damon_call() callers.  Meanwhile, damon_call()
is never meant to be performance critical.  It uses mutex and completion. 
Add the NULL pointer check inside damon_call() so that callers can pass
the parameter without NULL checks.

Link: https://lore.kernel.org/20260903010334.93622-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010334.93622-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-handle-null-ctx-parameter-in-damon_call
+++ a/mm/damon/core.c
@@ -2216,6 +2216,8 @@ int damon_kdamond_pid(struct damon_ctx *
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 {
+	if (!ctx)
+		return -EINVAL;
 	if (!control->repeat)
 		init_completion(&control->completion);
 	control->canceled = false;
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

