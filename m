From: akpm@linux-foundation.org
Subject: - mm-dont-touch-uninitialized-variable-in-do_pages_stat_array.patch removed from -mm tree
Date: Tue, 16 Dec 2008 12:30:27 -0800
Message-ID: <200812162030.mBGKUREp006548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbYLPUbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 15:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Brice.Goglin@inria.fr, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: don't touch uninitialized variable in do_pages_stat_array()
has been removed from the -mm tree.  Its filename was
     mm-dont-touch-uninitialized-variable-in-do_pages_stat_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't touch uninitialized variable in do_pages_stat_array()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

80bba1290ab5122c60cdb73332b26d288dc8aedd ("mm: no get_user/put_user while
holding mmap_sem in do_pages_stat?") removed one necessary variable
initialization.  Then, following warning happend.

  CC      mm/migrate.o
mm/migrate.c: In function 'sys_move_pages':
mm/migrate.c:1001: warning: 'err' may be used uninitialized in this function

More unfortunately, if find_vma() failed, kernel read uninitialized memory.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-dont-touch-uninitialized-variable-in-do_pages_stat_array mm/migrate.c
--- a/mm/migrate.c~mm-dont-touch-uninitialized-variable-in-do_pages_stat_array
+++ a/mm/migrate.c
@@ -998,7 +998,7 @@ static void do_pages_stat_array(struct m
 		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
-		int err;
+		int err = -EFAULT;
 
 		vma = find_vma(mm, addr);
 		if (!vma)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
proc-enclose-desc-variable-of-show_stat-in-config_sparse_irq.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch

