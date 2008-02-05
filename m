From: akpm@linux-foundation.org
Subject: - is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:39 -0800
Message-ID: <200802052229.m15MTKFo011971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241AbYBEWnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
has been removed from the -mm tree.  Its filename was
     is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
From: Christoph Lameter <clameter@sgi.com>

Checking if an address is a vmalloc address is done in a couple of places. 
Define a common version in mm.h and replace the other checks.

Again the include structures suck.  The definition of VMALLOC_START and
VMALLOC_END is not available in vmalloc.h since highmem.c cannot be included
there.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_offload.c |    4 +---
 fs/ntfs/malloc.h                  |    3 +--
 fs/proc/kcore.c                   |    2 +-
 fs/xfs/linux-2.6/kmem.c           |    3 +--
 fs/xfs/linux-2.6/xfs_buf.c        |    3 +--
 include/linux/mm.h                |    8 ++++++++
 mm/sparse.c                       |   10 +---------
 7 files changed, 14 insertions(+), 19 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_offload.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries drivers/net/cxgb3/cxgb3_offload.c
--- a/drivers/net/cxgb3/cxgb3_offload.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/drivers/net/cxgb3/cxgb3_offload.c
@@ -1070,9 +1070,7 @@ void *cxgb_alloc_mem(unsigned long size)
  */
 void cxgb_free_mem(void *addr)
 {
-	unsigned long p = (unsigned long)addr;
-
-	if (p >= VMALLOC_START && p < VMALLOC_END)
+	if (is_vmalloc_addr(addr))
 		vfree(addr);
 	else
 		kfree(addr);
diff -puN fs/ntfs/malloc.h~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries fs/ntfs/malloc.h
--- a/fs/ntfs/malloc.h~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/fs/ntfs/malloc.h
@@ -85,8 +85,7 @@ static inline void *ntfs_malloc_nofs_nof
 
 static inline void ntfs_free(void *addr)
 {
-	if (likely(((unsigned long)addr < VMALLOC_START) ||
-			((unsigned long)addr >= VMALLOC_END ))) {
+	if (!is_vmalloc_addr(addr)) {
 		kfree(addr);
 		/* free_page((unsigned long)addr); */
 		return;
diff -puN fs/proc/kcore.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries fs/proc/kcore.c
--- a/fs/proc/kcore.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/fs/proc/kcore.c
@@ -325,7 +325,7 @@ read_kcore(struct file *file, char __use
 		if (m == NULL) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
-		} else if ((start >= VMALLOC_START) && (start < VMALLOC_END)) {
+		} else if (is_vmalloc_addr((void *)start)) {
 			char * elf_buf;
 			struct vm_struct *m;
 			unsigned long curstart = start;
diff -puN fs/xfs/linux-2.6/kmem.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries fs/xfs/linux-2.6/kmem.c
--- a/fs/xfs/linux-2.6/kmem.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/fs/xfs/linux-2.6/kmem.c
@@ -92,8 +92,7 @@ kmem_zalloc_greedy(size_t *size, size_t 
 void
 kmem_free(void *ptr, size_t size)
 {
-	if (((unsigned long)ptr < VMALLOC_START) ||
-	    ((unsigned long)ptr >= VMALLOC_END)) {
+	if (!is_vmalloc_addr(ptr)) {
 		kfree(ptr);
 	} else {
 		vfree(ptr);
diff -puN fs/xfs/linux-2.6/xfs_buf.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -709,8 +709,7 @@ static inline struct page *
 mem_to_page(
 	void			*addr)
 {
-	if (((unsigned long)addr < VMALLOC_START) ||
-	    ((unsigned long)addr >= VMALLOC_END)) {
+	if ((!is_vmalloc_addr(addr))) {
 		return virt_to_page(addr);
 	} else {
 		return vmalloc_to_page(addr);
diff -puN include/linux/mm.h~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries include/linux/mm.h
--- a/include/linux/mm.h~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/include/linux/mm.h
@@ -235,6 +235,14 @@ static inline int get_page_unless_zero(s
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
+/* Determine if an address is within the vmalloc range */
+static inline int is_vmalloc_addr(const void *x)
+{
+	unsigned long addr = (unsigned long)x;
+
+	return addr >= VMALLOC_START && addr < VMALLOC_END;
+}
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
diff -puN mm/sparse.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries mm/sparse.c
--- a/mm/sparse.c~is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries
+++ a/mm/sparse.c
@@ -353,17 +353,9 @@ static inline struct page *kmalloc_secti
 	return __kmalloc_section_memmap(nr_pages);
 }
 
-static int vaddr_in_vmalloc_area(void *addr)
-{
-	if (addr >= (void *)VMALLOC_START &&
-	    addr < (void *)VMALLOC_END)
-		return 1;
-	return 0;
-}
-
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
-	if (vaddr_in_vmalloc_area(memmap))
+	if (is_vmalloc_addr(memmap))
 		vfree(memmap);
 	else
 		free_pages((unsigned long)memmap,
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
