From: akpm@linux-foundation.org
Subject: [nacked]
 kasan-module-vmalloc-rework-shadow-allocation-for-modules.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 16:59:58 -0800
Message-ID: <54e5358e.HbUIcdu2DBpCBid2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbbBSA77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 19:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, module, vmalloc: rework shadow allocation for modules
has been removed from the -mm tree.  Its filename was
     kasan-module-vmalloc-rework-shadow-allocation-for-modules.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan, module, vmalloc: rework shadow allocation for modules

The current approach in handling shadow memory for modules is broken.

Shadow memory could be freed only after memory shadow corresponds it is no
longer used.  vfree() called from interrupt context could use memory its
freeing to store 'struct llist_node' in it:

void vfree(const void *addr)
{
...
	if (unlikely(in_interrupt())) {
		struct vfree_deferred *p = this_cpu_ptr(&vfree_deferred);
		if (llist_add((struct llist_node *)addr, &p->list))
			schedule_work(&p->wq);

Later this list node used in free_work() which actually frees memory. 
Currently module_memfree() called in interrupt context will free shadow
before freeing module's memory which could provoke kernel crash.

So shadow memory should be freed after module's memory.  However, such
deallocation order could race with kasan_module_alloc() in module_alloc().

To fix this we could move kasan hooks into vmalloc code.  This allows us
to allocate/free shadow memory in appropriate time and order.

This hooks also might be helpful in future if we decide to track other
vmalloc'ed memory.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/module.c |   11 +----------
 include/linux/kasan.h    |   26 +++++++++++++++++++-------
 kernel/module.c          |    2 --
 mm/kasan/kasan.c         |   12 +++++++++---
 mm/vmalloc.c             |   10 ++++++++++
 5 files changed, 39 insertions(+), 22 deletions(-)

diff -puN arch/x86/kernel/module.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/arch/x86/kernel/module.c
@@ -24,7 +24,6 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/kasan.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/gfp.h>
@@ -84,22 +83,14 @@ static unsigned long int get_module_load
 
 void *module_alloc(unsigned long size)
 {
-	void *p;
-
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN,
+	return __vmalloc_node_range(size, 1,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL | __GFP_HIGHMEM,
 				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
-	if (p && (kasan_module_alloc(p, size) < 0)) {
-		vfree(p);
-		return NULL;
-	}
-
-	return p;
 }
 
 #ifdef CONFIG_X86_32
diff -puN include/linux/kasan.h~kasan-module-vmalloc-rework-shadow-allocation-for-modules include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/include/linux/kasan.h
@@ -5,6 +5,7 @@
 
 struct kmem_cache;
 struct page;
+struct vm_struct;
 
 #ifdef CONFIG_KASAN
 
@@ -12,6 +13,7 @@ struct page;
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 
 #include <asm/kasan.h>
+#include <linux/kernel.h>
 #include <linux/sched.h>
 
 static inline void *kasan_mem_to_shadow(const void *addr)
@@ -49,15 +51,19 @@ void kasan_krealloc(const void *object,
 void kasan_slab_alloc(struct kmem_cache *s, void *object);
 void kasan_slab_free(struct kmem_cache *s, void *object);
 
-#define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
+int kasan_vmalloc(const void *addr, size_t size);
+void kasan_vfree(const void *addr, const struct vm_struct *vm);
 
-int kasan_module_alloc(void *addr, size_t size);
-void kasan_module_free(void *addr);
+static inline unsigned long kasan_vmalloc_align(unsigned long addr,
+						unsigned long align)
+{
+	if (addr >= MODULES_VADDR && addr < MODULES_END)
+		return ALIGN(align, PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT);
+	return align;
+}
 
 #else /* CONFIG_KASAN */
 
-#define MODULE_ALIGN 1
-
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
 
 static inline void kasan_enable_current(void) {}
@@ -81,8 +87,14 @@ static inline void kasan_krealloc(const
 static inline void kasan_slab_alloc(struct kmem_cache *s, void *object) {}
 static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
 
-static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
-static inline void kasan_module_free(void *addr) {}
+static inline int kasan_vmalloc(const void *addr, size_t size) { return 0; }
+static inline void kasan_vfree(const void *addr, struct vm_struct *vm) {}
+
+static inline unsigned long kasan_vmalloc_align(unsigned long addr,
+						unsigned long align)
+{
+	return align;
+}
 
 #endif /* CONFIG_KASAN */
 
diff -puN kernel/module.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules kernel/module.c
--- a/kernel/module.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/kernel/module.c
@@ -56,7 +56,6 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
-#include <linux/kasan.h>
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
@@ -1814,7 +1813,6 @@ static void unset_module_init_ro_nx(stru
 void __weak module_memfree(void *module_region)
 {
 	vfree(module_region);
-	kasan_module_free(module_region);
 }
 
 void __weak module_arch_cleanup(struct module *mod)
diff -puN mm/kasan/kasan.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/mm/kasan/kasan.c
@@ -29,6 +29,7 @@
 #include <linux/stacktrace.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/vmalloc.h>
 #include <linux/kasan.h>
 
 #include "kasan.h"
@@ -396,7 +397,7 @@ void kasan_kfree_large(const void *ptr)
 			KASAN_FREE_PAGE);
 }
 
-int kasan_module_alloc(void *addr, size_t size)
+int kasan_vmalloc(const void *addr, size_t size)
 {
 	void *ret;
 	size_t shadow_size;
@@ -406,6 +407,9 @@ int kasan_module_alloc(void *addr, size_
 	shadow_size = round_up(size >> KASAN_SHADOW_SCALE_SHIFT,
 			PAGE_SIZE);
 
+	if (!(addr >= (void *)MODULES_VADDR && addr < (void *)MODULES_END))
+		return 0;
+
 	if (WARN_ON(!PAGE_ALIGNED(shadow_start)))
 		return -EINVAL;
 
@@ -417,9 +421,11 @@ int kasan_module_alloc(void *addr, size_
 	return ret ? 0 : -ENOMEM;
 }
 
-void kasan_module_free(void *addr)
+void kasan_vfree(const void *addr, const struct vm_struct *vm)
 {
-	vfree(kasan_mem_to_shadow(addr));
+	if (addr >= (void *)MODULES_VADDR && addr < (void *)MODULES_END
+		&& !(vm->flags & VM_UNINITIALIZED))
+			vfree(kasan_mem_to_shadow(addr));
 }
 
 static void register_global(struct kasan_global *global)
diff -puN mm/vmalloc.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules mm/vmalloc.c
--- a/mm/vmalloc.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/mm/vmalloc.c
@@ -20,6 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugobjects.h>
 #include <linux/kallsyms.h>
+#include <linux/kasan.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
@@ -1412,6 +1413,8 @@ struct vm_struct *remove_vm_area(const v
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->vm;
 
+		kasan_vfree(addr, vm);
+
 		spin_lock(&vmap_area_lock);
 		va->vm = NULL;
 		va->flags &= ~VM_VM_AREA;
@@ -1640,6 +1643,8 @@ void *__vmalloc_node_range(unsigned long
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		goto fail;
 
+	align = kasan_vmalloc_align(start, align);
+
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED |
 				vm_flags, start, end, node, gfp_mask, caller);
 	if (!area)
@@ -1649,6 +1654,11 @@ void *__vmalloc_node_range(unsigned long
 	if (!addr)
 		return NULL;
 
+	if (kasan_vmalloc(addr, size) < 0) {
+		vfree(addr);
+		return NULL;
+	}
+
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
 	 * flag. It means that vm_struct is not fully initialized.
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
linux-next.patch

