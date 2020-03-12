From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memorymin-load-store-tearing.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 15:45:07 -0700
Message-ID: <20200312224507.B0lRp_qOe%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLWpK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:45:10 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent memory.min load/store tearing
has been added to the -mm tree.  Its filename is
     mm-memcg-prevent-memorymin-load-store-tearing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-prevent-memorymin-load-store-tearing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-prevent-memorymin-load-store-tearing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent memory.min load/store tearing

This can be set concurrently with reads, which may cause the wrong value
to be propagated.

Link: http://lkml.kernel.org/r/e809b4e6b0c1626dac6945970de06409a180ee65.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c   |    5 +++--
 mm/page_counter.c |    9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memorymin-load-store-tearing
+++ a/mm/memcontrol.c
@@ -6390,7 +6390,7 @@ enum mem_cgroup_protection mem_cgroup_pr
 		return MEMCG_PROT_NONE;
 
 	if (parent == root) {
-		memcg->memory.emin = memcg->memory.min;
+		memcg->memory.emin = READ_ONCE(memcg->memory.min);
 		memcg->memory.elow = memcg->memory.low;
 		goto out;
 	}
@@ -6398,7 +6398,8 @@ enum mem_cgroup_protection mem_cgroup_pr
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

mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
mm-memcg-throttle-allocators-based-on-ancestral-memoryhigh.patch
mm-memcg-prevent-memoryhigh-load-store-tearing.patch
mm-memcg-prevent-memorymax-load-tearing.patch
mm-memcg-prevent-memorylow-load-store-tearing.patch
mm-memcg-prevent-memorymin-load-store-tearing.patch
mm-memcg-prevent-memoryswapmax-load-tearing.patch
mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch
