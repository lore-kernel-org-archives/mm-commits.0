Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D055B34AB13
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 18:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972388; cv=none; b=ILzXEPDCkbvSM6o6qiSAcnNJ5L9iYD+9yQPULDL6KGDi1W05ytLzp7258Imf4pILpwDRiKTL40NGNiXY3V9lfY9lSlh3zp/mN0pw5SSMz9OADIf/r5+81EYSV8Bzky+y8taR2NaPZWdHBxgNPAj2GZ7Hp8639yd7NJjEk+c1cH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972388; c=relaxed/simple;
	bh=GXhgKAvwdgp8z34nhT8dkKOmfFs4Vqiw314bOxOfz6Q=;
	h=Date:To:From:Subject:Message-Id; b=E1C1tGBYraIupV4VPQQIJIQkQJm7/sbXgYaF7edx5N7pMQH0hQFVkaP3nJj6DPgnGjATqQp755ogmNPlwyunL8i4BLhOrq3KJSlI/cU/ZGbZpZCGRfpvq8AVdnCE+cjyx9b3FpmqmGWDHl8R/P5/HXVK0L+1UDjtgmz0FlDeVz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2PrSBuUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2PrSBuUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F785C4CEF5;
	Wed, 12 Nov 2025 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762972388;
	bh=GXhgKAvwdgp8z34nhT8dkKOmfFs4Vqiw314bOxOfz6Q=;
	h=Date:To:From:Subject:From;
	b=2PrSBuUemQXsDeaCcRWEWM9/9d1JTMRG9IJjviuidFgebVB7mR6KF14xcMKKPrHd2
	 TeO8OuPM+fb3aSshcfvkhfkQu8GcQgq4im9ehn83x79f1tnOCDuku6BAmGHjacarWy
	 lEqGPoKPakL+8gblMEuJahboDaP6v8gPIz5KXQaM=
Date: Wed, 12 Nov 2025 10:33:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch added to mm-new branch
Message-Id: <20251112183308.2F785C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: rename damos core filter helpers to have word core
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch

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
Subject: mm/damon: rename damos core filter helpers to have word core
Date: Wed, 12 Nov 2025 07:41:04 -0800

Patch series "mm/damon: misc cleanups".

Yet another batch of misc cleanups and refactoring for DAMON code, tests,
and documents.

First two patches (1and 2) rename DAMOS core filters related code for
readability.

Three following patches (3-5) refactor page table walk callback functions
in DAMON, as suggested by Hugh and David, and I promised.

Next two patches (6 and 7) refactor DAMON core layer kunit test and sysfs
interface selftest to be simple and deduplicated.

Final two patches (8 and 9) fix up sphinx and grammatical errors on
documents.


This patch (of 9):

DAMOS filters handled by the core layer are called core filters, while
those handled by the ops layer are called ops filters.  They share the
same type but are managed in different places since core filters are
evaluated before the ops filters.  They also have different helper
functions that depend on their managed places.

The helper functions for ops filters have '_ops_' keyword on their name,
so it is easy to know they are for ops filters.  Meanwhile, the helper
functions for core filters are not having the 'core' keyword on their
name.  This makes it easy to be mistakenly used for ops filters.  Actually
there was such a bug.

To avoid future mistakes from similar confusions, rename DAMOS core
filters helper functions to have a keyword 'core' on their names.

Link: https://lkml.kernel.org/r/20251112154114.66053-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251112154114.66053-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
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
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .clang-format         |    4 ++--
 include/linux/damon.h |    4 ++--
 mm/damon/core.c       |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/.clang-format~mm-damon-rename-damos-core-filter-helpers-to-have-word-core
+++ a/.clang-format
@@ -140,8 +140,8 @@ ForEachMacros:
   - 'damon_for_each_scheme_safe'
   - 'damon_for_each_target'
   - 'damon_for_each_target_safe'
-  - 'damos_for_each_filter'
-  - 'damos_for_each_filter_safe'
+  - 'damos_for_each_core_filter'
+  - 'damos_for_each_core_filter_safe'
   - 'damos_for_each_ops_filter'
   - 'damos_for_each_ops_filter_safe'
   - 'damos_for_each_quota_goal'
--- a/include/linux/damon.h~mm-damon-rename-damos-core-filter-helpers-to-have-word-core
+++ a/include/linux/damon.h
@@ -871,10 +871,10 @@ static inline unsigned long damon_sz_reg
 #define damos_for_each_quota_goal_safe(goal, next, quota) \
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
 
-#define damos_for_each_filter(f, scheme) \
+#define damos_for_each_core_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->filters, list)
 
-#define damos_for_each_filter_safe(f, next, scheme) \
+#define damos_for_each_core_filter_safe(f, next, scheme) \
 	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
 
 #define damos_for_each_ops_filter(f, scheme) \
--- a/mm/damon/core.c~mm-damon-rename-damos-core-filter-helpers-to-have-word-core
+++ a/mm/damon/core.c
@@ -450,7 +450,7 @@ void damon_destroy_scheme(struct damos *
 	damos_for_each_quota_goal_safe(g, g_next, &s->quota)
 		damos_destroy_quota_goal(g);
 
-	damos_for_each_filter_safe(f, next, s)
+	damos_for_each_core_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
 	damos_for_each_ops_filter_safe(f, next, s)
@@ -864,12 +864,12 @@ static int damos_commit_quota(struct dam
 	return 0;
 }
 
-static struct damos_filter *damos_nth_filter(int n, struct damos *s)
+static struct damos_filter *damos_nth_core_filter(int n, struct damos *s)
 {
 	struct damos_filter *filter;
 	int i = 0;
 
-	damos_for_each_filter(filter, s) {
+	damos_for_each_core_filter(filter, s) {
 		if (i++ == n)
 			return filter;
 	}
@@ -923,15 +923,15 @@ static int damos_commit_core_filters(str
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
 	int i = 0, j = 0;
 
-	damos_for_each_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+	damos_for_each_core_filter_safe(dst_filter, next, dst) {
+		src_filter = damos_nth_core_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
 			damos_destroy_filter(dst_filter);
 	}
 
-	damos_for_each_filter_safe(src_filter, next, src) {
+	damos_for_each_core_filter_safe(src_filter, next, src) {
 		if (j++ < i)
 			continue;
 
@@ -1767,7 +1767,7 @@ static bool damos_filter_out(struct damo
 	struct damos_filter *filter;
 
 	s->core_filters_allowed = false;
-	damos_for_each_filter(filter, s) {
+	damos_for_each_core_filter(filter, s) {
 		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
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

