From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch added to
 -mm tree
Date: Tue, 20 Aug 2013 15:16:40 -0700
Message-ID: <5213eac8.XtDwfBX6oiQmZGA+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3HTWQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 18:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangwm@marvell.com, yinghan@google.com, riel@redhat.com, npiggin@gmail.com, minchan@kernel.org, mhocko@suse.cz, mel@csn.ul.ie, lliubbo@gmail.com, linux@arm.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cldu@marvell.com, cl@linux.com, aaditya.kumar.30@gmail.com, akpm@linux-foundation.org

Subject: + mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aaditya.kumar.30@gmail.com,cl@linux.com,cldu@marvell.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,linux@arm.linux.org.uk,lliubbo@gmail.com,mel@csn.ul.ie,mhocko@suse.cz,minchan@kernel.org,npiggin@gmail.com,riel@redhat.com,yinghan@google.com,zhangwm@marvell.com
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 15:16:40 -0700


The patch titled
     Subject: mm-vmscan-fix-do_try_to_free_pages-livelock-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

