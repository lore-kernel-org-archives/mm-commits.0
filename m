From: akpm@linux-foundation.org
Subject: +
 mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
 added to -mm tree
Date: Fri, 25 Aug 2017 14:14:13 -0700
Message-ID: <59a09325.hh8dpSog/wyjDqwP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932374AbdHYVOO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 17:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kemi.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch

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
Subject: mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#249: FILE: include/linux/vmstat.h:222:
+extern void __inc_numa_state(struct zone * zone,

WARNING: line over 80 characters
#402: FILE: mm/vmstat.c:768:
+	changes += fold_diff(global_zone_diff, global_numa_diff, global_node_diff);

WARNING: Missing a blank line after declarations
#459: FILE: mm/vmstat.c:862:
+			int v = pset->vm_numa_stat_diff[i];
+			pset->vm_numa_stat_diff[i] = 0;

ERROR: space required before the open parenthesis '('
#571: FILE: mm/vmstat.c:1641:
+	for(i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)

WARNING: line over 80 characters
#588: FILE: mm/vmstat.c:1752:
+				__func__, vmstat_text[i + NR_VM_ZONE_STAT_ITEMS], val);

total: 2 errors, 4 warnings, 460 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-change-the-call-sites-of-numa-statistics-items.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kemi Wang <kemi.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    8 +++-----
 mm/vmstat.c            |    6 ++++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/vmstat.h~mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes
+++ a/include/linux/vmstat.h
@@ -219,12 +219,10 @@ static inline unsigned long node_page_st
 
 
 #ifdef CONFIG_NUMA
-extern void __inc_numa_state(struct zone * zone,
-						enum numa_stat_item item);
+extern void __inc_numa_state(struct zone *zone, enum numa_stat_item item);
 extern unsigned long sum_zone_node_page_state(int node,
-						enum zone_stat_item item);
-extern unsigned long sum_zone_numa_state(int node,
-						enum numa_stat_item item);
+					      enum zone_stat_item item);
+extern unsigned long sum_zone_numa_state(int node, enum numa_stat_item item);
 extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
 #else
diff -puN mm/vmstat.c~mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes mm/vmstat.c
--- a/mm/vmstat.c~mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes
+++ a/mm/vmstat.c
@@ -765,7 +765,8 @@ static int refresh_cpu_vm_stats(bool do_
 	}
 
 #ifdef CONFIG_NUMA
-	changes += fold_diff(global_zone_diff, global_numa_diff, global_node_diff);
+	changes += fold_diff(global_zone_diff, global_numa_diff,
+			     global_node_diff);
 #else
 	changes += fold_diff(global_zone_diff, global_node_diff);
 #endif
@@ -859,6 +860,7 @@ void drain_zonestat(struct zone *zone, s
 	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
 		if (pset->vm_numa_stat_diff[i]) {
 			int v = pset->vm_numa_stat_diff[i];
+
 			pset->vm_numa_stat_diff[i] = 0;
 			atomic_long_add(v, &zone->vm_numa_stat[i]);
 			atomic_long_add(v, &vm_numa_stat[i]);
@@ -1638,7 +1640,7 @@ static void *vmstat_start(struct seq_fil
 	v += NR_VM_ZONE_STAT_ITEMS;
 
 #ifdef CONFIG_NUMA
-	for(i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++)
 		v[i] = global_numa_state(i);
 	v += NR_VM_NUMA_STAT_ITEMS;
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

