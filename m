From: akpm@linux-foundation.org
Subject: + mm-rmap-split-out-page_remove_file_rmap.patch added to -mm tree
Date: Thu, 23 Oct 2014 12:32:30 -0700
Message-ID: <544957ce.pfjnqvQIOj1D99IT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaJWTca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: split out page_remove_file_rmap()
has been added to the -mm tree.  Its filename is
     mm-rmap-split-out-page_remove_file_rmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-split-out-page_remove_file_rmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-split-out-page_remove_file_rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: rmap: split out page_remove_file_rmap()

page_remove_rmap() has too many branches on PageAnon() and is hard to
follow.  Move the file part into a separate function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   78 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff -puN mm/rmap.c~mm-rmap-split-out-page_remove_file_rmap mm/rmap.c
--- a/mm/rmap.c~mm-rmap-split-out-page_remove_file_rmap
+++ a/mm/rmap.c
@@ -1054,6 +1054,36 @@ void page_add_file_rmap(struct page *pag
 	mem_cgroup_end_page_stat(memcg, locked, flags);
 }
 
+static void page_remove_file_rmap(struct page *page)
+{
+	struct mem_cgroup *memcg;
+	unsigned long flags;
+	bool locked;
+
+	memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+
+	/* page still mapped by someone else? */
+	if (!atomic_add_negative(-1, &page->_mapcount))
+		goto out;
+
+	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
+	if (unlikely(PageHuge(page)))
+		goto out;
+
+	/*
+	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+	 * these counters are not modified in interrupt context, and
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
+	 */
+	__dec_zone_page_state(page, NR_FILE_MAPPED);
+	mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
+
+	if (unlikely(PageMlocked(page)))
+		clear_page_mlock(page);
+out:
+	mem_cgroup_end_page_stat(memcg, locked, flags);
+}
+
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
@@ -1062,46 +1092,33 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
-	struct mem_cgroup *uninitialized_var(memcg);
-	bool anon = PageAnon(page);
-	unsigned long flags;
-	bool locked;
-
-	/*
-	 * The anon case has no mem_cgroup page_stat to update; but may
-	 * uncharge_page() below, where the lock ordering can deadlock if
-	 * we hold the lock against page_stat move: so avoid it on anon.
-	 */
-	if (!anon)
-		memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+	if (!PageAnon(page)) {
+		page_remove_file_rmap(page);
+		return;
+	}
 
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
-		goto out;
+		return;
+
+	/* Hugepages are not counted in NR_ANON_PAGES for now. */
+	if (unlikely(PageHuge(page)))
+		return;
 
 	/*
-	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
-	 * and not charged by memcg for now.
-	 *
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
-	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	if (unlikely(PageHuge(page)))
-		goto out;
-	if (anon) {
-		if (PageTransHuge(page))
-			__dec_zone_page_state(page,
-					      NR_ANON_TRANSPARENT_HUGEPAGES);
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-				-hpage_nr_pages(page));
-	} else {
-		__dec_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
-	}
+	if (PageTransHuge(page))
+		__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+
+	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+			      -hpage_nr_pages(page));
+
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
+
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
@@ -1111,9 +1128,6 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
-out:
-	if (!anon)
-		mem_cgroup_end_page_stat(memcg, locked, flags);
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
mm-rmap-split-out-page_remove_file_rmap.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
debugging-keep-track-of-page-owners.patch

