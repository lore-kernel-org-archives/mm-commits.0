From: akpm@linux-foundation.org
Subject: [merged] kcore-register-vmalloc-area-in-generic-way.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:59 -0700
Message-ID: <200909231956.n8NJuxwB005984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770AbZIWT5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: register vmalloc area in generic way
has been removed from the -mm tree.  Its filename was
     kcore-register-vmalloc-area-in-generic-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: register vmalloc area in generic way
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For /proc/kcore, vmalloc areas are registered per arch.  But, all of them
registers same range of [VMALLOC_START...VMALLOC_END) This patch unifies
them.  By this.  archs which have no kclist_add() hooks can see vmalloc
area correctly.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c       |    4 +---
 arch/mips/mm/init.c       |    4 +---
 arch/powerpc/mm/init_32.c |    4 ----
 arch/powerpc/mm/init_64.c |    4 ----
 arch/sh/mm/init.c         |    4 +---
 arch/x86/mm/init_32.c     |    4 +---
 arch/x86/mm/init_64.c     |    4 +---
 fs/proc/kcore.c           |    5 +++++
 8 files changed, 10 insertions(+), 23 deletions(-)

diff -puN arch/ia64/mm/init.c~kcore-register-vmalloc-area-in-generic-way arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/ia64/mm/init.c
@@ -617,7 +617,7 @@ mem_init (void)
 	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
-	static struct kcore_list kcore_mem, kcore_vmem, kcore_kernel;
+	static struct kcore_list kcore_mem, kcore_kernel;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
@@ -640,8 +640,6 @@ mem_init (void)
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
 	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
-			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
 
 	for_each_online_pgdat(pgdat)
diff -puN arch/mips/mm/init.c~kcore-register-vmalloc-area-in-generic-way arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/mips/mm/init.c
@@ -352,7 +352,7 @@ void __init paging_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
-static struct kcore_list kcore_mem, kcore_vmalloc;
+static struct kcore_list kcore_mem;
 #ifdef CONFIG_64BIT
 static struct kcore_list kcore_kseg0;
 #endif
@@ -413,8 +413,6 @@ void __init mem_init(void)
 				0x80000000 - 4, KCORE_TEXT);
 #endif
 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
diff -puN arch/powerpc/mm/init_32.c~kcore-register-vmalloc-area-in-generic-way arch/powerpc/mm/init_32.c
--- a/arch/powerpc/mm/init_32.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/powerpc/mm/init_32.c
@@ -243,7 +243,6 @@ void free_initrd_mem(unsigned long start
 #endif
 
 #ifdef CONFIG_PROC_KCORE
-static struct kcore_list kcore_vmem;
 
 static int __init setup_kcore(void)
 {
@@ -271,9 +270,6 @@ static int __init setup_kcore(void)
 		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
 	}
 
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
-		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
-
 	return 0;
 }
 module_init(setup_kcore);
diff -puN arch/powerpc/mm/init_64.c~kcore-register-vmalloc-area-in-generic-way arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/powerpc/mm/init_64.c
@@ -110,7 +110,6 @@ void free_initrd_mem(unsigned long start
 #endif
 
 #ifdef CONFIG_PROC_KCORE
-static struct kcore_list kcore_vmem;
 
 static int __init setup_kcore(void)
 {
@@ -131,9 +130,6 @@ static int __init setup_kcore(void)
 		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
 	}
 
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
-		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
-
 	return 0;
 }
 module_init(setup_kcore);
diff -puN arch/sh/mm/init.c~kcore-register-vmalloc-area-in-generic-way arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/sh/mm/init.c
@@ -186,7 +186,7 @@ void __init paging_init(void)
 	set_fixmap_nocache(FIX_UNCACHED, __pa(&__uncached_start));
 }
 
-static struct kcore_list kcore_mem, kcore_vmalloc;
+static struct kcore_list kcore_mem;
 
 void __init mem_init(void)
 {
@@ -227,8 +227,6 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
diff -puN arch/x86/mm/init_32.c~kcore-register-vmalloc-area-in-generic-way arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/x86/mm/init_32.c
@@ -857,7 +857,7 @@ static void __init test_wp_bit(void)
 	}
 }
 
-static struct kcore_list kcore_mem, kcore_vmalloc;
+static struct kcore_list kcore_mem;
 
 void __init mem_init(void)
 {
@@ -887,8 +887,6 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
diff -puN arch/x86/mm/init_64.c~kcore-register-vmalloc-area-in-generic-way arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kcore-register-vmalloc-area-in-generic-way
+++ a/arch/x86/mm/init_64.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
+static struct kcore_list kcore_mem, kcore_kernel,
 			 kcore_modules, kcore_vsyscall;
 
 void __init mem_init(void)
@@ -678,8 +678,6 @@ void __init mem_init(void)
 
 	/* Register memory areas for /proc/kcore */
 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
 			KCORE_OTHER);
diff -puN fs/proc/kcore.c~kcore-register-vmalloc-area-in-generic-way fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-register-vmalloc-area-in-generic-way
+++ a/fs/proc/kcore.c
@@ -372,9 +372,14 @@ read_kcore(struct file *file, char __use
 	return acc;
 }
 
+static struct kcore_list kcore_vmalloc;
+
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
+
+	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
+		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 	return 0;
 }
 module_init(proc_kcore_init);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

