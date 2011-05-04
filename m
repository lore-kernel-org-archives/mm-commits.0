From: akpm@linux-foundation.org
Subject: + mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch added to -mm tree
Date: Wed, 04 May 2011 16:10:37 -0700
Message-ID: <201105042310.p44NAbYl020308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098Ab1EDXKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 19:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mm: make gather_stats() type-safe and remove forward declaration
has been added to the -mm tree.  Its filename is
     mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~mm-make-gather_stats-type-safe-and-remove-forward-declaration mm/mempolicy.c
--- a/mm/mempolicy.c~mm-make-gather_stats-type-safe-and-remove-forward-declaration
+++ a/mm/mempolicy.c
@@ -456,7 +456,6 @@ static const struct mempolicy_operations
 	},
 };
 
-static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
@@ -2538,9 +2537,8 @@ struct numa_maps {
 	unsigned long node[MAX_NUMNODES];
 };
 
-static void gather_stats(struct page *page, void *private, int pte_dirty)
+static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty)
 {
-	struct numa_maps *md = private;
 	int count = page_mapcount(page);
 
 	md->pages++;
@@ -2568,6 +2566,7 @@ static void gather_stats(struct page *pa
 static int gather_pte_stats(pte_t *pte, unsigned long addr,
 		unsigned long pte_size, struct mm_walk *walk)
 {
+	struct numa_maps *md;
 	struct page *page;
 	int nid;
 
@@ -2582,7 +2581,8 @@ static int gather_pte_stats(pte_t *pte, 
 	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
 		return 0;
 
-	gather_stats(page, walk->private, pte_dirty(*pte));
+	md = walk->private;
+	gather_stats(page, md, pte_dirty(*pte));
 	return 0;
 }
 
@@ -2619,6 +2619,7 @@ static void check_huge_range(struct vm_a
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
+	struct numa_maps *md;
 	struct page *page;
 
 	if (pte_none(*pte))
@@ -2628,7 +2629,8 @@ static int gather_hugetbl_stats(pte_t *p
 	if (!page)
 		return 0;
 
-	gather_stats(page, walk->private, pte_dirty(*pte));
+	md = walk->private;
+	gather_stats(page, md, pte_dirty(*pte));
 	return 0;
 }
 
_

Patches currently in -mm which might be from wilsons@start.ca are

mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

