From: akpm@linux-foundation.org
Subject: + mm-fix-xip-issue-with-dev-zero.patch added to -mm tree
Date: Wed, 28 Mar 2007 17:28:44 -0700
Message-ID: <200703290028.l2T0SiKF023759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933951AbXC2A2x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 20:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cotte@de.ibm.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     mm: fix xip issue with /dev/zero
has been added to the -mm tree.  Its filename is
     mm-fix-xip-issue-with-dev-zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix xip issue with /dev/zero
From: Carsten Otte <cotte@de.ibm.com>

Fix the bug, that reading into xip mapping from /dev/zero fills the user
page table with ZERO_PAGE() entries.  Later on, xip cannot tell which pages
have been ZERO_PAGE() filled by access to a sparse mapping, and which ones
origin from /dev/zero.  It will unmap ZERO_PAGE from all mappings when
filling the sparse hole with data.  xip does now use its own zeroed page
for its sparse mappings.  Please apply.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff -puN mm/filemap_xip.c~mm-fix-xip-issue-with-dev-zero mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-fix-xip-issue-with-dev-zero
+++ a/mm/filemap_xip.c
@@ -17,6 +17,29 @@
 #include "filemap.h"
 
 /*
+ * We do use our own empty page to avoid interference with other users
+ * of ZERO_PAGE(), such as /dev/zero
+ */
+static struct page *__xip_sparse_page;
+
+static struct page *xip_sparse_page(void)
+{
+	if (!__xip_sparse_page) {
+		unsigned long zeroes = get_zeroed_page(GFP_HIGHUSER);
+		if (zeroes) {
+			static DEFINE_SPINLOCK(xip_alloc_lock);
+			spin_lock(&xip_alloc_lock);
+			if (!__xip_sparse_page)
+				__xip_sparse_page = virt_to_page(zeroes);
+			else
+				free_page(zeroes);
+			spin_unlock(&xip_alloc_lock);
+		}
+	}
+	return __xip_sparse_page;
+}
+
+/*
  * This is a file read routine for execute in place files, and uses
  * the mapping->a_ops->get_xip_page() function for the actual low-level
  * stuff.
@@ -162,7 +185,7 @@ EXPORT_SYMBOL_GPL(xip_file_sendfile);
  * xip_write
  *
  * This function walks all vmas of the address_space and unmaps the
- * ZERO_PAGE when found at pgoff. Should it go in rmap.c?
+ * __xip_sparse_page when found at pgoff.
  */
 static void
 __xip_unmap (struct address_space * mapping,
@@ -177,13 +200,16 @@ __xip_unmap (struct address_space * mapp
 	spinlock_t *ptl;
 	struct page *page;
 
+	page = __xip_sparse_page;
+	if (!page)
+		return;
+
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
 		address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-		page = ZERO_PAGE(0);
 		pte = page_check_address(page, mm, address, &ptl);
 		if (pte) {
 			/* Nuke the page table entry. */
@@ -245,8 +271,12 @@ static struct page *xip_file_fault(struc
 		/* unmap page at pgoff from all other vmas */
 		__xip_unmap(mapping, fdata->pgoff);
 	} else {
-		/* not shared and writable, use ZERO_PAGE() */
-		page = ZERO_PAGE(0);
+		/* not shared and writable, use xip_sparse_page() */
+		page = xip_sparse_page();
+		if (!page) {
+	                fdata->type = VM_FAULT_OOM;
+	                return NULL;
+		}
 	}
 
 out:
_

Patches currently in -mm which might be from cotte@de.ibm.com are

mm-fix-xip-issue-with-dev-zero.patch
