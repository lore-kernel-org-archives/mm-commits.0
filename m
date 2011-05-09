From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-remove-mpol_mf_stats.patch removed from -mm tree
Date: Mon, 09 May 2011 13:07:35 -0700
Message-ID: <201105092007.p49K7ZrE014929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab1EIUHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 16:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove MPOL_MF_STATS
has been removed from the -mm tree.  Its filename was
     mm-remove-mpol_mf_stats.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove MPOL_MF_STATS
From: Stephen Wilson <wilsons@start.ca>

Mapping statistics in a NUMA environment is now computed using the generic
walk_page_range() logic.  Remove the old/equivalent functionality.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-remove-mpol_mf_stats mm/mempolicy.c
--- a/mm/mempolicy.c~mm-remove-mpol_mf_stats
+++ a/mm/mempolicy.c
@@ -99,7 +99,6 @@
 /* Internal flags */
 #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
 #define MPOL_MF_INVERT (MPOL_MF_INTERNAL << 1)		/* Invert check for nodemask */
-#define MPOL_MF_STATS (MPOL_MF_INTERNAL << 2)		/* Gather statistics */
 
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
@@ -492,9 +491,7 @@ static int check_pte_range(struct vm_are
 		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
 			continue;
 
-		if (flags & MPOL_MF_STATS)
-			gather_stats(page, private, pte_dirty(*pte));
-		else if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 			migrate_page_add(page, private, flags);
 		else
 			break;
@@ -2572,6 +2569,7 @@ static int gather_pte_stats(pte_t *pte, 
 		unsigned long pte_size, struct mm_walk *walk)
 {
 	struct page *page;
+	int nid;
 
 	if (pte_none(*pte))
 		return 0;
@@ -2580,6 +2578,10 @@ static int gather_pte_stats(pte_t *pte, 
 	if (!page)
 		return 0;
 
+	nid = page_to_nid(page);
+	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
+		return 0;
+
 	gather_stats(page, walk->private, pte_dirty(*pte));
 	return 0;
 }
_

Patches currently in -mm which might be from wilsons@start.ca are

mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch

