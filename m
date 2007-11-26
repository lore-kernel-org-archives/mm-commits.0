From: akpm@linux-foundation.org
Subject: - revoke-special-mmap-handling.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:06 -0800
Message-ID: <200711261936.lAQJa6Rh019273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbXKZTgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, alan@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     revoke: special mmap handling
has been removed from the -mm tree.  Its filename was
     revoke-special-mmap-handling.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: revoke: special mmap handling
From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds special handling for revoked memory mappings.  We want to raise
SIGBUS when accessing revoked mappings and return ENODEV when trying to remap
with mmap(2).

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/memory.c        |    3 +++
 mm/mmap.c          |   12 ++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~revoke-special-mmap-handling include/linux/mm.h
--- a/include/linux/mm.h~revoke-special-mmap-handling
+++ a/include/linux/mm.h
@@ -104,6 +104,7 @@ extern unsigned int kobjsize(const void 
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 
diff -puN mm/memory.c~revoke-special-mmap-handling mm/memory.c
--- a/mm/memory.c~revoke-special-mmap-handling
+++ a/mm/memory.c
@@ -2466,6 +2466,9 @@ int handle_mm_fault(struct mm_struct *mm
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, write_access);
 
+	if (unlikely(vma->vm_flags & VM_REVOKED))
+		return VM_FAULT_SIGBUS;
+
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
diff -puN mm/mmap.c~revoke-special-mmap-handling mm/mmap.c
--- a/mm/mmap.c~revoke-special-mmap-handling
+++ a/mm/mmap.c
@@ -1083,10 +1083,14 @@ unsigned long mmap_region(struct file *f
 	error = -ENOMEM;
 munmap_back:
 	vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
-	if (vma && vma->vm_start < addr + len) {
-		if (do_munmap(mm, addr, len))
-			return -ENOMEM;
-		goto munmap_back;
+	if (vma) {
+		if (unlikely(vma->vm_flags & VM_REVOKED))
+			return -ENODEV;
+		if (vma->vm_start < addr + len) {
+			if (do_munmap(mm, addr, len))
+				return -ENOMEM;
+			goto munmap_back;
+		}
 	}
 
 	/* Check against address space limit. */
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch
