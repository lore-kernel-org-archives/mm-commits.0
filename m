From: akpm@linux-foundation.org
Subject: [merged] kcore-register-module-area-in-generic-way.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:10 -0700
Message-ID: <200909231957.n8NJvALO006356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbZIWT5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, jirislaby@gmail.com, ralf@linux-mips.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: register module area in generic way
has been removed from the -mm tree.  Its filename was
     kcore-register-module-area-in-generic-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: register module area in generic way
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some archs define MODULED_VADDR/MODULES_END which is not in VMALLOC area. 
This is handled only in x86-64.  This patch make it more generic.  And we
can use vread/vwrite to access the area.  Fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    4 +---
 fs/proc/kcore.c       |   19 ++++++++++++++++++-
 include/linux/mm.h    |    8 ++++++++
 mm/vmalloc.c          |    2 +-
 4 files changed, 28 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/init_64.c~kcore-register-module-area-in-generic-way arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kcore-register-module-area-in-generic-way
+++ a/arch/x86/mm/init_64.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_modules, kcore_vsyscall;
+static struct kcore_list kcore_vsyscall;
 
 void __init mem_init(void)
 {
@@ -676,8 +676,6 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
-			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
 			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
 
diff -puN fs/proc/kcore.c~kcore-register-module-area-in-generic-way fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-register-module-area-in-generic-way
+++ a/fs/proc/kcore.c
@@ -490,7 +490,7 @@ read_kcore(struct file *file, char __use
 		if (m == NULL) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
-		} else if (is_vmalloc_addr((void *)start)) {
+		} else if (is_vmalloc_or_module_addr((void *)start)) {
 			char * elf_buf;
 
 			elf_buf = kzalloc(tsz, GFP_KERNEL);
@@ -586,6 +586,22 @@ static void __init proc_kcore_text_init(
 }
 #endif
 
+#if defined(CONFIG_MODULES) && defined(MODULES_VADDR)
+/*
+ * MODULES_VADDR has no intersection with VMALLOC_ADDR.
+ */
+struct kcore_list kcore_modules;
+static void __init add_modules_range(void)
+{
+	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+}
+#else
+static void __init add_modules_range(void)
+{
+}
+#endif
+
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
@@ -595,6 +611,7 @@ static int __init proc_kcore_init(void)
 	/* Store vmalloc area */
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
+	add_modules_range();
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
 	hotplug_memory_notifier(kcore_callback, 0);
diff -puN include/linux/mm.h~kcore-register-module-area-in-generic-way include/linux/mm.h
--- a/include/linux/mm.h~kcore-register-module-area-in-generic-way
+++ a/include/linux/mm.h
@@ -285,6 +285,14 @@ static inline int is_vmalloc_addr(const 
 	return 0;
 #endif
 }
+#ifdef CONFIG_MMU
+extern int is_vmalloc_or_module_addr(const void *x);
+#else
+static int is_vmalloc_or_module_addr(const void *x)
+{
+	return 0;
+}
+#endif
 
 static inline struct page *compound_head(struct page *page)
 {
diff -puN mm/vmalloc.c~kcore-register-module-area-in-generic-way mm/vmalloc.c
--- a/mm/vmalloc.c~kcore-register-module-area-in-generic-way
+++ a/mm/vmalloc.c
@@ -184,7 +184,7 @@ static int vmap_page_range(unsigned long
 	return ret;
 }
 
-static inline int is_vmalloc_or_module_addr(const void *x)
+int is_vmalloc_or_module_addr(const void *x)
 {
 	/*
 	 * ARM, x86-64 and sparc64 put modules in a special place,
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

