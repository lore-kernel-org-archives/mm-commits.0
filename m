From: akpm@linux-foundation.org
Subject: + mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
 added to -mm tree
Date: Mon, 07 Dec 2015 16:41:01 -0800
Message-ID: <5666271d.yksweukdYqwMzk2w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbbLHAlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2015 19:41:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud.c: use list_last_entry() instead of list_tail_entry()
has been added to the -mm tree.  Its filename is
     mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/zbud.c: use list_last_entry() instead of list_tail_entry()

list_last_entry*( has been defined in list.h, so replace list_tail_entry()
with it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/zbud.c~mm-zbud-use-list_last_entry-instead-of-list_tail_entry mm/zbud.c
--- a/mm/zbud.c~mm-zbud-use-list_last_entry-instead-of-list_tail_entry
+++ a/mm/zbud.c
@@ -463,9 +463,6 @@ void zbud_free(struct zbud_pool *pool, u
 	spin_unlock(&pool->lock);
 }
 
-#define list_tail_entry(ptr, type, member) \
-	list_entry((ptr)->prev, type, member)
-
 /**
  * zbud_reclaim_page() - evicts allocations from a pool page and frees it
  * @pool:	pool from which a page will attempt to be evicted
@@ -514,7 +511,7 @@ int zbud_reclaim_page(struct zbud_pool *
 		return -EINVAL;
 	}
 	for (i = 0; i < retries; i++) {
-		zhdr = list_tail_entry(&pool->lru, struct zbud_header, lru);
+		zhdr = list_last_entry(&pool->lru, struct zbud_header, lru);
 		list_del(&zhdr->lru);
 		list_del(&zhdr->buddy);
 		/* Protect zbud page against free */
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-slabc-add-a-helper-function-get_first_slab.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
mm-swapfilec-use-list_nextfirst_entry.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
dma-mapping-use-offset_in_page-macro.patch

