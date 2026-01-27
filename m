Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE33191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486709; cv=none; b=kZUFe0KU68jfuloixZZM3I1a0Md/RwcyJf4XVWz5TXNWnVVV0kPE4vro293ZpFVn8Zd/xeTlmDSOe/zC4OG8P1n8KDEjhh0YhZOI/ds0gT2Q/J1bhQB2DSyv82ndYLeMcICPfM59iQT0WdlmB1zkc/9wHWrxZIruvazAUMHRNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486709; c=relaxed/simple;
	bh=3hgznVT5lOYn4WlJjkAEnXoNswVZDhb3OU1e9q6PZro=;
	h=Date:To:From:Subject:Message-Id; b=I9DUR7Mrhu3kVuJE0XpGN2fF0KZnDAGSMhpDl6Frwo73pY9rlQ4j8UWalYkTtypsduWTSD7vTVRBsXHcQFha/GzhaQnkY8F+FsHmzMOwqD4OqR20jBKvcNvO5l2yESuZ5NbTC7nu8hjffZwQxkkIrDbuFbYV66KdLRahP+Ii0qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ls1WcVA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ls1WcVA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B38C116C6;
	Tue, 27 Jan 2026 04:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486709;
	bh=3hgznVT5lOYn4WlJjkAEnXoNswVZDhb3OU1e9q6PZro=;
	h=Date:To:From:Subject:From;
	b=ls1WcVA/wtZ/gnqHcDCKQzkpyGjDgym7i/QZ1yGrugFB/kPkGBYs5+RQ25pxx3JM9
	 ifaiy9bmUThn98YXp0bo+gqQzGmXEcPTNA7tmkPD/i9yR8b2xYjlgeyc450ZTO8Gb/
	 m/JkDHYso4loX1yiE/jmZQKDyjz76e5p8BxPMT4U=
Date: Mon, 26 Jan 2026 20:05:08 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch removed from -mm tree
Message-Id: <20260127040508.E8B38C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce [in]active memory ratio damos quota goal metric
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce [in]active memory ratio damos quota goal metric
Date: Tue, 13 Jan 2026 07:27:06 -0800

Patch series "mm/damon: advance DAMOS-based LRU sorting".

DAMOS_LRU_[DE]PRIO actions were added to DAMOS for more access-aware LRU
lists sorting.  For simple usage, a specialized kernel module, namely
DAMON_LRU_SORT, has also been introduced.  After the introduction of the
module, DAMON got a few important new features, including the aim-based
quota auto-tuning, age tracking, young page filter, and monitoring
intervals auto-tuning.  Meanwhile, DAMOS-based LRU sorting had no direct
updates.  Now we show some rooms to advance for DAMOS-based LRU sorting.

Firstly, the aim-oriented quota auto-tuning can simplify the LRU sorting
parameters tuning.  But there is no good auto-tuning target metric for LRU
sorting use case.  Secondly, the behavior of DAMOS_LRU_[DE]PRIO are not
very symmetric.  DAMOS_LRU_DEPRIO directly moves the pages to inactive LRU
list, while DAMOS_LRU_PRIO only marks the page as accessed, so that the
page can not directly but only eventually moved to the active LRU list. 
Finally, DAMON_LRU_SORT users cannot utilize the modern features that can
be useful for them, too.

Improve the situation with the following changes.  First, introduce a new
DAMOS quota auto-tuning target metric for active:inactive memory size
ratio.  Since LRU sorting is a kind of balancing of active and inactive
pages, the active:inactive memory size ratio can be intuitively set. 
Second, update DAMOS_LRU_[DE]PRIO behaviors to be more intuitive and
symmetric, by letting them directly move the pages to [in]active LRU list.
Third, update the DAMON_LRU_SORT module user interface to be able to
fully utilize the modern features including the [in]active memory size
ratio-based quota auto-tuning, young page filter, and monitoring intervals
auto-tuning.

With these changes, for example, users can now ask DAMON to "find hot/cold
memory regions with auto-tuned monitoring intervals, do one more page
level access check for found hot/cold memory, and move pages of those to
active or inactive LRU lists accordingly, aiming X:Y active to inactive
memory ratio." For example, if they know 30% of the memory is better to be
protected from reclamation, 30:70 can be set as the target ratio.

Test Results
------------

I ran DAMON_LRU_SORT with the features introduced by this series, on a
real world server workload.  For the active:inactive ratio goal, I set
50:50.  I confirmed it achieves the target active:inactive ratio, without
manual tuning of the monitoring intervals and the hot/coldness thresholds.
The baseline system that was not running the DAMON_LRU_SORT was keeping
active:inactive ratio of about 1:10.

Note that the test didn't show a clear performance difference, though.  I
believe that was mainly because the workload was not very memory
intensive.  Also, whether the 50:50 target ratio was optimum is unclear. 
Nonetheless, the positive performance impact of the basic LRU sorting idea
is already confirmed with the initial DAMON_LRU_SORT introduction patch
series.  The goal of this patch series is simplifying the parameters
tuning of DAMOS-based LRU sorting, and the test confirmed the aimed goals
are achieved.

Patches Sequence
----------------

First three patches extend DAMOS quota auto-tuning to support [in]active
memory ratio target metric type.  Those (patches 1-3) introduce new
metrics, implement DAMON sysfs support, and update the documentation,
respectively.

Following patch (patch 4) makes DAMOS_LRU_PRIO action to directly move
target pages to active LRU list, instead of only marking them accessed.

Following seven patches (patches 5-11) updates DAMON_LRU_SORT to support
modern DAMON features.  Patch 5 makes it uses not only access frequency
but also age at under-quota regions prioritization.  Patches 6-11 add the
support for young page filtering, active:inactive memory ratio based quota
auto-tuning, and monitoring intervals auto-tuning, with appropriate
document updates.


This patch (of 11):

DAMOS_LRU_[DE]PRIO are DAMOS actions for making balance of active and
inactive memory size.  There is no appropriate DAMOS quota auto-tuning
target metric for the use case.  Add two new DAMOS quota goal metrics for
the purpose, namely DAMOS_QUOTA_[IN]ACTIVE_MEM_BP.  Those will represent
the ratio of [in]active memory to total (inactive + active) memory. 
Hence, users will be able to ask DAMON to, for example, "find hot and cold
memory, and move pages of those to active and inactive LRU lists,
adjusting the hot/cold thresholds aiming 50:50 active:inactive memory
ratio."

Link: https://lkml.kernel.org/r/20260113152717.70459-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260113152717.70459-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++++
 mm/damon/core.c       |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric
+++ a/include/linux/damon.h
@@ -155,6 +155,8 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
+ * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -166,6 +168,8 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+	DAMOS_QUOTA_ACTIVE_MEM_BP,
+	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
--- a/mm/damon/core.c~mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric
+++ a/mm/damon/core.c
@@ -2132,6 +2132,23 @@ static unsigned long damos_get_node_memc
 }
 #endif
 
+/*
+ * Returns LRU-active or inactive memory to total LRU memory size ratio.
+ */
+static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
+{
+	unsigned long active, inactive, total;
+
+	/* This should align with /proc/meminfo output */
+	active = global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_ANON) +
+		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
+	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
+		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
+	total = active + inactive;
+	if (active_ratio)
+		return active * 10000 / total;
+	return inactive * 10000 / total;
+}
 
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 {
@@ -2154,6 +2171,11 @@ static void damos_set_quota_goal_current
 	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
+	case DAMOS_QUOTA_ACTIVE_MEM_BP:
+	case DAMOS_QUOTA_INACTIVE_MEM_BP:
+		goal->current_value = damos_get_in_active_mem_bp(
+				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

