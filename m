From: akpm@osdl.org
Subject: - read_cache_pages-cleanup.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:10 -0800
Message-ID: <200612072303.kB7N3Anv029941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163813AbWLGXDN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     read_cache_pages() cleanup
has been removed from the -mm tree.  Its filename was
     read_cache_pages-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: read_cache_pages() cleanup
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Use put_pages_list() instead of opencoding it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN mm/readahead.c~read_cache_pages-cleanup mm/readahead.c
--- a/mm/readahead.c~read_cache_pages-cleanup
+++ a/mm/readahead.c
@@ -148,13 +148,7 @@ int read_cache_pages(struct address_spac
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add(&lru_pvec);
 		if (ret) {
-			while (!list_empty(pages)) {
-				struct page *victim;
-
-				victim = list_to_page(pages);
-				list_del(&victim->lru);
-				page_cache_release(victim);
-			}
+			put_pages_list(pages);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fs-fix-cont-vs-deadlock-patches.patch

