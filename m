From: akpm@linux-foundation.org
Subject: + mm-memcontrol-rewrite-uncharge-api-fix-2.patch added to -mm
 tree
Date: Fri, 20 Jun 2014 12:00:10 -0700
Message-ID: <53a484ba.lCDwDaFLAAu+m9/6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaFTTAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 15:00:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, fengguang.wu@intel.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix 2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-uncharge-api-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-2.patch

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
Subject: mm: memcontrol: rewrite uncharge API fix 2

It's not entirely clear whether do_swap_account or PCG_MEMSW is the
authoritative answer to whether a page is swap-accounted or not.  This
currently leads to the following memsw counter underflow when swap
accounting is disabled:

[    2.753355] WARNING: CPU: 0 PID: 1 at kernel/res_counter.c:28 res_counter_uncharge_locked+0x48/0x74()
[    2.753355] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc1-00238-gddc5bfe #1
[    2.753355] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.753355]  0000000000000000 ffff880012073c50 ffffffff81a23b9d ffff880012073c88
[    2.753355]  ffffffff810bc765 ffffffff8111fac8 0000000000001000 ffff88001200fa50
[    2.753355]  0000000000000001 ffff88001200fa01 ffff880012073c98 ffffffff810bc84b
[    2.753355] Call Trace:
[    2.753355]  [<ffffffff81a23b9d>] dump_stack+0x19/0x1b
[    2.753355]  [<ffffffff810bc765>] warn_slowpath_common+0x73/0x8c
[    2.753355]  [<ffffffff8111fac8>] ? res_counter_uncharge_locked+0x48/0x74
[    2.753355]  [<ffffffff810bc84b>] warn_slowpath_null+0x1a/0x1c
[    2.753355]  [<ffffffff8111fac8>] res_counter_uncharge_locked+0x48/0x74
[    2.753355]  [<ffffffff8111fd02>] res_counter_uncharge_until+0x4e/0xa9
[    2.753355]  [<ffffffff8111fd70>] res_counter_uncharge+0x13/0x15
[    2.753355]  [<ffffffff8119499c>] mem_cgroup_uncharge_end+0x73/0x8d
[    2.753355]  [<ffffffff8115735e>] release_pages+0x1f2/0x20d
[    2.753355]  [<ffffffff8116cc3a>] tlb_flush_mmu_free+0x28/0x43
[    2.753355]  [<ffffffff8116d5e5>] tlb_flush_mmu+0x20/0x23
[    2.753355]  [<ffffffff8116d5fc>] tlb_finish_mmu+0x14/0x39
[    2.753355]  [<ffffffff811730c1>] unmap_region+0xcd/0xdf
[    2.753355]  [<ffffffff81172b0e>] ? vma_gap_callbacks_propagate+0x18/0x33
[    2.753355]  [<ffffffff81174bf1>] do_munmap+0x252/0x2e0
[    2.753355]  [<ffffffff81174cc3>] vm_munmap+0x44/0x5c
[    2.753355]  [<ffffffff81174cfe>] SyS_munmap+0x23/0x29
[    2.753355]  [<ffffffff81a31567>] system_call_fastpath+0x16/0x1b
[    2.753355] ---[ end trace cfeb07101f6fbdfb ]---

Don't set PCG_MEMSW when swap accounting is disabled, so that uncharging
only has to look at this per-page flag.

mem_cgroup_swapout() could also fully rely on this flag, but as it can
bail out before even looking up the page_cgroup, check do_swap_account as
a performance optimization and only sanity test for PCG_MEMSW.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-2
+++ a/mm/memcontrol.c
@@ -2740,7 +2740,7 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED | PCG_MEM | PCG_MEMSW;
+	pc->flags = PCG_USED | PCG_MEM | (do_swap_account ? PCG_MEMSW : 0);
 
 	if (lrucare) {
 		if (was_on_lru) {
@@ -6649,7 +6649,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEMSW), oldpage);
+	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
 
 	if (PageTransHuge(oldpage)) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

