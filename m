Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C122A21A447
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343161; cv=none; b=OWjVcP3T7XAKrGQsTAiCY70aI4ifEi96QqrSLrXV9/7wbnBQ1c38zFCnTcWWRM4LG0ecAYS8KahmLMJIgkWzqHEtu7fpt1i5FI+yUyhW70iepOhL7oluWbVd18OB4qZ4uimq4jpaz1wzIZ2pBwkd4F9suOcUzuMFS7SkCtOExrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343161; c=relaxed/simple;
	bh=cqr/scysWOius5hl1y/aDmmAtbWhv2eZQ5AjAWCwrQ8=;
	h=Date:To:From:Subject:Message-Id; b=RFfowYxkJPX49OIkGNuM7w4SdDfYMwaRBYUwJFedFKHJAv1rDSV/kGVK0dmVcrP/AKktADPWTlpoUojgvWhH9WT5kxH+pVzzKszNJzAoKROG5X2bRFvcIbW/22tzprKOxG8tiR+/iU+gyCGVwRFrX7db5s08NMn5yjSd6P0xsik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cI0mK5Sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cI0mK5Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94782C16AAE;
	Mon, 17 Nov 2025 01:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343161;
	bh=cqr/scysWOius5hl1y/aDmmAtbWhv2eZQ5AjAWCwrQ8=;
	h=Date:To:From:Subject:From;
	b=cI0mK5Sre6MR4C/zGXFnoFxXKC6o4MCtrlHC/QK2FHbh0ialJo4mGRgWGG/vtOeYj
	 E0EA3qX3rH42u1M4IUPzE8Thr7m2GRUvSzE+pGU1gklICFIg5PWm0X46tbmuVA/WiW
	 x4I9Eul/CHVRxOe87XKB8nJ7qvm7M89qecc2Grmo=
Date: Sun, 16 Nov 2025 17:32:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch removed from -mm tree
Message-Id: <20251117013241.94782C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP
Date: Fri, 17 Oct 2025 14:26:59 -0700

Extend DAMON sysfs to support DAMOS_QUOTA_NODE_MEMCG_FREE_BP.

Link: https://lkml.kernel.org/r/20251017212706.183502-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp
+++ a/mm/damon/sysfs-schemes.c
@@ -1034,6 +1034,10 @@ struct damos_sysfs_qgoal_metric_name dam
 		.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 		.name = "node_memcg_used_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+		.name = "node_memcg_free_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2552,6 +2556,7 @@ static int damos_sysfs_add_quota_score(
 			goal->nid = sysfs_goal->nid;
 			break;
 		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_goal->path, &goal->memcg_id);
 			if (err) {
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

