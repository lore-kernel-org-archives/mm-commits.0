From: akpm@linux-foundation.org
Subject: [patch 083/124] mm/zsmalloc: remove redundant SetPagePrivate2 in
 create_page_chain
Date: Fri, 24 Feb 2017 14:59:42 -0800
Message-ID: <58b0bade.Bq9Hdk3/Z1xuTRaM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdBXW7n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/zsmalloc: remove redundant SetPagePrivate2 in create_page_chain

We had used page->lru to link the component pages (except the first page)
of a zspage, and used INIT_LIST_HEAD(&page->lru) to init it.  Therefore,
to get the last page's next page, which is NULL, we had to use page flag
PG_Private_2 to identify it.

But now, we use page->freelist to link all of the pages in zspage and init
the page->freelist as NULL for last page, so no need to use PG_Private_2
anymore.

This remove redundant SetPagePrivate2 in create_page_chain and
ClearPagePrivate2 in reset_page().  Save a few cycles for migration of
zsmalloc page :)

Link: http://lkml.kernel.org/r/1487076509-49270-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain
+++ a/mm/zsmalloc.c
@@ -24,7 +24,6 @@
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
- *	PG_private2: identifies the last component page
  *	PG_owner_priv_1: identifies the huge component page
  *
  */
@@ -938,7 +937,6 @@ static void reset_page(struct page *page
 {
 	__ClearPageMovable(page);
 	ClearPagePrivate(page);
-	ClearPagePrivate2(page);
 	set_page_private(page, 0);
 	page_mapcount_reset(page);
 	ClearPageHugeObject(page);
@@ -1085,7 +1083,7 @@ static void create_page_chain(struct siz
 	 * 2. each sub-page point to zspage using page->private
 	 *
 	 * we set PG_private to identify the first page (i.e. no other sub-page
-	 * has this flag set) and PG_private_2 to identify the last page.
+	 * has this flag set).
 	 */
 	for (i = 0; i < nr_pages; i++) {
 		page = pages[i];
@@ -1100,8 +1098,6 @@ static void create_page_chain(struct siz
 		} else {
 			prev_page->freelist = page;
 		}
-		if (i == nr_pages - 1)
-			SetPagePrivate2(page);
 		prev_page = page;
 	}
 }
_
