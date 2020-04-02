From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 079/155] mm, memcg: prevent mem_cgroup_protected
 store tearing
Date: Wed, 01 Apr 2020 21:07:33 -0700
Message-ID: <20200402040733.lxojstLMj%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBEHj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:39 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

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
