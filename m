From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch added to -mm
 tree
Date: Wed, 18 Mar 2020 14:12:39 -0700
Message-ID: <20200318211239.QNgTEA6Qo%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgCRVMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 17:12:41 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dschatzberg@fb.com, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: make memory.oom.group tolerable to task migration
has been added to the -mm tree.  Its filename is
     mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch
