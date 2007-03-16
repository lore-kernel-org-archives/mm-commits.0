From: akpm@linux-foundation.org
Subject: + revoke-special-mmap-handling.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:15:51 -0800
Message-ID: <200703160115.l2G1FpIg031752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47917 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXCPBQP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, alan@redhat.com, hch@lst.de


The patch titled
     revoke: special mmap handling
has been added to the -mm tree.  Its filename is
     revoke-special-mmap-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -171,6 +171,7 @@ extern unsigned int kobjsize(const void 
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #define VM_CAN_INVALIDATE 0x08000000	/* The mapping may be invalidated,
 					 * eg. truncate or invalidate_inode_*.
diff -puN mm/memory.c~revoke-special-mmap-handling mm/memory.c
--- a/mm/memory.c~revoke-special-mmap-handling
+++ a/mm/memory.c
@@ -2470,6 +2470,9 @@ int __handle_mm_fault(struct mm_struct *
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
@@ -1030,10 +1030,14 @@ unsigned long do_mmap_pgoff(struct file 
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

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
