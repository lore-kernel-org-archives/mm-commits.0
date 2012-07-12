From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:02:16 -0700
Message-ID: <20120712210217.B7D2F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40943 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478Ab2GLVCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:02:20 -0400
Received: by eekd4 with SMTP id d4so91169eek.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:02:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aaditya.kumar.30@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org


The patch titled
     Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch

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
Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix

simplify nr_zone_isolate_freepages(), rework zone_watermark_ok_safe() comment, simplify set_pageblock_isolate() and restore_pageblock_isolate().

Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   19 ++++++++-----------
 mm/page_isolation.c |   19 ++++++++-----------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix
+++ a/mm/page_alloc.c
@@ -1626,12 +1626,9 @@ static bool __zone_watermark_ok(struct z
 #ifdef CONFIG_MEMORY_ISOLATION
 static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
 {
-	unsigned long nr_pages = 0;
-
-	if (unlikely(zone->nr_pageblock_isolate)) {
-		nr_pages = zone->nr_pageblock_isolate * pageblock_nr_pages;
-	}
-	return nr_pages;
+	if (unlikely(zone->nr_pageblock_isolate))
+		return zone->nr_pageblock_isolate * pageblock_nr_pages;
+	return 0;
 }
 #else
 static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
@@ -1656,11 +1653,11 @@ bool zone_watermark_ok_safe(struct zone 
 		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
 
 	/*
-	 * If the zone has MIGRATE_ISOLATE type free page,
-	 * we should consider it. nr_zone_isolate_freepages is never
-	 * accurate so kswapd might not sleep although she can.
-	 * But it's more desirable for memory hotplug rather than
-	 * forever sleep which cause livelock in direct reclaim path.
+	 * If the zone has MIGRATE_ISOLATE type free pages, we should consider
+	 * it.  nr_zone_isolate_freepages is never accurate so kswapd might not
+	 * sleep although it could do so.  But this is more desirable for memory
+	 * hotplug than sleeping which can cause a livelock in the direct
+	 * reclaim path.
 	 */
 	free_pages -= nr_zone_isolate_freepages(z);
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
diff -puN mm/page_isolation.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix
+++ a/mm/page_isolation.c
@@ -8,23 +8,20 @@
 #include <linux/memory.h>
 #include "internal.h"
 
-/* called by holding zone->lock */
-static void set_pageblock_isolate(struct zone *zone, struct page *page)
+/* called while holding zone->lock */
+static void set_pageblock_isolate(struct page *page)
 {
-	BUG_ON(page_zone(page) != zone);
-
 	if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
 		return;
 
 	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
-	zone->nr_pageblock_isolate++;
+	page_zone(page)->nr_pageblock_isolate++;
 }
 
-/* called by holding zone->lock */
-static void restore_pageblock_isolate(struct zone *zone, struct page *page,
-		int migratetype)
+/* called while holding zone->lock */
+static void restore_pageblock_isolate(struct page *page, int migratetype)
 {
-	BUG_ON(page_zone(page) != zone);
+	struct zone *zone = page_zone(page);
 	if (WARN_ON(get_pageblock_migratetype(page) != MIGRATE_ISOLATE))
 		return;
 
@@ -79,7 +76,7 @@ int set_migratetype_isolate(struct page 
 
 out:
 	if (!ret) {
-		set_pageblock_isolate(zone, page);
+		set_pageblock_isolate(page);
 		move_freepages_block(zone, page, MIGRATE_ISOLATE);
 	}
 
@@ -98,7 +95,7 @@ void unset_migratetype_isolate(struct pa
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
 	move_freepages_block(zone, page, migratetype);
-	restore_pageblock_isolate(zone, page, migratetype);
+	restore_pageblock_isolate(page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
_
Subject: Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

