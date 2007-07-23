From: akpm@linux-foundation.org
Subject: - nommu-vmalloc_32_user-vm_insert_page-and-symbol-exports.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:40 -0700
Message-ID: <200707230933.l6N9XeME016316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755757AbXGWJe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     nommu: vmalloc_32_user()/vm_insert_page() and symbol exports.
has been removed from the -mm tree.  Its filename was
     nommu-vmalloc_32_user-vm_insert_page-and-symbol-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nommu: vmalloc_32_user()/vm_insert_page() and symbol exports.
From: Paul Mundt <lethal@linux-sh.org>

Trying to survive an allmodconfig on a nommu platform results in many
screen lengths of module unhappiness.  Many of the mmap related things that
binfmt_flat hooks in to are never exported despite being global, and there
are also missing definitions for vmalloc_32_user() and vm_insert_page().

I've implemented vmalloc_32_user() trying to stick as close to the
mm/vmalloc.c implementation as possible, though we don't have any need for
VM_USERMAP, so groveling for the VMA can be skipped.  vm_insert_page() has
been stubbed for now in order to keep the build happy.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff -puN mm/nommu.c~nommu-vmalloc_32_user-vm_insert_page-and-symbol-exports mm/nommu.c
--- a/mm/nommu.c~nommu-vmalloc_32_user-vm_insert_page-and-symbol-exports
+++ a/mm/nommu.c
@@ -54,12 +54,6 @@ DECLARE_RWSEM(nommu_vma_sem);
 struct vm_operations_struct generic_file_vm_ops = {
 };
 
-EXPORT_SYMBOL(vfree);
-EXPORT_SYMBOL(vmalloc_to_page);
-EXPORT_SYMBOL(vmalloc_32);
-EXPORT_SYMBOL(vmap);
-EXPORT_SYMBOL(vunmap);
-
 /*
  * Handle all mappings that got truncated by a "truncate()"
  * system call.
@@ -168,7 +162,6 @@ int get_user_pages(struct task_struct *t
 finish_or_fault:
 	return i ? : -EFAULT;
 }
-
 EXPORT_SYMBOL(get_user_pages);
 
 DEFINE_RWLOCK(vmlist_lock);
@@ -178,6 +171,7 @@ void vfree(void *addr)
 {
 	kfree(addr);
 }
+EXPORT_SYMBOL(vfree);
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
@@ -186,17 +180,19 @@ void *__vmalloc(unsigned long size, gfp_
 	 */
 	return kmalloc(size, (gfp_mask | __GFP_COMP) & ~__GFP_HIGHMEM);
 }
+EXPORT_SYMBOL(__vmalloc);
 
 struct page * vmalloc_to_page(void *addr)
 {
 	return virt_to_page(addr);
 }
+EXPORT_SYMBOL(vmalloc_to_page);
 
 unsigned long vmalloc_to_pfn(void *addr)
 {
 	return page_to_pfn(virt_to_page(addr));
 }
-
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 long vread(char *buf, char *addr, unsigned long count)
 {
@@ -237,9 +233,8 @@ void *vmalloc_node(unsigned long size, i
 }
 EXPORT_SYMBOL(vmalloc_node);
 
-/*
- *	vmalloc_32  -  allocate virtually continguos memory (32bit addressable)
- *
+/**
+ * vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
  *
  *	Allocate enough 32bit PA addressable pages to cover @size from the
@@ -249,17 +244,33 @@ void *vmalloc_32(unsigned long size)
 {
 	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL);
 }
+EXPORT_SYMBOL(vmalloc_32);
+
+/**
+ * vmalloc_32_user - allocate zeroed virtually contiguous 32bit memory
+ *	@size:		allocation size
+ *
+ * The resulting memory area is 32bit addressable and zeroed so it can be
+ * mapped to userspace without leaking data.
+ */
+void *vmalloc_32_user(unsigned long size)
+{
+	return __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+}
+EXPORT_SYMBOL(vmalloc_32_user);
 
 void *vmap(struct page **pages, unsigned int count, unsigned long flags, pgprot_t prot)
 {
 	BUG();
 	return NULL;
 }
+EXPORT_SYMBOL(vmap);
 
 void vunmap(void *addr)
 {
 	BUG();
 }
+EXPORT_SYMBOL(vunmap);
 
 /*
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
@@ -269,6 +280,13 @@ void  __attribute__((weak)) vmalloc_sync
 {
 }
 
+int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
+		   struct page *page)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_insert_page);
+
 /*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
@@ -994,6 +1012,7 @@ unsigned long do_mmap_pgoff(struct file 
 	show_free_areas();
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(do_mmap_pgoff);
 
 /*
  * handle mapping disposal for uClinux
@@ -1074,6 +1093,7 @@ int do_munmap(struct mm_struct *mm, unsi
 
 	return 0;
 }
+EXPORT_SYMBOL(do_munmap);
 
 asmlinkage long sys_munmap(unsigned long addr, size_t len)
 {
@@ -1164,6 +1184,7 @@ unsigned long do_mremap(unsigned long ad
 
 	return vma->vm_start;
 }
+EXPORT_SYMBOL(do_mremap);
 
 asmlinkage unsigned long sys_mremap(unsigned long addr,
 	unsigned long old_len, unsigned long new_len,
@@ -1231,7 +1252,6 @@ unsigned long get_unmapped_area(struct f
 
 	return get_area(file, addr, len, pgoff, flags);
 }
-
 EXPORT_SYMBOL(get_unmapped_area);
 
 /*
@@ -1346,6 +1366,7 @@ int filemap_fault(struct vm_area_struct 
 	BUG();
 	return 0;
 }
+EXPORT_SYMBOL(filemap_fault);
 
 /*
  * Access another process' address space.
_

Patches currently in -mm which might be from lethal@linux-sh.org are

nohz-fix-nohz-x86-dyntick-idle-handling.patch
