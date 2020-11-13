Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CAEC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CBA221E9
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQ10I9yt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgKMAfJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAfJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:35:09 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C467620B80;
        Fri, 13 Nov 2020 00:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605227708;
        bh=gu3RbFtyB3NxSBy884efeaP9oTe2mmtoY1JNPreVshM=;
        h=Date:From:To:Subject:From;
        b=MQ10I9ytH+EseJM4G9sT+MdrRjA2fybPNHhkw4wVWZVK3RRfs+Dl+29mc0v02FyTl
         vY5droNuF4ZeuMULn0mX5kc+kDEtI7mlPfYoHi1mXrBDE9qW+EbLiW/GDqaax13ncJ
         zMp+wYFx0qcGXQFnuGzXnvvYnzLIcAKWmHrvORMg=
Date:   Thu, 12 Nov 2020 16:35:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  + mm-page_alloc-add-__free_pages-documentation.patch
 added to -mm tree
Message-ID: <20201113003507.XkduR-qof%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add __free_pages() documentation
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-__free_pages-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-__free_pages-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-__free_pages-documentation.patch

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
Subject: mm/page_alloc: add __free_pages() documentation

Provide some guidance towards when this might not be the right interface
to use.

Link: https://lkml.kernel.org/r/20201027025523.3235-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-__free_pages-documentation
+++ a/mm/page_alloc.c
@@ -5034,6 +5034,26 @@ static inline void free_the_page(struct
 		__free_pages_ok(page, order, FPI_NONE);
 }
 
+/**
+ * __free_pages - Free pages allocated with alloc_pages().
+ * @page: The page pointer returned from alloc_pages().
+ * @order: The order of the allocation.
+ *
+ * This function can free multi-page allocations that are not compound
+ * pages.  It does not check that the @order passed in matches that of
+ * the allocation, so it is easy to leak memory.  Freeing more memory
+ * than was allocated will probably emit a warning.
+ *
+ * If the last reference to this page is speculative, it will be released
+ * by put_page() which only frees the first page of a non-compound
+ * allocation.  To prevent the remaining pages from being leaked, we free
+ * the subsequent pages here.  If you want to use the page's reference
+ * count to decide when to free the allocation, you should allocate a
+ * compound page, and use put_page() instead of __free_pages().
+ *
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
 void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page))
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch

