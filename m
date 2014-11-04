From: akpm@linux-foundation.org
Subject: +
 mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch added
 to -mm tree
Date: Tue, 04 Nov 2014 11:56:12 -0800
Message-ID: <54592f5c.4/+ZxRGdDHVVEGH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaKDT4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 14:56:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix potential undefined behaviour in page stat accounting
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, memcg: fix potential undefined behaviour in page stat accounting

Since d7365e783edb (mm: memcontrol: fix missed end-writeback page
accounting) mem_cgroup_end_page_stat consumes locked and flags variables
directly rather than via pointers which might trigger C undefined behavior
as those variables are initialized only in the slow path of
mem_cgroup_begin_page_stat.

Although mem_cgroup_end_page_stat handles parameters correctly and touches
them only when they hold a sensible value it is caller which loads a
potentially uninitialized value which then might allow compiler to do
crazy things.

I haven't seen any warning from gcc and it seems that the current version
(4.9) doesn't exploit this type undefined behavior but Sasha has reported
the following:

[   26.868116] ================================================================================
[   26.870376] UBSan: Undefined behaviour in mm/rmap.c:1084:2
[   26.871792] load of value 255 is not a valid value for type '_Bool'
[   26.873256] CPU: 4 PID: 8304 Comm: rngd Not tainted 3.18.0-rc2-next-20141029-sasha-00039-g77ed13d-dirty #1427
[   26.875636]  ffff8800cac17ff0 0000000000000000 0000000000000000 ffff880069ffbb28
[   26.877611]  ffffffffaf010c16 0000000000000037 ffffffffb1c0d050 ffff880069ffbb38
[   26.879140]  ffffffffa6e97899 ffff880069ffbbb8 ffffffffa6e97cc7 ffff880069ffbbb8
[   26.880765] Call Trace:
[   26.881185] dump_stack (lib/dump_stack.c:52)
[   26.882755] ubsan_epilogue (lib/ubsan.c:159)
[   26.883555] __ubsan_handle_load_invalid_value (lib/ubsan.c:482)
[   26.884492] ? mem_cgroup_begin_page_stat (mm/memcontrol.c:1962)
[   26.885441] ? unmap_page_range (./arch/x86/include/asm/paravirt.h:694 mm/memory.c:1091 mm/memory.c:1258 mm/memory.c:1279 mm/memory.c:1303)
[   26.886242] page_remove_rmap (mm/rmap.c:1084 mm/rmap.c:1096)
[   26.886922] unmap_page_range (./arch/x86/include/asm/atomic.h:27 include/linux/mm.h:463 mm/memory.c:1146 mm/memory.c:1258 mm/memory.c:1279 mm/memory.c:1303)
[   26.887824] unmap_single_vma (mm/memory.c:1348)
[   26.888582] unmap_vmas (mm/memory.c:1377 (discriminator 3))
[   26.889430] exit_mmap (mm/mmap.c:2837)
[   26.890060] mmput (kernel/fork.c:659)
[   26.890656] do_exit (./arch/x86/include/asm/thread_info.h:168 kernel/exit.c:462 kernel/exit.c:747)
[   26.891359] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[   26.892287] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[   26.893107] ? syscall_trace_enter_phase2 (arch/x86/kernel/ptrace.c:1598 (discriminator 2))
[   26.893974] do_group_exit (include/linux/sched.h:775 kernel/exit.c:873)
[   26.894695] SyS_exit_group (kernel/exit.c:901)
[   26.895433] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[   26.896134] ================================================================================

Fix this by using pointer parameters for both locked and flags and be more
robust for future compiler changes even though the current code is
implemented correctly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 mm/memcontrol.c            |    8 ++++----
 mm/page-writeback.c        |    4 ++--
 mm/rmap.c                  |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting
+++ a/include/linux/memcontrol.h
@@ -141,8 +141,8 @@ static inline bool mem_cgroup_disabled(v
 
 struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page, bool *locked,
 					      unsigned long *flags);
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
-			      unsigned long flags);
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
+			      unsigned long *flags);
 void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val);
 
@@ -297,7 +297,7 @@ static inline struct mem_cgroup *mem_cgr
 }
 
 static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
-					bool locked, unsigned long flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
diff -puN mm/memcontrol.c~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting
+++ a/mm/memcontrol.c
@@ -2053,11 +2053,11 @@ again:
  * @locked: value received from mem_cgroup_begin_page_stat()
  * @flags: value received from mem_cgroup_begin_page_stat()
  */
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
-			      unsigned long flags)
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
+			      unsigned long *flags)
 {
-	if (memcg && locked)
-		spin_unlock_irqrestore(&memcg->move_lock, flags);
+	if (memcg && *locked)
+		spin_unlock_irqrestore(&memcg->move_lock, *flags);
 
 	rcu_read_unlock();
 }
diff -puN mm/page-writeback.c~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting mm/page-writeback.c
--- a/mm/page-writeback.c~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting
+++ a/mm/page-writeback.c
@@ -2357,7 +2357,7 @@ int test_clear_page_writeback(struct pag
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
 	return ret;
 }
 
@@ -2399,7 +2399,7 @@ int __test_set_page_writeback(struct pag
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITEBACK);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
 	return ret;
 
 }
diff -puN mm/rmap.c~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting mm/rmap.c
--- a/mm/rmap.c~mm-memcg-fix-potential-undefined-when-for-page-stat-accounting
+++ a/mm/rmap.c
@@ -1051,7 +1051,7 @@ void page_add_file_rmap(struct page *pag
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &flags);
 }
 
 static void page_remove_file_rmap(struct page *page)
@@ -1081,7 +1081,7 @@ static void page_remove_file_rmap(struct
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
-	mem_cgroup_end_page_stat(memcg, locked, flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &flags);
 }
 
 /**
_

Patches currently in -mm which might be from mhocko@suse.cz are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
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
mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
linux-next.patch

