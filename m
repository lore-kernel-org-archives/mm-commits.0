From: akpm@linux-foundation.org
Subject: + mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba.patch added to -mm tree
Date: Thu, 10 Sep 2009 14:31:53 -0700
Message-ID: <200909102131.n8ALVrwo031332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbZIJVcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 17:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     mm: Make vmalloc_user() align base kernel virtual address to SHMLBA
has been added to the -mm tree.  Its filename is
     mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba.patch

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
Subject: mm: Make vmalloc_user() align base kernel virtual address to SHMLBA
From: David Miller <davem@davemloft.net>

When a vmalloc'd area is mmap'd into userspace, some kind of co-ordination
is necessary for this to work on platforms with cpu D-caches which can
have aliases.

Otherwise kernel side writes won't be seen properly in userspace and vice
versa.

If the kernel side mapping and the user side one have the same alignment,
modulo SHMLBA, this can work as long as VM_SHARED is shared of VMA and for
all current users this is true.  VM_SHARED will force SHMLBA alignment of
the user side mmap on platforms with D-cache aliasing matters.

The bulk of this patch is just making it so that a specific alignment can
be passed down into __get_vm_area_node().  All existing callers pass in
'1' which preserves existing behavior.  vmalloc_user() gives SHMLBA for
the alignment.

As a side effect this should get the video media drivers and other
vmalloc_user() users into more working shape on such systems.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff -puN mm/vmalloc.c~mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba mm/vmalloc.c
--- a/mm/vmalloc.c~mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba
+++ a/mm/vmalloc.c
@@ -29,6 +29,7 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
+#include <asm/shmparam.h>
 
 
 /*** Page table manipulation functions ***/
@@ -1156,12 +1157,11 @@ static void insert_vmalloc_vm(struct vm_
 }
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
-		unsigned long flags, unsigned long start, unsigned long end,
-		int node, gfp_t gfp_mask, void *caller)
+		unsigned long align, unsigned long flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
 	static struct vmap_area *va;
 	struct vm_struct *area;
-	unsigned long align = 1;
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
@@ -1201,7 +1201,7 @@ static struct vm_struct *__get_vm_area_n
 struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 				unsigned long start, unsigned long end)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 						__builtin_return_address(0));
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
@@ -1210,7 +1210,7 @@ struct vm_struct *__get_vm_area_caller(u
 				       unsigned long start, unsigned long end,
 				       void *caller)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 				  caller);
 }
 
@@ -1225,22 +1225,22 @@ struct vm_struct *__get_vm_area_caller(u
  */
 struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 				-1, GFP_KERNEL, __builtin_return_address(0));
 }
 
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				void *caller)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 						-1, GFP_KERNEL, caller);
 }
 
 struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags,
 				   int node, gfp_t gfp_mask)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END, node,
-				  gfp_mask, __builtin_return_address(0));
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
+				  node, gfp_mask, __builtin_return_address(0));
 }
 
 static struct vm_struct *find_vm_area(const void *addr)
@@ -1403,7 +1403,8 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node, void *caller)
@@ -1417,7 +1418,7 @@ static void *__vmalloc_area_node(struct 
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, 1, gfp_mask | __GFP_ZERO,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
@@ -1476,6 +1477,7 @@ void *__vmalloc_area(struct vm_struct *a
 /**
  *	__vmalloc_node  -  allocate virtually contiguous memory
  *	@size:		allocation size
+ *	@align:		desired alignment
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
  *	@node:		node to use for allocation or -1
@@ -1485,8 +1487,9 @@ void *__vmalloc_area(struct vm_struct *a
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
  */
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
-						int node, void *caller)
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
+			    int node, void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1496,8 +1499,8 @@ static void *__vmalloc_node(unsigned lon
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
-	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
-						node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC, VMALLOC_START,
+				  VMALLOC_END, node, gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1516,7 +1519,7 @@ static void *__vmalloc_node(unsigned lon
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_node(size, gfp_mask, prot, -1,
+	return __vmalloc_node(size, 1, gfp_mask, prot, -1,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
@@ -1532,7 +1535,7 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					-1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc);
@@ -1549,7 +1552,8 @@ void *vmalloc_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+	ret = __vmalloc_node(size, SHMLBA,
+			     GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
 			     PAGE_KERNEL, -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
@@ -1572,7 +1576,7 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
@@ -1595,7 +1599,7 @@ EXPORT_SYMBOL(vmalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
 			      -1, __builtin_return_address(0));
 }
 
@@ -1616,7 +1620,7 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_VMALLOC32, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_VMALLOC32, PAGE_KERNEL,
 			      -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
@@ -1633,7 +1637,7 @@ void *vmalloc_32_user(unsigned long size
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
+	ret = __vmalloc_node(size, 1, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
 			     -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
_

Patches currently in -mm which might be from davem@davemloft.net are

linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
ide-use-printk_once.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch
sparc32-convert-to-asm-generic-hardirqh.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba.patch
perf-allocate-mmap-buffer-using-vmalloc_user.patch
move-magic-numbers-into-magich.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-pattern-depth.patch
kprobes-use-do_irq-in-lkdtm.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

