Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8F4343D6A
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972392; cv=none; b=t5NUaJ7nNvpBxktR7OwT+OR9Hmp46hYh5hhBbX/wxtX+8vVdcGqb0B6HvLR5m5ZRO3N+NWuA0dO9sPsxkA9e8QMbTv6E3MtQxeQHdoInSDYWn163t4aTEzzW/lO85lC2dW2UC5EoPjLfpIs3sdex1RqmEcbdj6iGH04wVmm6r4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972392; c=relaxed/simple;
	bh=AYE5OSN6vzdSlLqocB+WvzEiLxFWKm6nnw5uVYwvLnI=;
	h=Date:To:From:Subject:Message-Id; b=Ls3teKRRg0+HMzPnuRQwcJKc48HP9S2mKgvFqJHMMnLencuYwgjXi5x5P2EGDCN6fZ1HpDPVjBQU7lYLAZ3mHGkM9yACDNQ6rYmCyHDXyIfwNGC9DSFwzXi1pTcEnGXl+Syks2bvTALBmDruRSlJkP3nf5sc7DskpINBSR4nPZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iJI8eoV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iJI8eoV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BB8C4CEF7;
	Wed, 12 Nov 2025 18:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762972391;
	bh=AYE5OSN6vzdSlLqocB+WvzEiLxFWKm6nnw5uVYwvLnI=;
	h=Date:To:From:Subject:From;
	b=iJI8eoV0Jr6hBFEFNwes+8t5MkxEQuP0OlkMEfvL8SJFjmLF1UUD0Zr5U6d2/K4+c
	 yYk27oarxVJSDQJ3kkgHWyHyWHQYKHxcF3PZ7oA+RpawaWEhXhMP2fNg4/AaL70yKy
	 Zeme82zfBBeoMt/AXgLbMR5le7UiRN89QDy93U1Y=
Date: Wed, 12 Nov 2025 10:33:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-rename-damos-filters-to-damos-core_filters.patch added to mm-new branch
Message-Id: <20251112183311.55BB8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: rename damos->filters to damos->core_filters
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-rename-damos-filters-to-damos-core_filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-rename-damos-filters-to-damos-core_filters.patch

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
Subject: mm/damon: rename damos->filters to damos->core_filters
Date: Wed, 12 Nov 2025 07:41:05 -0800

DAMOS filters that are handled by the ops layer are linked to
damos->ops_filters.  Owing to the ops_ prefix on the name, it is easy to
understand it is for ops layer handled filters.  The other types of
filters, which are handled by the core layer, are linked to
damos->filters.  Because of the name, it is easy to confuse the list is
there for not only core layer handled ones but all filters.  Avoid such
confusions by renaming the field to core_filters.

Link: https://lkml.kernel.org/r/20251112154114.66053-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h                                   |   10 +++++-----
 mm/damon/core.c                                         |    6 +++---
 mm/damon/tests/core-kunit.h                             |    4 ++--
 tools/testing/selftests/damon/drgn_dump_damon_status.py |    8 ++++----
 tools/testing/selftests/damon/sysfs.py                  |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/damon.h~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/include/linux/damon.h
@@ -492,7 +492,7 @@ struct damos_migrate_dests {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @migrate_dests:	Destination nodes if @action is "migrate_{hot,cold}".
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
- * @filters:		Additional set of &struct damos_filter for &action.
+ * @core_filters:	Additional set of &struct damos_filter for &action.
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
@@ -518,7 +518,7 @@ struct damos_migrate_dests {
  *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
- * &filters
+ * &core_filters
  *
  * The minimum entity that @action can be applied depends on the underlying
  * &struct damon_operations.  Since it may not be aligned with the core layer
@@ -562,7 +562,7 @@ struct damos {
 			struct damos_migrate_dests migrate_dests;
 		};
 	};
-	struct list_head filters;
+	struct list_head core_filters;
 	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
@@ -872,10 +872,10 @@ static inline unsigned long damon_sz_reg
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
 
 #define damos_for_each_core_filter(f, scheme) \
-	list_for_each_entry(f, &(scheme)->filters, list)
+	list_for_each_entry(f, &(scheme)->core_filters, list)
 
 #define damos_for_each_core_filter_safe(f, next, scheme) \
-	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
+	list_for_each_entry_safe(f, next, &(scheme)->core_filters, list)
 
 #define damos_for_each_ops_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->ops_filters, list)
--- a/mm/damon/core.c~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/mm/damon/core.c
@@ -306,7 +306,7 @@ void damos_add_filter(struct damos *s, s
 	if (damos_filter_for_ops(f->type))
 		list_add_tail(&f->list, &s->ops_filters);
 	else
-		list_add_tail(&f->list, &s->filters);
+		list_add_tail(&f->list, &s->core_filters);
 }
 
 static void damos_del_filter(struct damos_filter *f)
@@ -397,7 +397,7 @@ struct damos *damon_new_scheme(struct da
 	 */
 	scheme->next_apply_sis = 0;
 	scheme->walk_completed = false;
-	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
@@ -995,7 +995,7 @@ static void damos_set_filters_default_re
 		s->core_filters_default_reject = false;
 	else
 		s->core_filters_default_reject =
-			damos_filters_default_reject(&s->filters);
+			damos_filters_default_reject(&s->core_filters);
 	s->ops_filters_default_reject =
 		damos_filters_default_reject(&s->ops_filters);
 }
--- a/mm/damon/tests/core-kunit.h~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/mm/damon/tests/core-kunit.h
@@ -876,7 +876,7 @@ static void damos_test_commit_filter(str
 static void damos_test_help_initailize_scheme(struct damos *scheme)
 {
 	INIT_LIST_HEAD(&scheme->quota.goals);
-	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 }
 
@@ -1140,7 +1140,7 @@ static void damon_test_set_filters_defau
 	struct damos scheme;
 	struct damos_filter *target_filter, *anon_filter;
 
-	INIT_LIST_HEAD(&scheme.filters);
+	INIT_LIST_HEAD(&scheme.core_filters);
 	INIT_LIST_HEAD(&scheme.ops_filters);
 
 	damos_set_filters_default_reject(&scheme);
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -175,11 +175,11 @@ def scheme_to_dict(scheme):
         ['target_nid', int],
         ['migrate_dests', damos_migrate_dests_to_dict],
         ])
-    filters = []
+    core_filters = []
     for f in list_for_each_entry(
-            'struct damos_filter', scheme.filters.address_of_(), 'list'):
-        filters.append(damos_filter_to_dict(f))
-    dict_['filters'] = filters
+            'struct damos_filter', scheme.core_filters.address_of_(), 'list'):
+        core_filters.append(damos_filter_to_dict(f))
+    dict_['core_filters'] = core_filters
     ops_filters = []
     for f in list_for_each_entry(
             'struct damos_filter', scheme.ops_filters.address_of_(), 'list'):
--- a/tools/testing/selftests/damon/sysfs.py~mm-damon-rename-damos-filters-to-damos-core_filters
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -132,7 +132,7 @@ def assert_scheme_committed(scheme, dump
     assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
     # TODO: test filters directory
     for idx, f in enumerate(scheme.core_filters.filters):
-        assert_filter_committed(f, dump['filters'][idx])
+        assert_filter_committed(f, dump['core_filters'][idx])
     for idx, f in enumerate(scheme.ops_filters.filters):
         assert_filter_committed(f, dump['ops_filters'][idx])
 
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
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

