From: akpm@linux-foundation.org
Subject: + mm-remove-return-value-of-putback_lru_pages.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:38:52 -0700
Message-ID: <201003152038.o2FKcqFA021266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678Ab0COUjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: remove return value of putback_lru_pages()
has been added to the -mm tree.  Its filename is
     mm-remove-return-value-of-putback_lru_pages.patch

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
Subject: mm: remove return value of putback_lru_pages()
From: Minchan Kim <minchan.kim@gmail.com>

putback_lru_page() never can fail.  So it doesn't matter count of "the
number of pages put back".

In addition, users of this functions don't use return value.

Let's remove unnecessary code.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++--
 mm/migrate.c            |    7 +------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN include/linux/migrate.h~mm-remove-return-value-of-putback_lru_pages include/linux/migrate.h
--- a/include/linux/migrate.h~mm-remove-return-value-of-putback_lru_pages
+++ a/include/linux/migrate.h
@@ -9,7 +9,7 @@ typedef struct page *new_page_t(struct p
 #ifdef CONFIG_MIGRATION
 #define PAGE_MIGRATION 1
 
-extern int putback_lru_pages(struct list_head *l);
+extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
 extern int migrate_pages(struct list_head *l, new_page_t x,
@@ -25,7 +25,7 @@ extern int migrate_vmas(struct mm_struct
 #else
 #define PAGE_MIGRATION 0
 
-static inline int putback_lru_pages(struct list_head *l) { return 0; }
+static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, int offlining) { return -ENOSYS; }
 
diff -puN mm/migrate.c~mm-remove-return-value-of-putback_lru_pages mm/migrate.c
--- a/mm/migrate.c~mm-remove-return-value-of-putback_lru_pages
+++ a/mm/migrate.c
@@ -57,23 +57,18 @@ int migrate_prep(void)
 /*
  * Add isolated pages on the list back to the LRU under page lock
  * to avoid leaking evictable pages back onto unevictable list.
- *
- * returns the number of pages put back.
  */
-int putback_lru_pages(struct list_head *l)
+void putback_lru_pages(struct list_head *l)
 {
 	struct page *page;
 	struct page *page2;
-	int count = 0;
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
 		putback_lru_page(page);
-		count++;
 	}
-	return count;
 }
 
 /*
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-remove-return-value-of-putback_lru_pages.patch

