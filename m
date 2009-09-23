From: akpm@linux-foundation.org
Subject: [merged] kcore-use-registerd-physmem-information.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:05 -0700
Message-ID: <200909231957.n8NJv5Du006234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbZIWUFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, jirislaby@gmail.com, kosaki.motohiro@jp.fujitsu.com, ralf@linux-mips.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: use registerd physmem information
has been removed from the -mm tree.  Its filename was
     kcore-use-registerd-physmem-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: use registerd physmem information
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For /proc/kcore, each arch registers its memory range by kclist_add().
In usual,

	- range of physical memory
	- range of vmalloc area
	- text, etc...

are registered but "range of physical memory" has some troubles.  It
doesn't updated at memory hotplug and it tend to include unnecessary
memory holes.  Now, /proc/iomem (kernel/resource.c) includes required
physical memory range information and it's properly updated at memory
hotplug.  Then, it's good to avoid using its own code(duplicating
information) and to rebuild kclist for physical memory based on
/proc/iomem.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c       |    3 
 arch/mips/mm/init.c       |    2 
 arch/powerpc/mm/init_32.c |   32 ------
 arch/powerpc/mm/init_64.c |   26 -----
 arch/sh/mm/init.c         |    4 
 arch/x86/mm/init_32.c     |    4 
 arch/x86/mm/init_64.c     |    3 
 fs/proc/kcore.c           |  179 +++++++++++++++++++++++++++++++++---
 8 files changed, 168 insertions(+), 85 deletions(-)

diff -puN arch/ia64/mm/init.c~kcore-use-registerd-physmem-information arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~kcore-use-registerd-physmem-information
+++ a/arch/ia64/mm/init.c
@@ -617,7 +617,6 @@ mem_init (void)
 	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
-	static struct kcore_list kcore_mem;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
@@ -639,8 +638,6 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
-
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);
diff -puN arch/mips/mm/init.c~kcore-use-registerd-physmem-information arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~kcore-use-registerd-physmem-information
+++ a/arch/mips/mm/init.c
@@ -352,7 +352,6 @@ void __init paging_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
-static struct kcore_list kcore_mem;
 #ifdef CONFIG_64BIT
 static struct kcore_list kcore_kseg0;
 #endif
@@ -412,7 +411,6 @@ void __init mem_init(void)
 		kclist_add(&kcore_kseg0, (void *) CKSEG0,
 				0x80000000 - 4, KCORE_TEXT);
 #endif
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
diff -puN arch/powerpc/mm/init_32.c~kcore-use-registerd-physmem-information arch/powerpc/mm/init_32.c
--- a/arch/powerpc/mm/init_32.c~kcore-use-registerd-physmem-information
+++ a/arch/powerpc/mm/init_32.c
@@ -242,35 +242,3 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-#ifdef CONFIG_PROC_KCORE
-
-static int __init setup_kcore(void)
-{
-	int i;
-
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		unsigned long base;
-		unsigned long size;
-		struct kcore_list *kcore_mem;
-
-		base = lmb.memory.region[i].base;
-		size = lmb.memory.region[i].size;
-
-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
-		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __func__);
-
-		/* must stay under 32 bits */
-		if ( 0xfffffffful - (unsigned long)__va(base) < size) {
-			size = 0xfffffffful - (unsigned long)(__va(base));
-			printk(KERN_DEBUG "setup_kcore: restrict size=%lx\n",
-						size);
-		}
-
-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
-	}
-
-	return 0;
-}
-module_init(setup_kcore);
-#endif
diff -puN arch/powerpc/mm/init_64.c~kcore-use-registerd-physmem-information arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~kcore-use-registerd-physmem-information
+++ a/arch/powerpc/mm/init_64.c
@@ -109,32 +109,6 @@ void free_initrd_mem(unsigned long start
 }
 #endif
 
-#ifdef CONFIG_PROC_KCORE
-
-static int __init setup_kcore(void)
-{
-	int i;
-
-	for (i=0; i < lmb.memory.cnt; i++) {
-		unsigned long base, size;
-		struct kcore_list *kcore_mem;
-
-		base = lmb.memory.region[i].base;
-		size = lmb.memory.region[i].size;
-
-		/* GFP_ATOMIC to avoid might_sleep warnings during boot */
-		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
-		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __func__);
-
-		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
-	}
-
-	return 0;
-}
-module_init(setup_kcore);
-#endif
-
 static void pgd_ctor(void *addr)
 {
 	memset(addr, 0, PGD_TABLE_SIZE);
diff -puN arch/sh/mm/init.c~kcore-use-registerd-physmem-information arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~kcore-use-registerd-physmem-information
+++ a/arch/sh/mm/init.c
@@ -186,8 +186,6 @@ void __init paging_init(void)
 	set_fixmap_nocache(FIX_UNCACHED, __pa(&__uncached_start));
 }
 
-static struct kcore_list kcore_mem;
-
 void __init mem_init(void)
 {
 	int codesize, datasize, initsize;
@@ -226,8 +224,6 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
 		nr_free_pages() << (PAGE_SHIFT-10),
diff -puN arch/x86/mm/init_32.c~kcore-use-registerd-physmem-information arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~kcore-use-registerd-physmem-information
+++ a/arch/x86/mm/init_32.c
@@ -857,8 +857,6 @@ static void __init test_wp_bit(void)
 	}
 }
 
-static struct kcore_list kcore_mem;
-
 void __init mem_init(void)
 {
 	int codesize, reservedpages, datasize, initsize;
@@ -886,8 +884,6 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
 		nr_free_pages() << (PAGE_SHIFT-10),
diff -puN arch/x86/mm/init_64.c~kcore-use-registerd-physmem-information arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kcore-use-registerd-physmem-information
+++ a/arch/x86/mm/init_64.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_mem, kcore_modules, kcore_vsyscall;
+static struct kcore_list kcore_modules, kcore_vsyscall;
 
 void __init mem_init(void)
 {
@@ -676,7 +676,6 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
 			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
diff -puN fs/proc/kcore.c~kcore-use-registerd-physmem-information fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-use-registerd-physmem-information
+++ a/fs/proc/kcore.c
@@ -17,10 +17,14 @@
 #include <linux/elfcore.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
+#include <linux/bootmem.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/list.h>
+#include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/memory.h>
 #include <asm/sections.h>
 
 #define CORE_STR "CORE"
@@ -31,17 +35,6 @@
 
 static struct proc_dir_entry *proc_root_kcore;
 
-static int open_kcore(struct inode * inode, struct file * filp)
-{
-	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
-}
-
-static ssize_t read_kcore(struct file *, char __user *, size_t, loff_t *);
-
-static const struct file_operations proc_kcore_operations = {
-	.read		= read_kcore,
-	.open		= open_kcore,
-};
 
 #ifndef kc_vaddr_to_offset
 #define	kc_vaddr_to_offset(v) ((v) - PAGE_OFFSET)
@@ -61,6 +54,7 @@ struct memelfnote
 
 static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
+static int kcore_need_update = 1;
 
 void
 kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
@@ -99,6 +93,126 @@ static size_t get_kcore_size(int *nphdr,
 	return size + *elf_buflen;
 }
 
+static void free_kclist_ents(struct list_head *head)
+{
+	struct kcore_list *tmp, *pos;
+
+	list_for_each_entry_safe(pos, tmp, head, list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+}
+/*
+ * Replace all KCORE_RAM information with passed list.
+ */
+static void __kcore_update_ram(struct list_head *list)
+{
+	struct kcore_list *tmp, *pos;
+	LIST_HEAD(garbage);
+
+	write_lock(&kclist_lock);
+	if (kcore_need_update) {
+		list_for_each_entry_safe(pos, tmp, &kclist_head, list) {
+			if (pos->type == KCORE_RAM)
+				list_move(&pos->list, &garbage);
+		}
+		list_splice_tail(list, &kclist_head);
+	} else
+		list_splice(list, &garbage);
+	kcore_need_update = 0;
+	write_unlock(&kclist_lock);
+
+	free_kclist_ents(&garbage);
+}
+
+
+#ifdef CONFIG_HIGHMEM
+/*
+ * If no highmem, we can assume [0...max_low_pfn) continuous range of memory
+ * because memory hole is not as big as !HIGHMEM case.
+ * (HIGHMEM is special because part of memory is _invisible_ from the kernel.)
+ */
+static int kcore_update_ram(void)
+{
+	LIST_HEAD(head);
+	struct kcore_list *ent;
+	int ret = 0;
+
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+	ent->addr = (unsigned long)__va(0);
+	ent->size = max_low_pfn << PAGE_SHIFT;
+	ent->type = KCORE_RAM;
+	list_add(&ent->list, &head);
+	__kcore_update_ram(&head);
+	return ret;
+}
+
+#else /* !CONFIG_HIGHMEM */
+
+static int
+kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
+{
+	struct list_head *head = (struct list_head *)arg;
+	struct kcore_list *ent;
+
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+	ent->addr = (unsigned long)__va((pfn << PAGE_SHIFT));
+	ent->size = nr_pages << PAGE_SHIFT;
+
+	/* Sanity check: Can happen in 32bit arch...maybe */
+	if (ent->addr < (unsigned long) __va(0))
+		goto free_out;
+
+	/* cut not-mapped area. ....from ppc-32 code. */
+	if (ULONG_MAX - ent->addr < ent->size)
+		ent->size = ULONG_MAX - ent->addr;
+
+	/* cut when vmalloc() area is higher than direct-map area */
+	if (VMALLOC_START > (unsigned long)__va(0)) {
+		if (ent->addr > VMALLOC_START)
+			goto free_out;
+		if (VMALLOC_START - ent->addr < ent->size)
+			ent->size = VMALLOC_START - ent->addr;
+	}
+
+	ent->type = KCORE_RAM;
+	list_add_tail(&ent->list, head);
+	return 0;
+free_out:
+	kfree(ent);
+	return 1;
+}
+
+static int kcore_update_ram(void)
+{
+	int nid, ret;
+	unsigned long end_pfn;
+	LIST_HEAD(head);
+
+	/* Not inialized....update now */
+	/* find out "max pfn" */
+	end_pfn = 0;
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long node_end;
+		node_end  = NODE_DATA(nid)->node_start_pfn +
+			NODE_DATA(nid)->node_spanned_pages;
+		if (end_pfn < node_end)
+			end_pfn = node_end;
+	}
+	/* scan 0 to max_pfn */
+	ret = walk_system_ram_range(0, end_pfn, &head, kclist_add_private);
+	if (ret) {
+		free_kclist_ents(&head);
+		return -ENOMEM;
+	}
+	__kcore_update_ram(&head);
+	return ret;
+}
+#endif /* CONFIG_HIGHMEM */
 
 /*****************************************************************************/
 /*
@@ -373,6 +487,39 @@ read_kcore(struct file *file, char __use
 	return acc;
 }
 
+
+static int open_kcore(struct inode *inode, struct file *filp)
+{
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	if (kcore_need_update)
+		kcore_update_ram();
+	return 0;
+}
+
+
+static const struct file_operations proc_kcore_operations = {
+	.read		= read_kcore,
+	.open		= open_kcore,
+};
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+/* just remember that we have to update kcore */
+static int __meminit kcore_callback(struct notifier_block *self,
+				    unsigned long action, void *arg)
+{
+	switch (action) {
+	case MEM_ONLINE:
+	case MEM_OFFLINE:
+		write_lock(&kclist_lock);
+		kcore_need_update = 1;
+		write_unlock(&kclist_lock);
+	}
+	return NOTIFY_OK;
+}
+#endif
+
+
 static struct kcore_list kcore_vmalloc;
 
 #ifdef CONFIG_ARCH_PROC_KCORE_TEXT
@@ -393,10 +540,18 @@ static void __init proc_kcore_text_init(
 
 static int __init proc_kcore_init(void)
 {
-	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
+	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
+				      &proc_kcore_operations);
+	/* Store text area if it's special */
 	proc_kcore_text_init();
+	/* Store vmalloc area */
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
+	/* Store direct-map area from physical memory map */
+	kcore_update_ram();
+	hotplug_memory_notifier(kcore_callback, 0);
+	/* Other special area, area-for-module etc is arch specific. */
+
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

