From: akpm@linux-foundation.org
Subject: + zsmalloc-partial-page-ordering-within-a-fullness_list.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 16:17:21 -0700
Message-ID: <559f0101.Jehou1Ba8dS52YCf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbGIXRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 19:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: partial page ordering within a fullness_list
has been added to the -mm tree.  Its filename is
     zsmalloc-partial-page-ordering-within-a-fullness_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-partial-page-ordering-within-a-fullness_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-partial-page-ordering-within-a-fullness_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: partial page ordering within a fullness_list

We want to see more ZS_FULL pages and less ZS_ALMOST_{FULL, EMPTY} pages. 
Put a page with higher ->inuse count first within its ->fullness_list,
which will give us better chances to fill up this page with new objects
(find_get_zspage() return ->fullness_list head for new object allocation),
so some zspages will become ZS_ALMOST_FULL/ZS_FULL quicker.

It performs a trivial and cheap ->inuse compare which does not slow down
zsmalloc and in the worst case keeps the list pages in no particular
order.

A more expensive solution could sort fullness_list by ->inuse count.

[minchan@kernel.org: code adjustments]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-partial-page-ordering-within-a-fullness_list mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-partial-page-ordering-within-a-fullness_list
+++ a/mm/zsmalloc.c
@@ -643,13 +643,22 @@ static void insert_zspage(struct page *p
 	if (fullness >= _ZS_NR_FULLNESS_GROUPS)
 		return;
 
-	head = &class->fullness_list[fullness];
-	if (*head)
-		list_add_tail(&page->lru, &(*head)->lru);
-
-	*head = page;
 	zs_stat_inc(class, fullness == ZS_ALMOST_EMPTY ?
 			CLASS_ALMOST_EMPTY : CLASS_ALMOST_FULL, 1);
+
+	head = &class->fullness_list[fullness];
+	if (!*head) {
+		*head = page;
+		return;
+	}
+
+	/*
+	 * We want to see more ZS_FULL pages and less almost
+	 * empty/full. Put pages with higher ->inuse first.
+	 */
+	list_add_tail(&page->lru, &(*head)->lru);
+	if (page->inuse >= (*head)->inuse)
+		*head = page;
 }
 
 /*
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch

