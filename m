From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch added to
 -mm tree
Date: Tue, 03 Feb 2015 15:05:31 -0800
Message-ID: <54d1543b.QDPDoSOIuZmpcYor%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbBCXFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: pass additional vm_flags to __vmalloc_node_range()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch

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
Subject: mm: vmalloc: pass additional vm_flags to __vmalloc_node_range()

For instrumenting global variables KASan will shadow memory backing memory
for modules.  So on module loading we will need to allocate memory for
shadow and map it at address in shadow that corresponds to the address
allocated in module_alloc().

__vmalloc_node_range() could be used for this purpose, except it puts a
guard hole after allocated area.  Guard hole in shadow memory should be a
problem because at some future point we might need to have a shadow memory
at address occupied by guard hole.  So we could fail to allocate shadow
for module_alloc().

Now we have VM_NO_GUARD flag disabling guard page, so we need to pass into
__vmalloc_node_range().  Add new parameter 'vm_flags' to
__vmalloc_node_range() function.

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

 arch/arm/kernel/module.c       |    2 +-
 arch/arm64/kernel/module.c     |    4 ++--
 arch/mips/kernel/module.c      |    2 +-
 arch/parisc/kernel/module.c    |    2 +-
 arch/s390/kernel/module.c      |    2 +-
 arch/sparc/kernel/module.c     |    2 +-
 arch/unicore32/kernel/module.c |    2 +-
 arch/x86/kernel/module.c       |    2 +-
 include/linux/vmalloc.h        |    4 +++-
 mm/vmalloc.c                   |   10 ++++++----
 10 files changed, 18 insertions(+), 14 deletions(-)

diff -puN arch/arm/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/arm/kernel/module.c
--- a/arch/arm/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/arm/kernel/module.c
@@ -41,7 +41,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff -puN arch/arm64/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/arm64/kernel/module.c
--- a/arch/arm64/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/arm64/kernel/module.c
@@ -35,8 +35,8 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+				    GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
+				    NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 enum aarch64_reloc_op {
diff -puN arch/mips/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/mips/kernel/module.c
@@ -47,7 +47,7 @@ static DEFINE_SPINLOCK(dbe_lock);
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
-				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff -puN arch/parisc/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/parisc/kernel/module.c
--- a/arch/parisc/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/parisc/kernel/module.c
@@ -219,7 +219,7 @@ void *module_alloc(unsigned long size)
 	 * init_data correctly */
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
 				    GFP_KERNEL | __GFP_HIGHMEM,
-				    PAGE_KERNEL_RWX, NUMA_NO_NODE,
+				    PAGE_KERNEL_RWX, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff -puN arch/s390/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/s390/kernel/module.c
--- a/arch/s390/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/s390/kernel/module.c
@@ -50,7 +50,7 @@ void *module_alloc(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
+				    GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 #endif
diff -puN arch/sparc/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/sparc/kernel/module.c
--- a/arch/sparc/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/sparc/kernel/module.c
@@ -29,7 +29,7 @@ static void *module_map(unsigned long si
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #else
diff -puN arch/unicore32/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/unicore32/kernel/module.c
--- a/arch/unicore32/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/unicore32/kernel/module.c
@@ -25,7 +25,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 
diff -puN arch/x86/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/arch/x86/kernel/module.c
@@ -88,7 +88,7 @@ void *module_alloc(unsigned long size)
 	return __vmalloc_node_range(size, 1,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL | __GFP_HIGHMEM,
-				    PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff -puN include/linux/vmalloc.h~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/include/linux/vmalloc.h
@@ -76,7 +76,9 @@ extern void *vmalloc_32_user(unsigned lo
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
-			pgprot_t prot, int node, const void *caller);
+			pgprot_t prot, unsigned long vm_flags, int node,
+			const void *caller);
+
 extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
diff -puN mm/vmalloc.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range
+++ a/mm/vmalloc.c
@@ -1619,6 +1619,7 @@ fail:
  *	@end:		vm area range end
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
+ *	@vm_flags:	additional vm area flags (e.g. %VM_NO_GUARD)
  *	@node:		node to use for allocation or NUMA_NO_NODE
  *	@caller:	caller's return address
  *
@@ -1628,7 +1629,8 @@ fail:
  */
 void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
-			pgprot_t prot, int node, const void *caller)
+			pgprot_t prot, unsigned long vm_flags, int node,
+			const void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1638,8 +1640,8 @@ void *__vmalloc_node_range(unsigned long
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		goto fail;
 
-	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED,
-				  start, end, node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED |
+				vm_flags, start, end, node, gfp_mask, caller);
 	if (!area)
 		goto fail;
 
@@ -1688,7 +1690,7 @@ static void *__vmalloc_node(unsigned lon
 			    int node, const void *caller)
 {
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
-				gfp_mask, prot, node, caller);
+				gfp_mask, prot, 0, node, caller);
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
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

