From: akpm@linux-foundation.org
Subject: - x86-fix-iounmaps-use-of-vm_structs-size-field.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:53 -0700
Message-ID: <200707192010.l6JKAr6e020711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52446 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188AbXGSUTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, cebbert@redhat.com, hidave.darkstar@gmail.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix iounmap's use of vm_struct's size field
has been removed from the -mm tree.  Its filename was
     x86-fix-iounmaps-use-of-vm_structs-size-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: fix iounmap's use of vm_struct's size field
From: Jeremy Fitzhardinge <jeremy@goop.org>

get_vm_area always returns an area with an adjacent guard page.  That guard
page is included in vm_struct.size.  iounmap uses vm_struct.size to
determine how much address space needs to have change_page_attr applied to
it, which will BUG if applied to the guard page.

This patch adds a helper function - get_vm_area_size() in linux/vmalloc.h -
to return the actual size of a vm area, and uses it to make iounmap do the
right thing.  There are probably other places which should be using
get_vm_area_size().

Thanks to Dave Young <hidave.darkstar@gmail.com> for debugging the
problem.

[ Andi, it wasn't clear to me whether x86_64 needs the same fix. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/ioremap.c  |    2 +-
 include/linux/vmalloc.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/i386/mm/ioremap.c~x86-fix-iounmaps-use-of-vm_structs-size-field arch/i386/mm/ioremap.c
--- a/arch/i386/mm/ioremap.c~x86-fix-iounmaps-use-of-vm_structs-size-field
+++ a/arch/i386/mm/ioremap.c
@@ -196,7 +196,7 @@ void iounmap(volatile void __iomem *addr
 	/* Reset the direct mapping. Can block */
 	if ((p->flags >> 20) && p->phys_addr < virt_to_phys(high_memory) - 1) {
 		change_page_attr(virt_to_page(__va(p->phys_addr)),
-				 p->size >> PAGE_SHIFT,
+				 get_vm_area_size(p) >> PAGE_SHIFT,
 				 PAGE_KERNEL);
 		global_flush_tlb();
 	} 
diff -puN include/linux/vmalloc.h~x86-fix-iounmaps-use-of-vm_structs-size-field include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~x86-fix-iounmaps-use-of-vm_structs-size-field
+++ a/include/linux/vmalloc.h
@@ -70,6 +70,12 @@ extern int map_vm_area(struct vm_struct 
 			struct page ***pages);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 
+static inline size_t get_vm_area_size(const struct vm_struct *area)
+{
+	/* return actual size without guard page */
+	return area->size - PAGE_SIZE;
+}
+
 /* Allocate/destroy a 'vmalloc' VM area. */
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-kbuild.patch
acpiphp_ibm-add-missing-n.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fix-the-softlockup-watchdog-to-actually-work.patch
