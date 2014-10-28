From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
 added to -mm tree
Date: Tue, 28 Oct 2014 14:44:24 -0700
Message-ID: <54500e38.gT6nk+5X2upxEilL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbaJ1VoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: pull the NULL check from __mem_cgroup_same_or_subtree()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch

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
Subject: mm: memcontrol: pull the NULL check from __mem_cgroup_same_or_subtree()

The NULL in mm_match_cgroup() comes from a possibly exiting mm->owner.  It
makes a lot more sense to check where it's looked up, rather than check
for it in __mem_cgroup_same_or_subtree() where it's unexpected.

No other callsite passes NULL to __mem_cgroup_same_or_subtree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree
+++ a/include/linux/memcontrol.h
@@ -83,11 +83,12 @@ static inline
 bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
-	bool match;
+	bool match = false;
 
 	rcu_read_lock();
 	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
+	if (task_memcg)
+		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
 	rcu_read_unlock();
 	return match;
 }
diff -puN mm/memcontrol.c~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree
+++ a/mm/memcontrol.c
@@ -1316,7 +1316,7 @@ bool __mem_cgroup_same_or_subtree(const
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy || !memcg)
+	if (!root_memcg->use_hierarchy)
 		return false;
 	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
 }
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
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
debugging-keep-track-of-page-owners.patch

