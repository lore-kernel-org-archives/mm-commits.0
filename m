Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BAF31AF2D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334343; cv=none; b=VtKsjOixMsaOtRVSNuEESPmKh1L3+KVJNLvzm7FNsX/ZkenCzvwnQkMc2NhmpYQ1VGHktjrGzRCfXT2diBxXSOtmrXIESGQfpnNmD8wZUm/NPm6IvTwg1d37Y5vAlBy4brXAkn8PZXysgv+N6s5eDy2DUr1wPFk1ZMLbeVLqDR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334343; c=relaxed/simple;
	bh=cJJE/avpk7Qz0CSScDQl/mUPUhriPyDGmoidsEHAEPA=;
	h=Date:To:From:Subject:Message-Id; b=tXVCr0XvwZL7WoQc1NvRet3EpNOr1jRqORgEkXL1S37q0RH8z6QxnoNy9ljTWZMXT7o9Q16BrjqPC0zBZZSK2hliJ+1RhFVIPYqxitq/qcfOGJBEHzS/KPXTInfeRS70CLkfi4LF0PopLhwJ4LI+2ZI229NQRclbYaXSS/fnlM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mKCyhaGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKCyhaGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3551F0089B;
	Wed,  7 Oct 2026 00:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334342;
	bh=7f7uuRfn/Yr4hMN8SCPuwLh0jdctTw+/G4DMzByg0vk=;
	h=Date:To:From:Subject;
	b=mKCyhaGI8wB1d40vmh3vdyVklZO6dlhHzxqhDkPEJ4VJ6hBik2hvwH/Ec+4Mi06jV
	 kunBbuDWARcDWc/DNz1dghXwHd64awicgHRVrDp5g9FPRl+GL0wdZofV4hQTfnB9vj
	 nPFnF8hLUNBnFpar5z0S4hE/hoxaUeUN7U04ZEF0=
Date: Tue, 06 Oct 2026 17:52:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_operations-prep_probes.patch removed from -mm tree
Message-Id: <20261007005222.6F3551F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_operations->prep_probes()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_operations-prep_probes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_operations->prep_probes()
Date: Tue, 1 Sep 2026 06:24:54 -0700

damon_prep needs to be executed by the underlying DAMON operation set. 
Extend the operation set callback list for the execution of damon_prep
actions.  If the underlying operation set implements the callback, DAMON
core executes it in the monitoring preparation time.

Link: https://lore.kernel.org/20260901132506.99243-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |   20 +++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_operations-prep_probes
+++ a/include/linux/damon.h
@@ -630,6 +630,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @prep_probes:		Prepare applying probes for each region.
  * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
@@ -657,6 +658,9 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @prep_probes should execute required &struct damon_prep for next &struct
+ * damon_probe applications to each region.  It should also set
+ * &damon_region->sampling_addr of each region if ``set_samples`` is true.
  * @apply_probes should apply the data attribute probes to each region and
  * accordingly update the probe hits counter of the region.  It should also
  * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
@@ -679,6 +683,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*prep_probes)(struct damon_ctx *context, bool set_samples);
 	unsigned int (*apply_probes)(struct damon_ctx *context,
 			bool set_samples, bool return_max_wsum);
 	int (*get_scheme_score)(struct damon_ctx *context,
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_operations-prep_probes
+++ a/mm/damon/core.c
@@ -157,6 +157,18 @@ static struct damon_prep *damon_nth_prep
 	return NULL;
 }
 
+static bool damon_has_prep(struct damon_ctx *c)
+{
+	struct damon_prep *prep;
+	struct damon_probe *probe;
+
+	damon_for_each_probe(probe, c) {
+		damon_for_each_prep(prep, probe)
+			return true;
+	}
+	return false;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -3905,14 +3917,19 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		bool do_prep;
 		unsigned int max_merge_score = 0, max_wsum;
 		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
+		do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
+
 		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
+		if (do_prep)
+			ctx->ops.prep_probes(ctx, access_check_disabled);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -3927,7 +3944,8 @@ static int kdamond_fn(void *data)
 			else
 				get_max_wsum = false;
 			max_wsum = ctx->ops.apply_probes(ctx,
-					access_check_disabled, get_max_wsum);
+					access_check_disabled && !do_prep,
+					get_max_wsum);
 			if (get_max_wsum)
 				max_merge_score = max_wsum;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch
mm-damon-vaddr-support-prep_probes.patch
mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch
mm-damon-vaddr-support-apply_probe.patch
mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch
mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-api-introduce-damon_filter_type_pgidle_set.patch
mm-damon-paddr-support-damon_filter_type_pgidle_set.patch
mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch
mm-damon-sysfs-support-damon_filter_type_pgidle_set.patch
docs-mm-damon-design-update-for-pgidle_set-probe-filter.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch
mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch
mm-damon-core-support-probe_hits_wsum-damos-core-filter.patch
mm-damon-sysfs-schemes-rename-sysfs_filter-sz_range-to-range_minmax.patch
mm-damon-sysfs-schemes-support-probe_hits_wsum-damos-core-filter.patch
docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch
docs-admin-guide-mm-damon-usage-update-for-probe_hits_wsum-damos-filter.patch
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

