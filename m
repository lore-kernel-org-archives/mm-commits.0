From: akpm@linux-foundation.org
Subject: + mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch added to -mm tree
Date: Thu, 02 Jun 2016 16:09:11 -0700
Message-ID: <5750bc97.lj9yhN45X5k9lxyy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbcFBXJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: teach uncharge_list to deal with kmem pages
has been added to the -mm tree.  Its filename is
     mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -5441,15 +5441,18 @@ void mem_cgroup_cancel_charge(struct pag
 
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
 
@@ -5472,6 +5475,7 @@ static void uncharge_list(struct list_he
 	unsigned long nr_anon = 0;
 	unsigned long nr_file = 0;
 	unsigned long nr_huge = 0;
+	unsigned long nr_kmem = 0;
 	unsigned long pgpgout = 0;
 	struct list_head *next;
 	struct page *page;
@@ -5482,8 +5486,6 @@ static void uncharge_list(struct list_he
 	 */
 	next = page_list->next;
 	do {
-		unsigned int nr_pages = 1;
-
 		page = list_entry(next, struct page, lru);
 		next = page->lru.next;
 
@@ -5502,31 +5504,35 @@ static void uncharge_list(struct list_he
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
-
-		pgpgout++;
 	} while (next != page_list);
 
 	if (memcg)
 		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-			       nr_huge, page);
+			       nr_huge, nr_kmem, page);
 }
 
 /**
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-zap-zone_oom_locked.patch
mm-oom-add-memcg-to-oom_control.patch
mm-remove-pointless-struct-in-struct-page-definition.patch
mm-clean-up-non-standard-page-_mapcount-users.patch
mm-memcontrol-cleanup-kmem-charge-functions.patch
mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch
mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch
arch-x86-charge-page-tables-to-kmemcg.patch
pipe-account-to-kmemcg.patch
af_unix-charge-buffers-to-kmemcg.patch

