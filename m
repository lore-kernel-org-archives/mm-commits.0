From: akpm@linux-foundation.org
Subject: [to-be-updated] vmstat-fix-build-errors-when-proc_fs-is-disabled.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:07:02 -0700
Message-ID: <201004221907.o3MJ72fw002165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab0DVTHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     vmstat: fix build errors when PROC_FS is disabled
has been removed from the -mm tree.  Its filename was
     vmstat-fix-build-errors-when-proc_fs-is-disabled.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: fix build errors when PROC_FS is disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix vmstat.c to build when CONFIG_PROC_FS is disabled
but CONFIG_DEBUG_FS is enabled.

Fixes around 25 errors.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |  119 ++++++++++++++++++++++++--------------------------
 1 file changed, 59 insertions(+), 60 deletions(-)

diff -puN mm/vmstat.c~vmstat-fix-build-errors-when-proc_fs-is-disabled mm/vmstat.c
--- a/mm/vmstat.c~vmstat-fix-build-errors-when-proc_fs-is-disabled
+++ a/mm/vmstat.c
@@ -16,6 +16,7 @@
 #include <linux/cpu.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/math64.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
@@ -380,18 +381,57 @@ void zone_statistics(struct zone *prefer
 }
 #endif
 
-#ifdef CONFIG_PROC_FS
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-
-static char * const migratetype_names[MIGRATE_TYPES] = {
-	"Unmovable",
-	"Reclaimable",
-	"Movable",
-	"Reserve",
-	"Isolate",
+struct contig_page_info {
+	unsigned long free_pages;
+	unsigned long free_blocks_total;
+	unsigned long free_blocks_suitable;
 };
 
+/* Walk all the zones in a node and print using a callback */
+static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
+		void (*print)(struct seq_file *m, pg_data_t *, struct zone *))
+{
+	struct zone *zone;
+	struct zone *node_zones = pgdat->node_zones;
+	unsigned long flags;
+
+	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
+		if (!populated_zone(zone))
+			continue;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		print(m, pgdat, zone);
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+}
+
+/*
+ * A fragmentation index only makes sense if an allocation of a requested
+ * size would fail. If that is true, the fragmentation index indicates
+ * whether external fragmentation or a lack of memory was the problem.
+ * The value can be used to determine if page reclaim or compaction
+ * should be used
+ */
+int __fragmentation_index(unsigned int order, struct contig_page_info *info)
+{
+	unsigned long requested = 1UL << order;
+
+	if (!info->free_blocks_total)
+		return 0;
+
+	/* Fragmentation index only makes sense when a request would fail */
+	if (info->free_blocks_suitable)
+		return -1000;
+
+	/*
+	 * Index is between 0 and 1 so return within 3 decimal places
+	 *
+	 * 0 => allocation would fail due to lack of memory
+	 * 1 => allocation would fail due to fragmentation
+	 */
+	return 1000 - div_u64( (1000+(div_u64(info->free_pages * 1000ULL, requested))), info->free_blocks_total);
+}
+
 static void *frag_start(struct seq_file *m, loff_t *pos)
 {
 	pg_data_t *pgdat;
@@ -416,23 +456,16 @@ static void frag_stop(struct seq_file *m
 {
 }
 
-/* Walk all the zones in a node and print using a callback */
-static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
-		void (*print)(struct seq_file *m, pg_data_t *, struct zone *))
-{
-	struct zone *zone;
-	struct zone *node_zones = pgdat->node_zones;
-	unsigned long flags;
-
-	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
-		if (!populated_zone(zone))
-			continue;
+#ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
 
-		spin_lock_irqsave(&zone->lock, flags);
-		print(m, pgdat, zone);
-		spin_unlock_irqrestore(&zone->lock, flags);
-	}
-}
+static char * const migratetype_names[MIGRATE_TYPES] = {
+	"Unmovable",
+	"Reclaimable",
+	"Movable",
+	"Reserve",
+	"Isolate",
+};
 
 static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 						struct zone *zone)
@@ -455,39 +488,6 @@ static int frag_show(struct seq_file *m,
 	return 0;
 }
 
-struct contig_page_info {
-	unsigned long free_pages;
-	unsigned long free_blocks_total;
-	unsigned long free_blocks_suitable;
-};
-
-/*
- * A fragmentation index only makes sense if an allocation of a requested
- * size would fail. If that is true, the fragmentation index indicates
- * whether external fragmentation or a lack of memory was the problem.
- * The value can be used to determine if page reclaim or compaction
- * should be used
- */
-int __fragmentation_index(unsigned int order, struct contig_page_info *info)
-{
-	unsigned long requested = 1UL << order;
-
-	if (!info->free_blocks_total)
-		return 0;
-
-	/* Fragmentation index only makes sense when a request would fail */
-	if (info->free_blocks_suitable)
-		return -1000;
-
-	/*
-	 * Index is between 0 and 1 so return within 3 decimal places
-	 *
-	 * 0 => allocation would fail due to lack of memory
-	 * 1 => allocation would fail due to fragmentation
-	 */
-	return 1000 - div_u64( (1000+(div_u64(info->free_pages * 1000ULL, requested))), info->free_blocks_total);
-}
-
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -999,7 +999,6 @@ module_init(setup_vmstat)
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
-#include <linux/seq_file.h>
 
 static struct dentry *extfrag_debug_root;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uv_irqc-fix-all-sparse-warnings.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

