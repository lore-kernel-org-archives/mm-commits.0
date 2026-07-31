Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB54F331207
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465734; cv=none; b=Vcwlmmw/dgBf9P+XcqTYL9K5tjZbxQxT7siinFofNNaUp8tUsYGJs4oJDIIQfHC55G4TD1gRMcKtIo4ngy68/r291Jlc19pL3/UO3cF468BrQdLkPM/8CUB/uDSU+LEy8rzM39kx86vZAStaMeu2EMB/i1RjOZzgMoVs/gH+ZfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465734; c=relaxed/simple;
	bh=bI1JWHUO8FODXQlFPRPqm5Te4hGyvaruEe7bv32+hF8=;
	h=Date:To:From:Subject:Message-Id; b=rpv3htcvD1Aoy5mKUme4dEET7A/4Cra9WiRxNPA9FxL0KmhiOA6mAnSNh44I8QEOKGzbTDDeag/d3smcsxP8GO0jQeK6dl74Bdl9TKl0kpaMt4Cg4qtThzCpjeqPjK7PTbj2A9O/eWQvruCQNI0gsH1hh4Ysf+QJ+pIbkR+Ag4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oj3WD2Cz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oj3WD2Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EEA1F00A3A;
	Fri, 31 Jul 2026 02:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465732;
	bh=hNC0qN667IQubx2f7wbjuT9/uHV+mmX1nnb7e1q24g8=;
	h=Date:To:From:Subject;
	b=Oj3WD2CzThyUHfMY3PY+ShxB5+j8XRfRfgHnvxcCLVkXATHXi8B8aRWqWk0VzyxwM
	 6U6tejgFcru0tJvdTDB2Ag5dkrB0kmPlsExTiSbtU5eR3Po6N18X9auSdhE5wT/bwI
	 bKrV+Wm/8AR2YTmk7is5+crDGvH6aESOhBdf9oz0=
Date: Thu, 30 Jul 2026 19:42:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch removed from -mm tree
Message-Id: <20260731024212.C2EEA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
Date: Tue, 30 Jun 2026 07:17:25 -0700

damon_sysfs_probe_{add,rm}_dirs names a variable for damon_sysf_probe as
'attr'.  Probably a trivial copy-pasta error, but it makes the code not
pleasant to read.  Fix those.

Link: https://lore.kernel.org/20260630141726.92246-12-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe
+++ a/mm/damon/sysfs.c
@@ -1073,7 +1073,7 @@ static struct damon_sysfs_probe *damon_s
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
-static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
 	struct damon_sysfs_filters *filters;
 	int err;
@@ -1081,22 +1081,22 @@ static int damon_sysfs_probe_add_dirs(st
 	filters = damon_sysfs_filters_alloc();
 	if (!filters)
 		return -ENOMEM;
-	attr->filters = filters;
+	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
-			&attr->kobj, "filters");
+			&probe->kobj, "filters");
 	if (err) {
 		kobject_put(&filters->kobj);
-		attr->filters = NULL;
+		probe->filters = NULL;
 	}
 	return err;
 }
 
-static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (attr->filters) {
-		damon_sysfs_filters_rm_dirs(attr->filters);
-		kobject_put(&attr->filters->kobj);
+	if (probe->filters) {
+		damon_sysfs_filters_rm_dirs(probe->filters);
+		kobject_put(&probe->filters->kobj);
 	}
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

