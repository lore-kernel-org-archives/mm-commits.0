Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7472D0628
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887588; cv=none; b=DMOIL3VYBAUylRIWq90dS02Rg3qzxM4TxkYfWhl7/mxdlcNpofHHBkK2kxjSZXGlvKhrIVmF7juZBP/pfbuf7DRvo416TvXIWWnlFqYLUHS9k/jDjirqSn14Nk/pxasY4SuNpUCmA3QmCdIcb5R6xFk8bCccU/JyGuqQpt025/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887588; c=relaxed/simple;
	bh=df0SPTXb9k/PUpvTZBaUIy3mtUaH3ywoRCwe5+sxjh8=;
	h=Date:To:From:Subject:Message-Id; b=HkhJ5whoBH68oZlXa5UTgbtqdQfsIpxabKm/SgqRHvaeNpxSoTgoxfWI+ZNniit/b2hBZjXoHe8aU1UuKasjL1QtaK4lC/e+JwBw/dGN+JV+ETxeolb3bWIuCEZxpJ+BCX4wofzhjO7/Y9e0Ge3RFNhFJ1Gr2adb8SWsXh545pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zy8NDdju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zy8NDdju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7766BC4CEF5;
	Tue, 11 Nov 2025 18:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762887588;
	bh=df0SPTXb9k/PUpvTZBaUIy3mtUaH3ywoRCwe5+sxjh8=;
	h=Date:To:From:Subject:From;
	b=Zy8NDdjuq66HKL3fCK4OWARKgDEJzqOiotOTK/di0Caah1vXbmMSPWoqyr2oiKRSb
	 H8+8MO2GMYvvo2q9p3i3hA0l/B48RhEe1GaTdloAO0E+vjoFMZtaZWtDXlNeX1KhlS
	 E/CB3ua9osPR6YtjPbnRYG3aPYsPZScLa6d6J0AM=
Date: Tue, 11 Nov 2025 10:59:47 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch added to mm-new branch
Message-Id: <20251111185948.7766BC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: pass migrate_dests to damos_commit_dests()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch

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
Subject: mm/damon/core: pass migrate_dests to damos_commit_dests()
Date: Tue, 11 Nov 2025 10:44:07 -0800

damos_commit_dests() receives 'struct damos' pointers, while it uses only
their ->migrate_dests fields.  This makes code unnecessarily difficult to
read.  It also makes unit tests writing complicated.  Refactor the
function to receive pointers to the ->migrate_dests fields.

Link: https://lkml.kernel.org/r/20251111184415.141757-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-pass-migrate_dests-to-damos_commit_dests
+++ a/mm/damon/core.c
@@ -1000,36 +1000,32 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
-static int damos_commit_dests(struct damos *dst, struct damos *src)
+static int damos_commit_dests(struct damos_migrate_dests *dst,
+		struct damos_migrate_dests *src)
 {
-	struct damos_migrate_dests *dst_dests, *src_dests;
-
-	dst_dests = &dst->migrate_dests;
-	src_dests = &src->migrate_dests;
-
-	if (dst_dests->nr_dests != src_dests->nr_dests) {
-		kfree(dst_dests->node_id_arr);
-		kfree(dst_dests->weight_arr);
-
-		dst_dests->node_id_arr = kmalloc_array(src_dests->nr_dests,
-			sizeof(*dst_dests->node_id_arr), GFP_KERNEL);
-		if (!dst_dests->node_id_arr) {
-			dst_dests->weight_arr = NULL;
+	if (dst->nr_dests != src->nr_dests) {
+		kfree(dst->node_id_arr);
+		kfree(dst->weight_arr);
+
+		dst->node_id_arr = kmalloc_array(src->nr_dests,
+			sizeof(*dst->node_id_arr), GFP_KERNEL);
+		if (!dst->node_id_arr) {
+			dst->weight_arr = NULL;
 			return -ENOMEM;
 		}
 
-		dst_dests->weight_arr = kmalloc_array(src_dests->nr_dests,
-			sizeof(*dst_dests->weight_arr), GFP_KERNEL);
-		if (!dst_dests->weight_arr) {
+		dst->weight_arr = kmalloc_array(src->nr_dests,
+			sizeof(*dst->weight_arr), GFP_KERNEL);
+		if (!dst->weight_arr) {
 			/* ->node_id_arr will be freed by scheme destruction */
 			return -ENOMEM;
 		}
 	}
 
-	dst_dests->nr_dests = src_dests->nr_dests;
-	for (int i = 0; i < src_dests->nr_dests; i++) {
-		dst_dests->node_id_arr[i] = src_dests->node_id_arr[i];
-		dst_dests->weight_arr[i] = src_dests->weight_arr[i];
+	dst->nr_dests = src->nr_dests;
+	for (int i = 0; i < src->nr_dests; i++) {
+		dst->node_id_arr[i] = src->node_id_arr[i];
+		dst->weight_arr[i] = src->weight_arr[i];
 	}
 
 	return 0;
@@ -1076,7 +1072,7 @@ static int damos_commit(struct damos *ds
 	dst->wmarks = src->wmarks;
 	dst->target_nid = src->target_nid;
 
-	err = damos_commit_dests(dst, src);
+	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);
 	if (err)
 		return err;
 
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
mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch

