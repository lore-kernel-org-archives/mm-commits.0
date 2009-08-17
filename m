From: akpm@linux-foundation.org
Subject: + kcore-add-kclist-type.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:25:54 -0700
Message-ID: <200908172125.n7HLPtR7029166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbZHQV1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com


The patch titled
     kcore: add kclist type
has been added to the -mm tree.  Its filename is
     kcore-add-kclist-type.patch

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
Subject: kcore: add kclist type
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, kclist_add() only eats start address and size as its arguments.
 Considering to make kclist dynamically reconfigulable, it's necessary to
know which kclists are for System RAM and which are not.

This patch add kclist types as
  KCORE_RAM
  KCORE_VMALLOC
  KCORE_TEXT
  KCORE_OTHER

This "type" is used in a patch following this for detecting KCORE_RAM.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c       |    7 ++++---
 arch/mips/mm/init.c       |    7 ++++---
 arch/powerpc/mm/init_32.c |    4 ++--
 arch/powerpc/mm/init_64.c |    5 +++--
 arch/sh/mm/init.c         |    4 ++--
 arch/x86/mm/init_32.c     |    4 ++--
 arch/x86/mm/init_64.c     |   11 ++++++-----
 fs/proc/kcore.c           |    3 ++-
 include/linux/proc_fs.h   |   13 +++++++++++--
 9 files changed, 36 insertions(+), 22 deletions(-)

diff -puN arch/ia64/mm/init.c~kcore-add-kclist-type arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~kcore-add-kclist-type
+++ a/arch/ia64/mm/init.c
@@ -639,9 +639,10 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE);
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START, VMALLOC_END-VMALLOC_START);
-	kclist_add(&kcore_kernel, _stext, _end - _stext);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
+	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
+			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
+	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
 
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
diff -puN arch/mips/mm/init.c~kcore-add-kclist-type arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~kcore-add-kclist-type
+++ a/arch/mips/mm/init.c
@@ -409,11 +409,12 @@ void __init mem_init(void)
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
 		/* The -4 is a hack so that user tools don't have to handle
 		   the overflow.  */
-		kclist_add(&kcore_kseg0, (void *) CKSEG0, 0x80000000 - 4);
+		kclist_add(&kcore_kseg0, (void *) CKSEG0,
+				0x80000000 - 4, KCORE_TEXT);
 #endif
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START);
+		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
diff -puN arch/powerpc/mm/init_32.c~kcore-add-kclist-type arch/powerpc/mm/init_32.c
--- a/arch/powerpc/mm/init_32.c~kcore-add-kclist-type
+++ a/arch/powerpc/mm/init_32.c
@@ -268,11 +268,11 @@ static int __init setup_kcore(void)
 						size);
 		}
 
-		kclist_add(kcore_mem, __va(base), size);
+		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
 	}
 
 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
-		VMALLOC_END-VMALLOC_START);
+		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	return 0;
 }
diff -puN arch/powerpc/mm/init_64.c~kcore-add-kclist-type arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~kcore-add-kclist-type
+++ a/arch/powerpc/mm/init_64.c
@@ -128,10 +128,11 @@ static int __init setup_kcore(void)
 		if (!kcore_mem)
 			panic("%s: kmalloc failed\n", __func__);
 
-		kclist_add(kcore_mem, __va(base), size);
+		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
 	}
 
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START, VMALLOC_END-VMALLOC_START);
+	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
+		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	return 0;
 }
diff -puN arch/sh/mm/init.c~kcore-add-kclist-type arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~kcore-add-kclist-type
+++ a/arch/sh/mm/init.c
@@ -218,9 +218,9 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END - VMALLOC_START);
+		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
diff -puN arch/x86/mm/init_32.c~kcore-add-kclist-type arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~kcore-add-kclist-type
+++ a/arch/x86/mm/init_32.c
@@ -886,9 +886,9 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START);
+		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
diff -puN arch/x86/mm/init_64.c~kcore-add-kclist-type arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kcore-add-kclist-type
+++ a/arch/x86/mm/init_64.c
@@ -677,13 +677,14 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START);
-	kclist_add(&kcore_kernel, &_stext, _end - _stext);
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN);
+		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
+	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
+	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
+			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
-				 VSYSCALL_END - VSYSCALL_START);
+			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
diff -puN fs/proc/kcore.c~kcore-add-kclist-type fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-add-kclist-type
+++ a/fs/proc/kcore.c
@@ -62,10 +62,11 @@ static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
 
 void
-kclist_add(struct kcore_list *new, void *addr, size_t size)
+kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
 {
 	new->addr = (unsigned long)addr;
 	new->size = size;
+	new->type = type;
 
 	write_lock(&kclist_lock);
 	list_add_tail(&new->list, &kclist_head);
diff -puN include/linux/proc_fs.h~kcore-add-kclist-type include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~kcore-add-kclist-type
+++ a/include/linux/proc_fs.h
@@ -78,10 +78,18 @@ struct proc_dir_entry {
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
 };
 
+enum kcore_type {
+	KCORE_TEXT,
+	KCORE_VMALLOC,
+	KCORE_RAM,
+	KCORE_OTHER,
+};
+
 struct kcore_list {
 	struct list_head list;
 	unsigned long addr;
 	size_t size;
+	int type;
 };
 
 struct vmcore {
@@ -233,11 +241,12 @@ static inline void dup_mm_exe_file(struc
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
-static inline void kclist_add(struct kcore_list *new, void *addr, size_t size)
+static inline void
+kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
 {
 }
 #else
-extern void kclist_add(struct kcore_list *, void *, size_t);
+extern void kclist_add(struct kcore_list *, void *, size_t, int type);
 #endif
 
 union proc_op {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-revert-oom-move-oom_adj-value.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-type.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
kcore-use-registerd-physmem-information.patch
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
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch

