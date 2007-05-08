From: akpm@linux-foundation.org
Subject: - oom-fix-constraint-deadlock.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:36 -0700
Message-ID: <200705080003.l4803ar2008964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967366AbXEHAFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, mbligh@mbligh.org, npiggin@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oom: fix constraint deadlock
has been removed from the -mm tree.  Its filename was
     oom-fix-constraint-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: fix constraint deadlock
From: David Rientjes <rientjes@google.com>

Fixes a deadlock in the OOM killer for allocations that are not
__GFP_HARDWALL.

Before the OOM killer checks for the allocation constraint, it takes
callback_mutex.

constrained_alloc() iterates through each zone in the allocation zonelist
and calls cpuset_zone_allowed_softwall() to determine whether an allocation
for gfp_mask is possible.  If a zone's node is not in the OOM-triggering
task's mems_allowed, it is not exiting, and we did not fail on a
__GFP_HARDWALL allocation, cpuset_zone_allowed_softwall() attempts to take
callback_mutex to check the nearest exclusive ancestor of current's cpuset.
 This results in deadlock.

We now take callback_mutex after iterating through the zonelist since we
don't need it yet.

Cc: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Martin J. Bligh <mbligh@mbligh.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-fix-constraint-deadlock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-constraint-deadlock
+++ a/mm/oom_kill.c
@@ -399,6 +399,7 @@ void out_of_memory(struct zonelist *zone
 	struct task_struct *p;
 	unsigned long points = 0;
 	unsigned long freed = 0;
+	int constraint;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -416,14 +417,15 @@ void out_of_memory(struct zonelist *zone
 	if (sysctl_panic_on_oom == 2)
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 
-	cpuset_lock();
-	read_lock(&tasklist_lock);
-
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	switch (constrained_alloc(zonelist, gfp_mask)) {
+	constraint = constrained_alloc(zonelist, gfp_mask);
+	cpuset_lock();
+	read_lock(&tasklist_lock);
+
+	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
 		oom_kill_process(current, points,
 				"No available memory (MPOL_BIND)");
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
