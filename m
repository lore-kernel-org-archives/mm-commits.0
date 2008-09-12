From: akpm@linux-foundation.org
Subject: + mm-make-do_move_pages-complexity-linear.patch added to -mm tree
Date: Fri, 12 Sep 2008 13:10:17 -0700
Message-ID: <200809122010.m8CKAHRM001666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbYILUKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 16:10:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Brice.Goglin@inria.fr, Nathalie.Furmento@labri.fr, cl@linux-foundation.org, mel@csn.ul.ie


The patch titled
     mm: make do_move_pages() complexity linear
has been added to the -mm tree.  Its filename is
     mm-make-do_move_pages-complexity-linear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make do_move_pages() complexity linear
From: Brice Goglin <Brice.Goglin@inria.fr>

Page migration is currently very slow because its overhead is quadratic
with the number of pages.  This is caused by each single page migration
doing a linear lookup in the page array in new_page_node().

Since pages are stored in the array order in the pagelist and
do_move_pages process this list in order, new_page_node() can increase the
"pm" pointer to the page array so that the next iteration will find the
next page in 0 or few lookup steps.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~mm-make-do_move_pages-complexity-linear mm/migrate.c
--- a/mm/migrate.c~mm-make-do_move_pages-complexity-linear
+++ a/mm/migrate.c
@@ -837,14 +837,23 @@ struct page_to_node {
 	int status;
 };
 
+/*
+ * Allocate a page on the node given as a page_to_node in private.
+ * Increase private to point to the next page_to_node so that the
+ * next iteration does not have to traverse the whole pm array.
+ */
 static struct page *new_page_node(struct page *p, unsigned long private,
 		int **result)
 {
-	struct page_to_node *pm = (struct page_to_node *)private;
+	struct page_to_node **pmptr = (struct page_to_node **)private;
+	struct page_to_node *pm = *pmptr;
 
 	while (pm->node != MAX_NUMNODES && pm->page != p)
 		pm++;
 
+	/* prepare for the next iteration */
+	*pmptr = pm + 1;
+
 	if (pm->node == MAX_NUMNODES)
 		return NULL;
 
@@ -926,10 +935,12 @@ set_status:
 		pp->status = err;
 	}
 
-	if (!list_empty(&pagelist))
+	if (!list_empty(&pagelist)) {
+		/* new_page_node() will modify tmp */
+		struct page_to_node *tmp = pm;
 		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm);
-	else
+				    (unsigned long)&tmp);
+	} else
 		err = -ENOENT;
 
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

mm-make-do_move_pages-complexity-linear.patch

