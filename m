From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 091/131] mm: memcontrol: prepare cgroup vmstat
 infrastructure for native anon counters
Date: Wed, 03 Jun 2020 16:01:51 -0700
Message-ID: <20200603230151.3eLAz1hqe%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: prepare cgroup vmstat infrastructure for native anon counters

Anonymous compound pages can be mapped by ptes, which means that if we
want to track NR_MAPPED_ANON, NR_ANON_THPS on a per-cgroup basis, we have
to be prepared to see tail pages in our accounting functions.

Make mod_lruvec_page_state() and lock_page_memcg() deal with tail pages
correctly, namely by redirecting to the head page which has the
page->mem_cgroup set up.

Link: http://lkml.kernel.org/r/20200508183105.225460-9-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |    9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters
+++ a/include/linux/memcontrol.h
@@ -709,16 +709,17 @@ static inline void mod_lruvec_state(stru
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
+	struct page *head = compound_head(page); /* rmap on tail pages */
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!page->mem_cgroup) {
+	if (!head->mem_cgroup) {
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
-	lruvec = mem_cgroup_lruvec(page->mem_cgroup, pgdat);
+	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
 }
 
--- a/mm/memcontrol.c~mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters
+++ a/mm/memcontrol.c
@@ -1981,6 +1981,7 @@ void mem_cgroup_print_oom_group(struct m
  */
 struct mem_cgroup *lock_page_memcg(struct page *page)
 {
+	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
 	unsigned long flags;
 
@@ -2000,7 +2001,7 @@ struct mem_cgroup *lock_page_memcg(struc
 	if (mem_cgroup_disabled())
 		return NULL;
 again:
-	memcg = page->mem_cgroup;
+	memcg = head->mem_cgroup;
 	if (unlikely(!memcg))
 		return NULL;
 
@@ -2008,7 +2009,7 @@ again:
 		return memcg;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
-	if (memcg != page->mem_cgroup) {
+	if (memcg != head->mem_cgroup) {
 		spin_unlock_irqrestore(&memcg->move_lock, flags);
 		goto again;
 	}
@@ -2051,7 +2052,9 @@ void __unlock_page_memcg(struct mem_cgro
  */
 void unlock_page_memcg(struct page *page)
 {
-	__unlock_page_memcg(page->mem_cgroup);
+	struct page *head = compound_head(page);
+
+	__unlock_page_memcg(head->mem_cgroup);
 }
 EXPORT_SYMBOL(unlock_page_memcg);
 
_
