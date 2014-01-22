From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-recompute-pgoff-for-huge-page.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:18 -0800
Message-ID: <52e0265e.gmbYmnDeQ43oioaL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaAVUNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-recompute-pgoff-for-huge-page.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:18 -0800


The patch titled
     Subject: mm/rmap: recompute pgoff for huge page
has been removed from the -mm tree.  Its filename was
     mm-rmap-recompute-pgoff-for-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: recompute pgoff for huge page

Rmap traversing is used in five different cases, try_to_unmap(),
try_to_munlock(), page_referenced(), page_mkclean() and
remove_migration_ptes().  Each one implements its own traversing functions
for the cases, anon, file, ksm, respectively.  These cause lots of
duplications and cause maintenance overhead.  They also make codes being
hard to understand and error-prone.  One example is hugepage handling. 
There is a code to compute hugepage offset correctly in
try_to_unmap_file(), but, there isn't a code to compute hugepage offset in
rmap_walk_file().  These are used pairwise in migration context, but we
missed to modify pairwise.

To overcome these drawbacks, we should unify these through one unified
function.  I decide rmap_walk() as main function since it has no
unnecessity.  And to control behavior of rmap_walk(), I introduce struct
rmap_walk_control having some function pointers.  These makes rmap_walk()
working for their specific needs.

This patchset remove a lot of duplicated code as you can see in below
short-stat and kernel text size also decrease slightly.

   text    data     bss     dec     hex filename
  10640       1      16   10657    29a1 mm/rmap.o
  10047       1      16   10064    2750 mm/rmap.o

  13823     705    8288   22816    5920 mm/ksm.o
  13199     705    8288   22192    56b0 mm/ksm.o



This patch (of 9):

We have to recompute pgoff if the given page is huge, since result based
on HPAGE_SIZE is not approapriate for scanning the vma interval tree, as
shown by commit 36e4f20af833 ("hugetlb: do not use vma_hugecache_offset()
for vma_prio_tree_foreach") and commit 369a713e ("rmap: recompute pgoff
for unmapping huge page").

To handle both the cases, normal page for page cache and hugetlb page, by
same way, we can use compound_page().  It returns 0 on non-compound page
and it also returns proper value on compound page.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/rmap.c~mm-rmap-recompute-pgoff-for-huge-page mm/rmap.c
--- a/mm/rmap.c~mm-rmap-recompute-pgoff-for-huge-page
+++ a/mm/rmap.c
@@ -1512,7 +1512,7 @@ static int try_to_unmap_anon(struct page
 static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << compound_order(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 	unsigned long cursor;
@@ -1520,9 +1520,6 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 
-	if (PageHuge(page))
-		pgoff = page->index << compound_order(page);
