From: akpm@linux-foundation.org
Subject: + mem-hotplug-introduce-unlock_memory_hotplug.patch added to -mm tree
Date: Wed, 01 Dec 2010 16:11:31 -0800
Message-ID: <201012020011.oB20BVSU020105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437Ab0LBAL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 19:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mem-hotplug: introduce {un}lock_memory_hotplug()
has been added to the -mm tree.  Its filename is
     mem-hotplug-introduce-unlock_memory_hotplug.patch

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
Subject: mem-hotplug: introduce {un}lock_memory_hotplug()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Presently hwpoison is using lock_system_sleep() to prevent a race with
memory hotplug.  However lock_system_sleep() is a no-op if
CONFIG_HIBERNATION=n.  Therefore we need a new lock.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory-failure.c            |    8 ++++----
 mm/memory_hotplug.c            |   31 ++++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 11 deletions(-)

diff -puN include/linux/memory_hotplug.h~mem-hotplug-introduce-unlock_memory_hotplug include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mem-hotplug-introduce-unlock_memory_hotplug
+++ a/include/linux/memory_hotplug.h
@@ -161,6 +161,9 @@ extern void register_page_bootmem_info_n
 extern void put_page_bootmem(struct page *page);
 #endif
 
+void lock_memory_hotplug(void);
+void unlock_memory_hotplug(void);
+
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
  * Stub functions for when hotplug is off
@@ -192,6 +195,9 @@ static inline void register_page_bootmem
 {
 }
 
+static inline void lock_memory_hotplug(void) {}
+static inline void unlock_memory_hotplug(void) {}
+
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN mm/memory-failure.c~mem-hotplug-introduce-unlock_memory_hotplug mm/memory-failure.c
--- a/mm/memory-failure.c~mem-hotplug-introduce-unlock_memory_hotplug
+++ a/mm/memory-failure.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
+#include <linux/memory_hotplug.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1230,11 +1231,10 @@ static int get_any_page(struct page *p, 
 		return 1;
 
 	/*
-	 * The lock_system_sleep prevents a race with memory hotplug,
-	 * because the isolation assumes there's only a single user.
+	 * The lock_memory_hotplug prevents a race with memory hotplug.
 	 * This is a big hammer, a better would be nicer.
 	 */
-	lock_system_sleep();
+	lock_memory_hotplug();
 
 	/*
 	 * Isolate the page, so that it doesn't get reallocated if it
@@ -1264,7 +1264,7 @@ static int get_any_page(struct page *p, 
 		ret = 1;
 	}
 	unset_migratetype_isolate(p);
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 
diff -puN mm/memory_hotplug.c~mem-hotplug-introduce-unlock_memory_hotplug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-introduce-unlock_memory_hotplug
+++ a/mm/memory_hotplug.c
@@ -34,6 +34,23 @@
 
 #include "internal.h"
 
+DEFINE_MUTEX(mem_hotplug_mutex);
+
+void lock_memory_hotplug(void)
+{
+	mutex_lock(&mem_hotplug_mutex);
+
+	/* for exclusive hibernation if CONFIG_HIBERNATION=y */
+	lock_system_sleep();
+}
+
+void unlock_memory_hotplug(void)
+{
+	unlock_system_sleep();
+	mutex_unlock(&mem_hotplug_mutex);
+}
+
+
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
@@ -493,7 +510,7 @@ int mem_online_node(int nid)
 	pg_data_t	*pgdat;
 	int	ret;
 
-	lock_system_sleep();
+	lock_memory_hotplug();
 	pgdat = hotadd_new_pgdat(nid, 0);
 	if (pgdat) {
 		ret = -ENOMEM;
@@ -504,7 +521,7 @@ int mem_online_node(int nid)
 	BUG_ON(ret);
 
 out:
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 
@@ -516,7 +533,7 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
-	lock_system_sleep();
+	lock_memory_hotplug();
 
 	res = register_memory_resource(start, size);
 	ret = -EEXIST;
@@ -563,7 +580,7 @@ error:
 		release_memory_resource(res);
 
 out:
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -791,7 +808,7 @@ static int offline_pages(unsigned long s
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
-	lock_system_sleep();
+	lock_memory_hotplug();
 
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
@@ -880,7 +897,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return 0;
 
 failed_removal:
@@ -891,7 +908,7 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn);
 
 out:
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch
vmstat-fix-dirty-threshold-ordering.patch
linux-next.patch
mem-hotplug-introduce-unlock_memory_hotplug.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch

