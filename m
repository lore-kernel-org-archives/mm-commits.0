From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:51 -0700
Message-ID: <201004221906.o3MJ6pJQ002150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392Ab0DVTH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: add /sys trigger for per-node memory compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: add /sys trigger for per-node memory compaction
From: Mel Gorman <mel@csn.ul.ie>

Add a per-node sysfs file called compact.  When the file is written to,
each zone in that node is compacted.  The intention that this would be
used by something like a job scheduler in a batch system before a job
starts so that the job can allocate the maximum number of hugepages
without significant start-up cost.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-node |    7 +++++
 drivers/base/node.c                          |    3 ++
 include/linux/compaction.h                   |   16 +++++++++++
 mm/compaction.c                              |   23 +++++++++++++++++
 4 files changed, 49 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-devices-node
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-devices-node
@@ -0,0 +1,7 @@
+What:		/sys/devices/system/node/nodeX/compact
+Date:		February 2010
+Contact:	Mel Gorman <mel@csn.ul.ie>
+Description:
+		When this file is written to, all memory within that node
+		will be compacted. When it completes, memory will be freed
+		into blocks which have as many contiguous pages as possible
diff -puN drivers/base/node.c~mm-compaction-add-sys-trigger-for-per-node-memory-compaction drivers/base/node.c
--- a/drivers/base/node.c~mm-compaction-add-sys-trigger-for-per-node-memory-compaction
+++ a/drivers/base/node.c
@@ -9,6 +9,7 @@
 #include <linux/memory.h>
 #include <linux/node.h>
 #include <linux/hugetlb.h>
+#include <linux/compaction.h>
 #include <linux/cpumask.h>
 #include <linux/topology.h>
 #include <linux/nodemask.h>
@@ -246,6 +247,8 @@ int register_node(struct node *node, int
 		scan_unevictable_register_node(node);
 
 		hugetlb_register_node(node);
+
+		compaction_register_node(node);
 	}
 	return error;
 }
diff -puN include/linux/compaction.h~mm-compaction-add-sys-trigger-for-per-node-memory-compaction include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-add-sys-trigger-for-per-node-memory-compaction
+++ a/include/linux/compaction.h
@@ -12,4 +12,20 @@ extern int sysctl_compaction_handler(str
 			void __user *buffer, size_t *length, loff_t *ppos);
 #endif /* CONFIG_COMPACTION */
 
+#if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+extern int compaction_register_node(struct node *node);
+extern void compaction_unregister_node(struct node *node);
+
+#else
+
+static inline int compaction_register_node(struct node *node)
+{
+	return 0;
+}
+
+static inline void compaction_unregister_node(struct node *node)
+{
+}
+#endif /* CONFIG_COMPACTION && CONFIG_SYSFS && CONFIG_NUMA */
+
 #endif /* _LINUX_COMPACTION_H */
diff -puN mm/compaction.c~mm-compaction-add-sys-trigger-for-per-node-memory-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-sys-trigger-for-per-node-memory-compaction
+++ a/mm/compaction.c
@@ -13,6 +13,7 @@
 #include <linux/mm_inline.h>
 #include <linux/backing-dev.h>
 #include <linux/sysctl.h>
+#include <linux/sysfs.h>
 #include "internal.h"
 
 /*
@@ -437,3 +438,25 @@ int sysctl_compaction_handler(struct ctl
 
 	return 0;
 }
+
+#if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+ssize_t sysfs_compact_node(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			const char *buf, size_t count)
+{
+	compact_node(dev->id);
+
+	return count;
+}
+static SYSDEV_ATTR(compact, S_IWUSR, NULL, sysfs_compact_node);
+
+int compaction_register_node(struct node *node)
+{
+	return sysdev_create_file(&node->sysdev, &attr_compact);
+}
+
+void compaction_unregister_node(struct node *node)
+{
+	return sysdev_remove_file(&node->sysdev, &attr_compact);
+}
+#endif /* CONFIG_SYSFS && CONFIG_NUMA */
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

