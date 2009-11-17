From: akpm@linux-foundation.org
Subject: [folded] mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix.patch removed from -mm tree
Date: Tue, 17 Nov 2009 14:05:13 -0800
Message-ID: <200911172205.nAHM5Di5002336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbZKQWFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 17:05:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, gerald.schaefer@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, rjw@sisk.pl, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix
has been removed from the -mm tree.  Its filename was
     mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix.patch

This patch was dropped because it was folded into mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix
From: Andi Kleen <andi@firstfloor.org>

v2: Rename lock_hibernation to lock_system_sleep

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    8 ++++----
 mm/memory_hotplug.c     |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/suspend.h~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix include/linux/suspend.h
--- a/include/linux/suspend.h~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix
+++ a/include/linux/suspend.h
@@ -311,19 +311,19 @@ static inline void register_nosave_regio
 {
 }
 
-static inline void lock_hibernation(void) {}
-static inline void unlock_hibernation(void) {}
+static inline void lock_system_sleep(void) {}
+static inline void unlock_system_sleep(void) {}
 
 #else
 
 /* Let some subsystems like memory hotadd exclude hibernation */
 
-static inline void lock_hibernation(void)
+static inline void lock_system_sleep(void)
 {
 	mutex_lock(&pm_mutex);
 }
 
-static inline void unlock_hibernation(void)
+static inline void unlock_system_sleep(void)
 {
 	mutex_unlock(&pm_mutex);
 }
diff -puN mm/memory_hotplug.c~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix
+++ a/mm/memory_hotplug.c
@@ -486,7 +486,7 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
-	lock_hibernation();
+	lock_system_sleep();
 
 	res = register_memory_resource(start, size);
 	ret = -EEXIST;
@@ -530,7 +530,7 @@ error:
 		release_memory_resource(res);
 
 out:
-	unlock_hibernation();
+	unlock_system_sleep();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -767,7 +767,7 @@ int offline_pages(unsigned long start_pf
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
-	lock_hibernation();
+	lock_system_sleep();
 
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
@@ -854,7 +854,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
-	unlock_hibernation();
+	unlock_system_sleep();
 	return 0;
 
 failed_removal:
@@ -865,7 +865,7 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn);
 
 out:
-	unlock_hibernation();
+	unlock_system_sleep();
 	return ret;
 }
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch
mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel-fix.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-exit-early-when-invoked-with-d-describe.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-memory_hotplug-make-offline_pages-static.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

