Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED37D223336
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343156; cv=none; b=CGag/dvCeP7c2Pk3ghzcunea7fVz/G6kjzp2iPkVORw+RWECQQfCarhOkj2RLeMnbTE1yUr1NkGQ4ubGNA1CMshxSvlKSU2uGmNwgBVa3+WQoA3PzN/Ls8bwQWjtHJxOM5KNmqGNCcCVai00hTyeHQglLsHyBTgW2yVdwNDG0Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343156; c=relaxed/simple;
	bh=Fo41aVTjLl45vTadKNq01DFmP6r4cD3Nht8pXu16Jmw=;
	h=Date:To:From:Subject:Message-Id; b=nuqC8xjkvSw6/RKEtPpe+B8SF4GkLPrQmloMN8wjSPmouHyjxPbJsY1QeUEY51h0ns5he3q+UanUvZqynrH/47SLf/F5PB9gGML7W+zMmUBT9yoOBbfeDiEnEw4YBOOcOl6m7K1osGv+9XOZGXw4Uif0cERtn8Ehi1YwScGnrYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pswnHs8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pswnHs8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11D1C116D0;
	Mon, 17 Nov 2025 01:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343155;
	bh=Fo41aVTjLl45vTadKNq01DFmP6r4cD3Nht8pXu16Jmw=;
	h=Date:To:From:Subject:From;
	b=pswnHs8+Evd14SHfpOGJ/XfBFuU7DAF7F2/5zw30bapOSadu90T8dJZTMWjHt04UH
	 HGM01HPIotZEuORPziZWJVJeGxdp1TEylnj+RmeazO+BfaoZbd0V5nBY/rUhT1G/w8
	 MbgtVxrzCWcdY2vaqPQhuk/2tJqtC2mDru6UxNKI=
Date: Sun, 16 Nov 2025 17:32:35 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch removed from -mm tree
Message-Id: <20251117013235.C11D1C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add DAMOS quota goal type for per-memcg per-node memory usage
has been removed from the -mm tree.  Its filename was
     mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add DAMOS quota goal type for per-memcg per-node memory usage
Date: Fri, 17 Oct 2025 14:26:54 -0700

Define a new DAMOS quota auto-tuning target metric for per-cgroup per-node
memory usage.  For specifying the cgroup of the interest, add a field,
namely memcg_id, to damos_quota_goal struct.

Note that this commit is only implementing the interface.  The handling of
the interface (the metric value calculation) will be implemented in the
following commit.

Link: https://lkml.kernel.org/r/20251017212706.183502-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage
+++ a/include/linux/damon.h
@@ -147,6 +147,7 @@ enum damos_action {
  * @DAMOS_QUOTA_SOME_MEM_PSI_US:	System level some memory PSI in us.
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
+ * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -156,6 +157,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_SOME_MEM_PSI_US,
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
+	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -166,6 +168,7 @@ enum damos_quota_goal_metric {
  * @current_value:	Current value of @metric.
  * @last_psi_total:	Last measured total PSI
  * @nid:		Node id.
+ * @memcg_id:		Memcg id.
  * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
@@ -179,6 +182,9 @@ enum damos_quota_goal_metric {
  *
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
+ * the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
@@ -187,7 +193,10 @@ struct damos_quota_goal {
 	/* metric-dependent fields */
 	union {
 		u64 last_psi_total;
-		int nid;
+		struct {
+			int nid;
+			unsigned short memcg_id;
+		};
 	};
 	struct list_head list;
 };
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

