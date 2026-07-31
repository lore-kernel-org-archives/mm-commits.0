Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076CE331EA7
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465728; cv=none; b=VHYo2blBopEmupLGm1OLBcXPzFGu3YAOaBB3TBGYovsNNOsZgZCNfvMaOT562yfD3GXYsnaYs7FSxxujdXce1Hsr6VQ0Vrf+b12U+OzWxUhdpMi3ZVhoTPIAVUVFSGR1UUPyf5H7PjnaRMTwKd1i5O2cyCSrtr6jKiq4BxuSKJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465728; c=relaxed/simple;
	bh=sRPuZqaRbcF0f8ArWfUD+R/UoId7rPPa2aO7/nc/nhc=;
	h=Date:To:From:Subject:Message-Id; b=aHUswVVoJEnz6ghJJQSry6pqGp1qcJnyGe4eFX9ctmCJUSxjePd9qB/2fiojaty98+Elgvv1/uX3g4+FAArfbRiMSLiby/t87qn67GOmaNLGHeOixrdj3UYMGbTyn8gwa0NOOYHvHFoVUx7Rh9wFVn5Spf+H3PBzVaZaTws7oeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hk7K2ZSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hk7K2ZSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D11F000E9;
	Fri, 31 Jul 2026 02:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465726;
	bh=HChDzIuY0PZXMxglONCmCqzVA/MKxZdyyBxLu8c389A=;
	h=Date:To:From:Subject;
	b=hk7K2ZSpKJYRNA1DXz8H9NqbrFcYNRNb1vEUuRG372FvZimIerw53aP+6jYS0Jdjl
	 aIUVTmc2tVw5OOfQvWUSHIyPTPafckNT6WhnsC8sSpgPu0cEGkaq3o0dHs/vdkLO2f
	 paJL/f1IG1LA4OeIr2/OzTGBMXPiYjeyCSCj9mkI=
Date: Thu, 30 Jul 2026 19:42:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfssh-test-dests-dir.patch removed from -mm tree
Message-Id: <20260731024206.CD0D11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.sh: test dests dir
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfssh-test-dests-dir.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/sysfs.sh: test dests dir
Date: Tue, 30 Jun 2026 07:17:20 -0700

DAMON selftest interface essential file operations test (sysfs.sh) is not
testing DAMOS dests/ directory.  Add the test.

Link: https://lore.kernel.org/20260630141726.92246-7-sj@kernel.org
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

 tools/testing/selftests/damon/sysfs.sh |   24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-test-dests-dir
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -99,6 +99,29 @@ test_stats()
 	done
 }
 
+test_dest()
+{
+	dest_dir=$1
+	ensure_file "$dest_dir/id" "exist" "600"
+	ensure_file "$dest_dir/weight" "exist" "600"
+}
+
+test_dests()
+{
+	dests_dir=$1
+	ensure_file "$dests_dir/nr_dests" "exist" "600"
+	ensure_write_succ "$dests_dir/nr_dests" "1" "valid input"
+	test_dest "$dests_dir/0"
+
+	ensure_write_succ "$dests_dir/nr_dests" "2" "valid input"
+	test_dest "$dests_dir/0"
+	test_dest "$dests_dir/1"
+
+	ensure_write_succ "$dests_dir/nr_dests" "0" "valid input"
+	ensure_dir "$dests_dir/0" "not_exist"
+	ensure_dir "$dests_dir/1" "not_exist"
+}
+
 test_filter()
 {
 	filter_dir=$1
@@ -225,6 +248,7 @@ test_scheme()
 	ensure_file "$scheme_dir/apply_interval_us" "exist" "600"
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
+	test_dests "$scheme_dir/dests"
 	test_filters "$scheme_dir/filters"
 	test_filters "$scheme_dir/core_filters"
 	test_filters "$scheme_dir/ops_filters"
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

