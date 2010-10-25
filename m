From: akpm@linux-foundation.org
Subject: + mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:40:07 -0700
Message-ID: <201010252140.o9PLe7Dg017823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784Ab0JYVkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: page_isolation: codeclean fix comment and rm unneeded val init
has been added to the -mm tree.  Its filename is
     mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init.patch

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
Subject: mm: page_isolation: codeclean fix comment and rm unneeded val init
From: Bob Liu <lliubbo@gmail.com>

__test_page_isolated_in_pageblock() returns 1 if all pages in the range
are isolated, so fix the comment.  Variable `pfn' will be initialised in
the following loop so remove it.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init
+++ a/mm/page_isolation.c
@@ -86,7 +86,7 @@ undo_isolate_page_range(unsigned long st
  * all pages in [start_pfn...end_pfn) must be in the same zone.
  * zone->lock must be held before call this.
  *
- * Returns 0 if all pages in the range is isolated.
+ * Returns 1 if all pages in the range is isolated.
  */
 static int
 __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
@@ -119,7 +119,6 @@ int test_pages_isolated(unsigned long st
 	struct zone *zone;
 	int ret;
 
-	pfn = start_pfn;
 	/*
 	 * Note: pageblock_nr_page != MAX_ORDER. Then, chunks of free page
 	 * is not aligned to pageblock_nr_pages.
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch
mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init.patch
mm-do_migrate_range-exit-loop-if-not_managed-is-true.patch
mm-do_migrate_range-reduce-list_empty-check.patch

