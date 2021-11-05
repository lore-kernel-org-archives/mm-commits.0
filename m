Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3870DC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B9F60E8B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhKEUkG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A198660720;
        Fri,  5 Nov 2021 20:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144645;
        bh=u5mzoQR1SMHgiWq/xg3HGEOJS7HcxmR+enVcKc0Kw/8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kBetjkGavmlqCGCyVOKn3pixXc+otSmLhaBs/euDoeeSwkwB/JUtMdWcYUDXVDXZy
         bYjWV2xQXYzDyY9wtcoFPXVFjNFfNVyWkrsICOGa6IomUyl2R8zHNm9NdrtS0pUZ74
         +rOKiVr8eZv/vJCsRwCp2jsVLGDAmFAsHf3IngnE=
Date:   Fri, 05 Nov 2021 13:37:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anthony.yznaga@oracle.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 053/262] mm: optimise put_pages_list()
Message-ID: <20211105203725.zKys-1BiC%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
