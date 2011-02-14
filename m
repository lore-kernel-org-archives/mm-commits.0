From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-leak-of-accounting-at-failure-path-of-hugepage-collapsing.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:42 -0800
Message-ID: <201102142019.p1EKJgK1023011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046Ab1BNUU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hannes@cmpxchg.org, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix leak of accounting at failure path of hugepage collapsing
has been removed from the -mm tree.  Its filename was
     memcg-fix-leak-of-accounting-at-failure-path-of-hugepage-collapsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix leak of accounting at failure path of hugepage collapsing
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mem_cgroup_uncharge_page() should be called in all failure case
after mem_cgroup_charge_newpage() is called in
huge_memory.c::collapse_huge_page()

 [ 4209.076861] BUG: Bad page state in process khugepaged  pfn:1e9800
 [ 4209.077601] page:ffffea0006b14000 count:0 mapcount:0 mapping:          (null) index:0x2800
 [ 4209.078674] page flags: 0x40000000004000(head)
 [ 4209.079294] pc:ffff880214a30000 pc->flags:2146246697418756 pc->mem_cgroup:ffffc9000177a000
 [ 4209.082177] (/A)
 [ 4209.082500] Pid: 31, comm: khugepaged Not tainted 2.6.38-rc3-mm1 #1
 [ 4209.083412] Call Trace:
 [ 4209.083678]  [<ffffffff810f4454>] ? bad_page+0xe4/0x140
 [ 4209.084240]  [<ffffffff810f53e6>] ? free_pages_prepare+0xd6/0x120
 [ 4209.084837]  [<ffffffff8155621d>] ? rwsem_down_failed_common+0xbd/0x150
 [ 4209.085509]  [<ffffffff810f5462>] ? __free_pages_ok+0x32/0xe0
 [ 4209.086110]  [<ffffffff810f552b>] ? free_compound_page+0x1b/0x20
 [ 4209.086699]  [<ffffffff810fad6c>] ? __put_compound_page+0x1c/0x30
 [ 4209.087333]  [<ffffffff810fae1d>] ? put_compound_page+0x4d/0x200
 [ 4209.087935]  [<ffffffff810fb015>] ? put_page+0x45/0x50
 [ 4209.097361]  [<ffffffff8113f779>] ? khugepaged+0x9e9/0x1430
 [ 4209.098364]  [<ffffffff8107c870>] ? autoremove_wake_function+0x0/0x40
 [ 4209.099121]  [<ffffffff8113ed90>] ? khugepaged+0x0/0x1430
 [ 4209.099780]  [<ffffffff8107c236>] ? kthread+0x96/0xa0
 [ 4209.100452]  [<ffffffff8100dda4>] ? kernel_thread_helper+0x4/0x10
 [ 4209.101214]  [<ffffffff8107c1a0>] ? kthread+0x0/0xa0
 [ 4209.101842]  [<ffffffff8100dda0>] ? kernel_thread_helper+0x0/0x10

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~memcg-fix-leak-of-accounting-at-failure-path-of-hugepage-collapsing mm/huge_memory.c
--- a/mm/huge_memory.c~memcg-fix-leak-of-accounting-at-failure-path-of-hugepage-collapsing
+++ a/mm/huge_memory.c
@@ -1852,7 +1852,6 @@ static void collapse_huge_page(struct mm
 		set_pmd_at(mm, address, pmd, _pmd);
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
-		mem_cgroup_uncharge_page(new_page);
 		goto out;
 	}
 
@@ -1898,6 +1897,7 @@ out_up_write:
 	return;
 
 out:
+	mem_cgroup_uncharge_page(new_page);
 #ifdef CONFIG_NUMA
 	put_page(new_page);
 #endif
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-fix-out-of-date-comments-which-refers-non-existent-functions.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch

