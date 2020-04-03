From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:38:04 -0700
Message-ID: <20200403203804.jM8gQJb-z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUiF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent mem_cgroup_protected store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent mem_cgroup_protected store tearing

The read side of this is all protected, but we can still tear if multiple
iterations of mem_cgroup_protected are going at the same time.

There's some intentional racing in mem_cgroup_protected which is ok, but
load/store tearing should be avoided.

Link: http://lkml.kernel.org/r/d1e9fbc0379fe8db475d82c8b6fbe048876e12ae.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-mem_cgroup_protected-store-tearing
+++ a/mm/memcontrol.c
@@ -6396,14 +6396,14 @@ enum mem_cgroup_protection mem_cgroup_pr
 
 	parent_usage = page_counter_read(&parent->memory);
 
-	memcg->memory.emin = effective_protection(usage, parent_usage,
+	WRITE_ONCE(memcg->memory.emin, effective_protection(usage, parent_usage,
 			READ_ONCE(memcg->memory.min),
 			READ_ONCE(parent->memory.emin),
-			atomic_long_read(&parent->memory.children_min_usage));
+			atomic_long_read(&parent->memory.children_min_usage)));
 
-	memcg->memory.elow = effective_protection(usage, parent_usage,
+	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
 			memcg->memory.low, READ_ONCE(parent->memory.elow),
-			atomic_long_read(&parent->memory.children_low_usage));
+			atomic_long_read(&parent->memory.children_low_usage)));
 
 out:
 	if (usage <= memcg->memory.emin)
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
