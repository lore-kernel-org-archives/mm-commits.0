From: akpm@linux-foundation.org
Subject: [merged] shmem-replace_page-must-flush_dcache-and-others.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:11 -0700
Message-ID: <20120608194112.13CE9A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51134 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2FHTlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:13 -0400
Received: by ghbz15 with SMTP id z15so200681ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, airlied@gmail.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, daniel@ffwll.ch, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, marcheu@chromium.org, rob.clark@linaro.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: replace_page must flush_dcache and others
has been removed from the -mm tree.  Its filename was
     shmem-replace_page-must-flush_dcache-and-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: replace_page must flush_dcache and others

Commit bde05d1ccd51 ("shmem: replace page if mapping excludes its zone")
is not at all likely to break for anyone, but it was an earlier version
from before review feedback was incorporated.  Fix that up now.

* shmem_replace_page must flush_dcache_page after copy_highpage [akpm]
* Expand comment on why shmem_unuse_inode needs page_swapcount [akpm]
* Remove excess of VM_BUG_ONs from shmem_replace_page [wangcong]
* Check page_private matches swap before calling shmem_replace_page [hughd]
* shmem_replace_page allow for unexpected race in radix_tree lookup [hughd]

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephane Marchesin <marcheu@chromium.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Rob Clark <rob.clark@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   57 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff -puN mm/shmem.c~shmem-replace_page-must-flush_dcache-and-others mm/shmem.c
--- a/mm/shmem.c~shmem-replace_page-must-flush_dcache-and-others
+++ a/mm/shmem.c
@@ -683,10 +683,21 @@ static int shmem_unuse_inode(struct shme
 		mutex_lock(&shmem_swaplist_mutex);
 		/*
 		 * We needed to drop mutex to make that restrictive page
-		 * allocation; but the inode might already be freed by now,
-		 * and we cannot refer to inode or mapping or info to check.
-		 * However, we do hold page lock on the PageSwapCache page,
-		 * so can check if that still has our reference remaining.
+		 * allocation, but the inode might have been freed while we
+		 * dropped it: although a racing shmem_evict_inode() cannot
+		 * complete without emptying the radix_tree, our page lock
+		 * on this swapcache page is not enough to prevent that -
+		 * free_swap_and_cache() of our swap entry will only
+		 * trylock_page(), removing swap from radix_tree whatever.
+		 *
+		 * We must not proceed to shmem_add_to_page_cache() if the
+		 * inode has been freed, but of course we cannot rely on
+		 * inode or mapping or info to check that.  However, we can
+		 * safely check if our swap entry is still in use (and here
+		 * it can't have got reused for another page): if it's still
+		 * in use, then the inode cannot have been freed yet, and we
+		 * can safely proceed (if it's no longer in use, that tells
+		 * nothing about the inode, but we don't need to unuse swap).
 		 */
 		if (!page_swapcount(*pagep))
 			error = -ENOENT;
@@ -730,9 +741,9 @@ int shmem_unuse(swp_entry_t swap, struct
 
 	/*
 	 * There's a faint possibility that swap page was replaced before
-	 * caller locked it: it will come back later with the right page.
+	 * caller locked it: caller will come back later with the right page.
 	 */
-	if (unlikely(!PageSwapCache(page)))
+	if (unlikely(!PageSwapCache(page) || page_private(page) != swap.val))
 		goto out;
 
 	/*
@@ -995,21 +1006,15 @@ static int shmem_replace_page(struct pag
 	newpage = shmem_alloc_page(gfp, info, index);
 	if (!newpage)
 		return -ENOMEM;
-	VM_BUG_ON(shmem_should_replace_page(newpage, gfp));
 
-	*pagep = newpage;
 	page_cache_get(newpage);
 	copy_highpage(newpage, oldpage);
+	flush_dcache_page(newpage);
 
-	VM_BUG_ON(!PageLocked(oldpage));
 	__set_page_locked(newpage);
-	VM_BUG_ON(!PageUptodate(oldpage));
 	SetPageUptodate(newpage);
-	VM_BUG_ON(!PageSwapBacked(oldpage));
 	SetPageSwapBacked(newpage);
-	VM_BUG_ON(!swap_index);
 	set_page_private(newpage, swap_index);
-	VM_BUG_ON(!PageSwapCache(oldpage));
 	SetPageSwapCache(newpage);
 
 	/*
@@ -1019,13 +1024,24 @@ static int shmem_replace_page(struct pag
 	spin_lock_irq(&swap_mapping->tree_lock);
 	error = shmem_radix_tree_replace(swap_mapping, swap_index, oldpage,
 								   newpage);
-	__inc_zone_page_state(newpage, NR_FILE_PAGES);
-	__dec_zone_page_state(oldpage, NR_FILE_PAGES);
+	if (!error) {
+		__inc_zone_page_state(newpage, NR_FILE_PAGES);
+		__dec_zone_page_state(oldpage, NR_FILE_PAGES);
+	}
 	spin_unlock_irq(&swap_mapping->tree_lock);
-	BUG_ON(error);
 
-	mem_cgroup_replace_page_cache(oldpage, newpage);
-	lru_cache_add_anon(newpage);
+	if (unlikely(error)) {
+		/*
+		 * Is this possible?  I think not, now that our callers check
+		 * both PageSwapCache and page_private after getting page lock;
+		 * but be defensive.  Reverse old to newpage for clear and free.
+		 */
+		oldpage = newpage;
+	} else {
+		mem_cgroup_replace_page_cache(oldpage, newpage);
+		lru_cache_add_anon(newpage);
+		*pagep = newpage;
+	}
 
 	ClearPageSwapCache(oldpage);
 	set_page_private(oldpage, 0);
@@ -1033,7 +1049,7 @@ static int shmem_replace_page(struct pag
 	unlock_page(oldpage);
 	page_cache_release(oldpage);
 	page_cache_release(oldpage);
-	return 0;
+	return error;
 }
 
 /*
@@ -1107,7 +1123,8 @@ repeat:
 
 		/* We have to do this with page locked to prevent races */
 		lock_page(page);
-		if (!PageSwapCache(page) || page->mapping) {
+		if (!PageSwapCache(page) || page_private(page) != swap.val ||
+		    page->mapping) {
 			error = -EEXIST;	/* try again */
 			goto failed;
 		}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
prio_tree-debugging-patch.patch

