Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB921C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C186260FC1
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhJGTdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232829AbhJGTdn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:33:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CF9D60F90;
        Thu,  7 Oct 2021 19:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633635109;
        bh=gIQtvNKK7uSookFlIx5Gi/EF4+uR9FC56KpfkzajtGk=;
        h=Date:From:To:Subject:From;
        b=JRQwOw8wYzYo/Ro0llltJf6+Ln1s7owOgBwuqYw6BmuJ8H6nvfO+lo61rRECPunX0
         8PsrxDSoepuwZ0wuayv3tCz55kQ0+LCwVlAXFLPO1xA0q7n7+wwBAUf8IxcPNYku51
         BorcTk1WXK+/6iLGa89RRZCBJGklNODz2/LoRe20=
Date:   Thu, 07 Oct 2021 12:31:49 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-optimise-put_pages_list.patch added to -mm tree
Message-ID: <20211007193149.QtKjBIcKq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimise put_pages_list()
has been added to the -mm tree.  Its filename is
     mm-optimise-put_pages_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-optimise-put_pages_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-optimise-put_pages_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-move-kvmalloc-related-functions-to-slabh.patch
mm-remove-bogus-vm_bug_on.patch
mm-optimise-put_pages_list.patch
kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

