From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch added to -mm tree
Date: Thu, 23 Oct 2014 12:25:20 -0700
Message-ID: <54495620.n9MuJbCDh8tu5Blx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaJWTZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fold mem_cgroup_start_move()/mem_cgroup_end_move()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch

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
Subject: mm: memcontrol: fold mem_cgroup_start_move()/mem_cgroup_end_move()

Having these functions and their documentation split out and somewhere
makes it harder, not easier, to follow what's going on.

Inline them directly where charge moving is prepared and finished, and put
an explanation right next to it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move
+++ a/mm/memcontrol.c
@@ -1447,32 +1447,6 @@ int mem_cgroup_swappiness(struct mem_cgr
 }
 
 /*
- * memcg->moving_account is used for checking possibility that some thread is
- * calling move_account(). When a thread on CPU-A starts moving pages under
- * a memcg, other threads should check memcg->moving_account under
- * rcu_read_lock(), like this:
- *
- *         CPU-A                                    CPU-B
- *                                              rcu_read_lock()
- *         memcg->moving_account+1              if (memcg->mocing_account)
- *                                                   take heavy locks.
- *         synchronize_rcu()                    update something.
- *                                              rcu_read_unlock()
- *         start move here.
- */
-
-static void mem_cgroup_start_move(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->moving_account);
-	synchronize_rcu();
-}
-
-static void mem_cgroup_end_move(struct mem_cgroup *memcg)
-{
-	atomic_dec(&memcg->moving_account);
-}
-
-/*
  * A routine for checking "mem" is under move_account() or not.
  *
  * Checking a cgroup is mc.from or mc.to or under hierarchy of
@@ -5412,7 +5386,8 @@ static void mem_cgroup_clear_mc(void)
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
-	mem_cgroup_end_move(from);
+
+	atomic_dec(&memcg->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5445,7 +5420,16 @@ static int mem_cgroup_can_attach(struct
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
-			mem_cgroup_start_move(from);
+
+			/*
+			 * Signal mem_cgroup_begin_page_stat() to take
+			 * the memcg's move_lock while we're moving
+			 * its pages to another memcg.  Then wait for
+			 * already started RCU-only updates to finish.
+			 */
+			atomic_inc(&memcg->moving_account);
+			synchronize_rcu();
+
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
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

