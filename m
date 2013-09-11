From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 14:00:58 -0700
Message-ID: <5230da0a.zD9fpzGmgEfYj5SI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3IKVBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangwm@marvell.com, yinghan@google.com, riel@redhat.com, npiggin@gmail.com, minchan@kernel.org, mhocko@suse.cz, mel@csn.ul.ie, lliubbo@gmail.com, linux@arm.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cldu@marvell.com, cl@linux.com, aaditya.kumar.30@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aaditya.kumar.30@gmail.com,cl@linux.com,cldu@marvell.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,linux@arm.linux.org.uk,lliubbo@gmail.com,mel@csn.ul.ie,mhocko@suse.cz,minchan@kernel.org,npiggin@gmail.com,riel@redhat.com,yinghan@google.com,zhangwm@marvell.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:00:58 -0700


The patch titled
     Subject: mm-vmscan-fix-do_try_to_free_pages-livelock-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch

This patch was dropped because it was folded into mm-vmscan-fix-do_try_to_free_pages-livelock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-do_try_to_free_pages-livelock-fix

uninline zone_reclaimable_pages() and zone_reclaimable().

Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Neil Zhang <zhangwm@marvell.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   19 -------------------
 mm/internal.h             |    2 ++
 mm/page-writeback.c       |    2 ++
 mm/vmscan.c               |   19 +++++++++++++++++++
 mm/vmstat.c               |    2 ++
 5 files changed, 25 insertions(+), 19 deletions(-)

diff -puN include/linux/mm_inline.h~mm-vmscan-fix-do_try_to_free_pages-livelock-fix include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmscan-fix-do_try_to_free_pages-livelock-fix
+++ a/include/linux/mm_inline.h
@@ -100,23 +100,4 @@ static __always_inline enum lru_list pag
 	return lru;
 }
 
-static inline unsigned long zone_reclaimable_pages(struct zone *zone)
-{
-	int nr;
-
-	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
-	     zone_page_state(zone, NR_INACTIVE_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON);
-
-	return nr;
-}
-
-static inline bool zone_reclaimable(struct zone *zone)
-{
-	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
-}
-
 #endif
diff -puN mm/internal.h~mm-vmscan-fix-do_try_to_free_pages-livelock-fix mm/internal.h
--- a/mm/internal.h~mm-vmscan-fix-do_try_to_free_pages-livelock-fix
+++ a/mm/internal.h
@@ -85,6 +85,8 @@ extern unsigned long highest_memmap_pfn;
  */
 extern int isolate_lru_page(struct page *page);
 extern void putback_lru_page(struct page *page);
+extern unsigned long zone_reclaimable_pages(struct zone *zone);
+extern bool zone_reclaimable(struct zone *zone);
 
 /*
  * in mm/rmap.c:
diff -puN mm/page-writeback.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix
+++ a/mm/page-writeback.c
@@ -39,6 +39,8 @@
 #include <linux/mm_inline.h>
 #include <trace/events/writeback.h>
 
+#include "internal.h"
+
 /*
  * Sleep at most 200ms at a time in balance_dirty_pages().
  */
diff -puN mm/vmscan.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix
+++ a/mm/vmscan.c
@@ -146,6 +146,25 @@ static bool global_reclaim(struct scan_c
 }
 #endif
 
+unsigned long zone_reclaimable_pages(struct zone *zone)
+{
+	int nr;
+
+	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
+	     zone_page_state(zone, NR_INACTIVE_FILE);
+
+	if (get_nr_swap_pages() > 0)
+		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
+		      zone_page_state(zone, NR_INACTIVE_ANON);
+
+	return nr;
+}
+
+bool zone_reclaimable(struct zone *zone)
+{
+	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
+}
+
 static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
diff -puN mm/vmstat.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix
+++ a/mm/vmstat.c
@@ -21,6 +21,8 @@
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
 
+#include "internal.h"
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

