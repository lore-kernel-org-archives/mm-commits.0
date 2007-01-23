From: akpm@osdl.org
Subject: + add-install_special_mapping.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:49:15 -0800
Message-ID: <200701231949.l0NJnF4e029469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965465AbXAWTuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:50:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     Add install_special_mapping
has been added to the -mm tree.  Its filename is
     add-install_special_mapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add install_special_mapping
From: Roland McGrath <roland@redhat.com>

This patch adds a utility function install_special_mapping, for creating a
special vma using a fixed set of preallocated pages as backing, such as for a
vDSO.  This consolidates some nearly identical code used for vDSO mapping
reimplemented for different architectures.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h |    3 +
 mm/mmap.c          |   72 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff -puN include/linux/mm.h~add-install_special_mapping include/linux/mm.h
--- a/include/linux/mm.h~add-install_special_mapping
+++ a/include/linux/mm.h
@@ -1030,6 +1030,9 @@ extern struct vm_area_struct *copy_vma(s
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
 extern void exit_mmap(struct mm_struct *);
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+extern int install_special_mapping(struct mm_struct *mm,
+				   unsigned long addr, unsigned long len,
+				   unsigned long flags, struct page **pages);
 
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
diff -puN mm/mmap.c~add-install_special_mapping mm/mmap.c
--- a/mm/mmap.c~add-install_special_mapping
+++ a/mm/mmap.c
@@ -2094,3 +2094,75 @@ int may_expand_vm(struct mm_struct *mm, 
 		return 0;
 	return 1;
 }
+
+
+static struct page *special_mapping_nopage(struct vm_area_struct *vma,
+					   unsigned long address, int *type)
+{
+	struct page **pages;
+
+	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+
+	address -= vma->vm_start;
+	for (pages = vma->vm_private_data; address > 0 && *pages; ++pages)
+		address -= PAGE_SIZE;
+
+	if (*pages) {
+		struct page *page = *pages;
+		get_page(page);
+		return page;
+	}
+
+	return NOPAGE_SIGBUS;
+}
+
+/*
+ * Having a close hook prevents vma merging regardless of flags.
+ */
+static void special_mapping_close(struct vm_area_struct *vma)
+{
+}
+
+static struct vm_operations_struct special_mapping_vmops = {
+	.close = special_mapping_close,
+	.nopage	= special_mapping_nopage,
+};
+
+/*
+ * Called with mm->mmap_sem held for writing.
+ * Insert a new vma covering the given region, with the given flags.
+ * Its pages are supplied by the given array of struct page *.
+ * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
+ * The region past the last page supplied will always produce SIGBUS.
+ * The array pointer and the pages it points to are assumed to stay alive
+ * for as long as this mapping might exist.
+ */
+int install_special_mapping(struct mm_struct *mm,
+			    unsigned long addr, unsigned long len,
+			    unsigned long vm_flags, struct page **pages)
+{
+	struct vm_area_struct *vma;
+
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
+	if (unlikely(vma == NULL))
+		return -ENOMEM;
+
+	vma->vm_mm = mm;
+	vma->vm_start = addr;
+	vma->vm_end = addr + len;
+
+	vma->vm_flags = vm_flags | mm->def_flags;
+	vma->vm_page_prot = protection_map[vma->vm_flags & 7];
+
+	vma->vm_ops = &special_mapping_vmops;
+	vma->vm_private_data = pages;
+
+	if (unlikely(insert_vm_struct(mm, vma))) {
+		kmem_cache_free(vm_area_cachep, vma);
+		return -ENOMEM;
+	}
+
+	mm->total_vm += len >> PAGE_SHIFT;
+
+	return 0;
+}
_

Patches currently in -mm which might be from roland@redhat.com are

fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
