From: akpm@linux-foundation.org
Subject: + kcore-register-text-area-in-generic-way.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:25:59 -0700
Message-ID: <200908172126.n7HLQ0pC029305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbZHQV1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com


The patch titled
     kcore: register text area in generic way
has been added to the -mm tree.  Its filename is
     kcore-register-text-area-in-generic-way.patch

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
Subject: kcore: register text area in generic way
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some 64bit arch has special segment for mapping kernel text.  It should be
entried to /proc/kcore in addtion to direct-linear-map, vmalloc area. 
This patch unifies KCORE_TEXT entry scattered under x86 and ia64.

I'm not familiar with other archs (mips has its own even after this patch)
but range of [_stext ..._end) is a valid area of text and it's not in
direct-map area, defining CONFIG_ARCH_PROC_KCORE_TEXT is only a necessary
thing to do.

Note: I left mips as it is now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig     |    4 ++++
 arch/ia64/mm/init.c   |    2 --
 arch/x86/Kconfig      |    4 ++++
 arch/x86/mm/init_64.c |    4 +---
 fs/proc/kcore.c       |   19 ++++++++++++++++++-
 5 files changed, 27 insertions(+), 6 deletions(-)

diff -puN arch/ia64/Kconfig~kcore-register-text-area-in-generic-way arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kcore-register-text-area-in-generic-way
+++ a/arch/ia64/Kconfig
@@ -496,6 +496,10 @@ config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y
 	depends on NUMA
 
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on PROC_KCORE
+
 config IA32_SUPPORT
 	bool "Support for Linux/x86 binaries"
 	help
diff -puN arch/ia64/mm/init.c~kcore-register-text-area-in-generic-way arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~kcore-register-text-area-in-generic-way
+++ a/arch/ia64/mm/init.c
@@ -617,7 +617,6 @@ mem_init (void)
 	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
-	static struct kcore_list kcore_kernel;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
@@ -637,7 +636,6 @@ mem_init (void)
 	max_mapnr = max_low_pfn;
 #endif
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
-	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
 
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
diff -puN arch/x86/Kconfig~kcore-register-text-area-in-generic-way arch/x86/Kconfig
--- a/arch/x86/Kconfig~kcore-register-text-area-in-generic-way
+++ a/arch/x86/Kconfig
@@ -1250,6 +1250,10 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on X86_64 && PROC_KCORE
+
 config ILLEGAL_POINTER_VALUE
        hex
        default 0 if X86_32
diff -puN arch/x86/mm/init_64.c~kcore-register-text-area-in-generic-way arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kcore-register-text-area-in-generic-way
+++ a/arch/x86/mm/init_64.c
@@ -647,8 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_mem, kcore_kernel,
-			 kcore_modules, kcore_vsyscall;
+static struct kcore_list kcore_mem, kcore_modules, kcore_vsyscall;
 
 void __init mem_init(void)
 {
@@ -678,7 +677,6 @@ void __init mem_init(void)
 
 	/* Register memory areas for /proc/kcore */
 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
 			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
diff -puN fs/proc/kcore.c~kcore-register-text-area-in-generic-way fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-register-text-area-in-generic-way
+++ a/fs/proc/kcore.c
@@ -21,6 +21,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/list.h>
+#include <asm/sections.h>
 
 #define CORE_STR "CORE"
 
@@ -374,10 +375,26 @@ read_kcore(struct file *file, char __use
 
 static struct kcore_list kcore_vmalloc;
 
+#ifdef CONFIG_ARCH_PROC_KCORE_TEXT
+static struct kcore_list kcore_text;
+/*
+ * If defined, special segment is used for mapping kernel text instead of
+ * direct-map area. We need to create special TEXT section.
+ */
+static void __init proc_kcore_text_init(void)
+{
+	kclist_add(&kcore_text, _stext, _end - _stext, KCORE_TEXT);
+}
+#else
+static void __init proc_kcore_text_init(void)
+{
+}
+#endif
+
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
-
+	proc_kcore_text_init();
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 	return 0;
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

