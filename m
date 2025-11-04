Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672426E6F5
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762225668; cv=none; b=sUWd7KM/kG7L11y1/J5qPEf0R3E5SizUG6qxd2ULK5KPPzajaS4RZgN+/7ekrIenyyw8reI0/SJrRZQy2MlJSt1EcivoJlPzAYtYO7GwT7Gz0RPX0w8Yi0IbuQ7t66DbguM50zGPgrcYO4q+kmGAmVDsh22LxD4Er3c0H+zXGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762225668; c=relaxed/simple;
	bh=Yi5uEC6T5b0qSe5TSCxsZhTHJJQZy3/bTnfY7SBK8vw=;
	h=Date:To:From:Subject:Message-Id; b=rY6AU9bk3MKnzDn4Vafjybb61rI9ahrvWpIoZULGwDEvoKh7B4QLGWKZH5b58Wt5Kl9c5kS6myuV3LQjVeEk4Y20LocfB6qGrvBIqhHhFyR6a/BIhKJjDV2fmSpWyqyLzlXC3b4Y/MLS4i7Z5EJO0vLC0veAWIVEsz1nkyPlIpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V82QmJu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V82QmJu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AA6C4CEFD;
	Tue,  4 Nov 2025 03:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762225667;
	bh=Yi5uEC6T5b0qSe5TSCxsZhTHJJQZy3/bTnfY7SBK8vw=;
	h=Date:To:From:Subject:From;
	b=V82QmJu8kv21lo4tBiwA59KG59Rk7oTWWCZNrmzOBv+U4u+MGfjVrsxdVG+yLdIFH
	 HCEPNW9a50k9UQ28bnz1iD0aKwrtEfd+7UrwlnthSsG11SnzhxPMKUk0bjBreZkUoz
	 zg84P37qfBx4wCWy4II6raBHUsXFfEoS1kWtVKmc=
Date: Mon, 03 Nov 2025 19:07:46 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch added to mm-new branch
Message-Id: <20251104030747.66AA6C4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch

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
Subject: mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()
Date: Sat, 1 Nov 2025 11:20:15 -0700

damon_test_split_at() dynamically allocates a 'struct damon_ctx' object,
but it is not really being used in the code other than handling the
allocation failure and deallocating it at the end of the function.  Remove
the unnecessary allocation and deallocation of the object.

Link: https://lkml.kernel.org/r/20251101182021.74868-22-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at
+++ a/mm/damon/tests/core-kunit.h
@@ -144,20 +144,14 @@ static void damon_test_aggregate(struct
 
 static void damon_test_split_at(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
 
-	if (!c)
-		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "target alloc fail");
-	}
 	r = damon_new_region(0, 100);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -178,7 +172,6 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 
 	damon_free_target(t);
-	damon_destroy_ctx(c);
 }
 
 static void damon_test_merge_two(struct kunit *test)
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

