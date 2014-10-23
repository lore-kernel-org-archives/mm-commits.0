From: akpm@linux-foundation.org
Subject: + mm-memcontrol-inline-memcg-move_lock-locking.patch added to -mm tree
Date: Thu, 23 Oct 2014 12:23:37 -0700
Message-ID: <544955b9.lcMznP21OoaeRVEM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJWTXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: inline memcg->move_lock locking
has been added to the -mm tree.  Its filename is
     mm-memcontrol-inline-memcg-move_lock-locking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-inline-memcg-move_lock-locking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-inline-memcg-move_lock-locking.patch

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
Subject: mm: memcontrol: inline memcg->move_lock locking

The wrappers around taking and dropping the memcg->move_lock spinlock add
nothing of value.  Inline the spinlock calls into the callsites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-inline-memcg-move_lock-locking mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-inline-memcg-move_lock-locking
+++ a/mm/memcontrol.c
@@ -1522,23 +1522,6 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
-/*
- * Take this lock when
- * - a code tries to modify page's memcg while it's USED.
- * - a code tries to modify page state accounting in a memcg.
- */
-static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
-				  unsigned long *flags)
-{
-	spin_lock_irqsave(&memcg->move_lock, *flags);
-}
-
-static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
-				unsigned long *flags)
-{
-	spin_unlock_irqrestore(&memcg->move_lock, *flags);
-}
-
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /**
  * mem_cgroup_print_oom_info: Print OOM information relevant to memory controller.
@@ -2151,9 +2134,9 @@ again:
 	if (atomic_read(&memcg->moving_account) <= 0)
 		return memcg;
 
-	move_lock_mem_cgroup(memcg, flags);
+	spin_lock_irqsave(&memcg->move_lock, *flags);
 	if (memcg != pc->mem_cgroup) {
-		move_unlock_mem_cgroup(memcg, flags);
+		spin_unlock_irqrestore(&memcg->move_lock, *flags);
 		goto again;
 	}
 	*locked = true;
@@ -2165,7 +2148,7 @@ void mem_cgroup_end_page_stat(struct mem
 			      unsigned long flags)
 {
 	if (memcg && locked)
-		move_unlock_mem_cgroup(memcg, &flags);
+		spin_unlock_irqrestore(&memcg->move_lock, flags);
 
 	rcu_read_unlock();
 }
@@ -3200,7 +3183,7 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out_unlock;
 
-	move_lock_mem_cgroup(from, &flags);
+	spin_lock_irqsave(&from->move_lock, flags);
 
 	if (!PageAnon(page) && page_mapped(page)) {
 		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
@@ -3224,7 +3207,8 @@ static int mem_cgroup_move_account(struc
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	move_unlock_mem_cgroup(from, &flags);
+	spin_unlock_irqrestore(&from->move_lock, flags);
+
 	ret = 0;
 
 	local_irq_disable();
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
debugging-keep-track-of-page-owners.patch

