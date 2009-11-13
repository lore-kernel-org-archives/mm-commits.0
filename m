From: akpm@linux-foundation.org
Subject: + mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:51:08 -0800
Message-ID: <200911132351.nADNp8cV004510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932506AbZKMXvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, gerald.schaefer@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, rjw@sisk.pl, y-goto@jp.fujitsu.com


The patch titled
     mm: allow memory hotplug and hibernation in the same kernel
has been added to the -mm tree.  Its filename is
     mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch

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
Subject: mm: allow memory hotplug and hibernation in the same kernel
From: Andi Kleen <andi@firstfloor.org>

Allow memory hotplug and hibernation in the same kernel

Memory hotplug and hibernation were exclusive in Kconfig.  This is
obviously a problem for distribution kernels who want to support both in
the same image.

After some discussions with Rafael and others the only problem is with
parallel memory hotadd or removal while a hibernation operation is in
process.  It was also working for s390 before.

This patch removes the Kconfig level exclusion, and simply makes the
memory add / remove functions grab the pm_mutex to exclude against
hibernation.

Fixes a regression - old kernels didn't exclude memory hotadd and
hibernation.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |   21 +++++++++++++++++++--
 mm/Kconfig              |    5 +----
 mm/memory_hotplug.c     |   21 +++++++++++++++++----
 3 files changed, 37 insertions(+), 10 deletions(-)

diff -puN include/linux/suspend.h~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel include/linux/suspend.h
--- a/include/linux/suspend.h~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel
+++ a/include/linux/suspend.h
@@ -301,6 +301,8 @@ static inline int unregister_pm_notifier
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 #endif /* !CONFIG_PM_SLEEP */
 
+extern struct mutex pm_mutex;
+
 #ifndef CONFIG_HIBERNATION
 static inline void register_nosave_region(unsigned long b, unsigned long e)
 {
@@ -308,8 +310,23 @@ static inline void register_nosave_regio
 static inline void register_nosave_region_late(unsigned long b, unsigned long e)
 {
 }
-#endif
 
-extern struct mutex pm_mutex;
+static inline void lock_hibernation(void) {}
+static inline void unlock_hibernation(void) {}
+
+#else
+
+/* Let some subsystems like memory hotadd exclude hibernation */
+
+static inline void lock_hibernation(void)
+{
+	mutex_lock(&pm_mutex);
+}
+
+static inline void unlock_hibernation(void)
+{
+	mutex_unlock(&pm_mutex);
+}
+#endif
 
 #endif /* _LINUX_SUSPEND_H */
diff -puN mm/Kconfig~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel mm/Kconfig
--- a/mm/Kconfig~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel
+++ a/mm/Kconfig
@@ -128,12 +128,9 @@ config SPARSEMEM_VMEMMAP
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
-	depends on HOTPLUG && !(HIBERNATION && !S390) && ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
 
-comment "Memory hotplug is currently incompatible with Software Suspend"
-	depends on SPARSEMEM && HOTPLUG && HIBERNATION && !S390
-
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
 	depends on SPARSEMEM && MEMORY_HOTPLUG
diff -puN mm/memory_hotplug.c~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel
+++ a/mm/memory_hotplug.c
@@ -26,6 +26,7 @@
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
 #include <linux/pfn.h>
+#include <linux/suspend.h>
 
 #include <asm/tlbflush.h>
 
@@ -485,14 +486,18 @@ int __ref add_memory(int nid, u64 start,
 	struct resource *res;
 	int ret;
 
+	lock_hibernation();
+
 	res = register_memory_resource(start, size);
+	ret = -EEXIST;
 	if (!res)
-		return -EEXIST;
+		goto out;
 
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
+		ret = -ENOMEM;
 		if (!pgdat)
-			return -ENOMEM;
+			goto out;
 		new_pgdat = 1;
 	}
 
@@ -515,7 +520,8 @@ int __ref add_memory(int nid, u64 start,
 		BUG_ON(ret);
 	}
 
-	return ret;
+	goto out;
+
 error:
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
@@ -523,6 +529,8 @@ error:
 	if (res)
 		release_memory_resource(res);
 
+out:
+	unlock_hibernation();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -759,6 +767,8 @@ int offline_pages(unsigned long start_pf
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
+	lock_hibernation();
+
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
 	nr_pages = end_pfn - start_pfn;
@@ -766,7 +776,7 @@ int offline_pages(unsigned long start_pf
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn);
 	if (ret)
-		return ret;
+		goto out;
 
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
@@ -844,6 +854,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
+	unlock_hibernation();
 	return 0;
 
 failed_removal:
@@ -853,6 +864,8 @@ failed_removal:
 	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn);
 
+out:
+	unlock_hibernation();
 	return ret;
 }
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch
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
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

