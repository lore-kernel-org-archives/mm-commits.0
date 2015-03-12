From: akpm@linux-foundation.org
Subject: + mm-move-memtest-under-mm.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:41:49 -0700
Message-ID: <5501fa0d.BbIxiO8VyjLajgQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbCLUlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     patterns and validates memory contents, if bad memory regions is detected
has been added to the -mm tree.  Its filename is
     mm-move-memtest-under-mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-memtest-under-mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-memtest-under-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Memtest is a simple feature which fills the memory with a given set of
patterns and validates memory contents, if bad memory regions is detected
it reserves them via memblock API.  Since memblock API is widely used by
other architectures this feature can be enabled outside of x86 world.

This patch set promotes memtest to live under generic mm umbrella and
enables memtest feature for arm/arm64.

It was reported that this patch set was useful for tracking down an issue
with some errant DMA on an arm64 platform.



This patch (of 6):

There is nothing platform dependent in the core memtest code, so other
platforms might benefit from this feature too.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig            |   11 ---
 arch/x86/include/asm/e820.h |    8 --
 arch/x86/mm/Makefile        |    2 
 arch/x86/mm/memtest.c       |  118 ----------------------------------
 include/linux/memblock.h    |    8 ++
 lib/Kconfig.debug           |   11 +++
 mm/Makefile                 |    1 
 mm/memtest.c                |  118 ++++++++++++++++++++++++++++++++++
 8 files changed, 138 insertions(+), 139 deletions(-)

diff -puN arch/x86/Kconfig~mm-move-memtest-under-mm arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-move-memtest-under-mm
+++ a/arch/x86/Kconfig
@@ -723,17 +723,6 @@ endif #HYPERVISOR_GUEST
 config NO_BOOTMEM
 	def_bool y
 
-config MEMTEST
-	bool "Memtest"
-	---help---
-	  This option adds a kernel parameter 'memtest', which allows memtest
-	  to be set.
-	        memtest=0, mean disabled; -- default
-	        memtest=1, mean do 1 test pattern;
-	        ...
-	        memtest=4, mean do 4 test patterns.
-	  If you are unsure how to answer this question, answer N.
-
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
diff -puN arch/x86/include/asm/e820.h~mm-move-memtest-under-mm arch/x86/include/asm/e820.h
--- a/arch/x86/include/asm/e820.h~mm-move-memtest-under-mm
+++ a/arch/x86/include/asm/e820.h
@@ -40,14 +40,6 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
-#ifdef CONFIG_MEMTEST
-extern void early_memtest(unsigned long start, unsigned long end);
-#else
-static inline void early_memtest(unsigned long start, unsigned long end)
-{
-}
-#endif
-
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
 extern u64 early_reserve_e820(u64 sizet, u64 align);
diff -puN arch/x86/mm/Makefile~mm-move-memtest-under-mm arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile~mm-move-memtest-under-mm
+++ a/arch/x86/mm/Makefile
@@ -32,6 +32,4 @@ obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
-obj-$(CONFIG_MEMTEST)		+= memtest.o
-
 obj-$(CONFIG_X86_INTEL_MPX)	+= mpx.o
diff -puN arch/x86/mm/memtest.c~mm-move-memtest-under-mm /dev/null
--- a/arch/x86/mm/memtest.c
+++ /dev/null
@@ -1,118 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/init.h>
-#include <linux/pfn.h>
-#include <linux/memblock.h>
-
-static u64 patterns[] __initdata = {
-	/* The first entry has to be 0 to leave memtest with zeroed memory */
-	0,
-	0xffffffffffffffffULL,
-	0x5555555555555555ULL,
-	0xaaaaaaaaaaaaaaaaULL,
-	0x1111111111111111ULL,
-	0x2222222222222222ULL,
-	0x4444444444444444ULL,
-	0x8888888888888888ULL,
-	0x3333333333333333ULL,
-	0x6666666666666666ULL,
-	0x9999999999999999ULL,
-	0xccccccccccccccccULL,
-	0x7777777777777777ULL,
-	0xbbbbbbbbbbbbbbbbULL,
-	0xddddddddddddddddULL,
-	0xeeeeeeeeeeeeeeeeULL,
-	0x7a6c7258554e494cULL, /* yeah ;-) */
-};
-
-static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
-{
-	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
-	       (unsigned long long) pattern,
-	       (unsigned long long) start_bad,
-	       (unsigned long long) end_bad);
-	memblock_reserve(start_bad, end_bad - start_bad);
-}
-
-static void __init memtest(u64 pattern, u64 start_phys, u64 size)
-{
-	u64 *p, *start, *end;
-	u64 start_bad, last_bad;
-	u64 start_phys_aligned;
-	const size_t incr = sizeof(pattern);
-
-	start_phys_aligned = ALIGN(start_phys, incr);
-	start = __va(start_phys_aligned);
-	end = start + (size - (start_phys_aligned - start_phys)) / incr;
-	start_bad = 0;
-	last_bad = 0;
-
-	for (p = start; p < end; p++)
-		*p = pattern;
-
-	for (p = start; p < end; p++, start_phys_aligned += incr) {
-		if (*p == pattern)
-			continue;
-		if (start_phys_aligned == last_bad + incr) {
-			last_bad += incr;
-			continue;
-		}
-		if (start_bad)
-			reserve_bad_mem(pattern, start_bad, last_bad + incr);
-		start_bad = last_bad = start_phys_aligned;
-	}
-	if (start_bad)
-		reserve_bad_mem(pattern, start_bad, last_bad + incr);
-}
-
-static void __init do_one_pass(u64 pattern, u64 start, u64 end)
-{
-	u64 i;
-	phys_addr_t this_start, this_end;
-
-	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
-		this_start = clamp_t(phys_addr_t, this_start, start, end);
-		this_end = clamp_t(phys_addr_t, this_end, start, end);
-		if (this_start < this_end) {
-			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
-			       (unsigned long long)this_start,
-			       (unsigned long long)this_end,
-			       (unsigned long long)cpu_to_be64(pattern));
-			memtest(pattern, this_start, this_end - this_start);
-		}
-	}
-}
-
-/* default is disabled */
-static int memtest_pattern __initdata;
-
-static int __init parse_memtest(char *arg)
-{
-	if (arg)
-		memtest_pattern = simple_strtoul(arg, NULL, 0);
-	else
-		memtest_pattern = ARRAY_SIZE(patterns);
-
-	return 0;
-}
-
-early_param("memtest", parse_memtest);
-
-void __init early_memtest(unsigned long start, unsigned long end)
-{
-	unsigned int i;
-	unsigned int idx = 0;
-
-	if (!memtest_pattern)
-		return;
-
-	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
-	for (i = memtest_pattern-1; i < UINT_MAX; --i) {
-		idx = i % ARRAY_SIZE(patterns);
-		do_one_pass(patterns[idx], start, end);
-	}
-}
diff -puN include/linux/memblock.h~mm-move-memtest-under-mm include/linux/memblock.h
--- a/include/linux/memblock.h~mm-move-memtest-under-mm
+++ a/include/linux/memblock.h
@@ -365,6 +365,14 @@ static inline unsigned long memblock_reg
 #define __initdata_memblock
 #endif
 
+#ifdef CONFIG_MEMTEST
+extern void early_memtest(unsigned long start, unsigned long end);
+#else
+static inline void early_memtest(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 #else
 static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
diff -puN lib/Kconfig.debug~mm-move-memtest-under-mm lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-move-memtest-under-mm
+++ a/lib/Kconfig.debug
@@ -1732,6 +1732,17 @@ config TEST_UDELAY
 
 	  If unsure, say N.
 
+config MEMTEST
+	bool "Memtest"
+	---help---
+	  This option adds a kernel parameter 'memtest', which allows memtest
+	  to be set.
+	        memtest=0, mean disabled; -- default
+	        memtest=1, mean do 1 test pattern;
+	        ...
+	        memtest=4, mean do 4 test patterns.
+	  If you are unsure how to answer this question, answer N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff -puN mm/Makefile~mm-move-memtest-under-mm mm/Makefile
--- a/mm/Makefile~mm-move-memtest-under-mm
+++ a/mm/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
+obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
diff -puN /dev/null mm/memtest.c
--- /dev/null
+++ a/mm/memtest.c
@@ -0,0 +1,118 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/pfn.h>
+#include <linux/memblock.h>
+
+static u64 patterns[] __initdata = {
+	/* The first entry has to be 0 to leave memtest with zeroed memory */
+	0,
+	0xffffffffffffffffULL,
+	0x5555555555555555ULL,
+	0xaaaaaaaaaaaaaaaaULL,
+	0x1111111111111111ULL,
+	0x2222222222222222ULL,
+	0x4444444444444444ULL,
+	0x8888888888888888ULL,
+	0x3333333333333333ULL,
+	0x6666666666666666ULL,
+	0x9999999999999999ULL,
+	0xccccccccccccccccULL,
+	0x7777777777777777ULL,
+	0xbbbbbbbbbbbbbbbbULL,
+	0xddddddddddddddddULL,
+	0xeeeeeeeeeeeeeeeeULL,
+	0x7a6c7258554e494cULL, /* yeah ;-) */
+};
+
+static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
+{
+	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
+	       (unsigned long long) pattern,
+	       (unsigned long long) start_bad,
+	       (unsigned long long) end_bad);
+	memblock_reserve(start_bad, end_bad - start_bad);
+}
+
+static void __init memtest(u64 pattern, u64 start_phys, u64 size)
+{
+	u64 *p, *start, *end;
+	u64 start_bad, last_bad;
+	u64 start_phys_aligned;
+	const size_t incr = sizeof(pattern);
+
+	start_phys_aligned = ALIGN(start_phys, incr);
+	start = __va(start_phys_aligned);
+	end = start + (size - (start_phys_aligned - start_phys)) / incr;
+	start_bad = 0;
+	last_bad = 0;
+
+	for (p = start; p < end; p++)
+		*p = pattern;
+
+	for (p = start; p < end; p++, start_phys_aligned += incr) {
+		if (*p == pattern)
+			continue;
+		if (start_phys_aligned == last_bad + incr) {
+			last_bad += incr;
+			continue;
+		}
+		if (start_bad)
+			reserve_bad_mem(pattern, start_bad, last_bad + incr);
+		start_bad = last_bad = start_phys_aligned;
+	}
+	if (start_bad)
+		reserve_bad_mem(pattern, start_bad, last_bad + incr);
+}
+
+static void __init do_one_pass(u64 pattern, u64 start, u64 end)
+{
+	u64 i;
+	phys_addr_t this_start, this_end;
+
+	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
+		this_start = clamp_t(phys_addr_t, this_start, start, end);
+		this_end = clamp_t(phys_addr_t, this_end, start, end);
+		if (this_start < this_end) {
+			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
+			       (unsigned long long)this_start,
+			       (unsigned long long)this_end,
+			       (unsigned long long)cpu_to_be64(pattern));
+			memtest(pattern, this_start, this_end - this_start);
+		}
+	}
+}
+
+/* default is disabled */
+static int memtest_pattern __initdata;
+
+static int __init parse_memtest(char *arg)
+{
+	if (arg)
+		memtest_pattern = simple_strtoul(arg, NULL, 0);
+	else
+		memtest_pattern = ARRAY_SIZE(patterns);
+
+	return 0;
+}
+
+early_param("memtest", parse_memtest);
+
+void __init early_memtest(unsigned long start, unsigned long end)
+{
+	unsigned int i;
+	unsigned int idx = 0;
+
+	if (!memtest_pattern)
+		return;
+
+	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
+	for (i = memtest_pattern-1; i < UINT_MAX; --i) {
+		idx = i % ARRAY_SIZE(patterns);
+		do_one_pass(patterns[idx], start, end);
+	}
+}
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

mm-move-memtest-under-mm.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch
linux-next.patch

