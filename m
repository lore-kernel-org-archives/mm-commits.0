Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2D499F3F
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 23:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908878; cv=none; b=ZwZsogdGLZ6NH3+kSZvlbt7wq2RnaIh7dXwgt/MDKRCcUA0u9Wl4z53JZd+5zv9w29zi0TmX3Gy5JwxVBk1BNj26s4eM60O0VhXXYkt/rU/h/5AUBg9a+k1oUpAtP7pNEIqoeRW0eP56cuOWxD5o3s5R/shkA9iVlYJCymHQivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908878; c=relaxed/simple;
	bh=AWBHavZCf4Hx4XQNT5NU8KGCjJChDGdC8tJ4gtv8wug=;
	h=Date:To:From:Subject:Message-Id; b=XzKur0Od5W1NCABTkjMmV+c/yjG6AKtdXJDXZW2CPKqIlEDOemSzDpdrbm7fPCSs6Hqr75cIkEfcoFv3gZZ8S7zrrzuukfGJWR3eMwevwMVRYWYMuTWOXWzopKvxMk2z1leivDTzcbqNa669jfaJ2Jgl0oyCCRI5lkx+U8sO2G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DtryM7Wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DtryM7Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6031F00A3A;
	Tue,  8 Sep 2026 23:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788908876;
	bh=KtzrtXup0wsK+eoUzEtgGmQ1nb1FM4X9Avb4HCkv1no=;
	h=Date:To:From:Subject;
	b=DtryM7WnG9iJ9yuwXTxSLrAcVek3IbfpCQHalghthtjGX3WU26mO8hBY1SUXzJ5U6
	 zBQp1P+i0nLEyXs9ZOZdZ58kFSy6G4a1y1k7hGaW/OvvSWR7njNQ1y+7xu9113Mdm+
	 laU8OWMqqu3PcS/rcyaTbyF+qsO4S5YrlgpAnJJ0=
Date: Tue, 08 Sep 2026 16:07:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-damon-tests-core-kunit-test-damon_commit_filter.patch removed from -mm tree
Message-Id: <20260908230756.9E6031F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test damon_commit_filter()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-damon_commit_filter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: test damon_commit_filter()
Date: Wed, 2 Sep 2026 07:03:07 -0700

Patch series "mm/damon: add kunit and selftests for probes and probe
weights".

DAMON recently introduced probes and probe weights.  Add kunit and
selftests for ensuring the parameters for features can be set using the
core API and the sysfs ABI, respectively.


This patch (of 6):

Add kunit test to ensure damon_commit_filter() updates destination filter
as expected for valid inputs.

Link: https://lore.kernel.org/20260902140313.85983-1-sj@kernel.org
Link: https://lore.kernel.org/20260902140313.85983-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damon_commit_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -1316,6 +1316,45 @@ static void damon_test_commit_target_reg
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_filter_for(struct kunit *test,
+		struct damon_filter *dst, struct damon_filter *src)
+{
+	damon_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, dst->type, src->type);
+	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
+	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+	switch (src->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damon_test_commit_filter(struct kunit *test)
+{
+	struct damon_filter dst = {
+		.type = DAMON_FILTER_TYPE_ANON,
+		.matching = false,
+		.allow = false,
+	};
+
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_ANON,
+			.matching = true,
+			.allow = true,
+			});
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_MEMCG,
+			.matching = false,
+			.allow = false,
+			.memcg_id = 123,
+			});
+}
+
 static void damon_test_commit_ctx(struct kunit *test)
 {
 	struct damon_ctx *src, *dst;
@@ -1722,6 +1761,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-vaddr-avoid-hw-driven-pte-updates-during-damon_hugetlb_mkold.patch
mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
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

