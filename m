From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:40:52 -0700
Message-ID: <20200403204052.IDErsCeIe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgDCUkx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dschatzberg@fb.com, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: make memory.oom.group tolerable to task migration
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: make memory.oom.group tolerable to task migration

If a task is getting moved out of the OOMing cgroup, it might result in
unexpected OOM killings if memory.oom.group is used anywhere in the cgroup
tree.

Imagine the following example:

          A (oom.group = 1)
         / \
  (OOM) B   C

Let's say B's memory.max is exceeded and it's OOMing.  The OOM killer
selects a task in B as a victim, but someone asynchronously moves the task
into C.  mem_cgroup_get_oom_group() will iterate over all ancestors of C
up to the root cgroup.  In theory it had to stop at the oom_domain level -
the memory cgroup which is OOMing.  But because B is not an ancestor of C,
it's not happening.  Instead it chooses A (because it's oom.group is set),
and kills all tasks in A.  This behavior is wrong because the OOM happened
in B, so there is no reason to kill anything outside.

Fix this by checking it the memory cgroup to which the task belongs is a
descendant of the oom_domain.  If not, memory.oom.group should be ignored,
and the OOM killer should kill only the victim task.

Link: http://lkml.kernel.org/r/20200316223510.3176148-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Dan Schatzberg <dschatzberg@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-make-memoryoomgroup-tolerable-to-task-migration
+++ a/mm/memcontrol.c
@@ -1931,6 +1931,14 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 		goto out;
 
 	/*
+	 * If the victim task has been asynchronously moved to a different
+	 * memory cgroup, we might end up killing tasks outside oom_domain.
+	 * In this case it's better to ignore memory.group.oom.
+	 */
+	if (unlikely(!mem_cgroup_is_descendant(memcg, oom_domain)))
+		goto out;
+
+	/*
 	 * Traverse the memory cgroup hierarchy from the victim task's
 	 * cgroup up to the OOMing cgroup (or root) to find the
 	 * highest-level memory cgroup with oom.group set.
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
