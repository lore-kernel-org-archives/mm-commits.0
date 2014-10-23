From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch added to
 -mm tree
Date: Thu, 23 Oct 2014 12:28:36 -0700
Message-ID: <544956e4.LbpGjENN8bg8RGc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJWT2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix missed end-writeback page accounting fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch

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
Subject: mm: memcontrol: fix missed end-writeback page accounting fix

Add kernel-doc to page state accounting functions.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   51 +++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-missed-end-writeback-page-accounting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-missed-end-writeback-page-accounting-fix
+++ a/mm/memcontrol.c
@@ -2198,21 +2198,31 @@ cleanup:
 	return true;
 }
 
-/*
- * Used to update mapped file or writeback or other statistics.
+/**
+ * mem_cgroup_begin_page_stat - begin a page state statistics transaction
+ * @page: page that is going to change accounted state
+ * @locked: &memcg->move_lock slowpath was taken
+ * @flags: IRQ-state flags for &memcg->move_lock
  *
- * Notes: Race condition
+ * This function must mark the beginning of an accounted page state
+ * change to prevent double accounting when the page is concurrently
+ * being moved to another memcg:
  *
- * Charging occurs during page instantiation, while the page is
- * unmapped and locked in page migration, or while the page table is
- * locked in THP migration.  No race is possible.
+ *   memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+ *   if (TestClearPageState(page))
+ *     mem_cgroup_update_page_stat(memcg, state, -1);
+ *   mem_cgroup_end_page_stat(memcg, locked, flags);
  *
- * Uncharge happens to pages with zero references, no race possible.
+ * The RCU lock is held throughout the transaction.  The fast path can
+ * get away without acquiring the memcg->move_lock (@locked is false)
+ * because page moving starts with an RCU grace period.
  *
- * Charge moving between groups is protected by checking mm->moving
- * account and taking the move_lock in the slowpath.
+ * The RCU lock also protects the memcg from being freed when the page
+ * state that is going to change is the only thing preventing the page
+ * from being uncharged.  E.g. end-writeback clearing PageWriteback(),
+ * which allows migration to go ahead and uncharge the page before the
+ * account transaction might be complete.
  */
-
 struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 					      bool *locked,
 					      unsigned long *flags)
@@ -2230,12 +2240,7 @@ again:
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return NULL;
-	/*
-	 * If this memory cgroup is not under account moving, we don't
-	 * need to take move_lock_mem_cgroup(). Because we already hold
-	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock().
-	 */
+
 	*locked = false;
 	if (atomic_read(&memcg->moving_account) <= 0)
 		return memcg;
@@ -2250,6 +2255,12 @@ again:
 	return memcg;
 }
 
+/**
+ * mem_cgroup_end_page_stat - finish a page state statistics transaction
+ * @memcg: the memcg that was accounted against
+ * @locked: value received from mem_cgroup_begin_page_stat()
+ * @flags: value received from mem_cgroup_begin_page_stat()
+ */
 void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
 			      unsigned long flags)
 {
@@ -2259,6 +2270,14 @@ void mem_cgroup_end_page_stat(struct mem
 	rcu_read_unlock();
 }
 
+/**
+ * mem_cgroup_update_page_stat - update page state statistics
+ * @memcg: memcg to account against
+ * @idx: page state item to account
+ * @val: number of pages (positive or negative)
+ *
+ * See mem_cgroup_begin_page_stat() for locking requirements.
+ */
 void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
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

