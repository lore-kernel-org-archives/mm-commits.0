From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 080/155] mm: memcg: make memory.oom.group
 tolerable to task migration
Date: Wed, 01 Apr 2020 21:07:39 -0700
Message-ID: <20200402040739.PB5HXuW7o%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBEHk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:40 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dschatzberg@fb.com, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
