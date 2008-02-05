From: akpm@linux-foundation.org
Subject: - vmstat-remove-prefetch.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:59 -0800
Message-ID: <200802052231.m15MVeaT012181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760888AbYBEWl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: remove prefetch
has been removed from the -mm tree.  Its filename was
     vmstat-remove-prefetch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: remove prefetch
From: Christoph Lameter <clameter@sgi.com>

Remove the prefetch logic in order to avoid touching impossible per cpu
areas.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN mm/vmstat.c~vmstat-remove-prefetch mm/vmstat.c
--- a/mm/vmstat.c~vmstat-remove-prefetch
+++ a/mm/vmstat.c
@@ -21,21 +21,14 @@ EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
 static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
 {
-	int cpu = 0;
+	int cpu;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	cpu = first_cpu(*cpumask);
-	while (cpu < NR_CPUS) {
+	for_each_cpu_mask(cpu, *cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
-		cpu = next_cpu(cpu, *cpumask);
-
-		if (cpu < NR_CPUS)
-			prefetch(&per_cpu(vm_event_states, cpu));
-
-
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
 			ret[i] += this->event[i];
 	}
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
