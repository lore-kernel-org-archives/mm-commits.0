From: akpm@linux-foundation.org
Subject: - mm-dont-vmalloc-a-huge-page_to_node-array-for-do_pages_stat.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:11 -0700
Message-ID: <200810202034.m9KKYBaw010791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbYJTUoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:44:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Brice.Goglin@inria.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: don't vmalloc a huge page_to_node array for do_pages_stat()
has been removed from the -mm tree.  Its filename was
     mm-dont-vmalloc-a-huge-page_to_node-array-for-do_pages_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't vmalloc a huge page_to_node array for do_pages_stat()
From: Brice Goglin <Brice.Goglin@inria.fr>

do_pages_stat() does not need any page_to_node entry for real.  Just pass
the pointers to the user-space page address array and to the user-space
status array, and have do_pages_stat() traverse the former and fill the
latter directly.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff -puN mm/migrate.c~mm-dont-vmalloc-a-huge-page_to_node-array-for-do_pages_stat mm/migrate.c
--- a/mm/migrate.c~mm-dont-vmalloc-a-huge-page_to_node-array-for-do_pages_stat
+++ a/mm/migrate.c
@@ -906,25 +906,33 @@ set_status:
 }
 
 /*
- * Determine the nodes of a list of pages. The addr in the pm array
- * must have been set to the virtual address of which we want to determine
- * the node number.
+ * Determine the nodes of an array of pages and store it in an array of status.
  */
-static int do_pages_stat(struct mm_struct *mm, struct page_to_node *pm)
+static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
+			 const void __user * __user *pages,
+			 int __user *status)
 {
+	unsigned long i;
+	int err;
+
 	down_read(&mm->mmap_sem);
 
-	for ( ; pm->node != MAX_NUMNODES; pm++) {
+	for (i = 0; i < nr_pages; i++) {
+		const void __user *p;
+		unsigned long addr;
 		struct vm_area_struct *vma;
 		struct page *page;
-		int err;
 
 		err = -EFAULT;
-		vma = find_vma(mm, pm->addr);
+		if (get_user(p, pages+i))
+			goto out;
+		addr = (unsigned long) p;
+
+		vma = find_vma(mm, addr);
 		if (!vma)
 			goto set_status;
 
-		page = follow_page(vma, pm->addr, 0);
+		page = follow_page(vma, addr, 0);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
@@ -937,11 +945,13 @@ static int do_pages_stat(struct mm_struc
 
 		err = page_to_nid(page);
 set_status:
-		pm->status = err;
+		put_user(err, status+i);
 	}
+	err = 0;
 
+out:
 	up_read(&mm->mmap_sem);
-	return 0;
+	return err;
 }
 
 /*
@@ -997,6 +1007,10 @@ asmlinkage long sys_move_pages(pid_t pid
  	if (err)
  		goto out2;
 
+	if (!nodes) {
+		err = do_pages_stat(mm, nr_pages, pages, status);
+		goto out2;
+	}
 
 	task_nodes = cpuset_mems_allowed(task);
 
@@ -1045,11 +1059,7 @@ asmlinkage long sys_move_pages(pid_t pid
 	/* End marker */
 	pm[nr_pages].node = MAX_NUMNODES;
 
-	if (nodes)
-		err = do_move_pages(mm, pm, flags & MPOL_MF_MOVE_ALL);
-	else
-		err = do_pages_stat(mm, pm);
