From: akpm@linux-foundation.org
Subject: [merged]
 kasan-module-vmalloc-rework-shadow-allocation-for-modules.patch removed
 from -mm tree
Date: Mon, 16 Mar 2015 11:02:50 -0700
Message-ID: <55071aca.8sGBpNeFlUKCfVwq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbbCPSCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, module, vmalloc: rework shadow allocation for modules
has been removed from the -mm tree.  Its filename was
     kasan-module-vmalloc-rework-shadow-allocation-for-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan, module, vmalloc: rework shadow allocation for modules

Current approach in handling shadow memory for modules is broken.

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

Free shadow right before releasing vm area.  At this point vfree()'d
memory is not used anymore and yet not available for other allocations. 
New VM_KASAN flag used to indicate that vm area has dynamically allocated
shadow memory so kasan frees shadow only if it was previously allocated.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h   |    5 +++--
 include/linux/vmalloc.h |    1 +
 kernel/module.c         |    2 --
 mm/kasan/kasan.c        |   14 +++++++++++---
 mm/vmalloc.c            |    1 +
 5 files changed, 16 insertions(+), 7 deletions(-)

diff -puN include/linux/kasan.h~kasan-module-vmalloc-rework-shadow-allocation-for-modules include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/include/linux/kasan.h
@@ -5,6 +5,7 @@
 
 struct kmem_cache;
 struct page;
+struct vm_struct;
 
 #ifdef CONFIG_KASAN
 
@@ -52,7 +53,7 @@ void kasan_slab_free(struct kmem_cache *
 #define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
 
 int kasan_module_alloc(void *addr, size_t size);
-void kasan_module_free(void *addr);
+void kasan_free_shadow(const struct vm_struct *vm);
 
 #else /* CONFIG_KASAN */
 
@@ -82,7 +83,7 @@ static inline void kasan_slab_alloc(stru
 static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
 
 static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
-static inline void kasan_module_free(void *addr) {}
+static inline void kasan_free_shadow(const struct vm_struct *vm) {}
 
 #endif /* CONFIG_KASAN */
 
diff -puN include/linux/vmalloc.h~kasan-module-vmalloc-rework-shadow-allocation-for-modules include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/include/linux/vmalloc.h
@@ -17,6 +17,7 @@ struct vm_area_struct;		/* vma defining
 #define VM_VPAGES		0x00000010	/* buffer for pages was vmalloc'ed */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
+#define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
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
@@ -414,12 +415,19 @@ int kasan_module_alloc(void *addr, size_
 			GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
 			PAGE_KERNEL, VM_NO_GUARD, NUMA_NO_NODE,
 			__builtin_return_address(0));
-	return ret ? 0 : -ENOMEM;
+
+	if (ret) {
+		find_vm_area(addr)->flags |= VM_KASAN;
+		return 0;
+	}
+
+	return -ENOMEM;
 }
 
-void kasan_module_free(void *addr)
+void kasan_free_shadow(const struct vm_struct *vm)
 {
-	vfree(kasan_mem_to_shadow(addr));
+	if (vm->flags & VM_KASAN)
+		vfree(kasan_mem_to_shadow(vm->addr));
 }
 
 static void register_global(struct kasan_global *global)
diff -puN mm/vmalloc.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules mm/vmalloc.c
--- a/mm/vmalloc.c~kasan-module-vmalloc-rework-shadow-allocation-for-modules
+++ a/mm/vmalloc.c
@@ -1418,6 +1418,7 @@ struct vm_struct *remove_vm_area(const v
 		spin_unlock(&vmap_area_lock);
 
 		vmap_debug_free_range(va->va_start, va->va_end);
+		kasan_free_shadow(vm);
 		free_unmap_vmap_area(va);
 		vm->size -= PAGE_SIZE;
 
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
linux-next.patch

