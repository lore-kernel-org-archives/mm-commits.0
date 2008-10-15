From: akpm@linux-foundation.org
Subject: - mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear.patch removed from -mm tree
Date: Wed, 15 Oct 2008 15:17:03 -0700
Message-ID: <200810152217.m9FMH3ri012783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbYJOWRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 18:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Brice.Goglin@inria.fr, Nathalie.Furmento@labri.fr, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm: use a radix-tree to make do_move_pages() complexity linear
has been removed from the -mm tree.  Its filename was
     mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use a radix-tree to make do_move_pages() complexity linear
From: Brice Goglin <Brice.Goglin@inria.fr>

Add a radix-tree in do_move_pages() to associate each page with
the struct page_to_node that describes its migration.
new_page_node() can now easily find out the page_to_node of the
given page instead of traversing the whole page_to_node array.
So the overall complexity is linear instead of quadratic.

We still need the page_to_node array since it is allocated by the
caller (sys_move_page()) and used by do_pages_stat() when no target
nodes are given by the application. And we need room to store all
these page_to_node entries for do_move_pages() as well anyway.

If a page is given twice by the application, the old code would
return -EBUSY (failure from the second isolate_lru_page()). Now,
radix_tree_insert() will return -EEXIST, and we convert it back
to -EBUSY to keep the user-space ABI.

The radix-tree is emptied at the end of do_move_pages() since
new_page_node() doesn't know when an entry is used for the last
time (unmap_and_move() could try another pass later).
Marking pp->page as ZERO_PAGE(0) was actually never used. We now
set it to NULL when pp is not in the radix-tree. It is faster
than doing a loop of radix_tree_lookup_gang()+delete().

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff -puN mm/migrate.c~mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear mm/migrate.c
--- a/mm/migrate.c~mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear
+++ a/mm/migrate.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/memcontrol.h>
 #include <linux/syscalls.h>
+#include <linux/radix-tree.h>
 
 #include "internal.h"
 
@@ -808,12 +809,10 @@ struct page_to_node {
 static struct page *new_page_node(struct page *p, unsigned long private,
 		int **result)
 {
-	struct page_to_node *pm = (struct page_to_node *)private;
+	struct radix_tree_root *root = (struct radix_tree_root *) private;
+	struct page_to_node *pm = (struct page_to_node *) radix_tree_lookup(root, (unsigned long) p);
 
-	while (pm->node != MAX_NUMNODES && pm->page != p)
-		pm++;
-
-	if (pm->node == MAX_NUMNODES)
+	if (!pm)
 		return NULL;
 
 	*result = &pm->status;
@@ -833,6 +832,7 @@ static int do_move_pages(struct mm_struc
 	int err;
 	struct page_to_node *pp;
 	LIST_HEAD(pagelist);
+	RADIX_TREE(pmroot, GFP_KERNEL);
 
 	down_read(&mm->mmap_sem);
 
@@ -844,11 +844,8 @@ static int do_move_pages(struct mm_struc
 		struct vm_area_struct *vma;
 		struct page *page;
 
-		/*
-		 * A valid page pointer that will not match any of the
-		 * pages that will be moved.
-		 */
-		pp->page = ZERO_PAGE(0);
+		/* set to NULL as long as pp is not in the radix-tree */
+		pp->page = NULL;
 
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
@@ -868,9 +865,7 @@ static int do_move_pages(struct mm_struc
 		if (PageReserved(page))		/* Check for zero page */
 			goto put_and_set;
 
-		pp->page = page;
 		err = page_to_nid(page);
-
 		if (err == pp->node)
 			/*
 			 * Node already in the right place
@@ -882,6 +877,23 @@ static int do_move_pages(struct mm_struc
 				!migrate_all)
 			goto put_and_set;
 
+		/*
+		 * Insert pp in the radix-tree so that new_page_node() can find it
+		 * while only knowing the page.
+		 * There cannot be any duplicate since isolate_lru_page() would fail
+		 * below anyway.
+		 */
+		err = radix_tree_insert(&pmroot, (unsigned long) page, pp);
+		if (err < 0) {
+			if (err == -EEXIST)
+				/* the page cannot be migrated twice */
+				err = -EBUSY;
+			goto put_and_set;
+		}
+
+		/* set pp->page for real now that pp is in the radix-tree */
+		pp->page = page;
+
 		err = isolate_lru_page(page);
 		if (!err)
 			list_add_tail(&page->lru, &pagelist);
@@ -897,12 +909,17 @@ set_status:
 	}
 
 	if (!list_empty(&pagelist))
-		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm);
+		err = migrate_pages(&pagelist, new_page_node, (unsigned long) &pmroot);
 	else
 		err = -ENOENT;
 
 	up_read(&mm->mmap_sem);
+
+	/* empty the radix-tree now that new_page_node() will not be called anymore */
+	for(pp = pm; pp->node != MAX_NUMNODES; pp++)
+		if (pp->page)
+			radix_tree_delete(&pmroot, (unsigned long) pp->page);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear.patch
mm-use-a-radix-tree-to-make-do_move_pages-complexity-linear-checkpatch-fixes.patch

