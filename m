Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2B31C1F02
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343159; cv=none; b=rLYk4GlL0zkmY2ABOgd1le91GVLCOrbNOSxw4llfPoVQr3w4WShp4Mt4nBtZn4SdMMVGxwLzeFO42PEsCffoDC6HBoROKqUZ5GPqoqHiuR8hv6n4B1XKpDNwkFYmFhK+ZuodBEIvUn2Wmq8Y420jvDVrVhoVg35LU5fCL56ybM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343159; c=relaxed/simple;
	bh=l8rg7mYQG+mWvwVp16G7eQlW76KBS4XmtGlJMtJ+xSQ=;
	h=Date:To:From:Subject:Message-Id; b=Foq/hkXlBdZ9Sz3KsuZCIEjT3Ynd7kk0D4bAOq3y+Rostgq2G66gxWyCyy0CxNeXI6x1MTqmHp1ifQvnQBm+rYafxXXX9kLAG9+c6hb1J86FbErDR2PLfESIWLRjAevGuQyQxdXl3gttnSyS5kUBLD3yB07JZweMlW//LkDVuiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hY9j0bHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hY9j0bHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A22C4CEF5;
	Mon, 17 Nov 2025 01:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343159;
	bh=l8rg7mYQG+mWvwVp16G7eQlW76KBS4XmtGlJMtJ+xSQ=;
	h=Date:To:From:Subject:From;
	b=hY9j0bHfNtg0HX5ebxx2Oay7rk8CVNTGCOuNC4liWlYUo6V4t3druFrjaMGEUngCr
	 x7HGVFoo/SEB7B5y6nzN6FQf7ecNUL4nHbKzrIDQPVGCkn7mp4TPu/ypJfI37YmnAZ
	 3C+iwaH7JNki098pcBDd7NS7AH0+UM+rDhGKZpMI=
Date: Sun, 16 Nov 2025 17:32:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch removed from -mm tree
Message-Id: <20251117013239.35A22C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_USED_BP
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Fri, 17 Oct 2025 14:26:57 -0700

Add support of DAMOS_QUOTA_NODE_MEMCG_USED_BP.  For this, extend quota
goal metric inputs for the new metric, and update DAMOS core layer request
construction logic to set the target cgroup, which is specified by the
user, via the 'path' file.

Link: https://lkml.kernel.org/r/20251017212706.183502-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp
+++ a/mm/damon/sysfs-schemes.c
@@ -1030,6 +1030,10 @@ struct damos_sysfs_qgoal_metric_name dam
 		.metric = DAMOS_QUOTA_NODE_MEM_FREE_BP,
 		.name = "node_mem_free_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+		.name = "node_memcg_used_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2526,7 +2530,7 @@ static int damos_sysfs_add_quota_score(
 		struct damos_quota *quota)
 {
 	struct damos_quota_goal *goal;
-	int i;
+	int i, err;
 
 	for (i = 0; i < sysfs_goals->nr; i++) {
 		struct damos_sysfs_quota_goal *sysfs_goal =
@@ -2547,6 +2551,15 @@ static int damos_sysfs_add_quota_score(
 		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+			err = damon_sysfs_memcg_path_to_id(
+					sysfs_goal->path, &goal->memcg_id);
+			if (err) {
+				damos_destroy_quota_goal(goal);
+				return err;
+			}
+			goal->nid = sysfs_goal->nid;
+			break;
 		default:
 			break;
 		}
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

