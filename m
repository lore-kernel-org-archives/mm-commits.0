From: akpm@linux-foundation.org
Subject: + fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch added to -mm tree
Date: Thu, 18 Dec 2008 15:16:00 -0800
Message-ID: <200812182316.mBING0w3009985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbYLRXQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 18:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de


The patch titled
     fs-symlink-write_begin-allocation-context-fix: reiser4 fix
has been added to the -mm tree.  Its filename is
     fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-symlink-write_begin-allocation-context-fix: reiser4 fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

build fix.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file_conversion.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/file/file_conversion.c~fs-symlink-write_begin-allocation-context-fix-reiser4-fix fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~fs-symlink-write_begin-allocation-context-fix-reiser4-fix
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -686,7 +686,8 @@ int reiser4_write_begin_careful(struct f
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + len;
 
-	page = __grab_cache_page(mapping, index);
+	page = grab_cache_page_write_begin(mapping, index,
+					   flags & AOP_FLAG_NOFS);
 	*pagep = page;
 	if (!page)
 		return -ENOMEM;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
fs-symlink-write_begin-allocation-context-fix.patch
fs-symlink-write_begin-allocation-context-fix-ubifs-fix.patch
fs-symlink-write_begin-allocation-context-fix-fuse-fix.patch
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
mm-remove-config_out_of_line_pfn_to_page.patch
mm-kill-page_queue_congested.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
sys_execve-and-sys_uselib-do-not-call-into-fsnotify.patch
profile-dont-include-asm-ptraceh-twice.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
irq-remove-unnecessary-ifdef.patch
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
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

