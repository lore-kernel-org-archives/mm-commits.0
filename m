From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:19 -0700
Message-ID: <20130430184719.A02805A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:44378 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3D3SrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:21 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so84838ggc.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, anderson@redhat.com, cmetcalf@tilera.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, iamjoonsoo.kim@lge.com, kumagai-atsushi@mxc.nes.nec.co.jp, mingo@kernel.org, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: change iterating a vmlist to find_vm_area()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, vmalloc: change iterating a vmlist to find_vm_area()

This patchset removes vm_struct list management after initializing
vmalloc.  Adding and removing an entry to vmlist is linear time
complexity, so it is inefficient.  If we maintain this list, overall time
complexity of adding and removing area to vmalloc space is O(N), although
we use rbtree for finding vacant place and it's time complexity is just
O(logN).

And vmlist and vmlist_lock is used many places of outside of vmalloc.c. 
It is preferable that we hide this raw data structure and provide
well-defined function for supporting them, because it makes that they
cannot mistake when manipulating theses structure and it makes us easily
maintain vmalloc layer.

For kexec and makedumpfile, I export vmap_area_list, instead of vmlist. 
This comes from Atsushi's recommendation.  For more information, please
refer below link.  https://lkml.org/lkml/2012/12/6/184


This patch:

The purpose of iterating a vmlist is finding vm area with specific virtual
address.  find_vm_area() is provided for this purpose and more efficient,
because it uses a rbtree.  So change it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/pgtable.c      |    7 +------
 arch/unicore32/mm/ioremap.c |   17 +++++------------
 arch/x86/mm/ioremap.c       |    7 +------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff -puN arch/tile/mm/pgtable.c~mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area
+++ a/arch/tile/mm/pgtable.c
@@ -592,12 +592,7 @@ void iounmap(volatile void __iomem *addr
 	   in parallel. Reuse of the virtual address is prevented by
 	   leaving it in the global lists until we're done with it.
 	   cpa takes care of the direct mappings. */
-	read_lock(&vmlist_lock);
-	for (p = vmlist; p; p = p->next) {
-		if (p->addr == addr)
-			break;
-	}
-	read_unlock(&vmlist_lock);
+	p = find_vm_area((void *)addr);
 
 	if (!p) {
 		pr_err("iounmap: bad address %p\n", addr);
diff -puN arch/unicore32/mm/ioremap.c~mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area arch/unicore32/mm/ioremap.c
--- a/arch/unicore32/mm/ioremap.c~mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area
+++ a/arch/unicore32/mm/ioremap.c
@@ -235,7 +235,7 @@ EXPORT_SYMBOL(__uc32_ioremap_cached);
 void __uc32_iounmap(volatile void __iomem *io_addr)
 {
 	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
-	struct vm_struct **p, *tmp;
+	struct vm_struct *vm;
 
 	/*
 	 * If this is a section based mapping we need to handle it
@@ -244,17 +244,10 @@ void __uc32_iounmap(volatile void __iome
 	 * all the mappings before the area can be reclaimed
 	 * by someone else.
 	 */
-	write_lock(&vmlist_lock);
-	for (p = &vmlist ; (tmp = *p) ; p = &tmp->next) {
-		if ((tmp->flags & VM_IOREMAP) && (tmp->addr == addr)) {
-			if (tmp->flags & VM_UNICORE_SECTION_MAPPING) {
-				unmap_area_sections((unsigned long)tmp->addr,
-						    tmp->size);
-			}
-			break;
-		}
-	}
-	write_unlock(&vmlist_lock);
+	vm = find_vm_area(addr);
+	if (vm && (vm->flags & VM_IOREMAP) &&
+		(vm->flags & VM_UNICORE_SECTION_MAPPING))
+		unmap_area_sections((unsigned long)vm->addr, vm->size);
 
 	vunmap(addr);
 }
diff -puN arch/x86/mm/ioremap.c~mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area
+++ a/arch/x86/mm/ioremap.c
@@ -282,12 +282,7 @@ void iounmap(volatile void __iomem *addr
 	   in parallel. Reuse of the virtual address is prevented by
 	   leaving it in the global lists until we're done with it.
 	   cpa takes care of the direct mappings. */
-	read_lock(&vmlist_lock);
-	for (p = vmlist; p; p = p->next) {
-		if (p->addr == (void __force *)addr)
-			break;
-	}
-	read_unlock(&vmlist_lock);
+	p = find_vm_area((void __force *)addr);
 
 	if (!p) {
 		printk(KERN_ERR "iounmap: bad address %p\n", addr);
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch

