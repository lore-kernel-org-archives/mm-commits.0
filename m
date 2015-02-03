From: akpm@linux-foundation.org
Subject: + kasan-enable-stack-instrumentation.patch added to -mm tree
Date: Tue, 03 Feb 2015 15:05:26 -0800
Message-ID: <54d15436.oRISsWQyDsJ+ebUU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbBCXF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:05:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: enable stack instrumentation
has been added to the -mm tree.  Its filename is
     kasan-enable-stack-instrumentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-enable-stack-instrumentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-enable-stack-instrumentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan: enable stack instrumentation

Stack instrumentation allows to detect out of bounds memory accesses for
variables allocated on stack.  Compiler adds redzones around every
variable on stack and poisons redzones in function's prologue.

Such approach significantly increases stack usage, so all in-kernel stacks
size were doubled.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_64_types.h |   12 +++++++++---
 arch/x86/kernel/Makefile             |    2 ++
 arch/x86/mm/kasan_init_64.c          |   11 +++++++++--
 include/linux/init_task.h            |    8 ++++++++
 mm/kasan/kasan.h                     |    9 +++++++++
 mm/kasan/report.c                    |    6 ++++++
 scripts/Makefile.kasan               |    1 +
 7 files changed, 44 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/page_64_types.h~kasan-enable-stack-instrumentation arch/x86/include/asm/page_64_types.h
--- a/arch/x86/include/asm/page_64_types.h~kasan-enable-stack-instrumentation
+++ a/arch/x86/include/asm/page_64_types.h
@@ -1,17 +1,23 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
-#define THREAD_SIZE_ORDER	2
+#ifdef CONFIG_KASAN
+#define KASAN_STACK_ORDER 1
+#else
+#define KASAN_STACK_ORDER 0
+#endif
+
+#define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
-#define EXCEPTION_STACK_ORDER 0
+#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
 #define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
 
-#define IRQ_STACK_ORDER 2
+#define IRQ_STACK_ORDER (2 + KASAN_STACK_ORDER)
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
 #define DOUBLEFAULT_STACK 1
diff -puN arch/x86/kernel/Makefile~kasan-enable-stack-instrumentation arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~kasan-enable-stack-instrumentation
+++ a/arch/x86/kernel/Makefile
@@ -17,6 +17,8 @@ CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o := n
+KASAN_SANITIZE_dumpstack.o := n
+KASAN_SANITIZE_dumpstack_$(BITS).o := n
 
 CFLAGS_irq.o := -I$(src)/../include/asm/trace
 
diff -puN arch/x86/mm/kasan_init_64.c~kasan-enable-stack-instrumentation arch/x86/mm/kasan_init_64.c
--- a/arch/x86/mm/kasan_init_64.c~kasan-enable-stack-instrumentation
+++ a/arch/x86/mm/kasan_init_64.c
@@ -189,11 +189,18 @@ void __init kasan_init(void)
 		if (map_range(&pfn_mapped[i]))
 			panic("kasan: unable to allocate shadow!");
 	}
-
 	populate_zero_shadow(kasan_mem_to_shadow((void *)PAGE_OFFSET + MAXMEM),
-				(void *)KASAN_SHADOW_END);
+			kasan_mem_to_shadow((void *)__START_KERNEL_map));
+
+	vmemmap_populate((unsigned long)kasan_mem_to_shadow(_stext),
+			(unsigned long)kasan_mem_to_shadow(_end),
+			NUMA_NO_NODE);
+
+	populate_zero_shadow(kasan_mem_to_shadow((void *)MODULES_VADDR),
+			(void *)KASAN_SHADOW_END);
 
 	memset(kasan_zero_page, 0, PAGE_SIZE);
 
 	load_cr3(init_level4_pgt);
+	init_task.kasan_depth = 0;
 }
diff -puN include/linux/init_task.h~kasan-enable-stack-instrumentation include/linux/init_task.h
--- a/include/linux/init_task.h~kasan-enable-stack-instrumentation
+++ a/include/linux/init_task.h
@@ -175,6 +175,13 @@ extern struct task_group root_task_group
 # define INIT_NUMA_BALANCING(tsk)
 #endif
 
+#ifdef CONFIG_KASAN
+# define INIT_KASAN(tsk)						\
+	.kasan_depth = 1,
+#else
+# define INIT_KASAN(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -247,6 +254,7 @@ extern struct task_group root_task_group
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
 	INIT_NUMA_BALANCING(tsk)					\
+	INIT_KASAN(tsk)							\
 }
 
 
diff -puN mm/kasan/kasan.h~kasan-enable-stack-instrumentation mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-enable-stack-instrumentation
+++ a/mm/kasan/kasan.h
@@ -12,6 +12,15 @@
 #define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
 #define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
 
+/*
+ * Stack redzone shadow values
+ * (Those are compiler's ABI, don't change them)
+ */
+#define KASAN_STACK_LEFT        0xF1
+#define KASAN_STACK_MID         0xF2
+#define KASAN_STACK_RIGHT       0xF3
+#define KASAN_STACK_PARTIAL     0xF4
+
 
 struct kasan_access_info {
 	const void *access_addr;
diff -puN mm/kasan/report.c~kasan-enable-stack-instrumentation mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-enable-stack-instrumentation
+++ a/mm/kasan/report.c
@@ -64,6 +64,12 @@ static void print_error_description(stru
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "out of bounds access";
 		break;
+	case KASAN_STACK_LEFT:
+	case KASAN_STACK_MID:
+	case KASAN_STACK_RIGHT:
+	case KASAN_STACK_PARTIAL:
+		bug_type = "out of bounds on stack";
+		break;
 	}
 
 	pr_err("BUG: KASan: %s in %pS at addr %p\n",
diff -puN scripts/Makefile.kasan~kasan-enable-stack-instrumentation scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-enable-stack-instrumentation
+++ a/scripts/Makefile.kasan
@@ -9,6 +9,7 @@ CFLAGS_KASAN_MINIMAL := $(call cc-option
 
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET) \
+		--param asan-stack=1 \
 		--param asan-instrumentation-with-call-threshold=$(call_threshold))
 
 ifeq ($(CFLAGS_KASAN_MINIMAL),)
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
linux-next.patch

