From: akpm@linux-foundation.org
Subject: - unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch removed from -mm tree
Date: Sat, 16 Jun 2007 08:31:25 -0700
Message-ID: <200706161531.l5GFVPc3014750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757354AbXFPPbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Jun 2007 11:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     unmap_vm_area becomes unmap_kernel_range for the public
has been removed from the -mm tree.  Its filename was
     unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unmap_vm_area becomes unmap_kernel_range for the public
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch makes unmap_vm_area static and a wrapper around a new exported
unmap_kernel_range that takes an explicit range instead of a vm_area
struct.

This makes it more versatile for code that wants to play with kernel page
tables outside of the standard vmalloc area.

(One example is some rework of the PowerPC PCI IO space mapping code that
depends on that patch and removes some code duplication and horrible abuse
of forged struct vm_struct).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cachetlb.txt   |    2 +-
 arch/powerpc/mm/imalloc.c    |    3 ++-
 arch/powerpc/mm/pgtable_64.c |    1 -
 include/linux/vmalloc.h      |    3 ++-
 mm/vmalloc.c                 |   13 +++++++++----
 5 files changed, 14 insertions(+), 8 deletions(-)

diff -puN Documentation/cachetlb.txt~unmap_vm_area-becomes-unmap_kernel_range-for-the-public Documentation/cachetlb.txt
--- a/Documentation/cachetlb.txt~unmap_vm_area-becomes-unmap_kernel_range-for-the-public
+++ a/Documentation/cachetlb.txt
@@ -253,7 +253,7 @@ Here are the routines, one by one:
 
 	The first of these two routines is invoked after map_vm_area()
 	has installed the page table entries.  The second is invoked
-	before unmap_vm_area() deletes the page table entries.
+	before unmap_kernel_range() deletes the page table entries.
 
 There exists another whole class of cpu cache issues which currently
 require a whole different set of interfaces to handle properly.
diff -puN arch/powerpc/mm/imalloc.c~unmap_vm_area-becomes-unmap_kernel_range-for-the-public arch/powerpc/mm/imalloc.c
--- a/arch/powerpc/mm/imalloc.c~unmap_vm_area-becomes-unmap_kernel_range-for-the-public
+++ a/arch/powerpc/mm/imalloc.c
@@ -301,7 +301,8 @@ void im_free(void * addr)
 	for (p = &imlist ; (tmp = *p) ; p = &tmp->next) {
 		if (tmp->addr == addr) {
 			*p = tmp->next;
-			unmap_vm_area(tmp);
+			unmap_kernel_range((unsigned long)tmp->addr,
+					   tmp->size);
 			kfree(tmp);
 			mutex_unlock(&imlist_mutex);
 			return;
diff -puN arch/powerpc/mm/pgtable_64.c~unmap_vm_area-becomes-unmap_kernel_range-for-the-public arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~unmap_vm_area-becomes-unmap_kernel_range-for-the-public
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -240,7 +240,6 @@ int __ioremap_explicit(phys_addr_t pa, u
 /*  
  * Unmap an IO region and remove it from imalloc'd list.
  * Access to IO memory should be serialized by driver.
- * This code is modeled after vmalloc code - unmap_vm_area()
  *
  * XXX	what about calls before mem_init_done (ie python_countermeasures())
  */
diff -puN include/linux/vmalloc.h~unmap_vm_area-becomes-unmap_kernel_range-for-the-public include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~unmap_vm_area-becomes-unmap_kernel_range-for-the-public
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
 
 /* Allocate/destroy a 'vmalloc' VM area. */
 extern struct vm_struct *alloc_vm_area(size_t size);
diff -puN mm/vmalloc.c~unmap_vm_area-becomes-unmap_kernel_range-for-the-public mm/vmalloc.c
--- a/mm/vmalloc.c~unmap_vm_area-becomes-unmap_kernel_range-for-the-public
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
@@ -84,7 +84,12 @@ void unmap_vm_area(struct vm_struct *are
 			continue;
 		vunmap_pud_range(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
-	flush_tlb_kernel_range((unsigned long) area->addr, end);
+	flush_tlb_kernel_range(start, end);
+}
+
+static void unmap_vm_area(struct vm_struct *area)
+{
+	unmap_kernel_range((unsigned long)area->addr, area->size);
 }
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix.patch
git-powerpc.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
8xx-fix-whitespace-and-indentation.patch
radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
controlfb-the-pseudo_palette-is-only-16-elements-long.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
