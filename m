Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDA4C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474E261D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhF2Cnr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2Cnq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C804611AE;
        Tue, 29 Jun 2021 02:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934480;
        bh=cmEO5iBmc5ITQEdAIhCVo7vS5Kn/MdhwbnzBA6MwwqI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rvhM5Crljtrs/0arq41xpTX1BmDct3lWCqS156ySdhy2WpB9iR/95dhAGD+60C97n
         1GFKA0dNOQRanuzyeeN+wXS4+WcIxQDam1z8QW9XGGElDbp3Lx/6WpTOqvEmuaFoNm
         rtcuu343UpX0CjIijNFKiJ08WjtbOTFwXdBfsLA4=
Date:   Mon, 28 Jun 2021 19:41:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 154/192] mm: make compound_head const-preserving
Message-ID: <20210629024119.KP64mnhwd%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
