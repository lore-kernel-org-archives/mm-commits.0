From: akpm@linux-foundation.org
Subject: - mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:11 -0800
Message-ID: <200901072211.n07MBBov011489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbZAGWLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Brice.Goglin@inria.fr, Nathalie.Furmento@labri.fr, cl@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: rework do_pages_move() to work on page_sized chunks
has been removed from the -mm tree.  Its filename was
     mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rework do_pages_move() to work on page_sized chunks
From: Brice Goglin <Brice.Goglin@inria.fr>

Rework do_pages_move() to work by page-sized chunks of struct page_to_node
that are passed to do_move_page_to_node_array().  We now only have to
allocate a single page instead a possibly very large vmalloc area to store
all page_to_node entries.

As a result, new_page_node() will now have a very small lookup, hidding
much of the overall sys_move_pages() overhead.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   81 +++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 36 deletions(-)

diff -puN mm/migrate.c~mm-rework-do_pages_move-to-work-on-page_sized-chunks mm/migrate.c
--- a/mm/migrate.c~mm-rework-do_pages_move-to-work-on-page_sized-chunks
+++ a/mm/migrate.c
@@ -919,41 +919,43 @@ static int do_pages_move(struct mm_struc
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
-	struct page_to_node *pm = NULL;
+	struct page_to_node *pm;
 	nodemask_t task_nodes;
-	int err = 0;
-	int i;
+	unsigned long chunk_nr_pages;
+	unsigned long chunk_start;
+	int err;
 
 	task_nodes = cpuset_mems_allowed(task);
 
-	/* Limit nr_pages so that the multiplication may not overflow */
-	if (nr_pages >= ULONG_MAX / sizeof(struct page_to_node) - 1) {
-		err = -E2BIG;
+	err = -ENOMEM;
+	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
+	if (!pm)
 		goto out;
-	}
-
-	pm = vmalloc((nr_pages + 1) * sizeof(struct page_to_node));
-	if (!pm) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	/*
-	 * Get parameters from user space and initialize the pm
-	 * array. Return various errors if the user did something wrong.
+	 * Store a chunk of page_to_node array in a page,
+	 * but keep the last one as a marker
 	 */
-	for (i = 0; i < nr_pages; i++) {
-		const void __user *p;
+	chunk_nr_pages = (PAGE_SIZE / sizeof(struct page_to_node)) - 1;
 
-		err = -EFAULT;
-		if (get_user(p, pages + i))
-			goto out_pm;
-
-		pm[i].addr = (unsigned long)p;
-		if (nodes) {
+	for (chunk_start = 0;
+	     chunk_start < nr_pages;
+	     chunk_start += chunk_nr_pages) {
+		int j;
+
+		if (chunk_start + chunk_nr_pages > nr_pages)
+			chunk_nr_pages = nr_pages - chunk_start;
+
+		/* fill the chunk pm with addrs and nodes from user-space */
+		for (j = 0; j < chunk_nr_pages; j++) {
+			const void __user *p;
 			int node;
 
-			if (get_user(node, nodes + i))
+			err = -EFAULT;
+			if (get_user(p, pages + j + chunk_start))
+				goto out_pm;
+			pm[j].addr = (unsigned long) p;
+
+			if (get_user(node, nodes + j + chunk_start))
 				goto out_pm;
 
 			err = -ENODEV;
@@ -964,22 +966,29 @@ static int do_pages_move(struct mm_struc
 			if (!node_isset(node, task_nodes))
 				goto out_pm;
 
-			pm[i].node = node;
-		} else
-			pm[i].node = 0;	/* anything to not match MAX_NUMNODES */
-	}
-	/* End marker */
-	pm[nr_pages].node = MAX_NUMNODES;
+			pm[j].node = node;
+		}
+
+		/* End marker for this chunk */
+		pm[chunk_nr_pages].node = MAX_NUMNODES;
+
+		/* Migrate this chunk */
+		err = do_move_page_to_node_array(mm, pm,
+						 flags & MPOL_MF_MOVE_ALL);
+		if (err < 0)
+			goto out_pm;
 
-	err = do_move_page_to_node_array(mm, pm, flags & MPOL_MF_MOVE_ALL);
-	if (err >= 0)
 		/* Return status information */
-		for (i = 0; i < nr_pages; i++)
-			if (put_user(pm[i].status, status + i))
+		for (j = 0; j < chunk_nr_pages; j++)
+			if (put_user(pm[j].status, status + j + chunk_start)) {
 				err = -EFAULT;
+				goto out_pm;
+			}
+	}
+	err = 0;
 
 out_pm:
-	vfree(pm);
+	free_page((unsigned long)pm);
 out:
 	return err;
 }
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

origin.patch

