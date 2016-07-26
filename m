From: akpm@linux-foundation.org
Subject: [patch 042/126] mm: use put_page() to free page instead of
 putback_lru_page()
Date: Tue, 26 Jul 2016 15:23:02 -0700
Message-ID: <5797e2c6.DYO+Qw5IG7gKMFUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, hughd@google.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: use put_page() to free page instead of putback_lru_page()

Recently, I got many reports about perfermance degradation in embedded
system(Android mobile phone, webOS TV and so on) and easy fork fail.

The problem was fragmentation caused by zram and GPU driver mainly.  With
memory pressure, their pages were spread out all of pageblock and it
cannot be migrated with current compaction algorithm which supports only
LRU pages.  In the end, compaction cannot work well so reclaimer shrinks
all of working set pages.  It made system very slow and even to fail to
fork easily which requires order-[2 or 3] allocations.

Other pain point is that they cannot use CMA memory space so when OOM kill
happens, I can see many free pages in CMA area, which is not memory
efficient.  In our product which has big CMA memory, it reclaims zones too
exccessively to allocate GPU and zram page although there are lots of free
space in CMA so system becomes very slow easily.

To solve these problem, this patch tries to add facility to migrate
non-lru pages via introducing new functions and page flags to help
migration.

struct address_space_operations {
	..
	..
	bool (*isolate_page)(struct page *, isolate_mode_t);
	void (*putback_page)(struct page *);
	..
}

new page flags

	PG_movable
	PG_isolated

For details, please read description in "mm: migrate: support non-lru
movable page migration".

Originally, Gioh Kim had tried to support this feature but he moved so I
took over the work.  I took many code from his work and changed a little
bit and Konstantin Khlebnikov helped Gioh a lot so he should deserve to
have many credit, too.

And I should mention Chulmin who have tested this patchset heavily
so I can find many bugs from him. :)

Thanks, Gioh, Konstantin and Chulmin!

This patchset consists of five parts.

1. clean up migration
  mm: use put_page to free page instead of putback_lru_page

2. add non-lru page migration feature
  mm: migrate: support non-lru movable page migration

3. rework KVM memory-ballooning
  mm: balloon: use general non-lru movable page feature

4. zsmalloc refactoring for preparing page migration
  zsmalloc: keep max_object in size_class
  zsmalloc: use bit_spin_lock
  zsmalloc: use accessor
  zsmalloc: factor page chain functionality out
  zsmalloc: introduce zspage structure
  zsmalloc: separate free_zspage from putback_zspage
  zsmalloc: use freeobj for index

5. zsmalloc page migration
  zsmalloc: page migration support
  zram: use __GFP_MOVABLE for memory allocation



This patch (of 12):

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

Link: http://lkml.kernel.org/r/1464736881-24886-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   64 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff -puN mm/migrate.c~mm-use-put_page-to-free-page-instead-of-putback_lru_page mm/migrate.c
--- a/mm/migrate.c~mm-use-put_page-to-free-page-instead-of-putback_lru_page
+++ a/mm/migrate.c
@@ -915,6 +915,19 @@ out_unlock:
 		put_anon_vma(anon_vma);
 	unlock_page(page);
 out:
+	/*
+	 * If migration is successful, decrease refcount of the newpage
+	 * which will not free the page because new page owner increased
+	 * refcounter. As well, if it is LRU page, add the page to LRU
+	 * list in here.
+	 */
+	if (rc == MIGRATEPAGE_SUCCESS) {
+		if (unlikely(__is_movable_balloon_page(newpage)))
+			put_page(newpage);
+		else
+			putback_lru_page(newpage);
+	}
+
 	return rc;
 }
 
@@ -948,6 +961,12 @@ static ICE_noinline int unmap_and_move(n
 
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
 
@@ -960,10 +979,8 @@ static ICE_noinline int unmap_and_move(n
 	}
 
 	rc = __unmap_and_move(page, newpage, force, mode);
-	if (rc == MIGRATEPAGE_SUCCESS) {
-		put_new_page = NULL;
+	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(newpage, reason);
-	}
 
 out:
 	if (rc != -EAGAIN) {
@@ -976,34 +993,33 @@ out:
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		/* Soft-offlined page shouldn't go through lru cache list */
-		if (reason == MR_MEMORY_FAILURE && rc == MIGRATEPAGE_SUCCESS) {
+	}
+
+	/*
+	 * If migration is successful, releases reference grabbed during
+	 * isolation. Otherwise, restore the page to right list unless
+	 * we want to retry.
+	 */
+	if (rc == MIGRATEPAGE_SUCCESS) {
+		put_page(page);
+		if (reason == MR_MEMORY_FAILURE) {
 			/*
-			 * With this release, we free successfully migrated
-			 * page and set PG_HWPoison on just freed page
-			 * intentionally. Although it's rather weird, it's how
-			 * HWPoison flag works at the moment.
+			 * Set PG_HWPoison on just freed page
+			 * intentionally. Although it's rather weird,
+			 * it's how HWPoison flag works at the moment.
 			 */
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
