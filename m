From: akpm@linux-foundation.org
Subject: [merged] mm-memblockc-memblock_double_array-cosmetic-cleanups.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:09 -0700
Message-ID: <20120801201310.2C1455C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35308 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:13 -0400
Received: by lbbgp10 with SMTP id gp10so47325lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, greg.pearson@hp.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c:memblock_double_array(): cosmetic cleanups
has been removed from the -mm tree.  Its filename was
     mm-memblockc-memblock_double_array-cosmetic-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memblock.c:memblock_double_array(): cosmetic cleanups

This function is an 80-column eyesore, quite unnecessarily.  Clean that
up, and use standard comment layout style.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Pearson <greg.pearson@hp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-memblock_double_array-cosmetic-cleanups mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-memblock_double_array-cosmetic-cleanups
+++ a/mm/memblock.c
@@ -222,13 +222,13 @@ static int __init_memblock memblock_doub
 	/* Try to find some space for it.
 	 *
 	 * WARNING: We assume that either slab_is_available() and we use it or
-	 * we use MEMBLOCK for allocations. That means that this is unsafe to use
-	 * when bootmem is currently active (unless bootmem itself is implemented
-	 * on top of MEMBLOCK which isn't the case yet)
+	 * we use MEMBLOCK for allocations. That means that this is unsafe to
+	 * use when bootmem is currently active (unless bootmem itself is
+	 * implemented on top of MEMBLOCK which isn't the case yet)
 	 *
 	 * This should however not be an issue for now, as we currently only
-	 * call into MEMBLOCK while it's still active, or much later when slab is
-	 * active for memory hotplug operations
+	 * call into MEMBLOCK while it's still active, or much later when slab
+	 * is active for memory hotplug operations
 	 */
 	if (use_slab) {
 		new_array = kmalloc(new_size, GFP_KERNEL);
@@ -243,8 +243,8 @@ static int __init_memblock memblock_doub
 						new_alloc_size, PAGE_SIZE);
 		if (!addr && new_area_size)
 			addr = memblock_find_in_range(0,
-					min(new_area_start, memblock.current_limit),
-					new_alloc_size, PAGE_SIZE);
+				min(new_area_start, memblock.current_limit),
+				new_alloc_size, PAGE_SIZE);
 
 		new_array = addr ? __va(addr) : 0;
 	}
@@ -254,12 +254,14 @@ static int __init_memblock memblock_doub
 		return -1;
 	}
 
-	memblock_dbg("memblock: %s array is doubled to %ld at [%#010llx-%#010llx]",
-		 memblock_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size - 1);
+	memblock_dbg("memblock: %s is doubled to %ld at [%#010llx-%#010llx]",
+			memblock_type_name(type), type->max * 2, (u64)addr,
+			(u64)addr + new_size - 1);
 
-	/* Found space, we now need to move the array over before
-	 * we add the reserved region since it may be our reserved
-	 * array itself that is full.
+	/*
+	 * Found space, we now need to move the array over before we add the
+	 * reserved region since it may be our reserved array itself that is
+	 * full.
 	 */
 	memcpy(new_array, type->regions, old_size);
 	memset(new_array + type->max, 0, old_size);
@@ -267,17 +269,16 @@ static int __init_memblock memblock_doub
 	type->regions = new_array;
 	type->max <<= 1;
 
-	/* Free old array. We needn't free it if the array is the
-	 * static one
-	 */
+	/* Free old array. We needn't free it if the array is the static one */
 	if (*in_slab)
 		kfree(old_array);
 	else if (old_array != memblock_memory_init_regions &&
 		 old_array != memblock_reserved_init_regions)
 		memblock_free(__pa(old_array), old_alloc_size);
 
-	/* Reserve the new array if that comes from the memblock.
-	 * Otherwise, we needn't do it
+	/*
+	 * Reserve the new array if that comes from the memblock.  Otherwise, we
+	 * needn't do it
 	 */
 	if (!use_slab)
 		BUG_ON(memblock_reserve(addr, new_alloc_size));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
mm-slab_commonc-fix-warning.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

