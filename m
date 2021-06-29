Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B44AC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C5261D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhF2Cnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2Cnl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3762C61D0D;
        Tue, 29 Jun 2021 02:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934474;
        bh=G4KBF3ZopxSlzA/A1K6xaKzERv1BmB6h/9H/TEDOboc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E6527QNXeKryZHrj57k7kvsIaHzK5thKuXEVapK1pwPH8hn6IhvpQ5rvRlWiqLhlX
         TYpOWyVjyCyrEj41HPAHBHEyPYsr4xGB5wgSZnaf7mMDF+frjorR1BtSVnnGnT+Tnh
         A+E7EVKkXpl8cQ6vZgXe6QW4qrIJejdaQm28WTy4=
Date:   Mon, 28 Jun 2021 19:41:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 152/192] mm/debug: factor PagePoisoned out of
 __dump_page
Message-ID: <20210629024113.AE7B5dMlb%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: factor PagePoisoned out of __dump_page

Move the PagePoisoned test into dump_page().  Skip the hex print for
poisoned pages -- we know they're full of ffffffff.  Move the reason
printing from __dump_page() to dump_page().

Link: https://lkml.kernel.org/r/20210416231531.2521383-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/mm/debug.c~mm-debug-factor-pagepoisoned-out-of-__dump_page
+++ a/mm/debug.c
@@ -42,11 +42,10 @@ const struct trace_print_flags vmaflag_n
 	{0, NULL}
 };
 
-static void __dump_page(struct page *page, const char *reason)
+static void __dump_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 	struct address_space *mapping;
-	bool page_poisoned = PagePoisoned(page);
 	bool compound = PageCompound(page);
 	/*
 	 * Accessing the pageblock without the zone lock. It could change to
@@ -58,16 +57,6 @@ static void __dump_page(struct page *pag
 	int mapcount;
 	char *type = "";
 
-	/*
-	 * If struct page is poisoned don't access Page*() functions as that
-	 * leads to recursive loop. Page*() check for poisoned pages, and calls
-	 * dump_page() when detected.
-	 */
-	if (page_poisoned) {
-		pr_warn("page:%px is uninitialized and poisoned", page);
-		goto hex_only;
-	}
-
 	if (page < head || (page >= head + MAX_ORDER_NR_PAGES)) {
 		/*
 		 * Corrupt page, so we cannot call page_mapping. Instead, do a
@@ -173,8 +162,6 @@ out_mapping:
 
 	pr_warn("%sflags: %#lx(%pGp)%s\n", type, head->flags, &head->flags,
 		page_cma ? " CMA" : "");
-
-hex_only:
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
 			sizeof(struct page), false);
@@ -182,14 +169,16 @@ hex_only:
 		print_hex_dump(KERN_WARNING, "head: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), head,
 			sizeof(struct page), false);
-
-	if (reason)
-		pr_warn("page dumped because: %s\n", reason);
 }
 
 void dump_page(struct page *page, const char *reason)
 {
-	__dump_page(page, reason);
+	if (PagePoisoned(page))
+		pr_warn("page:%p is uninitialized and poisoned", page);
+	else
+		__dump_page(page);
+	if (reason)
+		pr_warn("page dumped because: %s\n", reason);
 	dump_page_owner(page);
 }
 EXPORT_SYMBOL(dump_page);
_
