From: akpm@linux-foundation.org
Subject: + ia64-fix-arch-ia64-kernel-iosapicc-build.patch added to -mm tree
Date: Tue, 28 Oct 2008 21:42:59 -0700
Message-ID: <200810290457.m9T4vo5u008504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYJ2E54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 00:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tony.luck@intel.com


The patch titled
     ia64: fix arch/ia64/kernel/iosapic.c build
has been added to the -mm tree.  Its filename is
     ia64-fix-arch-ia64-kernel-iosapicc-build.patch

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
Subject: ia64: fix arch/ia64/kernel/iosapic.c build
From: Andrew Morton <akpm@linux-foundation.org>

- someone can't type (or test)

- nr_cpu_ids is declared in cpumask.h.  Include it.

Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/iosapic.c |    3 
 mm/cpu_alloc.c             |  188 +++++++++++++++++++++++++++++++++++
 2 files changed, 190 insertions(+), 1 deletion(-)

diff -puN /dev/null mm/cpu_alloc.c
--- /dev/null
+++ a/mm/cpu_alloc.c
@@ -0,0 +1,188 @@
+/*
+ * Cpu allocator - Manage objects allocated for each processor
+ *
+ * (C) 2008 SGI, Christoph Lameter <cl@linux-foundation.org>
+ * 	Basic implementation with allocation and free from a dedicated per
+ * 	cpu area.
+ *
+ * The per cpu allocator allows a dynamic allocation of a piece of memory on
+ * every processor. A bitmap is used to track used areas.
+ * The allocator implements tight packing to reduce the cache footprint
+ * and increase speed since cacheline contention is typically not a concern
+ * for memory mainly used by a single cpu. Small objects will fill up gaps
+ * left by larger allocations that required alignments.
+ */
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/bitmap.h>
+#include <asm/sections.h>
+#include <linux/bootmem.h>
+
+/*
+ * Basic allocation unit. A bit map is created to track the use of each
+ * UNIT_SIZE element in the cpu area.
+ */
+#define UNIT_TYPE int
+#define UNIT_SIZE sizeof(UNIT_TYPE)
+
+/*
+ * How many units are needed for an object of a given size
+ */
+static int size_to_units(unsigned long size)
+{
+	return DIV_ROUND_UP(size, UNIT_SIZE);
+}
+
+/*
+ * Lock to protect the bitmap and the meta data for the cpu allocator.
+ */
+static DEFINE_SPINLOCK(cpu_alloc_map_lock);
+static unsigned long *cpu_alloc_map;
+static int nr_units;		/* Number of available units */
+static int first_free;		/* First known free unit */
+static int base_percpu_in_units; /* Size of base percpu area in units */
+
+/*
+ * Mark an object as used in the cpu_alloc_map
+ *
+ * Must hold cpu_alloc_map_lock
+ */
+static void set_map(int start, int length)
+{
+	while (length-- > 0)
+		__set_bit(start++, cpu_alloc_map);
+}
+
+/*
+ * Mark an area as freed.
+ *
+ * Must hold cpu_alloc_map_lock
+ */
+static void clear_map(int start, int length)
+{
+	while (length-- > 0)
+		__clear_bit(start++, cpu_alloc_map);
+}
+
+/*
+ * Allocate an object of a certain size
+ *
+ * Returns a special pointer that can be used with CPU_PTR to find the
+ * address of the object for a certain cpu.
+ */
+void *cpu_alloc(unsigned long size, gfp_t gfpflags, unsigned long align)
+{
+	unsigned long start;
+	int units = size_to_units(size);
+	void *ptr;
+	int first;
+	unsigned long flags;
+
+	if (!size)
+		return ZERO_SIZE_PTR;
+
+	WARN_ON(align > PAGE_SIZE);
+
+	if (align < UNIT_SIZE)
+		align = UNIT_SIZE;
+
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+
+	first = 1;
+	start = first_free;
+
+	for ( ; ; ) {
+
+		start = find_next_zero_bit(cpu_alloc_map, nr_units, start);
+		if (start >= nr_units)
+			goto out_of_memory;
+
+		if (first)
+			first_free = start;
+
+		/*
+		 * Check alignment and that there is enough space after
+		 * the starting unit.
+		 */
+		if ((base_percpu_in_units + start) %
+					(align / UNIT_SIZE) == 0 &&
+			find_next_bit(cpu_alloc_map, nr_units, start + 1)
+					>= start + units)
+				break;
+		start++;
+		first = 0;
+	}
+
+	if (first)
+		first_free = start + units;
+
+	if (start + units > nr_units)
+		goto out_of_memory;
+
+	set_map(start, units);
+	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
+
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+
+	ptr = (int *)__per_cpu_end + start;
+
+	if (gfpflags & __GFP_ZERO) {
+		int cpu;
+
+		for_each_possible_cpu(cpu)
+			memset(CPU_PTR(ptr, cpu), 0, size);
+	}
+
+	return ptr;
+
+out_of_memory:
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+	return NULL;
+}
+EXPORT_SYMBOL(cpu_alloc);
+
+/*
+ * Free an object. The pointer must be a cpu pointer allocated
+ * via cpu_alloc.
+ */
+void cpu_free(void *start, unsigned long size)
+{
+	unsigned long units = size_to_units(size);
+	unsigned long index = (int *)start - (int *)__per_cpu_end;
+	unsigned long flags;
+
+	if (!start || start == ZERO_SIZE_PTR)
+		return;
+
+	if (WARN_ON(index >= nr_units))
+		return;
+
+	if (WARN_ON(!test_bit(index, cpu_alloc_map) ||
+		!test_bit(index + units - 1, cpu_alloc_map)))
+			return;
+
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
+
+	clear_map(index, units);
+	__count_vm_events(CPU_BYTES, -units * UNIT_SIZE);
+
+	if (index < first_free)
+		first_free = index;
+
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
+}
+EXPORT_SYMBOL(cpu_free);
+
+
+void __init cpu_alloc_init(void)
+{
+	base_percpu_in_units = (__per_cpu_end - __per_cpu_start
+					+ UNIT_SIZE - 1) / UNIT_SIZE;
+
+	nr_units = PERCPU_AREA_SIZE / UNIT_SIZE - base_percpu_in_units;
+
+	cpu_alloc_map = alloc_bootmem(BITS_TO_LONGS(nr_units));
+}
+
diff -puN arch/ia64/kernel/iosapic.c~ia64-fix-arch-ia64-kernel-iosapicc-build arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~ia64-fix-arch-ia64-kernel-iosapicc-build
+++ a/arch/ia64/kernel/iosapic.c
@@ -85,6 +85,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/cpumask.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
 #include <linux/string.h>
@@ -720,7 +721,7 @@ get_target_cpu (unsigned int gsi, int ir
 		for (numa_cpu = first_cpu(cpu_mask) ; i < cpu_index ; i++)
 			numa_cpu = next_cpu(numa_cpu, cpu_mask);
 
-		if (numa_cpu < nr_cpus_ids)
+		if (numa_cpu < nr_cpu_ids)
 			return cpu_physical_id(numa_cpu);
 	}
 skip_numa_setup:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
nfsd-fix-vm-overcommit-crash-checkpatch-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
ia64-fix-arch-ia64-kernel-iosapicc-build.patch
ia64-fix-arch-ia64-kernel-iosapicc-build.patch

