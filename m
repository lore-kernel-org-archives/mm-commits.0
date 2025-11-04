Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63026C3AE;
	Tue,  4 Nov 2025 03:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762225636; cv=none; b=rlxCsSOPn2Yg5WGMr7lWeJHvzfQE8AfECXY/apMnH5QfJ3nz5HOsnNkznqYMXt/+6Genf4KFhmb91RMMnvo1tpBF7k9ll/Ei03Tc4hGJdAnhVDXls9OHjyvEAHRdjbO0d+rW9c+kquFfkSURcqlOJdbTPrWK4PVTJ0wjGQfTe7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762225636; c=relaxed/simple;
	bh=0Hw6Kg0wq0jo+prtQepZux5aErVrfhT+jkimUS7/oOE=;
	h=Date:To:From:Subject:Message-Id; b=TGjxR6kk56Dstk2WWGy+09MyVeZNYzwTpm2VGEQRnNOFu8t4F2rgnw/t4f9om1owX7ishc9jTTd+jQoBY5WoH1OpADY9VVrpNAXfJgzGT0qJJr4qrx8lif45pguLkMm1/E+vnEx7mvMj79n6zzlAlLwjADKmn6bzwR3cGHb+bi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s7EbmLoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s7EbmLoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01B1C4CEFD;
	Tue,  4 Nov 2025 03:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762225635;
	bh=0Hw6Kg0wq0jo+prtQepZux5aErVrfhT+jkimUS7/oOE=;
	h=Date:To:From:Subject:From;
	b=s7EbmLoXsa9W7quhEaR7ZH2NTIHbEj6bcRJ6ba0+znO5UDKz1CuL/kC4lXUELRbli
	 3BGjebrjIuO2unXJLMPFbMiFTSV95zBpLJfk9kmEkET8JtPSDFwZNru1GBEU4xuyWZ
	 v2iUbzHdSOYhC7G90KWET8OAHCeUx96fxHpeTKPk=
Date: Mon, 03 Nov 2025 19:07:15 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch added to mm-new branch
Message-Id: <20251104030715.A01B1C4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
Date: Sat, 1 Nov 2025 11:19:59 -0700

damon_test_split_at() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-6-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at
+++ a/mm/damon/tests/core-kunit.h
@@ -148,8 +148,19 @@ static void damon_test_split_at(struct k
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch
mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject.patch
mm-damon-tests-core-kunit-handle-allocation-failures-in-damon_test_regions.patch
mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target.patch
mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_merge_two.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_ops_registration.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_set_regions.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damon_test_set_attrs.patch
mm-damon-tests-core-kunit-handle-alloc-failres-in-damon_test_new_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_do_test_apply_three_regions.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-in-damon_test_split_evenly_fail.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ.patch
mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets.patch
mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of.patch

