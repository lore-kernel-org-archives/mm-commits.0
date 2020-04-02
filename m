From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 076/155] mm, memcg: prevent memory.low load/store
 tearing
Date: Wed, 01 Apr 2020 21:07:24 -0700
Message-ID: <20200402040724.6Xz5_-c5d%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBEHZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:25 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

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
