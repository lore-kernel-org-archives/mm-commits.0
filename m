From: akpm@linux-foundation.org
Subject: + ramfs-nommu-use-generic-lru-cache.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:10:31 -0700
Message-ID: <200903302310.n2UNAVRB018488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbZC3XQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, Lee.Schermerhorn@hp.com, dhowells@redhat.com, gerg@snapgear.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, peterz@infradead.com, riel@redhat.com


The patch titled
     ramfs-nommu: use generic lru cache
has been added to the -mm tree.  Its filename is
     ramfs-nommu-use-generic-lru-cache.patch

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
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
ramfs-nommu-use-generic-lru-cache.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

