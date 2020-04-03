From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-prevent-memorymin-load-store-tearing.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:00 -0700
Message-ID: <20200403203800._zYveVaPB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgDCUiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent memory.min load/store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memorymin-load-store-tearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent memory.min load/store tearing

This can be set concurrently with reads, which may cause the wrong value
to be propagated.

Link: http://lkml.kernel.org/r/e809b4e6b0c1626dac6945970de06409a180ee65.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c   |    5 +++--
 mm/page_counter.c |    9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memorymin-load-store-tearing
+++ a/mm/memcontrol.c
@@ -6389,7 +6389,7 @@ enum mem_cgroup_protection mem_cgroup_pr
 		return MEMCG_PROT_NONE;
 
 	if (parent == root) {
-		memcg->memory.emin = memcg->memory.min;
+		memcg->memory.emin = READ_ONCE(memcg->memory.min);
 		memcg->memory.elow = memcg->memory.low;
 		goto out;
 	}
@@ -6397,7 +6397,8 @@ enum mem_cgroup_protection mem_cgroup_pr
 	parent_usage = page_counter_read(&parent->memory);
 
 	memcg->memory.emin = effective_protection(usage, parent_usage,
-			memcg->memory.min, READ_ONCE(parent->memory.emin),
+			READ_ONCE(memcg->memory.min),
+			READ_ONCE(parent->memory.emin),
 			atomic_long_read(&parent->memory.children_min_usage));
 
 	memcg->memory.elow = effective_protection(usage, parent_usage,
--- a/mm/page_counter.c~mm-memcg-prevent-memorymin-load-store-tearing
+++ a/mm/page_counter.c
@@ -17,14 +17,15 @@ static void propagate_protected_usage(st
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
-	unsigned long low;
+	unsigned long low, min;
 	long delta;
 
 	if (!c->parent)
 		return;
 
-	if (c->min || atomic_long_read(&c->min_usage)) {
-		protected = min(usage, c->min);
+	min = READ_ONCE(c->min);
+	if (min || atomic_long_read(&c->min_usage)) {
+		protected = min(usage, min);
 		old_protected = atomic_long_xchg(&c->min_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
@@ -207,7 +208,7 @@ void page_counter_set_min(struct page_co
 {
 	struct page_counter *c;
 
-	counter->min = nr_pages;
+	WRITE_ONCE(counter->min, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
