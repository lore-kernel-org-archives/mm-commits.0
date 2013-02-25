From: akpm@linux-foundation.org
Subject: [merged] mm-shmem-use-new-radix-tree-iterator.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:17 -0800
Message-ID: <20130225205417.9FC7B5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:40890 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3BYUyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:18 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347514ghb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: use new radix tree iterator
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-new-radix-tree-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: shmem: use new radix tree iterator

In shmem_find_get_pages_and_swap(), use the faster radix tree iterator
construct from 78c1d78 ("radix-tree: introduce bit-optimized iterator").

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/shmem.c~mm-shmem-use-new-radix-tree-iterator mm/shmem.c
--- a/mm/shmem.c~mm-shmem-use-new-radix-tree-iterator
+++ a/mm/shmem.c
@@ -335,19 +335,19 @@ static unsigned shmem_find_get_pages_and
 					pgoff_t start, unsigned int nr_pages,
 					struct page **pages, pgoff_t *indices)
 {
-	unsigned int i;
-	unsigned int ret;
-	unsigned int nr_found;
+	void **slot;
+	unsigned int ret = 0;
+	struct radix_tree_iter iter;
+
+	if (!nr_pages)
+		return 0;
 
 	rcu_read_lock();
 restart:
-	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-				(void ***)pages, indices, start, nr_pages);
-	ret = 0;
-	for (i = 0; i < nr_found; i++) {
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
-		page = radix_tree_deref_slot((void **)pages[i]);
+		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
 			continue;
 		if (radix_tree_exception(page)) {
@@ -364,17 +364,16 @@ repeat:
 			goto repeat;
 
 		/* Has the page moved? */
-		if (unlikely(page != *((void **)pages[i]))) {
+		if (unlikely(page != *slot)) {
 			page_cache_release(page);
 			goto repeat;
 		}
 export:
-		indices[ret] = indices[i];
+		indices[ret] = iter.index;
 		pages[ret] = page;
-		ret++;
+		if (++ret == nr_pages)
+			break;
 	}
-	if (unlikely(!ret && nr_found))
-		goto restart;
 	rcu_read_unlock();
 	return ret;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

