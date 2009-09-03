From: akpm@linux-foundation.org
Subject: [to-be-updated] vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix.patch removed from -mm tree
Date: Thu, 03 Sep 2009 16:42:18 -0700
Message-ID: <200909032342.n83NgJEG008778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932505AbZICXnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 19:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.


The patch titled
     vmscan move pgdeactivate modification to shrink_active_list fix
has been removed from the -mm tree.  Its filename was
     vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan move pgdeactivate modification to shrink_active_list fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even quicker
than last time: one bug fixed but another bug introduced. 
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch forgot
to add NR_LRU_BASE to lru index to make zone_page_state index.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix
+++ a/mm/vmscan.c
@@ -1381,8 +1381,10 @@ static void shrink_active_list(unsigned 
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 	__count_vm_events(PGDEACTIVATE, nr_deactivated);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
-	__mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE, nr_rotated);
-	__mod_zone_page_state(zone, LRU_BASE + file * LRU_FILE, nr_deactivated);
+	__mod_zone_page_state(zone, NR_ACTIVE_ANON + file * LRU_FILE,
+							nr_rotated);
+	__mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
+							nr_deactivated);
 	spin_unlock_irq(&zone->lru_lock);
 }
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
vfs-optimize-touch_time-too-fix.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
page-types-move-from-documentation-vm-to-tools-vm.patch
pagemap-export-kpf_hwpoison.patch
pagemap-document-kpf_ksm-and-show-it-in-page-types.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list-fix2.patch

