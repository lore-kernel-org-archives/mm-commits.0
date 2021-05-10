Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9E9C43460
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90EF66108B
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhEJEiB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhEJEiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB5360720;
        Mon, 10 May 2021 04:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621417;
        bh=keRSPVWMvzpgy0eBHx7OI3PT2QFxlYlrgK6ISnNkiDc=;
        h=Date:From:To:Subject:From;
        b=B2nFdMkXeqC+tdRMmmVAqBPQoXyFx1Znxsgdc/usKxi90Y7Oennf3PRGUBUDqEaZD
         wjtUVL2fzOQAu61InxvYYk64yU+9aVLVRn7Czqie9FwtNgjqsJaK0IfRRh2+pC0LuE
         gRZQyoNDXebkFfB37arWNLFR7eA/bq8DL4jS9Tg8=
Date:   Sun, 09 May 2021 21:36:56 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org
Subject:  + mm-constify-page_count-and-page_ref_count.patch added
 to -mm tree
Message-ID: <20210510043656.fxh_N4AOV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: constify page_count and page_ref_count
has been added to the -mm tree.  Its filename is
     mm-constify-page_count-and-page_ref_count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-constify-page_count-and-page_ref_count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-constify-page_count-and-page_ref_count.patch

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

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch

