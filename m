From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memoryhigh-load-store-tearing.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 15:44:59 -0700
Message-ID: <20200312224459.TU-ARYwHi%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgCLWpB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:45:01 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent memory.high load/store tearing
has been added to the -mm tree.  Its filename is
     mm-memcg-prevent-memoryhigh-load-store-tearing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-prevent-memoryhigh-load-store-tearing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-prevent-memoryhigh-load-store-tearing.patch

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
Subject: mm, memcg: prevent memory.high load/store tearing

A mem_cgroup's high attribute can be concurrently set at the same time as
we are trying to read it -- for example, if we are in memory_high_write at
the same time as we are trying to do high reclaim.

Link: http://lkml.kernel.org/r/2f66f7038ed1d4688e59de72b627ae0ea52efa83.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memoryhigh-load-store-tearing
+++ a/mm/memcontrol.c
@@ -2242,7 +2242,7 @@ static void reclaim_high(struct mem_cgro
 			 gfp_t gfp_mask)
 {
 	do {
-		if (page_counter_read(&memcg->memory) <= memcg->high)
+		if (page_counter_read(&memcg->memory) <= READ_ONCE(memcg->high))
 			continue;
 		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
@@ -2582,7 +2582,7 @@ done_restock:
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		if (page_counter_read(&memcg->memory) > memcg->high) {
+		if (page_counter_read(&memcg->memory) > READ_ONCE(memcg->high)) {
 			/* Don't bother a random interrupted task */
 			if (in_interrupt()) {
 				schedule_work(&memcg->high_work);
@@ -4326,7 +4326,8 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	*pheadroom = PAGE_COUNTER_MAX;
 
 	while ((parent = parent_mem_cgroup(memcg))) {
-		unsigned long ceiling = min(memcg->memory.max, memcg->high);
+		unsigned long ceiling = min(memcg->memory.max,
+					    READ_ONCE(memcg->high));
 		unsigned long used = page_counter_read(&memcg->memory);
 
 		*pheadroom = min(*pheadroom, ceiling - min(ceiling, used));
@@ -5048,7 +5049,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (!memcg)
 		return ERR_PTR(error);
 
-	memcg->high = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
@@ -5201,7 +5202,7 @@ static void mem_cgroup_css_reset(struct
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
-	memcg->high = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	memcg_wb_domain_size_changed(memcg);
 }
@@ -6017,7 +6018,7 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
 
-	memcg->high = high;
+	WRITE_ONCE(memcg->high, high);
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
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
