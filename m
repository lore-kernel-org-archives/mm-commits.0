From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:19:27 -0700
Message-ID: <543c17af.2fjv2v3cKQcf5hJN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMST1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP: don't hold mmap_sem in khugepaged when allocating THP
has been removed from the -mm tree.  Its filename was
     mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, THP: don't hold mmap_sem in khugepaged when allocating THP

When allocating huge page for collapsing, khugepaged currently holds
mmap_sem for reading on the mm where collapsing occurs.  Afterwards the
read lock is dropped before write lock is taken on the same mmap_sem.

Holding mmap_sem during whole huge page allocation is therefore useless,
the vma needs to be rechecked after taking the write lock anyway. 
Furthemore, huge page allocation might involve a rather long sync
compaction, and thus block any mmap_sem writers and i.e.  affect workloads
that perform frequent m(un)map or mprotect oterations.

This patch simply releases the read lock before allocating a huge page. 
It also deletes an outdated comment that assumed vma must be stable, as it
was using alloc_hugepage_vma().  This is no longer true since commit
9f1b868a13ac ("mm: thp: khugepaged: add policy for finding target node").

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp
+++ a/mm/huge_memory.c
@@ -2322,23 +2322,17 @@ static struct page
 		       int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
+
 	/*
-	 * Allocate the page while the vma is still valid and under
-	 * the mmap_sem read mode so there is no memory allocation
-	 * later when we take the mmap_sem in write mode. This is more
-	 * friendly behavior (OTOH it may actually hide bugs) to
-	 * filesystems in userland with daemons allocating memory in
-	 * the userland I/O paths.  Allocating memory with the
-	 * mmap_sem in read mode is good idea also to allow greater
-	 * scalability.
+	 * Before allocating the hugepage, release the mmap_sem read lock.
+	 * The allocation can take potentially a long time if it involves
+	 * sync compaction, and we do not need to hold the mmap_sem during
+	 * that. We will recheck the vma after taking it again in write mode.
 	 */
+	up_read(&mm->mmap_sem);
+
 	*hpage = alloc_pages_exact_node(node, alloc_hugepage_gfpmask(
 		khugepaged_defrag(), __GFP_OTHER_NODE), HPAGE_PMD_ORDER);
-	/*
-	 * After allocating the hugepage, release the mmap_sem read lock in
-	 * preparation for taking it in write mode.
-	 */
-	up_read(&mm->mmap_sem);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch

