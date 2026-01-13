Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E75C3203A5
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343877; cv=none; b=ayYayDjanx1M/mvtl7QeVGyvceoOlky7B/fGAABlAmJxsXjiz0kBDy1YpNY/w1LXySj0g8mvOy2I0+xlOK1L9qFoh3OV3da5ExsIrXP+pi4oKPb4ShwdWtCrWfKh6N6fZ2KzR7k+IL2O/NPCuUcKVS17uG74G84NeNAPUWFXPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343877; c=relaxed/simple;
	bh=Vvjt/bdalkLRYgPcifY+qw3LXpc6JRJle7VR5z9vWx8=;
	h=Date:To:From:Subject:Message-Id; b=Mx1vzUTh8pdx29IUi7lUEbaP5zE4WDAhQyPFWEzCN82kOFF2tIQzIhQDHr9yvTwvZdjq1hcBZB1OZbH+TxQkC4xa/bDIyHtc28C/oYMb62v1ZtLaI0XHQI1WqudPuyZNYVE+kwquZIlsWHDAvdKeKjLIDPV+lip8WLqHB3iJhZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCaCJu3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCaCJu3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F021AC116C6;
	Tue, 13 Jan 2026 22:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343877;
	bh=Vvjt/bdalkLRYgPcifY+qw3LXpc6JRJle7VR5z9vWx8=;
	h=Date:To:From:Subject:From;
	b=WCaCJu3yFHJmsW1HZG6qj+RWcSg4PpzS1O0jL/1g54ZJy8hoJMZDQkp5+8wn05e5L
	 gkM3ynR9Ir9m6aVI+HnalwEfKCsXPF/uTH4BbbtX98immYeIL4Ozjw47PRm31OX3w+
	 wNs8H2MwSgxHzD+Hr1mydDjzmahUTlRUCwnhh6QQ=
Date: Tue, 13 Jan 2026 14:37:56 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch added to mm-new branch
Message-Id: <20260113223756.F021AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce [in]active memory ratio damos quota goal metric
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch

