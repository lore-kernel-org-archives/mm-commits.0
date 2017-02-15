From: akpm@linux-foundation.org
Subject: +
 mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain.patch
 added to -mm tree
Date: Tue, 14 Feb 2017 16:06:58 -0800
Message-ID: <58a39ba2.noFT9oq3yui38OFn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdBOAG7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 19:06:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: remove redundant SetPagePrivate2 in create_page_chain
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Minchan Kim <minchan@kernel.org>
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

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-migration-make-isolate_movable_page-return-int-type.patch
mm-migration-make-isolate_movable_page-return-int-type-v6.patch
mm-migration-make-isolate_movable_page-always-defined.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages.patch
mm-zsmalloc-fix-comment-in-zsmalloc.patch
mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain.patch
mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch

