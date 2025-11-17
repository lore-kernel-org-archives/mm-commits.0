Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EA2212548
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343157; cv=none; b=Ha1caNgHDDQgG3U/o9zKBGV6XZwRNm6OE2sEjp6De13y2BEitBT/V/WzGI3AQlbPO3acObjDvwMWD0mqdMDMI8p/co1XpF+EuWdLgX+2tmNe+cba/dAnAx5c7VroDiwGL6BRkVXtfmtkgMcmLRgs6VHwosq2r2oklx+ftkc2bHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343157; c=relaxed/simple;
	bh=krXaa8CjNKQoclcHEfX6Q1FuisGbQvKCL7f8s367igc=;
	h=Date:To:From:Subject:Message-Id; b=pl3A1H9zcAnjOnwzR0DSwpwIZojyrw7jfcO0hHhSWMrZor7jSQw2ZrfogSddPKDTOqsWygTzfbGJCNSIoQoI18sYVfXX+3XRRSZYl/NFP5OcGpDMQuL2rYSFScmHd8IWte6xbmtDLIP8OLF6pv9IMsOdIGUIO22iwax56XURBWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k0qXXGEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k0qXXGEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E770FC19421;
	Mon, 17 Nov 2025 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343157;
	bh=krXaa8CjNKQoclcHEfX6Q1FuisGbQvKCL7f8s367igc=;
	h=Date:To:From:Subject:From;
	b=k0qXXGEQ+MctMemv4hwlRmzZ2S9i+WtzOySKA5MqRiMfRkhwHQj8wbwiLLmKuG93v
	 0LZX/mFgUJRs3sjecAmolqD5KJm80BcDMQWmnO7Lw4YE2CNmJ7RIZ10O1qAhg6OXPG
	 1qNy2nOkLoCbJRXzHLsWFGQwm7dZkA+2I6CJvSyA=
Date: Sun, 16 Nov 2025 17:32:36 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch removed from -mm tree
Message-Id: <20251117013236.E770FC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Fri, 17 Oct 2025 14:26:55 -0700

Implement the handling of the new DAMOS quota goal metric for per-memcg
per-node memory usage, namely DAMOS_QUOTA_NODE_MEMCG_USED_BP.  The metric
value is calculated as the sum of active/inactive anon/file pages of the
given cgroup for a given NUMA node.

Link: https://lkml.kernel.org/r/20251017212706.183502-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-implement-damos_quota_node_memcg_used_bp
+++ a/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/damon.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/psi.h>
 #include <linux/slab.h>
@@ -788,6 +789,10 @@ static void damos_commit_quota_goal_unio
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
 		break;
+	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		dst->nid = src->nid;
+		dst->memcg_id = src->memcg_id;
+		break;
 	default:
 		break;
 	}
@@ -2035,12 +2040,46 @@ static __kernel_ulong_t damos_get_node_m
 		numerator = i.freeram;
 	return numerator * 10000 / i.totalram;
 }
+
+static unsigned long damos_get_node_memcg_used_bp(
+		struct damos_quota_goal *goal)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+	unsigned long used_pages;
+	struct sysinfo i;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(goal->memcg_id);
+	rcu_read_unlock();
+	if (!memcg) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 10000;
+	}
+	mem_cgroup_flush_stats(memcg);
+	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
+	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
+	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
+	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
+
+	si_meminfo_node(&i, goal->nid);
+	return used_pages * 10000 / i.totalram;
+}
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
 	return 0;
 }
+
+static unsigned long damos_get_node_memcg_used_bp(
+		struct damos_quota_goal *goal)
+{
+	return 0;
+}
 #endif
 
 
@@ -2061,6 +2100,9 @@ static void damos_set_quota_goal_current
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		goal->current_value = damos_get_node_mem_bp(goal);
 		break;
+	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		goal->current_value = damos_get_node_memcg_used_bp(goal);
+		break;
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

