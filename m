From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:23 -0700
Message-ID: <5390c9c3.G70a8TrEUUAn4HNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaFETtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:23 -0700


The patch titled
     Subject: mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control

Per-memcg swappiness and oom killing can currently not be tweaked on a
memcg that is part of a hierarchy, but not the root of that hierarchy. 
Users have complained that they can't configure this when they turned on
hierarchy mode.  In fact, with hierarchy mode becoming the default, this
restriction disables the tunables entirely.

But there is no good reason for this restriction.  The settings for
swappiness and OOM killing are taken from whatever memcg whose limit
triggered reclaim and OOM invocation, regardless of its position in the
hierarchy tree.

Allow setting swappiness on any group.  The knob on the root memcg already
reads the global VM swappiness, make it writable as well.

Allow disabling the OOM killer on any non-root memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   11 ++++-------
 mm/memcontrol.c                  |   29 +++++++----------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff -puN Documentation/cgroups/memory.txt~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control
+++ a/Documentation/cgroups/memory.txt
@@ -535,17 +535,15 @@ Note:
 
 5.3 swappiness
 
-Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Similar to /proc/sys/vm/swappiness, but only affecting reclaim that is
+triggered by this cgroup's hard limit.  The tunable in the root cgroup
+corresponds to the global swappiness setting.
+
 Please note that unlike the global swappiness, memcg knob set to 0
 really prevents from any swapping even if there is a swap storage
 available. This might lead to memcg OOM killer if there are no file
 pages to reclaim.
 
-Following cgroups' swappiness can't be changed.
-- root cgroup (uses /proc/sys/vm/swappiness).
-- a cgroup which uses hierarchy and it has other cgroup(s) below it.
-- a cgroup which uses hierarchy and not the root of hierarchy.
-
 5.4 failcnt
 
 A memory cgroup provides memory.failcnt and memory.memsw.failcnt files.
@@ -754,7 +752,6 @@ You can disable the OOM-killer by writin
 
 	#echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
diff -puN mm/memcontrol.c~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control
+++ a/mm/memcontrol.c
@@ -5444,22 +5444,14 @@ static int mem_cgroup_swappiness_write(s
 				       struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
-	if (val > 100 || !parent)
+	if (val > 100)
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-
-	/* If under hierarchy, only empty-root can set this value */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
-
-	memcg->swappiness = val;
-
-	mutex_unlock(&memcg_create_mutex);
+	if (css_parent(css))
+		memcg->swappiness = val;
+	else
+		vm_swappiness = val;
 
 	return 0;
 }
@@ -5791,22 +5783,15 @@ static int mem_cgroup_oom_control_write(
 	struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!parent || !((val == 0) || (val == 1)))
+	if (!css_parent(css) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
 	memcg->oom_kill_disable = val;
 	if (!val)
 		memcg_oom_recover(memcg);
-	mutex_unlock(&memcg_create_mutex);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
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
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

