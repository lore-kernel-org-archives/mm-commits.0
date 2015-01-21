From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-vmstatc-fix-cleanup-ifdefs-fix.patch
 removed from -mm tree
Date: Wed, 21 Jan 2015 14:31:01 -0800
Message-ID: <54c028a5.allsqUWhqHYEs4hi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbAUWbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jan 2015 17:31:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, iamjoonsoo.kim@lge.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstatc-fix-cleanup-ifdefs-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-fix-cleanup-ifdefs-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstatc-fix-cleanup-ifdefs-fix

iterate, iterate

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN mm/vmstat.c~mm-vmstatc-fix-cleanup-ifdefs-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-fix-cleanup-ifdefs-fix
+++ a/mm/vmstat.c
@@ -872,19 +872,8 @@ static void walk_zones_in_node(struct se
 }
 #endif
 
-#ifdef CONFIG_PROC_FS
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
+#if	defined(CONFIG_PROC_FS) || \
+	defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
 
 static void *frag_start(struct seq_file *m, loff_t *pos)
 {
@@ -909,6 +898,21 @@ static void *frag_next(struct seq_file *
 static void frag_stop(struct seq_file *m, void *arg)
 {
 }
+#endif
+
+#ifdef CONFIG_PROC_FS
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
 
 static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 						struct zone *zone)
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
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

