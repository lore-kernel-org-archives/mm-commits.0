Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116CEC43460
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E592F6101E
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhEJEh5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhEJEh5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:37:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC26B60720;
        Mon, 10 May 2021 04:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621413;
        bh=x8P+CcJCM60Z1aZT8xG7IKdFNw9wEkkiaJeoJoZcpzQ=;
        h=Date:From:To:Subject:From;
        b=YIVIXgJny5FENFyqRrKkzhblWsueAlu8ZNBL9NAMKoUYLTtz649iaXVrvU8FK707T
         DDeD1hELMxgMDal0QdU/sRiEORv/kl1tKYsLlgW98RAGxHEvwrXqlOfWbgbZP5EHbf
         0kMx15n3eSFAKlZ9Ea2MfvcqihErU/v2BRm86vv4=
Date:   Sun, 09 May 2021 21:36:52 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org
Subject:  + mm-make-compound_head-const-preserving.patch added to
 -mm tree
Message-ID: <20210510043652.i5fJ47hdW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make compound_head const-preserving
has been added to the -mm tree.  Its filename is
     mm-make-compound_head-const-preserving.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-compound_head-const-preserving.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-compound_head-const-preserving.patch

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
Subject: mm: make compound_head const-preserving

If you pass a const pointer to compound_head(), you get a const pointer
back; if you pass a mutable pointer, you get a mutable pointer back.  Also
remove an unnecessary forward definition of struct page; we're about to
dereference page->compound_head, so it must already have been defined.

Link: https://lkml.kernel.org/r/20210416231531.2521383-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/page-flags.h~mm-make-compound_head-const-preserving
+++ a/include/linux/page-flags.h
@@ -177,17 +177,17 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
-struct page;	/* forward declaration */
-
-static inline struct page *compound_head(struct page *page)
+static inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long head = READ_ONCE(page->compound_head);
 
 	if (unlikely(head & 1))
-		return (struct page *) (head - 1);
-	return page;
+		return head - 1;
+	return (unsigned long)page;
 }
 
+#define compound_head(page)	((typeof(page))_compound_head(page))
+
 static __always_inline int PageTail(struct page *page)
 {
 	return READ_ONCE(page->compound_head) & 1;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch

