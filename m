From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
 removed from -mm tree
Date: Thu, 30 Oct 2014 13:27:46 -0700
Message-ID: <54529f42.pCZDHKF/TfC32+6Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaJ3U1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-writeback: inline account_page_dirtied() into single caller
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page-writeback: inline account_page_dirtied() into single caller

A follow-up patch would have changed the call signature.  To save the
trouble, just fold it instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: <stable@vger.kernel.org>	[3.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 -
 mm/page-writeback.c |   23 ++++-------------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-page-writeback-inline-account_page_dirtied-into-single-caller include/linux/mm.h
--- a/include/linux/mm.h~mm-page-writeback-inline-account_page_dirtied-into-single-caller
+++ a/include/linux/mm.h
@@ -1235,7 +1235,6 @@ int __set_page_dirty_no_writeback(struct
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
-void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff -puN mm/page-writeback.c~mm-page-writeback-inline-account_page_dirtied-into-single-caller mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writeback-inline-account_page_dirtied-into-single-caller
+++ a/mm/page-writeback.c
@@ -2116,23 +2116,6 @@ void account_page_dirtied(struct page *p
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
- * Helper function for set_page_writeback family.
- *
- * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
- * while calling this function.
- * See test_set_page_writeback for example.
- *
- * NOTE: Unlike account_page_dirtied this does not rely on being atomic
- * wrt interrupts.
- */
-void account_page_writeback(struct page *page)
-{
-	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
-	inc_zone_page_state(page, NR_WRITEBACK);
-}
-EXPORT_SYMBOL(account_page_writeback);
-
-/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
@@ -2410,8 +2393,10 @@ int __test_set_page_writeback(struct pag
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
-	if (!ret)
-		account_page_writeback(page);
+	if (!ret) {
+		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		inc_zone_page_state(page, NR_WRITEBACK);
+	}
 	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
 	return ret;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
slab-print-slabinfo-header-in-seq-show.patch
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
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
debugging-keep-track-of-page-owners.patch

