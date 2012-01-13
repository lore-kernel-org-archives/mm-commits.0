From: akpm@linux-foundation.org
Subject: [merged] mm-no-blank-line-after-export_symbol-in-swapc.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:50 -0800
Message-ID: <20120113203550.A598810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56060 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086Ab2AMUfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:51 -0500
Received: by yenl1 with SMTP id l1so72336yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: no blank line after EXPORT_SYMBOL in swap.c
has been removed from the -mm tree.  Its filename was
     mm-no-blank-line-after-export_symbol-in-swapc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: no blank line after EXPORT_SYMBOL in swap.c

checkpatch rightly protests
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
so fix the five offenders in mm/swap.c.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/swap.c~mm-no-blank-line-after-export_symbol-in-swapc mm/swap.c
--- a/mm/swap.c~mm-no-blank-line-after-export_symbol-in-swapc
+++ a/mm/swap.c
@@ -369,7 +369,6 @@ void mark_page_accessed(struct page *pag
 		SetPageReferenced(page);
 	}
 }
-
 EXPORT_SYMBOL(mark_page_accessed);
 
 void __lru_cache_add(struct page *page, enum lru_list lru)
@@ -646,7 +645,6 @@ void __pagevec_release(struct pagevec *p
 	release_pages(pvec->pages, pagevec_count(pvec), pvec->cold);
 	pagevec_reinit(pvec);
 }
-
 EXPORT_SYMBOL(__pagevec_release);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -726,7 +724,6 @@ void __pagevec_lru_add(struct pagevec *p
 
 	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, (void *)lru);
 }
-
 EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
@@ -751,7 +748,6 @@ unsigned pagevec_lookup(struct pagevec *
 	pvec->nr = find_get_pages(mapping, start, nr_pages, pvec->pages);
 	return pagevec_count(pvec);
 }
-
 EXPORT_SYMBOL(pagevec_lookup);
 
 unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
@@ -761,7 +757,6 @@ unsigned pagevec_lookup_tag(struct pagev
 					nr_pages, pvec->pages);
 	return pagevec_count(pvec);
 }
