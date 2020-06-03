From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 089/131] mm: memcontrol: prepare uncharging for
 removal of private page type counters
Date: Wed, 03 Jun 2020 16:01:44 -0700
Message-ID: <20200603230144.mZU75P9Fi%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgFCXIn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:43 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: prepare uncharging for removal of private page type counters

The uncharge batching code adds up the anon, file, kmem counts to
determine the total number of pages to uncharge and references to drop. 
But the next patches will remove the anon and file counters.

Maintain an aggregate nr_pages in the uncharge_gather struct.

Link: http://lkml.kernel.org/r/20200508183105.225460-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters
+++ a/mm/memcontrol.c
@@ -6666,6 +6666,7 @@ int mem_cgroup_charge(struct page *page,
 
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
+	unsigned long nr_pages;
 	unsigned long pgpgout;
 	unsigned long nr_anon;
 	unsigned long nr_file;
@@ -6682,13 +6683,12 @@ static inline void uncharge_gather_clear
 
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
-	unsigned long nr_pages = ug->nr_anon + ug->nr_file + ug->nr_kmem;
 	unsigned long flags;
 
 	if (!mem_cgroup_is_root(ug->memcg)) {
-		page_counter_uncharge(&ug->memcg->memory, nr_pages);
+		page_counter_uncharge(&ug->memcg->memory, ug->nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&ug->memcg->memsw, nr_pages);
+			page_counter_uncharge(&ug->memcg->memsw, ug->nr_pages);
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
 			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
@@ -6700,16 +6700,18 @@ static void uncharge_batch(const struct
 	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
 	__mod_memcg_state(ug->memcg, NR_SHMEM, -ug->nr_shmem);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, nr_pages);
+	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
 	if (!mem_cgroup_is_root(ug->memcg))
-		css_put_many(&ug->memcg->css, nr_pages);
+		css_put_many(&ug->memcg->css, ug->nr_pages);
 }
 
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
+	unsigned long nr_pages;
+
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
 	if (!page->mem_cgroup)
@@ -6729,13 +6731,12 @@ static void uncharge_page(struct page *p
 		ug->memcg = page->mem_cgroup;
 	}
 
-	if (!PageKmemcg(page)) {
-		unsigned int nr_pages = 1;
+	nr_pages = compound_nr(page);
+	ug->nr_pages += nr_pages;
 
-		if (PageTransHuge(page)) {
-			nr_pages = compound_nr(page);
+	if (!PageKmemcg(page)) {
+		if (PageTransHuge(page))
 			ug->nr_huge += nr_pages;
-		}
 		if (PageAnon(page))
 			ug->nr_anon += nr_pages;
 		else {
@@ -6745,7 +6746,7 @@ static void uncharge_page(struct page *p
 		}
 		ug->pgpgout++;
 	} else {
-		ug->nr_kmem += compound_nr(page);
+		ug->nr_kmem += nr_pages;
 		__ClearPageKmemcg(page);
 	}
 
_
