From: akpm@linux-foundation.org
Subject: + mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:17 -0700
Message-ID: <201004070007.o3707Idd016404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932303Ab0DGAHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: add /sys trigger for per-node memory compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch

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

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

