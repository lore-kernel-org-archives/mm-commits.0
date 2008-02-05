From: akpm@linux-foundation.org
Subject: - vmalloc-add-const-to-void-parameters.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:35 -0800
Message-ID: <200802052229.m15MTGsb011965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083AbYBEWmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmalloc: add const to void* parameters
has been removed from the -mm tree.  Its filename was
     vmalloc-add-const-to-void-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: add const to void* parameters
From: Christoph Lameter <clameter@sgi.com>

Make vmalloc functions work the same way as kfree() and friends that
take a const void * argument.

[akpm@linux-foundation.org: fix consts, coding-style]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    4 ++--
 include/linux/vmalloc.h |    6 +++---
 mm/nommu.c              |    8 ++++----
 mm/vmalloc.c            |   16 ++++++++--------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff -puN include/linux/mm.h~vmalloc-add-const-to-void-parameters include/linux/mm.h
--- a/include/linux/mm.h~vmalloc-add-const-to-void-parameters
+++ a/include/linux/mm.h
@@ -232,8 +232,8 @@ static inline int get_page_unless_zero(s
 }
 
 /* Support for virtually mapped pages */
-struct page *vmalloc_to_page(void *addr);
-unsigned long vmalloc_to_pfn(void *addr);
+struct page *vmalloc_to_page(const void *addr);
+unsigned long vmalloc_to_pfn(const void *addr);
 
 static inline struct page *compound_head(struct page *page)
 {
diff -puN include/linux/vmalloc.h~vmalloc-add-const-to-void-parameters include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-add-const-to-void-parameters
+++ a/include/linux/vmalloc.h
@@ -45,11 +45,11 @@ extern void *vmalloc_32_user(unsigned lo
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
 extern void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask,
 				pgprot_t prot);
-extern void vfree(void *addr);
+extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
-extern void vunmap(void *addr);
+extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
@@ -71,7 +71,7 @@ extern struct vm_struct *__get_vm_area(u
 extern struct vm_struct *get_vm_area_node(unsigned long size,
 					  unsigned long flags, int node,
 					  gfp_t gfp_mask);
-extern struct vm_struct *remove_vm_area(void *addr);
+extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
 			struct page ***pages);
diff -puN mm/nommu.c~vmalloc-add-const-to-void-parameters mm/nommu.c
--- a/mm/nommu.c~vmalloc-add-const-to-void-parameters
+++ a/mm/nommu.c
@@ -167,7 +167,7 @@ EXPORT_SYMBOL(get_user_pages);
 DEFINE_RWLOCK(vmlist_lock);
 struct vm_struct *vmlist;
 
-void vfree(void *addr)
+void vfree(const void *addr)
 {
 	kfree(addr);
 }
@@ -183,13 +183,13 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
-struct page * vmalloc_to_page(void *addr)
+struct page *vmalloc_to_page(const void *addr)
 {
 	return virt_to_page(addr);
 }
 EXPORT_SYMBOL(vmalloc_to_page);
 
-unsigned long vmalloc_to_pfn(void *addr)
+unsigned long vmalloc_to_pfn(const void *addr)
 {
 	return page_to_pfn(virt_to_page(addr));
 }
@@ -267,7 +267,7 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
-void vunmap(void *addr)
+void vunmap(const void *addr)
 {
 	BUG();
 }
diff -puN mm/vmalloc.c~vmalloc-add-const-to-void-parameters mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-add-const-to-void-parameters
+++ a/mm/vmalloc.c
@@ -169,7 +169,7 @@ EXPORT_SYMBOL_GPL(map_vm_area);
 /*
  * Map a vmalloc()-space virtual address to the physical page.
  */
-struct page *vmalloc_to_page(void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
 	struct page *page = NULL;
@@ -198,7 +198,7 @@ EXPORT_SYMBOL(vmalloc_to_page);
 /*
  * Map a vmalloc()-space virtual address to the physical page frame number.
  */
-unsigned long vmalloc_to_pfn(void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
 	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
 }
@@ -306,7 +306,7 @@ struct vm_struct *get_vm_area_node(unsig
 }
 
 /* Caller must hold vmlist_lock */
-static struct vm_struct *__find_vm_area(void *addr)
+static struct vm_struct *__find_vm_area(const void *addr)
 {
 	struct vm_struct *tmp;
 
@@ -319,7 +319,7 @@ static struct vm_struct *__find_vm_area(
 }
 
 /* Caller must hold vmlist_lock */
-static struct vm_struct *__remove_vm_area(void *addr)
+static struct vm_struct *__remove_vm_area(const void *addr)
 {
 	struct vm_struct **p, *tmp;
 
@@ -348,7 +348,7 @@ found:
  *	This function returns the found VM area, but using it is NOT safe
  *	on SMP machines, except for its size or flags.
  */
-struct vm_struct *remove_vm_area(void *addr)
+struct vm_struct *remove_vm_area(const void *addr)
 {
 	struct vm_struct *v;
 	write_lock(&vmlist_lock);
@@ -357,7 +357,7 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
-static void __vunmap(void *addr, int deallocate_pages)
+static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
@@ -408,7 +408,7 @@ static void __vunmap(void *addr, int dea
  *
  *	Must not be called in interrupt context.
  */
-void vfree(void *addr)
+void vfree(const void *addr)
 {
 	BUG_ON(in_interrupt());
 	__vunmap(addr, 1);
@@ -424,7 +424,7 @@ EXPORT_SYMBOL(vfree);
  *
  *	Must not be called in interrupt context.
  */
-void vunmap(void *addr)
+void vunmap(const void *addr)
 {
 	BUG_ON(in_interrupt());
 	__vunmap(addr, 0);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
