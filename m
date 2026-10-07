Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BBA32692C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334381; cv=none; b=Z9t+lY/3to/FL0JEBlWjeyuToITE9BCHT4dpwa7ShDkWI5Pv1mKYFUiOGpKAvmFwXZ28N1P1iGSPzF7CKTy2hUXfBYW3cYh7BBznolf+GSLyrkNmIYiUjs97BczM5ZvLO2NpzTJT8IisQIp6SG1RfzKq1AzymiACDwyFvD2a6Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334381; c=relaxed/simple;
	bh=P5MQaDqtOZCeLfO8PJcLMSrql1xK3mMOlw6+cOYoY9c=;
	h=Date:To:From:Subject:Message-Id; b=U9Rk/BFm0nMjQrMfrXKfY/ruNH9K6b5ch//qIDWs220/2L91aCt/Owo+X7dmUULpKhXSdJA2pXjnNTkY6RexkMydhoqR5Pi0qdZD52+snWrfwpQTK9BOA7tHckcaWwZwaqEB0ymnM3Yl5q0CvoMKeNawrj5E245JWSTzZXWGaio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXl3QeKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXl3QeKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533251F0089C;
	Wed,  7 Oct 2026 00:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334379;
	bh=6O/OWN1uoKs5ey5Pr5sTNpN7B5ZcDVZWNGO87vmtvCs=;
	h=Date:To:From:Subject;
	b=OXl3QeKMo+jEfhJRasiQSNGcPmVI03Mhiw+iqxkojsHicIFY95BVCtuI4FubXo4o/
	 eaQx0pwh31bwSxn/HFFan6S5A0YNHRwOQJGP6HkjwxoQtxihLhkRuEGim6lpDmIu/8
	 DVFqMLSGcBkcD/uSw9kfKYzIrNWSg58eX6Fo9340=
Date: Tue, 06 Oct 2026 17:52:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-drgn_dump_damon_status-dump-probes.patch removed from -mm tree
Message-Id: <20261007005259.533251F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump probes
has been removed from the -mm tree.  Its filename was
     selftests-damon-drgn_dump_damon_status-dump-probes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/drgn_dump_damon_status: dump probes
Date: Wed, 2 Sep 2026 07:03:10 -0700

Extend drgn_dump_damon_status.py to dump damon_ctx->probes.  It will be
used to see if in-kernel DAMON status are changed as the user sets the
probes via sysfs.

Link: https://lore.kernel.org/20260902140313.85983-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |   32 ++++++++++
 1 file changed, 32 insertions(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-probes
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -48,6 +48,37 @@ def attrs_to_dict(attrs):
         ['max_nr_regions', int],
         ])
 
+def filter_to_dict(damon_filter):
+    filter_type_keyword = {
+            0: 'anon',
+            1: 'memcg',
+            }
+    dict_ = {
+            'type': filter_type_keyword[int(damon_filter.type)],
+            'matching': bool(damon_filter.matching),
+            'allow': bool(damon_filter.allow),
+            }
+    type_ = dict_['type']
+    if type_ == 'memcg':
+        dict_['memcg_id'] = int(damon_filter.memcg_id)
+    return dict_
+
+def filters_to_list(filters):
+    return [filter_to_dict(f)
+            for f in list_for_each_entry(
+                'struct damon_filter', filters.address_of_(), 'list')]
+
+def probe_to_dict(probe):
+    return to_dict(probe, [
+        ['weight', int],
+        ['filters', filters_to_list],
+        ])
+
+def probes_to_list(probes):
+    return [probe_to_dict(p)
+            for p in list_for_each_entry(
+                'struct damon_probe', probes.address_of_(), 'list')]
+
 def addr_range_to_dict(addr_range):
     return to_dict(addr_range, [
         ['start', int],
@@ -199,6 +230,7 @@ def damon_ctx_to_dict(ctx):
     return to_dict(ctx, [
         ['ops', ops_to_dict],
         ['attrs', attrs_to_dict],
+        ['probes', probes_to_list],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
         ['pause', bool],
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

