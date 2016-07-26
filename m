From: akpm@linux-foundation.org
Subject: [patch 071/126] mm: memcontrol: teach uncharge_list to deal with
 kmem pages
Date: Tue, 26 Jul 2016 15:24:27 -0700
Message-ID: <5797e31b.Z42lfq7yGJqWcm+d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbcGZWY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: teach uncharge_list to deal with kmem pages

Page table pages are batched-freed in release_pages on most
architectures. If we want to charge them to kmemcg (this is what is done
later in this series), we need to teach mem_cgroup_uncharge_list to
handle kmem pages.

Link: http://lkml.kernel.org/r/18d5c09e97f80074ed25b97a7d0f32b95d875717.1464079538.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages
+++ a/mm/memcontrol.c
@@ -5505,15 +5505,18 @@ void mem_cgroup_cancel_charge(struct pag
 
 static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_anon, unsigned long nr_file,
-			   unsigned long nr_huge, struct page *dummy_page)
+			   unsigned long nr_huge, unsigned long nr_kmem,
+			   struct page *dummy_page)
 {
-	unsigned long nr_pages = nr_anon + nr_file;
+	unsigned long nr_pages = nr_anon + nr_file + nr_kmem;
 	unsigned long flags;
 
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_uncharge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_uncharge(&memcg->memsw, nr_pages);
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && nr_kmem)
+			page_counter_uncharge(&memcg->kmem, nr_kmem);
 		memcg_oom_recover(memcg);
 	}
 
@@ -5536,6 +5539,7 @@ static void uncharge_list(struct list_he
 	unsigned long nr_anon = 0;
 	unsigned long nr_file = 0;
 	unsigned long nr_huge = 0;
+	unsigned long nr_kmem = 0;
 	unsigned long pgpgout = 0;
 	struct list_head *next;
 	struct page *page;
@@ -5546,8 +5550,6 @@ static void uncharge_list(struct list_he
 	 */
 	next = page_list->next;
 	do {
-		unsigned int nr_pages = 1;
-
 		page = list_entry(next, struct page, lru);
 		next = page->lru.next;
 
@@ -5566,31 +5568,35 @@ static void uncharge_list(struct list_he
 		if (memcg != page->mem_cgroup) {
 			if (memcg) {
 				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-					       nr_huge, page);
-				pgpgout = nr_anon = nr_file = nr_huge = 0;
+					       nr_huge, nr_kmem, page);
+				pgpgout = nr_anon = nr_file =
+					nr_huge = nr_kmem = 0;
 			}
 			memcg = page->mem_cgroup;
 		}
 
-		if (PageTransHuge(page)) {
-			nr_pages <<= compound_order(page);
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-			nr_huge += nr_pages;
-		}
+		if (!PageKmemcg(page)) {
+			unsigned int nr_pages = 1;
 
-		if (PageAnon(page))
-			nr_anon += nr_pages;
-		else
-			nr_file += nr_pages;
+			if (PageTransHuge(page)) {
+				nr_pages <<= compound_order(page);
+				VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+				nr_huge += nr_pages;
+			}
+			if (PageAnon(page))
+				nr_anon += nr_pages;
+			else
+				nr_file += nr_pages;
+			pgpgout++;
+		} else
+			nr_kmem += 1 << compound_order(page);
 
 		page->mem_cgroup = NULL;
