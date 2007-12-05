From: akpm@linux-foundation.org
Subject: + mm-special-mapping-nopage.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:14:01 -0800
Message-ID: <200712052314.lB5NE1jn029914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbXLEXOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: special mapping nopage
has been added to the -mm tree.  Its filename is
     mm-special-mapping-nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: special mapping nopage
From: Nick Piggin <npiggin@suse.de>

Convert special mapping install from nopage to fault.  This requires a small
special case in the do_linear_fault calculation in order to handle vmas
without ->vm_file set.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++---
 mm/mmap.c   |   19 +++++++++----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff -puN mm/memory.c~mm-special-mapping-nopage mm/memory.c
--- a/mm/memory.c~mm-special-mapping-nopage
+++ a/mm/memory.c
@@ -2288,9 +2288,13 @@ static int do_linear_fault(struct mm_str
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		int write_access, pte_t orig_pte)
 {
-	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
+	pgoff_t pgoff;
+	unsigned int flags;
+
+	pgoff = (((address) - vma->vm_start) >> PAGE_SHIFT);
+	if (likely(vma->vm_file))
+		pgoff += vma->vm_pgoff;
+	flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
 	pte_unmap(page_table);
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
diff -puN mm/mmap.c~mm-special-mapping-nopage mm/mmap.c
--- a/mm/mmap.c~mm-special-mapping-nopage
+++ a/mm/mmap.c
@@ -2165,24 +2165,23 @@ int may_expand_vm(struct mm_struct *mm, 
 }
 
 
-static struct page *special_mapping_nopage(struct vm_area_struct *vma,
-					   unsigned long address, int *type)
+static int special_mapping_fault(struct vm_area_struct *vma,
+				struct vm_fault *vmf)
 {
+	pgoff_t pgoff = vmf->pgoff;
 	struct page **pages;
 
-	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-
-	address -= vma->vm_start;
-	for (pages = vma->vm_private_data; address > 0 && *pages; ++pages)
-		address -= PAGE_SIZE;
+	for (pages = vma->vm_private_data; pgoff && *pages; ++pages)
+		pgoff--;
 
 	if (*pages) {
 		struct page *page = *pages;
 		get_page(page);
-		return page;
+		vmf->page = page;
+		return 0;
 	}
 
-	return NOPAGE_SIGBUS;
+	return VM_FAULT_SIGBUS;
 }
 
 /*
@@ -2194,7 +2193,7 @@ static void special_mapping_close(struct
 
 static struct vm_operations_struct special_mapping_vmops = {
 	.close = special_mapping_close,
-	.nopage	= special_mapping_nopage,
+	.fault = special_mapping_fault,
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
alsa-nopage.patch
alsa-usx2y-nopage.patch
v4l-nopage.patch
ia64-ia32-nopage.patch
ieee1394-nopage.patch
ib-nopage.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
usb-mon-nopage.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
