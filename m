From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 081/128] mm/memcg: move cgroup high memory limit
 setting into struct page_counter
Date: Mon, 01 Jun 2020 21:49:49 -0700
Message-ID: <20200602044949.1EocTf-zn%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEtu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:50 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, hannes@cmpxchg.org, hughd@google.com, kuba@kernel.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org, torvalds@linux-foundation.org

From: Jakub Kicinski <kuba@kernel.org>
Subject: mm/memcg: move cgroup high memory limit setting into struct page_counter

High memory limit is currently recorded directly in struct mem_cgroup.  We
are about to add a high limit for swap, move the field to struct
page_counter and add some helpers.

Link: http://lkml.kernel.org/r/20200527195846.102707-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h   |    3 ---
 include/linux/page_counter.h |    8 ++++++++
 mm/memcontrol.c              |   19 +++++++++++--------
 3 files changed, 19 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~mm-move-cgroup-high-memory-limit-setting-into-struct-page_counter
+++ a/include/linux/memcontrol.h
@@ -215,9 +215,6 @@ struct mem_cgroup {
 	struct page_counter kmem;
 	struct page_counter tcpmem;
 
-	/* Upper bound of normal memory consumption range */
-	unsigned long high;
-
 	/* Range enforcement for interrupt charges */
 	struct work_struct high_work;
 
--- a/include/linux/page_counter.h~mm-move-cgroup-high-memory-limit-setting-into-struct-page_counter
+++ a/include/linux/page_counter.h
@@ -10,6 +10,7 @@ struct page_counter {
 	atomic_long_t usage;
 	unsigned long min;
 	unsigned long low;
+	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
 
@@ -55,6 +56,13 @@ bool page_counter_try_charge(struct page
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
+
+static inline void page_counter_set_high(struct page_counter *counter,
+					 unsigned long nr_pages)
+{
+	WRITE_ONCE(counter->high, nr_pages);
+}
+
 int page_counter_set_max(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_memparse(const char *buf, const char *max,
 			  unsigned long *nr_pages);
--- a/mm/memcontrol.c~mm-move-cgroup-high-memory-limit-setting-into-struct-page_counter
+++ a/mm/memcontrol.c
@@ -2252,7 +2252,8 @@ static void reclaim_high(struct mem_cgro
 			 gfp_t gfp_mask)
 {
 	do {
-		if (page_counter_read(&memcg->memory) <= READ_ONCE(memcg->high))
+		if (page_counter_read(&memcg->memory) <=
+		    READ_ONCE(memcg->memory.high))
 			continue;
 		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
@@ -2345,7 +2346,7 @@ static u64 mem_find_max_overage(struct m
 
 	do {
 		overage = calculate_overage(page_counter_read(&memcg->memory),
-					    READ_ONCE(memcg->high));
+					    READ_ONCE(memcg->memory.high));
 		max_overage = max(overage, max_overage);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2604,7 +2605,8 @@ done_restock:
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		if (page_counter_read(&memcg->memory) > READ_ONCE(memcg->high)) {
+		if (page_counter_read(&memcg->memory) >
+		    READ_ONCE(memcg->memory.high)) {
 			/* Don't bother a random interrupted task */
 			if (in_interrupt()) {
 				schedule_work(&memcg->high_work);
@@ -4347,7 +4349,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 
 	while ((parent = parent_mem_cgroup(memcg))) {
 		unsigned long ceiling = min(READ_ONCE(memcg->memory.max),
-					    READ_ONCE(memcg->high));
+					    READ_ONCE(memcg->memory.high));
 		unsigned long used = page_counter_read(&memcg->memory);
 
 		*pheadroom = min(*pheadroom, ceiling - min(ceiling, used));
@@ -5072,7 +5074,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
 
-	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
@@ -5225,7 +5227,7 @@ static void mem_cgroup_css_reset(struct
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
-	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	memcg_wb_domain_size_changed(memcg);
 }
@@ -6024,7 +6026,8 @@ static ssize_t memory_low_write(struct k
 
 static int memory_high_show(struct seq_file *m, void *v)
 {
-	return seq_puts_memcg_tunable(m, READ_ONCE(mem_cgroup_from_seq(m)->high));
+	return seq_puts_memcg_tunable(m,
+		READ_ONCE(mem_cgroup_from_seq(m)->memory.high));
 }
 
 static ssize_t memory_high_write(struct kernfs_open_file *of,
@@ -6041,7 +6044,7 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
 
-	WRITE_ONCE(memcg->high, high);
+	page_counter_set_high(&memcg->memory, high);
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
_
