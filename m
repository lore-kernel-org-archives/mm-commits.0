From: akpm@linux-foundation.org
Subject: - vmstat-small-revisions-to-refresh_cpu_vm_stats.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:46 -0800
Message-ID: <200802052231.m15MVRo9012166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760594AbYBEWlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: small revisions to refresh_cpu_vm_stats()
has been removed from the -mm tree.  Its filename was
     vmstat-small-revisions-to-refresh_cpu_vm_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: small revisions to refresh_cpu_vm_stats()
From: Christoph Lameter <clameter@sgi.com>

1. Add comments explaining how the function can be called.

2. Collect global diffs in a local array and only spill
   them once into the global counters when the zone scan
   is finished. This means that we only touch each global
   counter once instead of each time we fold cpu counters
   into zone counters.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/vmstat.c~vmstat-small-revisions-to-refresh_cpu_vm_stats mm/vmstat.c
--- a/mm/vmstat.c~vmstat-small-revisions-to-refresh_cpu_vm_stats
+++ a/mm/vmstat.c
@@ -284,6 +284,10 @@ EXPORT_SYMBOL(dec_zone_page_state);
 /*
  * Update the zone counters for one cpu.
  *
+ * The cpu specified must be either the current cpu or a processor that
+ * is not online. If it is the current cpu then the execution thread must
+ * be pinned to the current cpu.
+ *
  * Note that refresh_cpu_vm_stats strives to only access
  * node local memory. The per cpu pagesets on remote zones are placed
  * in the memory local to the processor using that pageset. So the
@@ -299,7 +303,7 @@ void refresh_cpu_vm_stats(int cpu)
 {
 	struct zone *zone;
 	int i;
-	unsigned long flags;
+	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 
 	for_each_zone(zone) {
 		struct per_cpu_pageset *p;
@@ -311,15 +315,19 @@ void refresh_cpu_vm_stats(int cpu)
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 			if (p->vm_stat_diff[i]) {
+				unsigned long flags;
+				int v;
+
 				local_irq_save(flags);
-				zone_page_state_add(p->vm_stat_diff[i],
-					zone, i);
+				v = p->vm_stat_diff[i];
 				p->vm_stat_diff[i] = 0;
+				local_irq_restore(flags);
+				atomic_long_add(v, &zone->vm_stat[i]);
+				global_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
 				p->expire = 3;
 #endif
-				local_irq_restore(flags);
 			}
 #ifdef CONFIG_NUMA
 		/*
@@ -351,6 +359,10 @@ void refresh_cpu_vm_stats(int cpu)
 			drain_zone_pages(zone, p->pcp + 1);
 #endif
 	}
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		if (global_diff[i])
+			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
 #endif
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
