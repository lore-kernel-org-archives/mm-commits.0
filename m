From: akpm@linux-foundation.org
Subject: - fs-symlink-write_begin-allocation-context-fix-ubifs-fix.patch removed from -mm tree
Date: Sun, 04 Jan 2009 11:34:03 -0800
Message-ID: <200901041934.n04JY3MN022820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbZADTeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 4 Jan 2009 14:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs-symlink-write_begin-allocation-context-fix: ubifs fix
has been removed from the -mm tree.  Its filename was
     fs-symlink-write_begin-allocation-context-fix-ubifs-fix.patch

This patch was dropped because it was folded into fs-symlink-write_begin-allocation-context-fix.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-symlink-write_begin-allocation-context-fix: ubifs fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

build fix.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ubifs/file.c~fs-symlink-write_begin-allocation-context-fix-ubifs-fix fs/ubifs/file.c
--- a/fs/ubifs/file.c~fs-symlink-write_begin-allocation-context-fix-ubifs-fix
+++ a/fs/ubifs/file.c
@@ -219,7 +219,8 @@ static void release_existing_page_budget
 }
 
 static int write_begin_slow(struct address_space *mapping,
-			    loff_t pos, unsigned len, struct page **pagep)
+			    loff_t pos, unsigned len, struct page **pagep,
+			    unsigned flags)
 {
 	struct inode *inode = mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
@@ -485,7 +486,7 @@ static int ubifs_write_begin(struct file
 		unlock_page(page);
 		page_cache_release(page);
 
-		return write_begin_slow(mapping, pos, len, pagep);
+		return write_begin_slow(mapping, pos, len, pagep, flags);
 	}
 
 	/*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
fs-symlink-write_begin-allocation-context-fix.patch
fs-symlink-write_begin-allocation-context-fix-ubifs-fix.patch
fs-symlink-write_begin-allocation-context-fix-fuse-fix.patch
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
mm-remove-config_out_of_line_pfn_to_page.patch
mm-kill-page_queue_congested.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
sys_execve-and-sys_uselib-do-not-call-into-fsnotify.patch
profile-dont-include-asm-ptraceh-twice.patch
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
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
coredump_filter-permit-changing-of-the-default-filter.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

