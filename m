From: akpm@linux-foundation.org
Subject: + mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch added to -mm tree
Date: Tue, 28 Oct 2014 14:41:44 -0700
Message-ID: <54500d98.pBenQK13JVuRo/8l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaJ1Vln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: shorten the page statistics update slowpath
has been added to the -mm tree.  Its filename is
     mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch

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
Subject: mm: memcontrol: shorten the page statistics update slowpath

While moving charges from one memcg to another, page stat updates must
acquire the old memcg's move_lock to prevent double accounting.  That
situation is denoted by an increased memcg->move_accounting.  However, the
charge moving code declares this way too early for now, even before
summing up the RSS and pre-allocating destination charges.

Shorten this slowpath mode by increasing memcg->move_accounting only right
before walking the task's address space with the intention of actually
moving the pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-shorten-the-page-statistics-update-slowpath mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-shorten-the-page-statistics-update-slowpath
+++ a/mm/memcontrol.c
@@ -5246,8 +5246,6 @@ static void __mem_cgroup_clear_mc(void)
 
 static void mem_cgroup_clear_mc(void)
 {
-	struct mem_cgroup *from = mc.from;
-
 	/*
 	 * we must clear moving_task before waking up waiters at the end of
 	 * task migration.
@@ -5258,8 +5256,6 @@ static void mem_cgroup_clear_mc(void)
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
-
-	atomic_dec(&from->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5293,15 +5289,6 @@ static int mem_cgroup_can_attach(struct
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
 
-			/*
-			 * Signal mem_cgroup_begin_page_stat() to take
-			 * the memcg's move_lock while we're moving
-			 * its pages to another memcg.  Then wait for
-			 * already started RCU-only updates to finish.
-			 */
-			atomic_inc(&from->moving_account);
-			synchronize_rcu();
-
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
@@ -5433,6 +5420,13 @@ static void mem_cgroup_move_charge(struc
 	struct vm_area_struct *vma;
 
 	lru_add_drain_all();
+	/*
+	 * Signal mem_cgroup_begin_page_stat() to take the memcg's
+	 * move_lock while we're moving its pages to another memcg.
+	 * Then wait for already started RCU-only updates to finish.
+	 */
+	atomic_inc(&mc.from->moving_account);
+	synchronize_rcu();
 retry:
 	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
 		/*
@@ -5465,6 +5459,7 @@ retry:
 			break;
 	}
 	up_read(&mm->mmap_sem);
+	atomic_dec(&mc.from->moving_account);
 }
 
 static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
mm-rmap-split-out-page_remove_file_rmap.patch
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
mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
debugging-keep-track-of-page-owners.patch

