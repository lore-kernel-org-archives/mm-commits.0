Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E40C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CECA6101E
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhEJEhy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhEJEhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF356105A;
        Mon, 10 May 2021 04:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621409;
        bh=dhcezN09DCEe9eAGmBC7HuSBDux0/9ytllyLWEe6LPE=;
        h=Date:From:To:Subject:From;
        b=EyGU5lqhBEyXpZXPLjR5jKqI5Aj+1Pm0dSKxvtdMMOSyn/j2I9Ve2WMq34466XvTD
         zUD1iCFtoheVP7nEuCFc5OAlCWDZHHm9n9bNv8IfqxibquYUH/2+bNw9QbVlkYk0vQ
         2rnEOODuRUHjbQlOs4iZbhyHyJxHpT3QH1Y577HU=
Date:   Sun, 09 May 2021 21:36:48 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org
Subject:  + mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
 added to -mm tree
Message-ID: <20210510043648.uYqnMdiew%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: factor PagePoisoned out of __dump_page
has been added to the -mm tree.  Its filename is
     mm-debug-factor-pagepoisoned-out-of-__dump_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-factor-pagepoisoned-out-of-__dump_page.patch

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

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch

