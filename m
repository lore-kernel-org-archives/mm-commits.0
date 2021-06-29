Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BA4C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1057F61D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhF2Cnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2Cnx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BCB261D0C;
        Tue, 29 Jun 2021 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934486;
        bh=z+oAVVjlGIwkhmpFvRmzGVnC4giyS+xOs219fpV1yvo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Eq5p78vPU9nkaorjIF0eKvRNbUmD96X0xfUVJQgx1BC2s9/+KEFfARaqIespN/R6m
         DhXpYHkNcdoNB74/ByEjGwHXCdPYGC5V9eq2kz0Wqe7vemSY5K9z6vR42xCUR9/mPV
         vhsjpuz5P4MLRTwsC6ZrsZFkegQmn98yATP7HmEA=
Date:   Mon, 28 Jun 2021 19:41:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 156/192] mm: constify page_count and
 page_ref_count
Message-ID: <20210629024125.8tPyrqCyS%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify page_count and page_ref_count

Now that compound_head() accepts a const struct page pointer, these two
functions can be marked as not modifying the page pointer they are passed.

Link: https://lkml.kernel.org/r/20210416231531.2521383-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page_ref.h~mm-constify-page_count-and-page_ref_count
+++ a/include/linux/page_ref.h
@@ -62,12 +62,12 @@ static inline void __page_ref_unfreeze(s
 
 #endif
 
-static inline int page_ref_count(struct page *page)
+static inline int page_ref_count(const struct page *page)
 {
 	return atomic_read(&page->_refcount);
 }
 
-static inline int page_count(struct page *page)
+static inline int page_count(const struct page *page)
 {
 	return atomic_read(&compound_head(page)->_refcount);
 }
_
