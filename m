From: akpm@linux-foundation.org
Subject: + migration-find-correct-vma-in-new_vma_page.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:05:43 -0800
Message-ID: <200711052305.lA5N5ioA024203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbXKEXFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     Migration: find correct vma in new_vma_page()
has been added to the -mm tree.  Its filename is
     migration-find-correct-vma-in-new_vma_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Migration: find correct vma in new_vma_page()
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

We hit the BUG_ON() in mm/rmap.c:vma_address() when trying to migrate via
mbind(MPOL_MF_MOVE) a non-anon region that spans multiple vmas.  For
anon-regions, we just fail to migrate any pages beyond the 1st vma in the
range.

This occurs because do_mbind() collects a list of pages to migrate by
calling check_range().  check_range() walks the task's mm, spanning vmas as
necessary, to collect the migratable pages into a list.  Then, do_mbind()
calls migrate_pages() passing the list of pages, a function to allocate new
pages based on vma policy [new_vma_page()], and a pointer to the first vma
of the range.

For each page in the list, new_vma_page() calls page_address_in_vma()
passing the page and the vma [first in range] to obtain the address to get
for alloc_page_vma().  The page address is needed to get interleaving
policy correct.  If the pages in the list come from multiple vmas,
eventually, new_page_address() will pass that page to page_address_in_vma()
with the incorrect vma.  For !PageAnon pages, this will result in a bug
check in rmap.c:vma_address().  For anon pages, vma_address() will just
return EFAULT and fail the migration.

This patch modifies new_vma_page() to check the return value from
page_address_in_vma().  If the return value is EFAULT, new_vma_page()
searchs forward via vm_next for the vma that maps the page--i.e., that does
not return EFAULT.  This assumes that the pages in the list handed to
migrate_pages() is in address order.  This is currently case.  The patch
documents this assumption in a new comment block for new_vma_page().

If new_vma_page() cannot locate the vma mapping the page in a forward
search in the mm, it will pass a NULL vma to alloc_page_vma().  This will
result in the allocation using the task policy, if any, else system default
policy.  This situation is unlikely, but the patch documents this behavior
with a comment.

Note, this patch results in restarting from the first vma in a multi-vma
range each time new_vma_page() is called.  If this is not acceptable, we
can make the vma argument a pointer, both in new_vma_page() and it's caller
unmap_and_move() so that the value held by the loop in migrate_pages()
always passes down the last vma in which a page was found.  This will
require changes to all new_page_t functions passed to migrate_pages().  Is
this necessary?

For this patch to work, we can't bug check in vma_address() for pages
outside the argument vma.  This patch removes the BUG_ON().  All other
callers [besides new_vma_page()] already check the return status.

Tested on x86_64, 4 node NUMA platform.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 +++++++++++++++++++--
 mm/rmap.c      |    7 ++++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~migration-find-correct-vma-in-new_vma_page mm/mempolicy.c
--- a/mm/mempolicy.c~migration-find-correct-vma-in-new_vma_page
+++ a/mm/mempolicy.c
@@ -722,12 +722,29 @@ out:
 
 }
 
+/*
+ * Allocate a new page for page migration based on vma policy.
+ * Start assuming that page is mapped by vma pointed to by @private.
+ * Search forward from there, if not.  N.B., this assumes that the
+ * list of pages handed to migrate_pages()--which is how we get here--
+ * is in virtual address order.
+ */
 static struct page *new_vma_page(struct page *page, unsigned long private, int **x)
 {
 	struct vm_area_struct *vma = (struct vm_area_struct *)private;
+	unsigned long uninitialized_var(address);
 
-	return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
-					page_address_in_vma(page, vma));
+	while (vma) {
+		address = page_address_in_vma(page, vma);
+		if (address != -EFAULT)
+			break;
+		vma = vma->vm_next;
+	}
+
+	/*
+	 * if !vma, alloc_page_vma() will use task or system default policy
+	 */
+	return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 }
 #else
 
diff -puN mm/rmap.c~migration-find-correct-vma-in-new_vma_page mm/rmap.c
--- a/mm/rmap.c~migration-find-correct-vma-in-new_vma_page
+++ a/mm/rmap.c
@@ -183,7 +183,9 @@ static void page_unlock_anon_vma(struct 
 }
 
 /*
- * At what user virtual address is page expected in vma?
+ * At what user virtual address is page expected in @vma?
+ * Returns virtual address or -EFAULT if page's index/offset is not
+ * within the range mapped the @vma.
  */
 static inline unsigned long
 vma_address(struct page *page, struct vm_area_struct *vma)
@@ -193,8 +195,7 @@ vma_address(struct page *page, struct vm
 
 	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
-		/* page should be within any vma from prio_tree_next */
-		BUG_ON(!PageAnon(page));
+		/* page should be within @vma mapping range */
 		return -EFAULT;
 	}
 	return address;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

migration-find-correct-vma-in-new_vma_page.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
