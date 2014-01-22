From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:13:20 -0800
Message-ID: <52e02660.ONgxaZjcZQa3bu2G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:20 -0800


The patch titled
     Subject: mm/rmap: factor nonlinear handling out of try_to_unmap_file()
has been removed from the -mm tree.  Its filename was
     mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: factor nonlinear handling out of try_to_unmap_file()

To merge all kinds of rmap traverse functions, try_to_unmap(),
try_to_munlock(), page_referenced() and page_mkclean(), we need to extract
common parts and separate out non-common parts.

Nonlinear handling is handled just in try_to_unmap_file() and other rmap
traverse functions doesn't care of it.  Therfore it is better to factor
nonlinear handling out of try_to_unmap_file() in order to merge all kinds
of rmap traverse functions easily.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |  136 ++++++++++++++++++++++++++++------------------------
 1 file changed, 74 insertions(+), 62 deletions(-)

diff -puN mm/rmap.c~mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file mm/rmap.c
--- a/mm/rmap.c~mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file
+++ a/mm/rmap.c
@@ -1426,6 +1426,79 @@ static int try_to_unmap_cluster(unsigned
 	return ret;
 }
 
+static int try_to_unmap_nonlinear(struct page *page,
+		struct address_space *mapping, struct vm_area_struct *vma)
+{
+	int ret = SWAP_AGAIN;
+	unsigned long cursor;
+	unsigned long max_nl_cursor = 0;
+	unsigned long max_nl_size = 0;
+	unsigned int mapcount;
+
+	list_for_each_entry(vma,
+		&mapping->i_mmap_nonlinear, shared.nonlinear) {
+
+		cursor = (unsigned long) vma->vm_private_data;
+		if (cursor > max_nl_cursor)
+			max_nl_cursor = cursor;
+		cursor = vma->vm_end - vma->vm_start;
+		if (cursor > max_nl_size)
+			max_nl_size = cursor;
+	}
+
+	if (max_nl_size == 0) {	/* all nonlinears locked or reserved ? */
+		return SWAP_FAIL;
+	}
+
+	/*
+	 * We don't try to search for this page in the nonlinear vmas,
+	 * and page_referenced wouldn't have found it anyway.  Instead
+	 * just walk the nonlinear vmas trying to age and unmap some.
+	 * The mapcount of the page we came in with is irrelevant,
+	 * but even so use it as a guide to how hard we should try?
+	 */
+	mapcount = page_mapcount(page);
+	if (!mapcount)
+		return ret;
+
+	cond_resched();
+
+	max_nl_size = (max_nl_size + CLUSTER_SIZE - 1) & CLUSTER_MASK;
+	if (max_nl_cursor == 0)
+		max_nl_cursor = CLUSTER_SIZE;
+
+	do {
+		list_for_each_entry(vma,
+			&mapping->i_mmap_nonlinear, shared.nonlinear) {
+
+			cursor = (unsigned long) vma->vm_private_data;
+			while (cursor < max_nl_cursor &&
+				cursor < vma->vm_end - vma->vm_start) {
+				if (try_to_unmap_cluster(cursor, &mapcount,
+						vma, page) == SWAP_MLOCK)
+					ret = SWAP_MLOCK;
+				cursor += CLUSTER_SIZE;
+				vma->vm_private_data = (void *) cursor;
+				if ((int)mapcount <= 0)
+					return ret;
+			}
+			vma->vm_private_data = (void *) max_nl_cursor;
+		}
+		cond_resched();
+		max_nl_cursor += CLUSTER_SIZE;
+	} while (max_nl_cursor <= max_nl_size);
+
+	/*
+	 * Don't loop forever (perhaps all the remaining pages are
+	 * in locked vmas).  Reset cursor on all unreserved nonlinear
+	 * vmas, now forgetting on which ones it had fallen behind.
+	 */
+	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.nonlinear)
+		vma->vm_private_data = NULL;
+
+	return ret;
+}
+
 bool is_vma_temporary_stack(struct vm_area_struct *vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
@@ -1515,10 +1588,6 @@ static int try_to_unmap_file(struct page
 	pgoff_t pgoff = page->index << compound_order(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
-	unsigned long cursor;
-	unsigned long max_nl_cursor = 0;
-	unsigned long max_nl_size = 0;
-	unsigned int mapcount;
 
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
@@ -1539,64 +1608,7 @@ static int try_to_unmap_file(struct page
 	if (TTU_ACTION(flags) == TTU_MUNLOCK)
 		goto out;
 
-	list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
-							shared.nonlinear) {
-		cursor = (unsigned long) vma->vm_private_data;
-		if (cursor > max_nl_cursor)
-			max_nl_cursor = cursor;
-		cursor = vma->vm_end - vma->vm_start;
-		if (cursor > max_nl_size)
-			max_nl_size = cursor;
-	}
-
-	if (max_nl_size == 0) {	/* all nonlinears locked or reserved ? */
-		ret = SWAP_FAIL;
-		goto out;
-	}
-
-	/*
-	 * We don't try to search for this page in the nonlinear vmas,
-	 * and page_referenced wouldn't have found it anyway.  Instead
-	 * just walk the nonlinear vmas trying to age and unmap some.
-	 * The mapcount of the page we came in with is irrelevant,
-	 * but even so use it as a guide to how hard we should try?
-	 */
-	mapcount = page_mapcount(page);
-	if (!mapcount)
-		goto out;
-	cond_resched();
-
-	max_nl_size = (max_nl_size + CLUSTER_SIZE - 1) & CLUSTER_MASK;
-	if (max_nl_cursor == 0)
-		max_nl_cursor = CLUSTER_SIZE;
-
-	do {
-		list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
-							shared.nonlinear) {
-			cursor = (unsigned long) vma->vm_private_data;
-			while ( cursor < max_nl_cursor &&
-				cursor < vma->vm_end - vma->vm_start) {
-				if (try_to_unmap_cluster(cursor, &mapcount,
-						vma, page) == SWAP_MLOCK)
-					ret = SWAP_MLOCK;
-				cursor += CLUSTER_SIZE;
-				vma->vm_private_data = (void *) cursor;
-				if ((int)mapcount <= 0)
-					goto out;
-			}
-			vma->vm_private_data = (void *) max_nl_cursor;
-		}
-		cond_resched();
-		max_nl_cursor += CLUSTER_SIZE;
-	} while (max_nl_cursor <= max_nl_size);
