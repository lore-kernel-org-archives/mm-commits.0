Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210F7C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D298F223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgLODPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgLODMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:50 -0500
Date:   Mon, 14 Dec 2020 19:11:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001899;
        bh=E8edMoq1ikhELEaq0Pxaqbl+wR5JtCUaDk7LEIRztYk=;
        h=From:To:Subject:In-Reply-To:From;
        b=PoYvYFsSZukSJz6WAT0GRYkJTniC3fzXq23C/oMNSiqH8SJN6IK9E24kVDs5LmUCS
         7RuzvTGMxTc3jghq+7L8ARpeaTZo1UdwdDDP2iX6wSdZZxQ69SPKUO67c2RB+GIOOS
         eKj8gSfVJijLKxh/IZfhUB0jMe1BBXel8MEMcR1E=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, qcai@redhat.com, torvalds@linux-foundation.org,
        Vbabka@suse.cz
Subject:  [patch 141/200] mm,hwpoison: refactor get_any_page
Message-ID: <20201215031138.UWpWpFspG%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: refactor get_any_page

Patch series "HWPoison: Refactor get page interface", v2.


This patch (of 3):

When we want to grab a refcount via get_any_page, we call __get_any_page
that calls get_hwpoison_page to get the actual refcount.

get_any_page() is only there because we have a sort of retry mechanism in
case the page we met is unknown to us or if we raced with an allocation.

Also __get_any_page() prints some messages about the page type in case the
page was a free page or the page type was unknown, but if anything, we
only need to print a message in case the pagetype was unknown, as that is
reporting an error down the chain.

Let us merge get_any_page() and __get_any_page(), and let the message be
printed in soft_offline_page.  While we are it, we can also remove the
'pfn' parameter as it is no longer used.

Link: https://lkml.kernel.org/r/20201204102558.31607-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20201204102558.31607-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Vlastimil Babka <Vbabka@suse.cz>
Cc: Qian Cai <qcai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   99 +++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 57 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-refactor-get_any_page
+++ a/mm/memory-failure.c
@@ -1707,70 +1707,51 @@ EXPORT_SYMBOL(unpoison_memory);
 
 /*
  * Safely get reference count of an arbitrary page.
- * Returns 0 for a free page, -EIO for a zero refcount page
- * that is not free, and 1 for any other page type.
- * For 1 the page is returned with increased page count, otherwise not.
+ * Returns 0 for a free page, 1 for an in-use page, -EIO for a page-type we
+ * cannot handle and -EBUSY if we raced with an allocation.
+ * We only incremented refcount in case the page was already in-use and it is
+ * a known type we can handle.
  */
-static int __get_any_page(struct page *p, unsigned long pfn, int flags)
+static int get_any_page(struct page *p, int flags)
 {
-	int ret;
+	int ret = 0, pass = 0;
+	bool count_increased = false;
 
 	if (flags & MF_COUNT_INCREASED)
-		return 1;
+		count_increased = true;
 
-	/*
-	 * When the target page is a free hugepage, just remove it
-	 * from free hugepage list.
-	 */
-	if (!get_hwpoison_page(p)) {
-		if (PageHuge(p)) {
-			pr_info("%s: %#lx free huge page\n", __func__, pfn);
-			ret = 0;
-		} else if (is_free_buddy_page(p)) {
-			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
-			ret = 0;
-		} else if (page_count(p)) {
-			/* raced with allocation */
+try_again:
+	if (!count_increased && !get_hwpoison_page(p)) {
+		if (page_count(p)) {
+			/* We raced with an allocation, retry. */
+			if (pass++ < 3)
+				goto try_again;
 			ret = -EBUSY;
-		} else {
-			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
-				__func__, pfn, p->flags);
+		} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
+			/* We raced with put_page, retry. */
+			if (pass++ < 3)
+				goto try_again;
 			ret = -EIO;
 		}
 	} else {
-		/* Not a free page */
-		ret = 1;
-	}
-	return ret;
-}
-
-static int get_any_page(struct page *page, unsigned long pfn, int flags)
-{
-	int ret = __get_any_page(page, pfn, flags);
-
-	if (ret == -EBUSY)
-		ret = __get_any_page(page, pfn, flags);
-
-	if (ret == 1 && !PageHuge(page) &&
-	    !PageLRU(page) && !__PageMovable(page)) {
-		/*
-		 * Try to free it.
-		 */
-		put_page(page);
-		shake_page(page, 1);
-
-		/*
-		 * Did it turn free?
-		 */
-		ret = __get_any_page(page, pfn, 0);
-		if (ret == 1 && !PageLRU(page)) {
-			/* Drop page reference which is from __get_any_page() */
-			put_page(page);
-			pr_info("soft_offline: %#lx: unknown non LRU page type %lx (%pGp)\n",
-				pfn, page->flags, &page->flags);
-			return -EIO;
+		if (PageHuge(p) || PageLRU(p) || __PageMovable(p)) {
+			ret = 1;
+		} else {
+			/*
+			 * A page we cannot handle. Check whether we can turn
+			 * it into something we can handle.
+			 */
+			if (pass++ < 3) {
+				put_page(p);
+				shake_page(p, 1);
+				count_increased = false;
+				goto try_again;
+			}
+			put_page(p);
+			ret = -EIO;
 		}
 	}
+
 	return ret;
 }
 
@@ -1939,7 +1920,7 @@ int soft_offline_page(unsigned long pfn,
 		return -EIO;
 
 	if (PageHWPoison(page)) {
-		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(page);
 		return 0;
@@ -1947,16 +1928,20 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_any_page(page, pfn, flags);
+	ret = get_any_page(page, flags);
 	put_online_mems();
 
-	if (ret > 0)
+	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
-	else if (ret == 0)
+	} else if (ret == 0) {
 		if (soft_offline_free_page(page) && try_again) {
 			try_again = false;
 			goto retry;
 		}
+	} else if (ret == -EIO) {
+		pr_info("%s: %#lx: unknown page type: %lx (%pGP)\n",
+			 __func__, pfn, page->flags, &page->flags);
+	}
 
 	return ret;
 }
_
