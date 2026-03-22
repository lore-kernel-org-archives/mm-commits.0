Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C70E364E8D;
	Sun, 22 Mar 2026 00:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139856; cv=none; b=rtLWdB/a9bKHY8ndkgKwna/xvtvt4Z6/AfJzjiWIOdZE0jNeCXD2shFdODeuj2FiDbuluoNfUmN1zQHaTCOGV6x+D2bnOEmyS3z8DkbZRhk6CnhkB9sX5VnHMP/cK7mR5IS5t9ABRdW7KLqYzlpbnW0n38agg9eApWTY8aidiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139856; c=relaxed/simple;
	bh=6CLhz8D4dlxPVJk/yJR3f6hq4yU+SqS3nGfE0GSiRsE=;
	h=Date:To:From:Subject:Message-Id; b=NU3XdZ5ei5xEp5tlv0ONKEaPeYoETFKze6WXRUAcelCTmkIbSliaT64os072KDRslrQZ2l5lO+cFenWYMlQz9dZehUtoX3nDTuWZwxwmJLk1XYCh19KwisDl1lQPOzsyfYrhDFXZJh0mAQ/7S/d3OOJOSJ752vjPJ7vZZyNllGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=auDUJkjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="auDUJkjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BFCC19421;
	Sun, 22 Mar 2026 00:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139856;
	bh=6CLhz8D4dlxPVJk/yJR3f6hq4yU+SqS3nGfE0GSiRsE=;
	h=Date:To:From:Subject:From;
	b=auDUJkjt9yuUKlxqKf0tAOXup2dn+tSQgPhRwC1VM/cMLlURoGSHDE5cia5pfkmZ1
	 Ai04YzjE/hpGyrJBcdiJng7bSShRUqnCoCe42agflWfoOay4f1Sxit5eMOVpoJa2MJ
	 GXQDyMs14LpJwyc5hje9VtWyHc9kFv/L7mXNxpWQ=
Date: Sat, 21 Mar 2026 17:37:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-stat-monitor-all-system-ram-resources.patch removed from -mm tree
Message-Id: <20260322003736.46BFCC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: monitor all System RAM resources
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-monitor-all-system-ram-resources.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: monitor all System RAM resources
Date: Mon, 16 Mar 2026 16:51:17 -0700

DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
says it monitors the system's entire physical memory.  But, it is
monitoring only the biggest System RAM resource of the system.  When there
are multiple System RAM resources, this results in monitoring only an
unexpectedly small fraction of the physical memory.  For example, suppose
the system has a 500 GiB System RAM, 10 MiB non-System RAM, and 500 GiB
System RAM resources in order on the physical address space.  DAMON_STAT
will monitor only the first 500 GiB System RAM.  This situation is
particularly common on NUMA systems.

Select a physical address range that covers all System RAM areas of the
system, to fix this issue and make it work as documented.

[sj@kernel.org: return error if monitoring target region is invalid]
  Link: https://lkml.kernel.org/r/20260317053631.87907-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260316235118.873-1-sj@kernel.org
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   53 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-monitor-all-system-ram-resources
+++ a/mm/damon/stat.c
@@ -145,12 +145,59 @@ static int damon_stat_damon_call_fn(void
 	return 0;
 }
 
+struct damon_stat_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
+{
+	struct damon_stat_system_ram_range_walk_arg *a = arg;
+
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
+	}
+	a->res.end = res->end;
+	return 0;
+}
+
+static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
+		unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(ra, addr_unit);
+	return ra / addr_unit;
+}
+
+static int damon_stat_set_monitoring_region(struct damon_target *t,
+		unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+	struct damon_stat_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
+	if (!arg.walked)
+		return -EINVAL;
+	addr_range.start = damon_stat_res_to_core_addr(
+			arg.res.start, addr_unit);
+	addr_range.end = damon_stat_res_to_core_addr(
+			arg.res.end + 1, addr_unit);
+	if (addr_range.end <= addr_range.start)
+		return -EINVAL;
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	unsigned long start = 0, end = 0;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -180,8 +227,8 @@ static struct damon_ctx *damon_stat_buil
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_region_sz))
+	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
+				ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

