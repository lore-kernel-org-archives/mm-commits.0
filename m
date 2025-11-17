Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F237B2222C4
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343163; cv=none; b=eFqi9pRGvFkPDQxxyXuF+dxjVKTuscGw6bbk0WUXGQ1+yyCQd6WOh3YhZZnDRe1ROLNpJnij+ClsNyo5I5nAm7HGtcTb3HhyJcnye5WQgkBgYIDEPM6N7pAg5Mez9Ws1deqvv3vd59ZVxBFi6AmdwyQpNa8R8+33POUfTZipdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343163; c=relaxed/simple;
	bh=kXSr0PZYwlYv3XclBYWaSCEl+mz6UCDP3wjZ7GVnPSo=;
	h=Date:To:From:Subject:Message-Id; b=F4/09G3lMKIoZnO6/2iyMSfDh2exlUzhR/0EBWHXPK09wg1J0x4wsO5rL1fBo8Y9vxS5S4CHm83ZX7jHhDbaOg9dUS+vGXITTx9ZJxaTpOyFLcPolNu3CadlAYERBsJdknEcAot8ADIYnN9S5BODqZzVGYf2SMWpVfvO0fDQ7Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Him2GOKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Him2GOKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C445EC4CEF5;
	Mon, 17 Nov 2025 01:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343162;
	bh=kXSr0PZYwlYv3XclBYWaSCEl+mz6UCDP3wjZ7GVnPSo=;
	h=Date:To:From:Subject:From;
	b=Him2GOKIsT/mZl5/RJqV6mJvrkDybWVIq4Lq0EWp4samwshLA10OxnWhbT7Oo/FAl
	 vXZJCvEL7yemUGniKEiyAceOk0XEnhDVYZcUICOh8966L4acgVmrqvr7ZpEm+GAZgv
	 zYF6r8R7SufbSkjfxP4Gupn4ykRhKa6U+Gi0mKVc=
Date: Sun, 16 Nov 2025 17:32:42 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch removed from -mm tree
Message-Id: <20251117013242.C445EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP
Date: Fri, 17 Oct 2025 14:27:00 -0700

Update design doc for the newly added two DAMOS quota auto-tuning target
goal metrics, DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP.

Link: https://lkml.kernel.org/r/20251017212706.183502-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp
+++ a/Documentation/mm/damon/design.rst
@@ -564,9 +564,9 @@ aggressiveness (the quota) of the corres
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
-The goal can be specified with four parameters, namely ``target_metric``,
-``target_value``, ``current_value`` and ``nid``.  The auto-tuning mechanism
-tries to make ``current_value`` of ``target_metric`` be same to
+The goal can be specified with five parameters, namely ``target_metric``,
+``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
+mechanism tries to make ``current_value`` of ``target_metric`` be same to
 ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
@@ -581,9 +581,18 @@ tries to make ``current_value`` of ``tar
   set by users at the initial time.  In other words, DAMOS does self-feedback.
 - ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
 - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
+- ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
+  specific NUMA node, in bp (1/10,000).
+- ``node_memcg_free_bp``: Specific cgroup's node unused memory ratio for a
+  specific NUMA node, in bp (1/10,000).
 
-``nid`` is optionally required for only ``node_mem_used_bp`` and
-``node_mem_free_bp`` to point the specific NUMA node.
+``nid`` is optionally required for only ``node_mem_used_bp``,
+``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
+point the specific NUMA node.
+
+``path`` is optionally required for only ``node_memcg_used_bp`` and
+``node_memcg_free_bp`` to point the path to the cgroup.  The value should be
+the path of the memory cgroup from the cgroups mount point.
 
 To know how user-space can set the tuning goal metric, the target value, and/or
 the current value via :ref:`DAMON sysfs interface <sysfs_interface>`, refer to
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

