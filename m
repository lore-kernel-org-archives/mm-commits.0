Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B64F230D35
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343262; cv=none; b=GKhw6RBXXBKeMLk1CPDAA/6mOmf063t5u6J4UZSWWG2tktJR7mexu0m7jkU0jizH1QNcvtOh9zWJolUUP1wje+p2aS6xN3oW/QhuAg224wNuMR+ROYg+Ywt96cHCHW3oRNG8hXhr0oXSWyii8TKsP/G4nf8teBWlAg9YYtxKxA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343262; c=relaxed/simple;
	bh=iL1pPcnwJnNwUo+3HGN1bBzCM4xoPNxlu5kqUMEJRlM=;
	h=Date:To:From:Subject:Message-Id; b=FOd8+loCdATlJIMSXFgeh3LaBJJaGPsLvkKuszdkj/ihe2n+oVKp+/tPWybgqm/sF5OboRX7RBetYmIoED1kyQBi322ZXZNh0URhMqs1vG24BZYPPY6RwwCS5JqUWJA3SBu6vhblk6c+g6w+kRBYQ2vtF8HZaKQYOwmcfpZps50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G4mRAHSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G4mRAHSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCD3C4CEF5;
	Mon, 17 Nov 2025 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343262;
	bh=iL1pPcnwJnNwUo+3HGN1bBzCM4xoPNxlu5kqUMEJRlM=;
	h=Date:To:From:Subject:From;
	b=G4mRAHSR+rRSMGZMohguib5ig0OzUWRgZAcHw86t9wzWDxK9h1u/Hy1UbMEi1vc9P
	 OHW4nmaBRL5+U+C/4eHXQXMq4uX6BWf1S+kJu8trgU4oq0HH8bOeRgKlW2Zq4Tkdsg
	 FtxmYUoJ9vUgLHuqqEDLiWLxXJbeM5vT8nY2JnjA=
Date: Sun, 16 Nov 2025 17:34:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch removed from -mm tree
Message-Id: <20251117013421.EDCD3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sysfs.py: extend assert_ctx_committed() for monitoring targets
has been removed from the -mm tree.  Its filename was
     sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: sysfs.py: extend assert_ctx_committed() for monitoring targets
Date: Wed, 22 Oct 2025 18:25:32 -0700

assert_ctx_committed() is not asserting monitoring targets commitment,
since all existing callers of the function assume no target changes. 
Extend it for future usage.

Link: https://lkml.kernel.org/r/20251023012535.69625-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~sysfspy-extend-assert_ctx_committed-for-monitoring-targets
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -164,6 +164,16 @@ def assert_monitoring_attrs_committed(at
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_monitoring_target_committed(target, dump):
+    # target.pid is the pid "number", while dump['pid'] is 'struct pid'
+    # pointer, and hence cannot be compared.
+    assert_true(dump['obsolete'] == target.obsolete, 'target obsolete', dump)
+
+def assert_monitoring_targets_committed(targets, dump):
+    assert_true(len(targets) == len(dump), 'len_targets', dump)
+    for idx, target in enumerate(targets):
+        assert_monitoring_target_committed(target, dump[idx])
+
 def assert_ctx_committed(ctx, dump):
     ops_val = {
             'vaddr': 0,
@@ -172,6 +182,7 @@ def assert_ctx_committed(ctx, dump):
             }
     assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
 def assert_ctxs_committed(ctxs, dump):
_

Patches currently in -mm which might be from sj@kernel.org are

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

