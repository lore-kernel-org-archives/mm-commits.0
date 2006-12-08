From: akpm@osdl.org
Subject: - ia64-resolve-name-clash-by-renaming-is_available_memory.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:31:29 -0800
Message-ID: <200612080831.kB88VTrr013482@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425176AbWLHIbg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:31:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, artiom.myaskouvskey@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: resolve name clash by renaming is_available_memory()
has been removed from the -mm tree.  Its filename was
     ia64-resolve-name-clash-by-renaming-is_available_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: resolve name clash by renaming is_available_memory()
From: Christoph Lameter <clameter@sgi.com>

There is a name clash with ia64 arch code in Andrew's tree. Rename
is_avialable_memory() to is_memory_available() to avoid the clash.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Artiom Myaskouvskey <artiom.myaskouvskey@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/efi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/efi.c~ia64-resolve-name-clash-by-renaming-is_available_memory arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-resolve-name-clash-by-renaming-is_available_memory
+++ a/arch/ia64/kernel/efi.c
@@ -225,7 +225,7 @@ efi_gettimeofday (struct timespec *ts)
 }
 
 static int
-is_available_memory (efi_memory_desc_t *md)
+is_memory_available (efi_memory_desc_t *md)
 {
 	if (!(md->attribute & EFI_MEMORY_WB))
 		return 0;
@@ -892,7 +892,7 @@ find_memmap_space (void)
 			}
 			contig_high = GRANULEROUNDDOWN(contig_high);
 		}
-		if (!is_available_memory(md) || md->type == EFI_LOADER_DATA)
+		if (!is_memory_available(md) || md->type == EFI_LOADER_DATA)
 			continue;
 
 		/* Round ends inward to granule boundaries */
@@ -968,7 +968,7 @@ efi_memmap_init(unsigned long *s, unsign
 			}
 			contig_high = GRANULEROUNDDOWN(contig_high);
 		}
-		if (!is_available_memory(md))
+		if (!is_memory_available(md))
 			continue;
 
 		/*
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

