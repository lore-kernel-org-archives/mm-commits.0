From: akpm@linux-foundation.org
Subject: +
 mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 11:38:56 -0700
Message-ID: <20200616183856.Z2poT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgFPSi6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 14:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@surriel.com, minchan.kim@gmail.com, mhocko@suse.com, js1304@gmail.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: workingset: age nonresident information alongside anonymous pages
has been added to the -mm tree.  Its filename is
     mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: age nonresident information alongside anonymous pages

Patch series "fix for "mm: balance LRU lists based on relative thrashing" patchset"

This patchset fixes some problems of the patchset, "mm: balance LRU lists
based on relative thrashing", which is now merged on the mainline.

Patch "mm: workingset: let cache workingset challenge anon fix" is the
result of discussion with Johannes.  See following link.

http://lkml.kernel.org/r/20200520232525.798933-6-hannes@cmpxchg.org

And, the other two are minor things which are found when I try to rebase
my patchset.


This patch (of 3):
After ("mm: workingset: let cache workingset challenge anon fix"), we
compare refault distances to active_file + anon.  But age of the
non-resident information is only driven by the file LRU.  As a result, we
may overestimate the recency of any incoming refaults and activate them
too eagerly, causing unnecessary LRU churn in certain situations.

Make anon aging drive nonresident age as well to address that.

Link: http://lkml.kernel.org/r/1592288204-27734-1-git-send-email-iamjoonsoo.kim@lge.com
Link: http://lkml.kernel.org/r/1592288204-27734-2-git-send-email-iamjoonsoo.kim@lge.com
Fixes: 34e58cac6d8f2a ("mm: workingset: let cache workingset challenge anon")
Reported-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +--
 include/linux/swap.h   |    1 
 mm/vmscan.c            |    3 ++
 mm/workingset.c        |   46 ++++++++++++++++++++++-----------------
 4 files changed, 33 insertions(+), 21 deletions(-)

--- a/include/linux/mmzone.h~mm-workingset-age-nonresident-information-alongside-anonymous-pages
+++ a/include/linux/mmzone.h
@@ -257,8 +257,8 @@ struct lruvec {
 	 */
 	unsigned long			anon_cost;
 	unsigned long			file_cost;
-	/* Evictions & activations on the inactive file list */
-	atomic_long_t			inactive_age;
+	/* Non-resident age, driven by LRU movement */
+	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
 	unsigned long			refaults;
 	/* Various lruvec state flags (enum lruvec_flags) */
--- a/include/linux/swap.h~mm-workingset-age-nonresident-information-alongside-anonymous-pages
+++ a/include/linux/swap.h
@@ -313,6 +313,7 @@ struct vma_swap_readahead {
 };
 
 /* linux/mm/workingset.c */
+void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct page *page, struct mem_cgroup *target_memcg);
 void workingset_refault(struct page *page, void *shadow);
 void workingset_activation(struct page *page);
--- a/mm/vmscan.c~mm-workingset-age-nonresident-information-alongside-anonymous-pages
+++ a/mm/vmscan.c
@@ -904,6 +904,7 @@ static int __remove_mapping(struct addre
 		__delete_from_swap_cache(page, swap);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		put_swap_page(page, swap);
+		workingset_eviction(page, target_memcg);
 	} else {
 		void (*freepage)(struct page *);
 		void *shadow = NULL;
@@ -1884,6 +1885,8 @@ static unsigned noinline_for_stack move_
 				list_add(&page->lru, &pages_to_free);
 		} else {
 			nr_moved += nr_pages;
+			if (PageActive(page))
+				workingset_age_nonresident(lruvec, nr_pages);
 		}
 	}
 
--- a/mm/workingset.c~mm-workingset-age-nonresident-information-alongside-anonymous-pages
+++ a/mm/workingset.c
@@ -156,8 +156,8 @@
  *
  *		Implementation
  *
- * For each node's file LRU lists, a counter for inactive evictions
- * and activations is maintained (node->inactive_age).
+ * For each node's LRU lists, a counter for inactive evictions and
+ * activations is maintained (node->nonresident_age).
  *
  * On eviction, a snapshot of this counter (along with some bits to
  * identify the node) is stored in the now empty page cache
@@ -213,7 +213,17 @@ static void unpack_shadow(void *shadow,
 	*workingsetp = workingset;
 }
 
-static void advance_inactive_age(struct mem_cgroup *memcg, pg_data_t *pgdat)
+/**
+ * workingset_age_nonresident - age non-resident entries as LRU ages
+ * @memcg: the lruvec that was aged
+ * @nr_pages: the number of pages to count
+ *
+ * As in-memory pages are aged, non-resident pages need to be aged as
+ * well, in order for the refault distances later on to be comparable
+ * to the in-memory dimensions. This function allows reclaim and LRU
+ * operations to drive the non-resident aging along in parallel.
+ */
+void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
 {
 	/*
 	 * Reclaiming a cgroup means reclaiming all its children in a
@@ -227,11 +237,8 @@ static void advance_inactive_age(struct
 	 * the root cgroup's, age as well.
 	 */
 	do {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		atomic_long_inc(&lruvec->inactive_age);
-	} while (memcg && (memcg = parent_mem_cgroup(memcg)));
+		atomic_long_add(nr_pages, &lruvec->nonresident_age);
+	} while ((lruvec = parent_lruvec(lruvec)));
 }
 
 /**
@@ -254,12 +261,11 @@ void *workingset_eviction(struct page *p
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	advance_inactive_age(page_memcg(page), pgdat);
-
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
+	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
-	eviction = atomic_long_read(&lruvec->inactive_age);
+	eviction = atomic_long_read(&lruvec->nonresident_age);
 	return pack_shadow(memcgid, pgdat, eviction, PageWorkingset(page));
 }
 
@@ -309,20 +315,20 @@ void workingset_refault(struct page *pag
 	if (!mem_cgroup_disabled() && !eviction_memcg)
 		goto out;
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
-	refault = atomic_long_read(&eviction_lruvec->inactive_age);
+	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
 
 	/*
 	 * Calculate the refault distance
 	 *
 	 * The unsigned subtraction here gives an accurate distance
-	 * across inactive_age overflows in most cases. There is a
+	 * across nonresident_age overflows in most cases. There is a
 	 * special case: usually, shadow entries have a short lifetime
 	 * and are either refaulted or reclaimed along with the inode
 	 * before they get too old.  But it is not impossible for the
-	 * inactive_age to lap a shadow entry in the field, which can
-	 * then result in a false small refault distance, leading to a
-	 * false activation should this old entry actually refault
-	 * again.  However, earlier kernels used to deactivate
+	 * nonresident_age to lap a shadow entry in the field, which
+	 * can then result in a false small refault distance, leading
+	 * to a false activation should this old entry actually
+	 * refault again.  However, earlier kernels used to deactivate
 	 * unconditionally with *every* reclaim invocation for the
 	 * longest time, so the occasional inappropriate activation
 	 * leading to pressure on the active list is not a problem.
@@ -359,7 +365,7 @@ void workingset_refault(struct page *pag
 		goto out;
 
 	SetPageActive(page);
-	advance_inactive_age(memcg, pgdat);
+	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
 	inc_lruvec_state(lruvec, WORKINGSET_ACTIVATE);
 
 	/* Page was active prior to eviction */
@@ -382,6 +388,7 @@ out:
 void workingset_activation(struct page *page)
 {
 	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
 
 	rcu_read_lock();
 	/*
@@ -394,7 +401,8 @@ void workingset_activation(struct page *
 	memcg = page_memcg_rcu(page);
 	if (!mem_cgroup_disabled() && !memcg)
 		goto out;
-	advance_inactive_age(memcg, page_pgdat(page));
+	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+	workingset_age_nonresident(lruvec, hpage_nr_pages(page));
 out:
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
