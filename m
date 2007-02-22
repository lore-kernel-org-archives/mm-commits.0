From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:53:29 -0800
Message-ID: <200702220253.l1M2rTrP002472@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXBVCy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:54:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, chrisw@sous-sol.org, clameter@sgi.com, ian.pratt@xensource.com, jeremy@xensource.com


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


Add a new mm function apply_to_page_range() which applies a given
function to every pte in a given virtual address range in a given mm
structure. This is a generic alternative to cut-and-pasting the Linux
idiomatic pagetable walking code in every place that a sequence of
PTEs must be accessed.

Although this interface is intended to be useful in a wide range of
situations, it is currently used specifically by several Xen
subsystems, for example: to ensure that pagetables have been allocated
for a virtual address range, and to construct batched special
pagetable update requests to map I/O memory (in ioremap()).

Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Christoph Lameter <clameter@sgi.com>

---

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 ++
 mm/memory.c        |   94 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN include/linux/mm.h~xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range include/linux/mm.h
--- a/include/linux/mm.h~xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range
+++ a/include/linux/mm.h
@@ -1130,6 +1130,11 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
 
+typedef int (*pte_fn_t)(pte_t *pte, struct page *pmd_page, unsigned long addr,
+			void *data);
+extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
+			       unsigned long size, pte_fn_t fn, void *data);
+
 #ifdef CONFIG_PROC_FS
 void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
 #else
diff -puN mm/memory.c~xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range mm/memory.c
--- a/mm/memory.c~xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range
+++ a/mm/memory.c
@@ -1448,6 +1448,100 @@ int remap_pfn_range(struct vm_area_struc
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
+				     unsigned long addr, unsigned long end,
+				     pte_fn_t fn, void *data)
+{
+	pte_t *pte;
+	int err;
+	struct page *pmd_page;
+	spinlock_t *ptl;
+
+	pte = (mm == &init_mm) ?
+		pte_alloc_kernel(pmd, addr) :
+		pte_alloc_map_lock(mm, pmd, addr, &ptl);
+	if (!pte)
+		return -ENOMEM;
+
+	BUG_ON(pmd_huge(*pmd));
+
+	pmd_page = pmd_page(*pmd);
+
+	do {
+		err = fn(pte, pmd_page, addr, data);
+		if (err)
+			break;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	if (mm != &init_mm)
+		pte_unmap_unlock(pte-1, ptl);
+	return err;
+}
+
+static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
+				     unsigned long addr, unsigned long end,
+				     pte_fn_t fn, void *data)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int err;
+
+	pmd = pmd_alloc(mm, pud, addr);
+	if (!pmd)
+		return -ENOMEM;
+	do {
+		next = pmd_addr_end(addr, end);
+		err = apply_to_pte_range(mm, pmd, addr, next, fn, data);
+		if (err)
+			break;
+	} while (pmd++, addr = next, addr != end);
+	return err;
+}
+
+static int apply_to_pud_range(struct mm_struct *mm, pgd_t *pgd,
+				     unsigned long addr, unsigned long end,
+				     pte_fn_t fn, void *data)
+{
+	pud_t *pud;
+	unsigned long next;
+	int err;
+
+	pud = pud_alloc(mm, pgd, addr);
+	if (!pud)
+		return -ENOMEM;
+	do {
+		next = pud_addr_end(addr, end);
+		err = apply_to_pmd_range(mm, pud, addr, next, fn, data);
+		if (err)
+			break;
+	} while (pud++, addr = next, addr != end);
+	return err;
+}
+
+/*
+ * Scan a region of virtual memory, filling in page tables as necessary
+ * and calling a provided function on each leaf page table.
+ */
+int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
+			unsigned long size, pte_fn_t fn, void *data)
+{
+	pgd_t *pgd;
+	unsigned long next;
+	unsigned long end = addr + size;
+	int err;
+
+	BUG_ON(addr >= end);
+	pgd = pgd_offset(mm, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		err = apply_to_pud_range(mm, pgd, addr, next, fn, data);
+		if (err)
+			break;
+	} while (pgd++, addr = next, addr != end);
+	return err;
+}
+EXPORT_SYMBOL_GPL(apply_to_page_range);
+
 /*
  * handle_pte_fault chooses page fault handler according to an entry
  * which was read non-atomically.  Before making any commitment, on
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
