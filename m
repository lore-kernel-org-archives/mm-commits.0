Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78A63368AE
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465774; cv=none; b=eoWd+eIUL+zvWnAQxmeI0c867ZeQEvd5z6ZzIzzQuMNqR8tUBIDnLd6nNSuXBsDHJ/eKXLeSCCzDFFx50q6DqaB8xl6Hu1GB+L7+EyFZzMVenLGl8aDEs0xolvIYuJEd0hD0t4smd5gvT9YxbrAcz0umRFSGp5PS/lsWd2SJiUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465774; c=relaxed/simple;
	bh=IidFoWfSC+U1WX8kj+0g3zOSwSzGI++rpyrhJ57bpK0=;
	h=Date:To:From:Subject:Message-Id; b=p8V+/vfkhuLWiB1NRqRqRNFoWUbKVzGmNFryaL0w5eoiRaB6o4XRMXbPA788p6TmP51pWTnFTZ7zcF8hOJcZQHx8EM0JTFlzefeVv0TlfS9GVNozqytKns4rBo2Z3yNLsXKBjPlfrnIFK5Z6cfxJKpO2Zh0KFg9tlNubSUsIIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pc2vcUzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pc2vcUzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE72F1F000E9;
	Fri, 31 Jul 2026 02:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465772;
	bh=atSJ6gpNhL9yuaSuuEVsgIDKp78ZIWL+dU9K+1MoPws=;
	h=Date:To:From:Subject;
	b=pc2vcUzmg/wiYe8ybsdByrj5rVgdsdka/lAXIBpRwFyjt9L69wjLUlMt3mRq4FHNj
	 hUa2Walo0w3TgTphhjiT3ByEwT3q/kDFMhgg/QH1WMcBt9jarmJQnfNllU1vQaRhs5
	 AP8iWDQoElTB2hR9PNmVe+w9nueTyihYSk8ledAA=
Date: Thu, 30 Jul 2026 19:42:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch removed from -mm tree
Message-Id: <20260731024252.AE72F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove attrs param from damon_update_region_access_rate()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove attrs param from damon_update_region_access_rate()
Date: Mon, 29 Jun 2026 21:08:07 -0700

damon_update_region_access_rate() is not using attrs parameter.  Remove
it.

Link: https://lore.kernel.org/20260630040812.149729-15-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +--
 mm/damon/core.c       |    4 +---
 mm/damon/paddr.c      |    4 ++--
 mm/damon/vaddr.c      |    6 +++---
 4 files changed, 7 insertions(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate
+++ a/include/linux/damon.h
@@ -1016,8 +1016,7 @@ unsigned int damon_nr_accesses_mvsum(str
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
-void damon_update_region_access_rate(struct damon_region *r, bool accessed,
-		struct damon_attrs *attrs);
+void damon_update_region_access_rate(struct damon_region *r, bool accessed);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		bool matching, bool allow);
--- a/mm/damon/core.c~mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate
+++ a/mm/damon/core.c
@@ -3833,15 +3833,13 @@ static unsigned int damon_moving_sum(uns
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
  * @accessed:	Whether the region has accessed during last sampling interval.
- * @attrs:	The damon_attrs of the DAMON context.
  *
  * Update the access rate of a region with the region's last sampling interval
  * access check result.
  *
  * Usually this will be called by &damon_operations->check_accesses callback.
  */
-void damon_update_region_access_rate(struct damon_region *r, bool accessed,
-		struct damon_attrs *attrs)
+void damon_update_region_access_rate(struct damon_region *r, bool accessed)
 {
 	if (accessed)
 		r->nr_accesses++;
--- a/mm/damon/paddr.c~mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate
+++ a/mm/damon/paddr.c
@@ -91,12 +91,12 @@ static void __damon_pa_check_access(stru
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = sampling_addr;
 }
--- a/mm/damon/vaddr.c~mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate
+++ a/mm/damon/vaddr.c
@@ -501,19 +501,19 @@ static void __damon_va_check_access(stru
 	static bool last_accessed;
 
 	if (!mm) {
-		damon_update_region_access_rate(r, false, attrs);
+		damon_update_region_access_rate(r, false);
 		return;
 	}
 
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed, attrs);
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed, attrs);
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = r->sampling_addr;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch
samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch
mm-damon-core-make-damon_stop-never-fails.patch
mm-damon-sysfs-ignore-damon_stop-return-value.patch
mm-damon-reclaaim-ignore-damon_stop-return-value.patch
mm-damon-lru_sort-ignore-damon_stop-return-value.patch
mm-damon-core-change-damon_stop-return-type-to-void.patch
samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch
mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch
samples-damon-wsse-do-not-stop-ctx-for-damon_call-failure.patch
samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch
mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch
mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch
mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch
mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch
mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch
mm-damon-core-update-probe-hits-for-new-parameter-commit.patch
mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch
mm-damon-core-introduce-damon_probe-weight.patch
mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address.patch
mm-damon-paddr-set-samples-in-apply_probes-if-requested.patch
mm-damon-core-ask-apply_probe-to-return-max-probe-hits-weighted-sum.patch
mm-damon-core-implement-damon_probe_hits_wsum.patch
mm-damon-paddr-respect-return_max_wsum.patch
mm-damon-core-use-abs_diff-instead-of-abs.patch
mm-damon-core-extend-merge-function-to-work-with-probe-hits.patch
mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring.patch
mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow.patch
mm-damon-core-disable-access-monitoring-when-probe-weights-are-set.patch
mm-damon-core-set-samples-in-apply_probes-if-probe-weights-are-set.patch
mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn.patch
mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set.patch
mm-damon-core-implement-damon_has_probe_weight.patch
mm-damon-sysfs-implement-probe-weight-file.patch
docs-mm-damon-design-document-attrs-only-monitoring.patch
docs-admin-guide-mm-damon-usage-document-weight-sysfs-file.patch
docs-abi-damon-document-probe-weight-file.patch
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

