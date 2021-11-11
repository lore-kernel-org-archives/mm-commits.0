Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A20C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C5C61284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhKKCoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234005AbhKKCoh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 910A961872;
        Thu, 11 Nov 2021 02:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598508;
        bh=FIjMYS36gtTabmGAtpTpk+0WdKb+yOEvHRASAVFxav4=;
        h=Date:From:To:Subject:From;
        b=riHIduZCe+FIZbbuZM+MpdqtOloVK9uHcSzxCybcwLR/M8OPalU2Ut4IoB5YD66if
         Zq/W5WXktLXMl/V+Y9bEJYIJCXon1DKqQgDysOhP7K/kylZSE4byyWfARuGpzb2Tr3
         n+FGIaGxfArMj84VT8oqoMxuRqJuiqp9dbiROZt0=
Date:   Wed, 10 Nov 2021 18:41:48 -0800
From:   akpm@linux-foundation.org
To:     anthony.yznaga@oracle.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-optimise-put_pages_list.patch removed from
 -mm tree
Message-ID: <20211111024148.IK5D_dXpr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimise put_pages_list()
has been removed from the -mm tree.  Its filename was
     mm-optimise-put_pages_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: optimise put_pages_list()

Instead of calling put_page() one page at a time, pop pages off the list
if their refcount was too high and pass the remainder to
put_unref_page_list().  This should be a speed improvement, but I have no
measurements to support that.  Current callers do not care about
performance, but I hope to add some which do.

Link: https://lkml.kernel.org/r/20211007192138.561673-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-optimise-put_pages_list
+++ a/mm/swap.c
@@ -134,18 +134,27 @@ EXPORT_SYMBOL(__put_page);
  * put_pages_list() - release a list of pages
  * @pages: list of pages threaded on page->lru
  *
- * Release a list of pages which are strung together on page.lru.  Currently
- * used by read_cache_pages() and related error recovery code.
+ * Release a list of pages which are strung together on page.lru.
  */
 void put_pages_list(struct list_head *pages)
 {
-	while (!list_empty(pages)) {
-		struct page *victim;
+	struct page *page, *next;
 
-		victim = lru_to_page(pages);
-		list_del(&victim->lru);
-		put_page(victim);
+	list_for_each_entry_safe(page, next, pages, lru) {
+		if (!put_page_testzero(page)) {
+			list_del(&page->lru);
+			continue;
+		}
+		if (PageHead(page)) {
+			list_del(&page->lru);
+			__put_compound_page(page);
+			continue;
+		}
+		/* Cannot be PageLRU because it's passed to us using the lru */
+		__ClearPageWaiters(page);
 	}
+
+	free_unref_page_list(pages);
 }
 EXPORT_SYMBOL(put_pages_list);
 
_

Patches currently in -mm which might be from willy@infradead.org are

hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

