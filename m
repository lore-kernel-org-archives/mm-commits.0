From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:13:41 -0700
Message-ID: <57042a85.HXGcir4Y9Ac/Lu+G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbcDEVNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:13:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use put_page to free page instead of putback_lru_page
has been removed from the -mm tree.  Its filename was
     mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: use put_page to free page instead of putback_lru_page

Recently, I got many reports about performance degradation in embedded
system(Android mobile phone, webOS TV and so on) and failed to fork
easily.

The problem was fragmentation caused by zram and GPU driver pages.  Their
pages cannot be migrated so compaction cannot work well, either so
reclaimer ends up shrinking all of working set pages.  It made system very
slow and even to fail to fork easily.

Other pain point is that they cannot work with CMA.  Most of CMA memory
space could be idle(ie, it could be used for movable pages unless driver
is using) but if driver(i.e., zram) cannot migrate his page, that memory
space could be wasted.  In our product which has big CMA memory, it
reclaims zones too exccessively although there are lots of free space in
CMA so system was very slow easily.

To solve these problem, this patch try to add facility to migrate non-lru
pages via introducing new friend functions of migratepage in
address_space_operation and new page flags.

	(isolate_page, putback_page)
	(PG_movable, PG_isolated)

For details, please read description in "mm/compaction: support non-lru
movable page migration".

Originally, Gioh Kim tried to support this feature but he moved so I took
over the work.  But I took many code from his work and changed a little
bit.  Thanks, Gioh!

And I should mention Konstantin Khlebnikov.  He really heped Gioh at that
time so he should deserve to have many credit, too.  Thanks, Konstantin!

This patchset consists of five parts.

1. clean up migration
  mm: use put_page to free page instead of putback_lru_page

2. add non-lru page migration feature
  mm/compaction: support non-lru movable page migration
  mm: add non-lru movable page support document

3. rework KVM memory-ballooning
  mm/balloon: use general movable page feature into balloon

4. zsmalloc clean-up for preparing page migration
  zsmalloc: keep max_object in size_class
  zsmalloc: squeeze inuse into page->mapping
  zsmalloc: remove page_mapcount_reset
  zsmalloc: squeeze freelist into page->mapping
  zsmalloc: move struct zs_meta from mapping to freelist
  zsmalloc: factor page chain functionality out
  zsmalloc: separate free_zspage from putback_zspage
  zsmalloc: zs_compact refactoring

5. add zsmalloc page migration
  zsmalloc: migrate head page of zspage
  zsmalloc: use single linked list for page chain
  zsmalloc: migrate tail pages in zspage
  zram: use __GFP_MOVABLE for memory allocation




This patch (of 16):

Procedure of page migration is as follows:

First of all, it should isolate a page from LRU and try to migrate the
page.  If it is successful, it releases the page for freeing.  Otherwise,
it should put the page back to LRU list.

For LRU pages, we have used putback_lru_page for both freeing and putback
to LRU list.  It's okay because put_page is aware of LRU list so if it
releases last refcount of the page, it removes the page from LRU list. 
However, It makes unnecessary operations (e.g., lru_cache_add, pagevec and
flags operations.  It would be not significant but no worth to do) and
harder to support new non-lru page migration because put_page isn't aware
of non-lru page's data structure.

To solve the problem, we can add new hook in put_page with PageMovable
flags check but it can increase overhead in hot path and needs new locking
scheme to stabilize the flag check with put_page.

So, this patch cleans it up to divide two semantic(ie, put and putback). 
If migration is successful, use put_page instead of putback_lru_page and
use putback_lru_page only on failure.  That makes code more readable and
doesn't add overhead in put_page.

Comment from Vlastimil
"Yeah, and compaction (perhaps also other migration users) has to drain
the lru pvec... Getting rid of this stuff is worth even by itself."

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   50 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff -puN mm/migrate.c~mm-use-put_page-to-free-page-instead-of-putback_lru_page mm/migrate.c
--- a/mm/migrate.c~mm-use-put_page-to-free-page-instead-of-putback_lru_page
+++ a/mm/migrate.c
@@ -913,6 +913,14 @@ out_unlock:
 		put_anon_vma(anon_vma);
 	unlock_page(page);
 out:
+	/* If migration is successful, move newpage to right list */
+	if (rc == MIGRATEPAGE_SUCCESS) {
+		if (unlikely(__is_movable_balloon_page(newpage)))
+			put_page(newpage);
+		else
+			putback_lru_page(newpage);
+	}
+
 	return rc;
 }
 
@@ -946,6 +954,12 @@ static ICE_noinline int unmap_and_move(n
 
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
+		ClearPageActive(page);
+		ClearPageUnevictable(page);
+		if (put_new_page)
+			put_new_page(newpage, private);
+		else
+			put_page(newpage);
 		goto out;
 	}
 
@@ -958,10 +972,8 @@ static ICE_noinline int unmap_and_move(n
 	}
 
 	rc = __unmap_and_move(page, newpage, force, mode);
-	if (rc == MIGRATEPAGE_SUCCESS) {
-		put_new_page = NULL;
+	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(newpage, reason);
-	}
 
 out:
 	if (rc != -EAGAIN) {
@@ -974,28 +986,28 @@ out:
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		/* Soft-offlined page shouldn't go through lru cache list */
+	}
+
+	/*
+	 * If migration is successful, drop the reference grabbed during
+	 * isolation. Otherwise, restore the page to LRU list unless we
+	 * want to retry.
+	 */
+	if (rc == MIGRATEPAGE_SUCCESS) {
+		put_page(page);
 		if (reason == MR_MEMORY_FAILURE) {
-			put_page(page);
 			if (!test_set_page_hwpoison(page))
 				num_poisoned_pages_inc();
-		} else
+		}
+	} else {
+		if (rc != -EAGAIN)
 			putback_lru_page(page);
+		if (put_new_page)
+			put_new_page(newpage, private);
+		else
+			put_page(newpage);
 	}
 
-	/*
-	 * If migration was not successful and there's a freeing callback, use
-	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
-	 * during isolation.
-	 */
-	if (put_new_page)
-		put_new_page(newpage, private);
-	else if (unlikely(__is_movable_balloon_page(newpage))) {
-		/* drop our reference, page already in the balloon */
-		put_page(newpage);
-	} else
-		putback_lru_page(newpage);
-
 	if (result) {
 		if (rc)
 			*result = rc;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
mm-compaction-support-non-lru-movable-page-migration.patch
mm-add-non-lru-movable-page-support-document.patch
mm-balloon-use-general-movable-page-feature-into-balloon.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-squeeze-inuse-into-page-mapping.patch
zsmalloc-remove-page_mapcount_reset.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

