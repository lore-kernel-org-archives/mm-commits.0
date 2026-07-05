Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A633EC
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783217142; cv=none; b=aV2t0GSWwyVmMpyFtmIXb/0Ui2V9gn+OGH0eov36IkZxc8Kp2WDpsbyZdZ9a2/+Uufc8ZZ666VaXvWQLzTwSVRLfK9qQzL6zHNZJg27+htw6R8y+E8ehkcCneD1vTKNMHAFohz9pwJtQF/eQahHUcadE244THQUPNtmFDl1w6oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783217142; c=relaxed/simple;
	bh=dT1dy+yH06ykEFH5gxAozrfVl60f8n4QVvdGkeNIQrE=;
	h=Date:To:From:Subject:Message-Id; b=pl+zqiiWCn/8l8b6Cas9H8k+cqW7p5A/rKvH8WDByP97p4k/Cbqnaj6ANFP04q/3lBQe4Xgg6YEDV0gwvDaqWllEsx4F3o3nIKh9oRJbS7n64poMe6CS9yBdsHH+921dtpXjKSUais/qu8Uekd6A3esZ3ibxcpAJSe6DGqlm7cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NaWaRslp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NaWaRslp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE761F000E9;
	Sun,  5 Jul 2026 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783217140;
	bh=NFQaVuTnN7yV2g3YUZhzzzhH3qzJVF/19n6PQ7OvWUc=;
	h=Date:To:From:Subject;
	b=NaWaRslpAV9cFz+s4sMjspyBCXfR30jq9WUuBiUHFh8NR5FCZJrj/hArfUkOML1dI
	 tz87tb8IATHhDzikio/ez1ifh0fdRoqCgYNOzHSL31ncwAJgj/LrHk3M9g5FKl2fLK
	 nfVNYFnT/Fr9AKjlaJjQwukogkm8fCweZB5VIkcU=
Date: Sat, 04 Jul 2026 19:05:40 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_probe_hits_mvsum.patch added to mm-new branch
Message-Id: <20260705020540.7EE761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damon_probe_hits_mvsum()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_probe_hits_mvsum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_probe_hits_mvsum.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_probe_hits_mvsum()
Date: Fri, 3 Jul 2026 10:06:02 -0700

Implement a function for getting a reasonable best effort quality pseudo
moving sums of probe_hits on demands.  It reuses the internal function for
the pseudo moving sum for data access frequency (nr_accesses).

Link: https://lore.kernel.org/20260703170605.94472-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_probe_hits_mvsum
+++ a/include/linux/damon.h
@@ -1003,6 +1003,8 @@ void damon_add_probe(struct damon_ctx *c
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_probe_hits_mvsum
+++ a/mm/damon/core.c
@@ -273,6 +273,27 @@ unsigned int damon_nr_accesses_mvsum(str
 			left_window_bp);
 }
 
+unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+		struct damon_ctx *ctx)
+{
+	unsigned long sample_interval, aggr_interval;
+	unsigned long window_len, left_window, left_window_bp;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	aggr_interval =  ctx->attrs.aggr_interval ? : 1;
+	window_len = aggr_interval / sample_interval;
+	if (time_after_eq(ctx->passed_sample_intervals,
+				ctx->next_aggregation_sis))
+		left_window = 0;
+	else
+		left_window = ctx->next_aggregation_sis -
+			ctx->passed_sample_intervals;
+	left_window_bp = mult_frac(left_window, 10000, window_len);
+
+	return damon_mvsum(r->probe_hits[probe_idx],
+			r->last_probe_hits[probe_idx], left_window_bp);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-s-seongjae-sj.patch
mm-damon-core-validate-ranges-in-damon_set_regions.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch
mm-damon-add-damon_region-last_probe_hits.patch
mm-damon-core-introduce-damon_probe_hits_mvsum.patch
mm-damon-sysfs-schemes-set-probe-hits-as-pseudo-moving-sums.patch
mm-damon-core-disallow-overlapping-input-ranges-for-damon_set_regions.patch

