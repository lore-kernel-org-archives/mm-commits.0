From: akpm@linux-foundation.org
Subject: + mm-unify-module_alloc-code-for-vmalloc.patch added to -mm tree
Date: Mon, 22 Nov 2010 15:36:56 -0800
Message-ID: <201011222336.oAMNau8e015687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791Ab0KVXho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 18:37:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux.com, davem@davemloft.net, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, ralf@linux-mips.org, tglx@linutronix.de


The patch titled
     mm: unify module_alloc code for vmalloc
has been added to the -mm tree.  Its filename is
     mm-unify-module_alloc-code-for-vmalloc.patch

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
Subject: mm: unify module_alloc code for vmalloc
From: David Rientjes <rientjes@google.com>

Four architectures (arm, mips, sparc, x86) use __vmalloc_area() for
module_init().  Much of the code is duplicated and can be generalized in a
globally accessible function, __vmalloc_node_range().

__vmalloc_node() now calls into __vmalloc_node_range() with a range of
[VMALLOC_START, VMALLOC_END) for functionally equivalent behavior.

Each architecture may then use __vmalloc_node_range() directly to remove
the duplication of code.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/module.c   |   14 ++-------
 arch/mips/kernel/module.c  |   14 ++-------
 arch/sparc/kernel/module.c |   14 ++-------
 arch/x86/kernel/module.c   |   17 ++---------
 include/linux/vmalloc.h    |    5 ++-
 mm/vmalloc.c               |   50 ++++++++++++++++++++---------------
 6 files changed, 46 insertions(+), 68 deletions(-)

diff -puN arch/arm/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc arch/arm/kernel/module.c
--- a/arch/arm/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc
+++ a/arch/arm/kernel/module.c
@@ -38,17 +38,9 @@
 #ifdef CONFIG_MMU
 void *module_alloc(unsigned long size)
 {
-	struct vm_struct *area;
-
-	size = PAGE_ALIGN(size);
-	if (!size)
-		return NULL;
-
-	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
-	if (!area)
-		return NULL;
-
-	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
+	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
+				__builtin_return_address(0));
 }
 #else /* CONFIG_MMU */
 void *module_alloc(unsigned long size)
diff -puN arch/mips/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc
+++ a/arch/mips/kernel/module.c
@@ -46,17 +46,9 @@ static DEFINE_SPINLOCK(dbe_lock);
 void *module_alloc(unsigned long size)
 {
 #ifdef MODULE_START
-	struct vm_struct *area;
-
-	size = PAGE_ALIGN(size);
-	if (!size)
-		return NULL;
-
-	area = __get_vm_area(size, VM_ALLOC, MODULE_START, MODULE_END);
-	if (!area)
-		return NULL;
-
-	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL);
+	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
+				GFP_KERNEL, PAGE_KERNEL, -1,
+				__builtin_return_address(0));
 #else
 	if (size == 0)
 		return NULL;
diff -puN arch/sparc/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc arch/sparc/kernel/module.c
--- a/arch/sparc/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc
+++ a/arch/sparc/kernel/module.c
@@ -23,17 +23,11 @@
 
 static void *module_map(unsigned long size)
 {
-	struct vm_struct *area;
-
-	size = PAGE_ALIGN(size);
-	if (!size || size > MODULES_LEN)
-		return NULL;
-
-	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
-	if (!area)
+	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
-
-	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL);
+	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
+				GFP_KERNEL, PAGE_KERNEL, -1,
+				__builtin_return_address(0));
 }
 
 static char *dot2underscore(char *name)
diff -puN arch/x86/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c~mm-unify-module_alloc-code-for-vmalloc
+++ a/arch/x86/kernel/module.c
@@ -37,20 +37,11 @@
 
 void *module_alloc(unsigned long size)
 {
-	struct vm_struct *area;
-
-	if (!size)
-		return NULL;
-	size = PAGE_ALIGN(size);
-	if (size > MODULES_LEN)
+	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
-
-	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
-	if (!area)
-		return NULL;
-
-	return __vmalloc_area(area, GFP_KERNEL | __GFP_HIGHMEM,
-					PAGE_KERNEL_EXEC);
+	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
+				GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+				-1, __builtin_return_address(0));
 }
 
 /* Free memory returned from module_alloc */
diff -puN include/linux/vmalloc.h~mm-unify-module_alloc-code-for-vmalloc include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-unify-module_alloc-code-for-vmalloc
+++ a/include/linux/vmalloc.h
@@ -61,8 +61,9 @@ extern void *vmalloc_exec(unsigned long 
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
-extern void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask,
-				pgprot_t prot);
+extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
+			unsigned long start, unsigned long end, gfp_t gfp_mask,
+			pgprot_t prot, int node, void *caller);
 extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
diff -puN mm/vmalloc.c~mm-unify-module_alloc-code-for-vmalloc mm/vmalloc.c
--- a/mm/vmalloc.c~mm-unify-module_alloc-code-for-vmalloc
+++ a/mm/vmalloc.c
@@ -1581,25 +1581,12 @@ fail:
 	return NULL;
 }
 
-void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
-{
-	void *addr = __vmalloc_area_node(area, gfp_mask, prot, -1,
-					 __builtin_return_address(0));
-
-	/*
-	 * A ref_count = 3 is needed because the vm_struct and vmap_area
-	 * structures allocated in the __get_vm_area_node() function contain
-	 * references to the virtual address of the vmalloc'ed block.
-	 */
-	kmemleak_alloc(addr, area->size - PAGE_SIZE, 3, gfp_mask);
-
-	return addr;
-}
-
 /**
- *	__vmalloc_node  -  allocate virtually contiguous memory
+ *	__vmalloc_node_range  -  allocate virtually contiguous memory
  *	@size:		allocation size
  *	@align:		desired alignment
+ *	@start:		vm area range start
+ *	@end:		vm area range end
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
  *	@node:		node to use for allocation or -1
@@ -1609,9 +1596,9 @@ void *__vmalloc_area(struct vm_struct *a
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
  */
-static void *__vmalloc_node(unsigned long size, unsigned long align,
-			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, void *caller)
+void *__vmalloc_node_range(unsigned long size, unsigned long align,
+			unsigned long start, unsigned long end, gfp_t gfp_mask,
+			pgprot_t prot, int node, void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1621,8 +1608,8 @@ static void *__vmalloc_node(unsigned lon
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
-	area = __get_vm_area_node(size, align, VM_ALLOC, VMALLOC_START,
-				  VMALLOC_END, node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC, start, end, node,
+				  gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1639,6 +1626,27 @@ static void *__vmalloc_node(unsigned lon
 	return addr;
 }
 
+/**
+ *	__vmalloc_node  -  allocate virtually contiguous memory
+ *	@size:		allocation size
+ *	@align:		desired alignment
+ *	@gfp_mask:	flags for the page level allocator
+ *	@prot:		protection mask for the allocated pages
+ *	@node:		node to use for allocation or -1
+ *	@caller:	caller's return address
+ *
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator with @gfp_mask flags.  Map them into contiguous
+ *	kernel virtual space, using a pagetable protection of @prot.
+ */
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
+			    int node, void *caller)
+{
+	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
+				gfp_mask, prot, node, caller);
+}
+
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
 	return __vmalloc_node(size, 1, gfp_mask, prot, -1,
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
jbd-remove-dependency-on-__gfp_nofail.patch

