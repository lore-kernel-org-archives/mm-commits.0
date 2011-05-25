From: akpm@linux-foundation.org
Subject: [merged] mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:19 -0700
Message-ID: <201105252028.p4PKSgaM014766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701Ab1EYU3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: make gather_stats() type-safe and remove forward declaration
has been removed from the -mm tree.  Its filename was
     mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make gather_stats() type-safe and remove forward declaration
From: Stephen Wilson <wilsons@start.ca>

Improve the prototype of gather_stats() to take a struct numa_maps as
argument instead of a generic void *.  Update all callers to make the
required type explicit.

Since gather_stats() is not needed before its definition and is scheduled
to be moved out of mempolicy.c the declaration is removed as well.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-make-gather_stats-type-safe-and-remove-forward-declaration mm/mempolicy.c
--- a/mm/mempolicy.c~mm-make-gather_stats-type-safe-and-remove-forward-declaration
+++ a/mm/mempolicy.c
@@ -456,7 +456,6 @@ static const struct mempolicy_operations
 	},
 };
 
-static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
@@ -2539,9 +2538,8 @@ struct numa_maps {
 	unsigned long node[MAX_NUMNODES];
 };
 
-static void gather_stats(struct page *page, void *private, int pte_dirty)
+static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty)
 {
-	struct numa_maps *md = private;
 	int count = page_mapcount(page);
 
 	md->pages++;
@@ -2634,6 +2632,7 @@ static void check_huge_range(struct vm_a
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
+	struct numa_maps *md;
 	struct page *page;
 
 	if (pte_none(*pte))
@@ -2643,7 +2642,8 @@ static int gather_hugetbl_stats(pte_t *p
 	if (!page)
 		return 0;
 
-	gather_stats(page, walk->private, pte_dirty(*pte));
+	md = walk->private;
+	gather_stats(page, md, pte_dirty(*pte));
 	return 0;
 }
 
_

Patches currently in -mm which might be from wilsons@start.ca are

origin.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

