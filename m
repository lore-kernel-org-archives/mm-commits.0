Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C7921CC51
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343160; cv=none; b=js978SO7Qw46080WyrfXT2vetXaJEpJt8VXwewvwAjECvh1lMuBVg6z/VUWgAejkHcTf6BQGHtL9/v0goUCRNSS9sETiW2Rg9h38UIez9gu3BWwC5TNMu6sVrQUVKfps/qB63Um7uaS/Pn0iUcGNQRaBL3nekjrtFi6+g9JJBdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343160; c=relaxed/simple;
	bh=0WuWUsm/kJQI3jcrAUtHUtk0q4bFLf9vFG4QJsQEks0=;
	h=Date:To:From:Subject:Message-Id; b=KBsMJHDjvSGuoqwxHR32DM56uWhwZ/EJ7oTP/z+gL7Q6ABrLjxQtyj6vMTiCkPUPJjmH+HNC6KT96CAcGr2nJQszKGo6NVJknSLwGdk52RNp8oe57oEg8pO4I1lHqps3+ROPg0yiC42a81CeAD7MwvMpMbdAcgTHhQP/zwvL31s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RqgWBZ5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RqgWBZ5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEF7C4CEF1;
	Mon, 17 Nov 2025 01:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343160;
	bh=0WuWUsm/kJQI3jcrAUtHUtk0q4bFLf9vFG4QJsQEks0=;
	h=Date:To:From:Subject:From;
	b=RqgWBZ5EN+djvpk9TmXBu40rzNMPTXgookF6XQo+frPWrhb01bJXUkpCfkyP8nWy4
	 kX1CuzYnZI6nJmP2OGe8o5O4rd9MflX8ZcGyUytAP8Iq5ZSANhujWHOCXEBAhCahW0
	 vd5FszDTUlb4vIEPNC4m3HUF3TY+5EwMgKcLYHYQ=
Date: Sun, 16 Nov 2025 17:32:39 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch removed from -mm tree
Message-Id: <20251117013240.6AEF7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
Date: Fri, 17 Oct 2025 14:26:58 -0700

Add a variant of DAMOS_QUOTA_NODE_MEMCG_USED_BP, for the free memory
portion.  The value of the metric is implemented as the entire memory of
the given NUMA node subtracted by the given cgroup's usage.  So from a
perspective, "unused" could be a better term than "free".  But arguably it
is not very clear what is better, so use the term "free".

Link: https://lkml.kernel.org/r/20251017212706.183502-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++--
 mm/damon/core.c       |   10 ++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory
+++ a/include/linux/damon.h
@@ -148,6 +148,7 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -158,6 +159,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -183,8 +185,8 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
  *
- * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
- * the node id and the cgroup to account the used memory for.
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP, @nid and @memcg_id
+ * represents the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
--- a/mm/damon/core.c~mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory
+++ a/mm/damon/core.c
@@ -790,6 +790,7 @@ static void damos_commit_quota_goal_unio
 		dst->nid = src->nid;
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
@@ -2046,7 +2047,7 @@ static unsigned long damos_get_node_memc
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
-	unsigned long used_pages;
+	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
 	rcu_read_lock();
@@ -2066,7 +2067,11 @@ static unsigned long damos_get_node_memc
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
 	si_meminfo_node(&i, goal->nid);
-	return used_pages * 10000 / i.totalram;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+		numerator = used_pages;
+	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+		numerator = i.totalram - used_pages;
+	return numerator * 10000 / i.totalram;
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2101,6 +2106,7 @@ static void damos_set_quota_goal_current
 		goal->current_value = damos_get_node_mem_bp(goal);
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
 	default:
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

