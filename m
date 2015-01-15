From: akpm@linux-foundation.org
Subject: + mm-vmstatc-fix-cleanup-ifdefs.patch added to -mm tree
Date: Thu, 15 Jan 2015 15:47:17 -0800
Message-ID: <54b85185.8gZh2A8udqSYd2T3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbAOXra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:47:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: fix/cleanup ifdefs
has been added to the -mm tree.  Its filename is
     mm-vmstatc-fix-cleanup-ifdefs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstatc-fix-cleanup-ifdefs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstatc-fix-cleanup-ifdefs.patch

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
Subject: mm/vmstat.c: fix/cleanup ifdefs

CONFIG_COMPACTION=y, CONFIG_DEBUG_FS=n:

mm/vmstat.c:690: warning: 'frag_start' defined but not used
mm/vmstat.c:702: warning: 'frag_next' defined but not used
mm/vmstat.c:710: warning: 'frag_stop' defined but not used
mm/vmstat.c:715: warning: 'walk_zones_in_node' defined but not used

It's all a bit of a tangly mess and it's unclear why CONFIG_COMPACTION
figures in there at all.  Move frag_start/frag_next/frag_stop and
migratetype_names[] into the existing CONFIG_PROC_FS block.

walk_zones_in_node() gets a special ifdef.

Also move the #include lines up to where #include lines live.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |  124 +++++++++++++++++++++++++-------------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff -puN mm/vmstat.c~mm-vmstatc-fix-cleanup-ifdefs mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-fix-cleanup-ifdefs
+++ a/mm/vmstat.c
@@ -17,6 +17,9 @@
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/vmstat.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/math64.h>
 #include <linux/writeback.h>
@@ -670,66 +673,6 @@ int fragmentation_index(struct zone *zon
 }
 #endif
 
-#if defined(CONFIG_PROC_FS) || defined(CONFIG_COMPACTION)
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-
-static char * const migratetype_names[MIGRATE_TYPES] = {
-	"Unmovable",
-	"Reclaimable",
-	"Movable",
-	"Reserve",
-#ifdef CONFIG_CMA
-	"CMA",
-#endif
-#ifdef CONFIG_MEMORY_ISOLATION
-	"Isolate",
-#endif
-};
-
-static void *frag_start(struct seq_file *m, loff_t *pos)
-{
-	pg_data_t *pgdat;
-	loff_t node = *pos;
-	for (pgdat = first_online_pgdat();
-	     pgdat && node;
-	     pgdat = next_online_pgdat(pgdat))
-		--node;
-
-	return pgdat;
-}
-
-static void *frag_next(struct seq_file *m, void *arg, loff_t *pos)
-{
-	pg_data_t *pgdat = (pg_data_t *)arg;
-
-	(*pos)++;
-	return next_online_pgdat(pgdat);
-}
-
-static void frag_stop(struct seq_file *m, void *arg)
-{
-}
-
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
-
-		spin_lock_irqsave(&zone->lock, flags);
-		print(m, pgdat, zone);
-		spin_unlock_irqrestore(&zone->lock, flags);
-	}
-}
-#endif
-
 #if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS) || defined(CONFIG_NUMA)
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
@@ -907,7 +850,66 @@ const char * const vmstat_text[] = {
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
 
 
+#if (defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)) || \
+     defined(CONFIG_PROC_FS)
+
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
+#endif
+
 #ifdef CONFIG_PROC_FS
+static char * const migratetype_names[MIGRATE_TYPES] = {
+	"Unmovable",
+	"Reclaimable",
+	"Movable",
+	"Reserve",
+#ifdef CONFIG_CMA
+	"CMA",
+#endif
+#ifdef CONFIG_MEMORY_ISOLATION
+	"Isolate",
+#endif
+};
+
+static void *frag_start(struct seq_file *m, loff_t *pos)
+{
+	pg_data_t *pgdat;
+	loff_t node = *pos;
+	for (pgdat = first_online_pgdat();
+	     pgdat && node;
+	     pgdat = next_online_pgdat(pgdat))
+		--node;
+
+	return pgdat;
+}
+
+static void *frag_next(struct seq_file *m, void *arg, loff_t *pos)
+{
+	pg_data_t *pgdat = (pg_data_t *)arg;
+
+	(*pos)++;
+	return next_online_pgdat(pgdat);
+}
+
+static void frag_stop(struct seq_file *m, void *arg)
+{
+}
+
 static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 						struct zone *zone)
 {
@@ -1536,8 +1538,6 @@ static int __init setup_vmstat(void)
 module_init(setup_vmstat)
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
-#include <linux/debugfs.h>
-
 
 /*
  * Return an index indicating how much of the available free memory is
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
dax-add-dax_zero_page_range-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

