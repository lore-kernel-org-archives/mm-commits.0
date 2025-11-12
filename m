Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F35353885
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 18:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972407; cv=none; b=A2GWg6Eir59hL+oMvGv2d6SLh1O862rcyeXEv+CxUlyKPJVrwqpSpAGL/pNqMFOPZ6M5Cbo1sjTC7/WSEQ3ZKDSMtn4FbWKuXuSbJlMM3jxzHbiLbOBMna0R0T7u2+DjCJNKC5ZVn1hfB5Nk7N418SAFejGoSrP1FVC29Jhp3ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972407; c=relaxed/simple;
	bh=pBxxr19m2SKxYmQpoTacs6RIw7A7JAByloUYRLIZQCU=;
	h=Date:To:From:Subject:Message-Id; b=o+pXPHjohYnsBDZ5Pl3ecb9Kk2j8hD7oHhj6fhM5Qw8qy4s1P1imxWU/bQQsVa3TynL97fGHVg/bgH6nCRGIpy9NlsAw523fLhitvl+kyOSon0/bgryLw3+k1MNxnDa1DIYaMFoqc2JJJ33I+ivsF9tAbCNEqhdwJbaeZFBVJPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R1uK472/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R1uK472/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D6C4CEF1;
	Wed, 12 Nov 2025 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762972407;
	bh=pBxxr19m2SKxYmQpoTacs6RIw7A7JAByloUYRLIZQCU=;
	h=Date:To:From:Subject:From;
	b=R1uK472/hxncHGtx7CIDzASmiPd4bsiWxOD+OUwjNN3zvAJaAQtjTKRXzSToE33vc
	 P9g1mPro7/MzlSi6MdjlNHI+nSQgnYvDSBeJddKFxCzCWt4H3Zwu4Smg2CjJNbI3X7
	 CsW7ypEarrn16hDfm1wk6BBs6GW5M77CWIiBRcUc=
Date: Wed, 12 Nov 2025 10:33:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch added to mm-new branch
Message-Id: <20251112183327.505D6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch

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
Subject: selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion
Date: Wed, 12 Nov 2025 07:41:10 -0800

For each test case, sysfs.py makes changes to DAMON, dumps DAMON internal
status and asserts the expectation is met.  The dumping part should be the
same for all cases, so it is duplicated for each test case.  Which means
it is easy to make mistakes.  Actually a few of those duplicates are not
turning DAMON off in case of the dumping failure.  It makes following
selftests that need to turn DAMON on fails with -EBUSY.  Merge the status
dumping into commitment assertion with proper dumping failure handling, to
deduplicate and avoid the unnecessary following tests failures.

Link: https://lkml.kernel.org/r/20251112154114.66053-8-sj@kernel.org
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

 tools/testing/selftests/damon/sysfs.py |   43 ++++++-----------------
 1 file changed, 13 insertions(+), 30 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -185,7 +185,15 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
-def assert_ctxs_committed(ctxs, dump):
+def assert_ctxs_committed(kdamonds):
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        kdamonds.stop()
+        exit(1)
+
+    ctxs = kdamonds.kdamonds[0].contexts
+    dump = status['contexts']
     assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])
@@ -202,13 +210,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        kdamonds.stop()
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     context = _damon_sysfs.DamonCtx(
             monitoring_attrs=_damon_sysfs.DamonAttrs(
@@ -256,12 +258,7 @@ def main():
     kdamonds.kdamonds[0].contexts = [context]
     kdamonds.kdamonds[0].commit()
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     # test online commitment of minimum context.
     context = _damon_sysfs.DamonCtx()
@@ -270,12 +267,7 @@ def main():
     kdamonds.kdamonds[0].contexts = [context]
     kdamonds.kdamonds[0].commit()
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     kdamonds.stop()
 
@@ -303,17 +295,8 @@ def main():
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
     kdamonds.kdamonds[0].commit()
-
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        kdamonds.stop()
-        exit(1)
-
     del kdamonds.kdamonds[0].contexts[0].targets[1]
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
-
+    assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
 if __name__ == '__main__':
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

