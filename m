From: akpm@linux-foundation.org
Subject: [merged] ramfs-nommu-use-generic-lru-cache.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:54 -0700
Message-ID: <200904011838.n31IcsYh008429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933612AbZDASqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, Lee.Schermerhorn@hp.com, dhowells@redhat.com, gerg@snapgear.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, peterz@infradead.com, riel


The patch titled
     ramfs-nommu: use generic lru cache
has been removed from the -mm tree.  Its filename was
     ramfs-nommu-use-generic-lru-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramfs-nommu: use generic lru cache
From: Johannes Weiner <hannes@cmpxchg.org>

Instead of open-coding the lru-list-add pagevec batching when expanding a
file mapping from zero, defer to the appropriate page cache function that
also takes care of adding the page to the lru list.

This is cleaner, saves code and reduces the stack footprint by 16 words
worth of pagevec.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.com>
Cc: MinChan Kim <minchan.kim@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN fs/ramfs/file-nommu.c~ramfs-nommu-use-generic-lru-cache fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~ramfs-nommu-use-generic-lru-cache
+++ a/fs/ramfs/file-nommu.c
@@ -59,7 +59,6 @@ const struct inode_operations ramfs_file
  */
 int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
-	struct pagevec lru_pvec;
 	unsigned long npages, xpages, loop, limit;
 	struct page *pages;
 	unsigned order;
@@ -102,24 +101,20 @@ int ramfs_nommu_expand_for_mapping(struc
 	memset(data, 0, newsize);
 
 	/* attach all the pages to the inode's address space */
-	pagevec_init(&lru_pvec, 0);
 	for (loop = 0; loop < npages; loop++) {
 		struct page *page = pages + loop;
 
-		ret = add_to_page_cache(page, inode->i_mapping, loop, GFP_KERNEL);
+		ret = add_to_page_cache_lru(page, inode->i_mapping, loop,
+					GFP_KERNEL);
 		if (ret < 0)
 			goto add_error;
 
-		if (!pagevec_add(&lru_pvec, page))
-			__pagevec_lru_add_file(&lru_pvec);
-
 		/* prevent the page from being discarded on memory pressure */
 		SetPageDirty(page);
 
 		unlock_page(page);
 	}
 
-	pagevec_lru_add_file(&lru_pvec);
 	return 0;
 
  fsize_exceeded:
@@ -128,10 +123,8 @@ int ramfs_nommu_expand_for_mapping(struc
 	return -EFBIG;
 
  add_error:
-	pagevec_lru_add_file(&lru_pvec);
-	page_cache_release(pages + loop);
-	for (loop++; loop < npages; loop++)
-		__free_page(pages + loop);
+	while (loop < npages)
+		__free_page(pages + loop++);
 	return ret;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

