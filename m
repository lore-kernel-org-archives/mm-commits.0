From: akpm@linux-foundation.org
Subject: - mm-make-do_move_pages-complexity-linear-fix.patch removed from -mm tree
Date: Fri, 03 Oct 2008 06:09:29 -0700
Message-ID: <200810031309.m93D9T9b028893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbYJCNJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 09:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Brice.Goglin@inria.fr, Nathalie.Furmento@labri.fr, cl@linux-foundation.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: make do_move_pages() complexity linear
has been removed from the -mm tree.  Its filename was
     mm-make-do_move_pages-complexity-linear-fix.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make do_move_pages() complexity linear
From: Brice Goglin <Brice.Goglin@inria.fr>

> +/*
> + * Allocate a page on the node given as a page_to_node in private.
> + * Increase private to point to the next page_to_node so that the
> + * next iteration does not have to traverse the whole pm array.
> + */
>  static struct page *new_page_node(struct page *p, unsigned long private,
>  		int **result)
>  {
> -	struct page_to_node *pm = (struct page_to_node *)private;
> +	struct page_to_node **pmptr = (struct page_to_node **)private;
> +	struct page_to_node *pm = *pmptr;
>  
>  	while (pm->node != MAX_NUMNODES && pm->page != p)
>  		pm++;
>  
> +	/* prepare for the next iteration */
> +	*pmptr = pm + 1;
> +
>   
	
Actually, this "pm+1" breaks the case where migrate_pages() calls
unmap_and_move() multiple times on the same page. In this case, we need
the while loop to look at pm instead of pm+1 first. So we can't cache
pm+1 in private, but caching pm is ok. There will be 1 while loop
instead of 0 in the regular case. Updated patch (with more comments)
coming soon.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~mm-make-do_move_pages-complexity-linear-fix mm/migrate.c
--- a/mm/migrate.c~mm-make-do_move_pages-complexity-linear-fix
+++ a/mm/migrate.c
@@ -839,8 +839,14 @@ struct page_to_node {
 
 /*
  * Allocate a page on the node given as a page_to_node in private.
- * Increase private to point to the next page_to_node so that the
- * next iteration does not have to traverse the whole pm array.
+ *
+ * Cache the _last used_ pm in private so that the next call may find the
+ * target pm in very few while loops (usually 1) instead of scanning the
+ * whole pm array.
+ * We cannot cache the _next_ pm in private (to get 0 while loop in the
+ * regular case) because it would break the case where new_page_node()
+ * is called multiple times on the same page (when migrate_pages() tries
+ * unmap_and_move() multiple times).
  */
 static struct page *new_page_node(struct page *p, unsigned long private,
 		int **result)
@@ -851,8 +857,8 @@ static struct page *new_page_node(struct
 	while (pm->node != MAX_NUMNODES && pm->page != p)
 		pm++;
 
-	/* prepare for the next iteration */
-	*pmptr = pm + 1;
+	/* save the current pm to reduce the while loop in the next call */
+	*pmptr = pm;
 
 	if (pm->node == MAX_NUMNODES)
 		return NULL;
_

Patches currently in -mm which might be from Brice.Goglin@inria.fr are

mm-make-do_move_pages-complexity-linear-fix.patch

