From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-prevent-memorylow-load-store-tearing.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:57 -0700
Message-ID: <20200403203757.nEDWQL3sh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgDCUh6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent memory.low load/store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memorylow-load-store-tearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent memory.low load/store tearing

This can be set concurrently with reads, which may cause the wrong value
to be propagated.

Link: http://lkml.kernel.org/r/448206f44b0fa7be9dad2ca2601d2bcb2c0b7844.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page_counter.c~mm-memcg-prevent-memorylow-load-store-tearing
+++ a/mm/page_counter.c
@@ -17,6 +17,7 @@ static void propagate_protected_usage(st
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
+	unsigned long low;
 	long delta;
 
 	if (!c->parent)
@@ -30,8 +31,9 @@ static void propagate_protected_usage(st
 			atomic_long_add(delta, &c->parent->children_min_usage);
 	}
 
-	if (c->low || atomic_long_read(&c->low_usage)) {
-		protected = min(usage, c->low);
+	low = READ_ONCE(c->low);
+	if (low || atomic_long_read(&c->low_usage)) {
+		protected = min(usage, low);
 		old_protected = atomic_long_xchg(&c->low_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
@@ -222,7 +224,7 @@ void page_counter_set_low(struct page_co
 {
 	struct page_counter *c;
 
-	counter->low = nr_pages;
+	WRITE_ONCE(counter->low, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch
