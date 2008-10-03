From: akpm@linux-foundation.org
Subject: + cpualloc-the-allocator.patch added to -mm tree
Date: Fri, 03 Oct 2008 00:34:30 -0700
Message-ID: <200810030734.m937YUtk016754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbYJCHfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 03:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au


The patch titled
     cpualloc: the allocator
has been added to the -mm tree.  Its filename is
     cpualloc-the-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpualloc: the allocator
From: Christoph Lameter <cl@linux-foundation.org>

The per cpu allocator allows dynamic allocation of memory on all
processors simultaneously.  A bitmap is used to track used areas.  The
allocator implements tight packing to reduce the cache footprint and
increase speed since cacheline contention is typically not a concern for
memory mainly used by a single cpu.  Small objects will fill up gaps left
by larger allocations that required alignments.

The size of the cpu_alloc area can be changed via the percpu=xxx kernel
parameter.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |   46 +++++++++
 include/linux/vmstat.h |    2 
 init/main.c            |    2 
 mm/Makefile            |    2 
 mm/cpu_alloc.c         |  185 +++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c            |    1 
 6 files changed, 236 insertions(+), 2 deletions(-)

diff -puN include/linux/percpu.h~cpualloc-the-allocator include/linux/percpu.h
--- a/include/linux/percpu.h~cpualloc-the-allocator
+++ a/include/linux/percpu.h
@@ -114,4 +114,50 @@ static inline void percpu_free(void *__p
 #define free_percpu(ptr)	percpu_free((ptr))
 #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
 
+
+/*
+ * cpu allocator definitions
+ *
+ * The cpu allocator allows allocating an instance of an object for each
+ * processor and the use of a single pointer to access all instances
+ * of the object. cpu_alloc provides optimized means for accessing the
+ * instance of the object belonging to the currently executing processor
+ * as well as special atomic operations on fields of objects of the
+ * currently executing processor.
+ *
+ * Cpu objects are typically small. The allocator packs them tightly
+ * to increase the chance on each access that a per cpu object is already
+ * cached. Alignments may be specified but the intent is to align the data
+ * properly due to cpu alignment constraints and not to avoid cacheline
+ * contention. Any holes left by aligning objects are filled up with smaller
+ * objects that are allocated later.
+ *
+ * Cpu data can be allocated using CPU_ALLOC. The resulting pointer is
+ * pointing to the instance of the variable in the per cpu area provided
+ * by the loader. It is generally an error to use the pointer directly
+ * unless we are booting the system.
+ *
+ * __GFP_ZERO may be passed as a flag to zero the allocated memory.
+ */
+
+/* Return a pointer to the instance of a object for a particular processor */
+#define CPU_PTR(__p, __cpu)	SHIFT_PERCPU_PTR((__p), per_cpu_offset(__cpu))
+
+/*
+ * Return a pointer to the instance of the object belonging to the processor
+ * running the current code.
+ */
+#define THIS_CPU(__p)	SHIFT_PERCPU_PTR((__p), my_cpu_offset)
+#define __THIS_CPU(__p)	SHIFT_PERCPU_PTR((__p), __my_cpu_offset)
+
+#define CPU_ALLOC(type, flags)	((typeof(type) *)cpu_alloc(sizeof(type), (flags), \
+							__alignof__(type)))
+#define CPU_FREE(pointer)	cpu_free((pointer), sizeof(*(pointer)))
+
+/*
+ * Raw calls
+ */
+void *cpu_alloc(unsigned long size, gfp_t flags, unsigned long align);
+void cpu_free(void *cpu_pointer, unsigned long size);
+
 #endif /* __LINUX_PERCPU_H */
diff -puN include/linux/vmstat.h~cpualloc-the-allocator include/linux/vmstat.h
--- a/include/linux/vmstat.h~cpualloc-the-allocator
+++ a/include/linux/vmstat.h
@@ -37,7 +37,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, CPU_BYTES,
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN init/main.c~cpualloc-the-allocator init/main.c
--- a/init/main.c~cpualloc-the-allocator
+++ a/init/main.c
@@ -118,6 +118,7 @@ extern void time_init(void);
 /* Default late time init is NULL. archs can override this later. */
 void (*late_time_init)(void);
 extern void softirq_init(void);
+extern void cpu_alloc_init(void);
 
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
@@ -586,6 +587,7 @@ asmlinkage void __init start_kernel(void
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
 	unwind_setup();
+	cpu_alloc_init();
 	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
diff -puN mm/Makefile~cpualloc-the-allocator mm/Makefile
--- a/mm/Makefile~cpualloc-the-allocator
+++ a/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o $(mmu-y)
+			   page_isolation.o mm_init.o cpu_alloc.o $(mmu-y)
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
diff -puN /dev/null mm/cpu_alloc.c
--- /dev/null
+++ a/mm/cpu_alloc.c
@@ -0,0 +1,185 @@
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
+int units;	/* Actual available units */
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
+		if (start % (align / UNIT_SIZE) == 0 &&
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
+	nr_units = percpu_reserve / UNIT_SIZE;
+
+	cpu_alloc_map = alloc_bootmem(BITS_TO_LONGS(nr_units));
+}
+
diff -puN mm/vmstat.c~cpualloc-the-allocator mm/vmstat.c
--- a/mm/vmstat.c~cpualloc-the-allocator
+++ a/mm/vmstat.c
@@ -677,6 +677,7 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+	"cpu_bytes",
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
git-x86.patch
git-slab.patch
mm-make-do_move_pages-complexity-linear.patch
mm-make-do_move_pages-complexity-linear-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
cpualloc-make-the-per-cpu-reserve-configurable.patch
cpualloc-make-the-per-cpu-reserve-configurable-fix.patch
cpualloc-percpu-rename-variables-percpu_enough_room-percpu_area_size.patch
cpualloc-the-allocator.patch
cpu_alloc-remove-useless-variable.patch
cpualloc-use-cpu-allocator-instead-of-the-builtin-modules-per-cpu-allocator.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
slab-leaks3-default-y.patch

