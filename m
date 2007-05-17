From: akpm@linux-foundation.org
Subject: + unmap_vm_area-becomes-unmap_kernel_range.patch added to -mm tree
Date: Thu, 17 May 2007 11:37:56 -0700
Message-ID: <200705171837.l4HIbuC6030163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439AbXEQSjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org


The patch titled
     unmap_vm_area becomes unmap_kernel_range
has been added to the -mm tree.  Its filename is
     unmap_vm_area-becomes-unmap_kernel_range.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unmap_vm_area becomes unmap_kernel_range
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch renames unmap_vm_area to unmap_kernel_range and makes it take an
explicit range instead of a vm_area struct.  This makes it more versatile
for code that wants to play with kernel page tables outside of the standard
vmalloc area.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cachetlb.txt   |    2 +-
 arch/powerpc/mm/imalloc.c    |    2 +-
 arch/powerpc/mm/pgtable_64.c |    1 -
 include/linux/vmalloc.h      |    3 ++-
 mm/vmalloc.c                 |   10 +++++-----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/cachetlb.txt~unmap_vm_area-becomes-unmap_kernel_range Documentation/cachetlb.txt
--- a/Documentation/cachetlb.txt~unmap_vm_area-becomes-unmap_kernel_range
+++ a/Documentation/cachetlb.txt
@@ -253,7 +253,7 @@ Here are the routines, one by one:
 
 	The first of these two routines is invoked after map_vm_area()
 	has installed the page table entries.  The second is invoked
-	before unmap_vm_area() deletes the page table entries.
+	before unmap_kernel_range() deletes the page table entries.
 
 There exists another whole class of cpu cache issues which currently
 require a whole different set of interfaces to handle properly.
diff -puN arch/powerpc/mm/imalloc.c~unmap_vm_area-becomes-unmap_kernel_range arch/powerpc/mm/imalloc.c
--- a/arch/powerpc/mm/imalloc.c~unmap_vm_area-becomes-unmap_kernel_range
+++ a/arch/powerpc/mm/imalloc.c
@@ -301,7 +301,7 @@ void im_free(void * addr)
 	for (p = &imlist ; (tmp = *p) ; p = &tmp->next) {
 		if (tmp->addr == addr) {
 			*p = tmp->next;
-			unmap_vm_area(tmp);
+			unmap_kernel_range(tmp->addr, tmp->size);
 			kfree(tmp);
 			mutex_unlock(&imlist_mutex);
 			return;
diff -puN arch/powerpc/mm/pgtable_64.c~unmap_vm_area-becomes-unmap_kernel_range arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~unmap_vm_area-becomes-unmap_kernel_range
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -240,7 +240,6 @@ int __ioremap_explicit(phys_addr_t pa, u
 /*  
  * Unmap an IO region and remove it from imalloc'd list.
  * Access to IO memory should be serialized by driver.
- * This code is modeled after vmalloc code - unmap_vm_area()
  *
  * XXX	what about calls before mem_init_done (ie python_countermeasures())
  */
diff -puN include/linux/vmalloc.h~unmap_vm_area-becomes-unmap_kernel_range include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~unmap_vm_area-becomes-unmap_kernel_range
+++ a/include/linux/vmalloc.h
@@ -65,9 +65,10 @@ extern struct vm_struct *get_vm_area_nod
 					  unsigned long flags, int node,
 					  gfp_t gfp_mask);
 extern struct vm_struct *remove_vm_area(void *addr);
+
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
 			struct page ***pages);
-extern void unmap_vm_area(struct vm_struct *area);
+extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 
 /*
  *	Internals.  Dont't use..
diff -puN mm/vmalloc.c~unmap_vm_area-becomes-unmap_kernel_range mm/vmalloc.c
--- a/mm/vmalloc.c~unmap_vm_area-becomes-unmap_kernel_range
+++ a/mm/vmalloc.c
@@ -68,12 +68,12 @@ static inline void vunmap_pud_range(pgd_
 	} while (pud++, addr = next, addr != end);
 }
 
-void unmap_vm_area(struct vm_struct *area)
+void unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long addr = (unsigned long) area->addr;
-	unsigned long end = addr + area->size;
+	unsigned long start = addr;
+	unsigned long end = addr + size;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset_k(addr);
@@ -84,7 +84,7 @@ void unmap_vm_area(struct vm_struct *are
 			continue;
 		vunmap_pud_range(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
-	flush_tlb_kernel_range((unsigned long) area->addr, end);
+	flush_tlb_kernel_range(start, end);
 }
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
@@ -284,7 +284,7 @@ static struct vm_struct *__remove_vm_are
 	return NULL;
 
 found:
-	unmap_vm_area(tmp);
+	unmap_kernel_range(tmp->addr, tmp->size);
 	*p = tmp->next;
 
 	/*
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

make-__vunmap-static.patch
unmap_vm_area-becomes-unmap_kernel_range.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
8xx-mpc885ads-pcmcia-support-fix.patch
8xx-fix-whitespace-and-indentation.patch
dts-kill-hardcoded-phandles.patch
