Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C4A331ECE
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465731; cv=none; b=M+5ThSG0If1Txke8wlqg/ngy8Hkw4JFtXKn9dVfd/vC5EBeeBUl6ph9xn6+aLz9NPqPxbT655XcSn+sgKypsTVxMquwt/6rZu0Ng8eMCsDltcsaUSXmJBQBCFe3tYB13fHy7j3Lh9P1EhszlGY54GiQS2IeOwjCcqvyBqjEaHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465731; c=relaxed/simple;
	bh=eY5C1puLS1cXEKuROCwb9yTs+GH/BWuuFXWXNX6mH2Q=;
	h=Date:To:From:Subject:Message-Id; b=Jw/A36yqCv45V74wcdbVK5KLs8N0clzBGrfiE4bMv8ztTanPvN5odbrVlwNME+a58wkbBqmb8EavJnD70wp10t3UTiy8IhGSGc8160pSB6dCmS9gt9pyx+pqK9t9IRlwwnJk3MFFTdedoeDripw2CooUo19HaVpZBU69hfrrE7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YiSOGUAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YiSOGUAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD091F00A3A;
	Fri, 31 Jul 2026 02:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465730;
	bh=u4ELcF7oV8Ce2umY0hJHFuNsDxiM45gK86ZDgV01c0I=;
	h=Date:To:From:Subject;
	b=YiSOGUAFnuJORFIj1KZzL+qtp965mG8GotP4bY9mG0bE/EoIzZWSxFf2TKfayYHua
	 Vn72yzAcR9Np/C/lgtmscK1X8MAktPEatyye2KlDpu8ny5R3xQNlknDO58x8I8A92H
	 /FEh7u0v1qEnidVKdpHDcgr2T8das3J6h0cf27tI=
Date: Thu, 30 Jul 2026 19:42:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-split-probe-setup-function-out.patch removed from -mm tree
Message-Id: <20260731024210.6CD091F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: split probe setup function out
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-split-probe-setup-function-out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: split probe setup function out
Date: Tue, 30 Jun 2026 07:17:23 -0700

damon_sysfs_set_probes() function is relatively long.  It has two nested
loop for setting two nested entities, namely probe and filter.  Split out
the probe level setup for readability.

Link: https://lore.kernel.org/20260630141726.92246-10-sj@kernel.org
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

 mm/damon/sysfs.c |   80 +++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 34 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-split-probe-setup-function-out
+++ a/mm/damon/sysfs.c
@@ -1909,47 +1909,59 @@ static int damon_sysfs_set_attrs(struct
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probes(struct damon_ctx *ctx,
-		struct damon_sysfs_probes *sys_probes)
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
 {
+	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	for (i = 0; i < sys_probes->nr; i++) {
-		struct damon_sysfs_filters *sys_filters =
-			sys_probes->probes_arr[i]->filters;
-		struct damon_probe *c;
-		int j;
-
-		if (!sys_filters)
-			continue;
-		c = damon_new_probe();
-		if (!c)
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
+
+	for (i = 0; i < sys_filters->nr; i++) {
+		struct damon_sysfs_filter *sys_filter =
+			sys_filters->filters_arr[i];
+		struct damon_filter *filter;
+
+		filter = damon_new_filter(sys_filter->type,
+				sys_filter->matching,
+				sys_filter->allow);
+		if (!filter)
 			return -ENOMEM;
-		damon_add_probe(ctx, c);
+		if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+			int err;
 
-		for (j = 0; j < sys_filters->nr; j++) {
-			struct damon_sysfs_filter *sys_filter =
-				sys_filters->filters_arr[j];
-			struct damon_filter *filter;
-
-			filter = damon_new_filter(sys_filter->type,
-					sys_filter->matching,
-					sys_filter->allow);
-			if (!filter)
-				return -ENOMEM;
-			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
-				int err;
-
-				err = damon_sysfs_memcg_path_to_id(
-						sys_filter->path,
-						&filter->memcg_id);
-				if (err) {
-					damon_destroy_filter(filter);
-					return err;
-				}
+			err = damon_sysfs_memcg_path_to_id(
+					sys_filter->path,
+					&filter->memcg_id);
+			if (err) {
+				damon_destroy_filter(filter);
+				return err;
 			}
-			damon_add_filter(c, filter);
 		}
+		damon_add_filter(probe, filter);
+	}
+	return 0;
+}
+
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i, err;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_probe *sys_probe;
+		struct damon_probe *p;
+
+		p = damon_new_probe();
+		if (!p)
+			return -ENOMEM;
+		damon_add_probe(ctx, p);
+		sys_probe = sys_probes->probes_arr[i];
+		err = damon_sysfs_set_probe(p, sys_probe);
+		if (err)
+			return err;
 	}
 	return 0;
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

