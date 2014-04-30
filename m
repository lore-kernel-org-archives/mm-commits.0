From: akpm@linux-foundation.org
Subject: + memcg-mm-introduce-lowlimit-reclaim.patch added to -mm tree
Date: Wed, 30 Apr 2014 14:56:41 -0700
Message-ID: <53617199.swI6rT2vyUorvKEP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaD3V4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 17:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + memcg-mm-introduce-lowlimit-reclaim.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 14:56:41 -0700


The patch titled
     Subject: memcg, mm: introduce lowlimit reclaim
has been added to the -mm tree.  Its filename is
     memcg-mm-introduce-lowlimit-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-mm-introduce-lowlimit-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-mm-introduce-lowlimit-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, mm: introduce lowlimit reclaim

Previous discussions have shown that soft limits cannot be reformed
(http://lwn.net/Articles/555249/).  This series introduces an alternative
approach for protecting memory allocated to processes executing within a
memory cgroup controller.  It is based on a new tunable that was discussed
with Johannes and Tejun held during the kernel summit 2013 and at LSF
2014.

This patchset introduces such low limit that is functionally similar to a
minimum guarantee.  Memcgs which are under their lowlimit are not
considered eligible for the reclaim (both global and hardlimit) unless all
groups under the reclaimed hierarchy are below the low limit when all of
them are considered eligible.

The previous version of the patchset posted as a RFC
(http://marc.info/?l=linux-mm&m=138677140628677&w=2) suggested a hard
guarantee without any fallback.  More discussions led me to reconsidering
the default behavior and come up a more relaxed one.  The hard requirement
can be added later based on a use case which really requires.  It would be
controlled by memory.reclaim_flags knob which would specify whether to OOM
or fallback (default) when all groups are bellow low limit.

The default value of the limit is 0 so all groups are eligible by default
and an interested party has to explicitly set the limit.

The primary use case is to protect an amount of memory allocated to a
workload without it being reclaimed by an unrelated activity.  In some
cases this requirement can be fulfilled by mlock but it is not suitable
for many loads and generally requires application awareness.  Such
application awareness can be complex.  It effectively forbids the use of
memory overcommit as the application must explicitly manage memory
residency.

With the low limit, such workloads can be placed in a memcg with a low
limit that protects the estimated working set.

The hierarchical behavior of the lowlimit is described in the first patch.
 The second patch allows setting the lowlimit.  The last 2 patches clarify
documentation about the memcg reclaim in gereneral (3rd patch) and low
limit (4th patch).


This patch (of 4)

This patch introduces low limit reclaim.  The low_limit acts as a reclaim
protection because groups which are under their low_limit are considered
ineligible for reclaim.  While hardlimit protects from using more memory
than allowed lowlimit protects from getting below memory assigned to the
group due to external memory pressure.

More precisely a group is considered eligible for the reclaim under a
specific hierarchy represented by its root only if the group is above its
low limit and the same applies to all parents up the hierarchy to the
root.  Nevertheless the limit still might be ignored if all groups under
the reclaimed hierarchy are under their low limits.  This will prevent
from OOM rather than protecting the memory.

Consider the following hierarchy with memory pressure coming from the
group A (hard limit reclaim - l-low_limit_in_bytes, u-usage_in_bytes,
h-limit_in_bytes):

		root_mem_cgroup
			.
		  _____/
		 /
		A (l = 80 u=90 h=90)
	       /
	      / \_________
	     /            \
	    B (l=0 u=50)   C (l=50 u=40)
	                    \
			     D (l=0 u=30)

A and B are reclaimable but C and D are not (D is protected by C).

The low_limit is 0 by default so every group is eligible.  This patch
doesn't provide a way to set the limit yet although the core
infrastructure is there already.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h  |    9 +++++++++
 include/linux/res_counter.h |   27 +++++++++++++++++++++++++++
 mm/memcontrol.c             |   23 +++++++++++++++++++++++
 mm/vmscan.c                 |   34 +++++++++++++++++++++++++++++++++-
 4 files changed, 92 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-mm-introduce-lowlimit-reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-mm-introduce-lowlimit-reclaim
+++ a/include/linux/memcontrol.h
@@ -92,6 +92,9 @@ bool __mem_cgroup_same_or_subtree(const
 bool task_in_mem_cgroup(struct task_struct *task,
 			const struct mem_cgroup *memcg);
 
+extern bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
+		struct mem_cgroup *root);
+
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
@@ -288,6 +291,12 @@ static inline struct lruvec *mem_cgroup_
 	return &zone->lruvec;
 }
 
+static inline bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
+		struct mem_cgroup *root)
+{
+	return true;
+}
+
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	return NULL;
diff -puN include/linux/res_counter.h~memcg-mm-introduce-lowlimit-reclaim include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-mm-introduce-lowlimit-reclaim
+++ a/include/linux/res_counter.h
@@ -40,6 +40,11 @@ struct res_counter {
 	 */
 	unsigned long long soft_limit;
 	/*
+	 * the limit under which the usage cannot be pushed
+	 * due to external pressure.
+	 */
+	unsigned long long low_limit;
+	/*
 	 * the number of unsuccessful attempts to consume the resource
 	 */
 	unsigned long long failcnt;
@@ -174,6 +179,28 @@ res_counter_soft_limit_excess(struct res
 	spin_unlock_irqrestore(&cnt->lock, flags);
 	return excess;
 }
+
+/**
+ * Get the difference between the usage and the low limit
+ * @cnt: The counter
+ *
+ * Returns 0 if usage is less than or equal to low limit
+ * The difference between usage and low limit, otherwise.
+ */
+static inline unsigned long long
+res_counter_low_limit_excess(struct res_counter *cnt)
+{
+	unsigned long long excess;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	if (cnt->usage <= cnt->low_limit)
+		excess = 0;
+	else
+		excess = cnt->usage - cnt->low_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return excess;
+}
 
 static inline void res_counter_reset_max(struct res_counter *cnt)
 {
diff -puN mm/memcontrol.c~memcg-mm-introduce-lowlimit-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mm-introduce-lowlimit-reclaim
+++ a/mm/memcontrol.c
@@ -2808,6 +2808,29 @@ static struct mem_cgroup *mem_cgroup_loo
 	return mem_cgroup_from_id(id);
 }
 
+/**
+ * mem_cgroup_reclaim_eligible - checks whether given memcg is eligible for the
+ * reclaim
+ * @memcg: target memcg for the reclaim
+ * @root: root of the reclaim hierarchy (null for the global reclaim)
+ *
+ * The given group is reclaimable if it is above its low limit and the same
+ * applies for all parents up the hierarchy until root (including).
+ */
+bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
+		struct mem_cgroup *root)
+{
+	do {
+		if (!res_counter_low_limit_excess(&memcg->res))
+			return false;
+		if (memcg == root)
+			break;
+
+	} while ((memcg = parent_mem_cgroup(memcg)));
+
+	return true;
+}
+
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg = NULL;
diff -puN mm/vmscan.c~memcg-mm-introduce-lowlimit-reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-mm-introduce-lowlimit-reclaim
+++ a/mm/vmscan.c
@@ -2233,9 +2233,11 @@ static inline bool should_continue_recla
 	}
 }
 
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
+static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
+		bool follow_low_limit)
 {
 	unsigned long nr_reclaimed, nr_scanned;
+	unsigned nr_scanned_groups = 0;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2252,7 +2254,23 @@ static void shrink_zone(struct zone *zon
 		do {
 			struct lruvec *lruvec;
 
+			/*
+			 * Memcg might be under its low limit so we have to
+			 * skip it during the first reclaim round
+			 */
+			if (follow_low_limit &&
+					!mem_cgroup_reclaim_eligible(memcg, root)) {
+				/*
+				 * It would be more optimal to skip the memcg
+				 * subtree now but we do not have a memcg iter
+				 * helper for that. Anyone?
+				 */
+				memcg = mem_cgroup_iter(root, memcg, &reclaim);
+				continue;
+			}
+
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+			nr_scanned_groups++;
 
 			shrink_lruvec(lruvec, sc);
 
@@ -2280,6 +2298,20 @@ static void shrink_zone(struct zone *zon
 
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
+
+	return nr_scanned_groups;
+}
+
+static void shrink_zone(struct zone *zone, struct scan_control *sc)
+{
+	if (!__shrink_zone(zone, sc, true)) {
+		/*
+		 * First round of reclaim didn't find anything to reclaim
+		 * because of low limit protection so try again and ignore
+		 * the low limit this time.
+		 */
+		__shrink_zone(zone, sc, false);
+	}
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
_

Patches currently in -mm which might be from mhocko@suse.cz are

slub-fix-memcg_propagate_slab_attrs.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-document-memorylow_limit_in_bytes.patch

