From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:18 -0800
Message-ID: <200703020457.l224vIip000517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161136AbXCBE6S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, JBeulich@novell.com, ak@muc.de, chrisw@sous-sol.org, ian.pratt@xensource.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: allocate and free vmalloc areas
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: allocate and free vmalloc areas
From: Jeremy Fitzhardinge <jeremy@goop.org>

Allocate/destroy a 'vmalloc' VM area: alloc_vm_area and free_vm_area The alloc
function ensures that page tables are constructed for the region of kernel
virtual address space and mapped into init_mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: "Andi Kleen" <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c    |   43 ++++++++++++++++++++++++++++++++++++++
 include/linux/vmalloc.h |    4 +++
 2 files changed, 47 insertions(+)

diff -puN arch/i386/mm/fault.c~xen-paravirt_ops-allocate-and-free-vmalloc-areas arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~xen-paravirt_ops-allocate-and-free-vmalloc-areas
+++ a/arch/i386/mm/fault.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
@@ -639,3 +640,45 @@ void _vmalloc_sync_all(void)
 			start = address + PGDIR_SIZE;
 	}
 }
+
+
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
+	/* Make sure the pagetables are constructed in process kernel
+	   mappings */
+	vmalloc_sync_all();
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
diff -puN include/linux/vmalloc.h~xen-paravirt_ops-allocate-and-free-vmalloc-areas include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~xen-paravirt_ops-allocate-and-free-vmalloc-areas
+++ a/include/linux/vmalloc.h
@@ -68,6 +68,10 @@ extern int map_vm_area(struct vm_struct 
 			struct page ***pages);
 extern void unmap_vm_area(struct vm_struct *area);
 
+/* Allocate/destroy a 'vmalloc' VM area. */
+extern struct vm_struct *alloc_vm_area(unsigned long size);
+extern void free_vm_area(struct vm_struct *area);
+
 /*
  *	Internals.  Dont't use..
  */
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
