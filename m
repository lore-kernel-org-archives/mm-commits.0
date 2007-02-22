From: akpm@linux-foundation.org
Subject: - xen-paravirt-allocate-and-free-vmalloc-areas.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:36:21 -0800
Message-ID: <200702220236.l1M2aLpI002011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbXBVChe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, ak@suse.de, chrisw@sous-sol.org, ian.pratt@xensource.com, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Xen-paravirt: allocate and free vmalloc areas
has been removed from the -mm tree.  Its filename was
     xen-paravirt-allocate-and-free-vmalloc-areas.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Xen-paravirt: allocate and free vmalloc areas
From: Jeremy Fitzhardinge <jeremy@goop.org>

Allocate/destroy a 'vmalloc' VM area: alloc_vm_area and free_vm_area The alloc
function ensures that page tables are constructed for the region of kernel
virtual address space and mapped into init_mm.

Lock an area so that PTEs are accessible in the current address space:
lock_vm_area and unlock_vm_area.  The lock function prevents context switches
to a lazy mm that doesn't have the area mapped into its page tables.  It also
ensures that the page tables are mapped into the current mm by causing the
page fault handler to copy the page directory pointers from init_mm into the
current mm.

These functions are not particularly Xen-specific, so they're put into
mm/vmalloc.c.

Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    8 ++++
 mm/vmalloc.c            |   62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff -puN include/linux/vmalloc.h~xen-paravirt-allocate-and-free-vmalloc-areas include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~xen-paravirt-allocate-and-free-vmalloc-areas
+++ a/include/linux/vmalloc.h
@@ -68,6 +68,14 @@ extern int map_vm_area(struct vm_struct 
 			struct page ***pages);
 extern void unmap_vm_area(struct vm_struct *area);
 
+/* Allocate/destroy a 'vmalloc' VM area. */
+extern struct vm_struct *alloc_vm_area(unsigned long size);
+extern void free_vm_area(struct vm_struct *area);
+
+/* Lock an area so that PTEs are accessible in the current address space. */
+extern void lock_vm_area(struct vm_struct *area);
+extern void unlock_vm_area(struct vm_struct *area);
+
 /*
  *	Internals.  Dont't use..
  */
diff -puN mm/vmalloc.c~xen-paravirt-allocate-and-free-vmalloc-areas mm/vmalloc.c
--- a/mm/vmalloc.c~xen-paravirt-allocate-and-free-vmalloc-areas
+++ a/mm/vmalloc.c
@@ -749,3 +749,65 @@ out_einval_locked:
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
+static int f(pte_t *pte, struct page *pmd_page, unsigned long addr, void *data)
+{
+	/* apply_to_page_range() does all the hard work. */
+	return 0;
+}
+
+struct vm_struct *alloc_vm_area(unsigned long size)
+{
+	struct vm_struct *area;
+
+	area = get_vm_area(size, VM_IOREMAP);
+	if (area == NULL)
+		return NULL;
+
+	/*
+	 * This ensures that page tables are constructed for this region
+	 * of kernel virtual address space and mapped into init_mm.
+	 */
+	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
+				area->size, f, NULL)) {
+		free_vm_area(area);
+		return NULL;
+	}
+
+	return area;
+}
+EXPORT_SYMBOL_GPL(alloc_vm_area);
+
+void free_vm_area(struct vm_struct *area)
+{
+	struct vm_struct *ret;
+	ret = remove_vm_area(area->addr);
+	BUG_ON(ret != area);
+	kfree(area);
+}
+EXPORT_SYMBOL_GPL(free_vm_area);
+
+void lock_vm_area(struct vm_struct *area)
+{
+	unsigned long i;
+	char c;
+
+	/*
+	 * Prevent context switch to a lazy mm that doesn't have this area
+	 * mapped into its page tables.
+	 */
+	preempt_disable();
+
+	/*
+	 * Ensure that the page tables are mapped into the current mm. The
+	 * page-fault path will copy the page directory pointers from init_mm.
+	 */
+	for (i = 0; i < area->size; i += PAGE_SIZE)
+		(void)__get_user(c, (char __user *)area->addr + i);
+}
+EXPORT_SYMBOL_GPL(lock_vm_area);
+
+void unlock_vm_area(struct vm_struct *area)
+{
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(unlock_vm_area);
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-core-xen-implementation-fix.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
