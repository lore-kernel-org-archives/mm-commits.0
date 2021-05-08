Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9BEC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D202D613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWlq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWlp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29F761415;
        Sat,  8 May 2021 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513642;
        bh=9NBMVxX2a+Y0e7KikW5g0wqKR/1yABCtjIM2lMeKEMU=;
        h=Date:From:To:Subject:From;
        b=JCGXNfkUtwQmaqL3s+rzM5dWujU4K8Zw3wj0WC7xPjim/AVUN1Rm3iSPY6LxKLjV0
         q8u+PDZ3JkmsJIoMtVFDOiqsoHNnADKdmKowkW2Ia7+j/9M3+6EO+bLzhqQadq2P2X
         3O/KMSdJZd6nkapqT95EpUFa7Z4VimwYaOEvIKeg=
Date:   Sat, 08 May 2021 15:40:42 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-gup-add-compound-page-list-iterator.patch
 removed from -mm tree
Message-ID: <20210508224042.97lCCzH4c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add compound page list iterator
has been removed from the -mm tree.  Its filename was
     mm-gup-add-compound-page-list-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/gup: add compound page list iterator

Patch series "mm/gup: page unpining improvements", v4.

This series improves page unpinning, with an eye on improving MR
deregistration for big swaths of memory (which is bound by the page
unpining), particularly:

1) Decrement the head page by @ntails and thus reducing a lot the
   number of atomic operations per compound page.  This is done by
   comparing individual tail pages heads, and counting number of
   consecutive tails on which they match heads and based on that update
   head page refcount.  Should have a visible improvement in all page
   (un)pinners which use compound pages

2) Introducing a new API for unpinning page ranges (to avoid the trick
   in the previous item and be based on math), and use that in RDMA
   ib_mem_release (used for mr deregistration).

Performance improvements: unpin_user_pages() for hugetlbfs and THP
improves ~3x (through gup_test) and RDMA MR dereg improves ~4.5x with the
new API.  See patches 2 and 4 for those.


This patch (of 4):

Add a helper that iterates over head pages in a list of pages.  It
essentially counts the tails until the next page to process has a
different head that the current.  This is going to be used by
unpin_user_pages() family of functions, to batch the head page refcount
updates once for all passed consecutive tail pages.

Link: https://lkml.kernel.org/r/20210212130843.13865-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20210212130843.13865-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/gup.c~mm-gup-add-compound-page-list-iterator
+++ a/mm/gup.c
@@ -213,6 +213,32 @@ void unpin_user_page(struct page *page)
 }
 EXPORT_SYMBOL(unpin_user_page);
 
+static inline void compound_next(unsigned long i, unsigned long npages,
+				 struct page **list, struct page **head,
+				 unsigned int *ntails)
+{
+	struct page *page;
+	unsigned int nr;
+
+	if (i >= npages)
+		return;
+
+	page = compound_head(list[i]);
+	for (nr = i + 1; nr < npages; nr++) {
+		if (compound_head(list[nr]) != page)
+			break;
+	}
+
+	*head = page;
+	*ntails = nr - i;
+}
+
+#define for_each_compound_head(__i, __list, __npages, __head, __ntails) \
+	for (__i = 0, \
+	     compound_next(__i, __npages, __list, &(__head), &(__ntails)); \
+	     __i < __npages; __i += __ntails, \
+	     compound_next(__i, __npages, __list, &(__head), &(__ntails)))
+
 /**
  * unpin_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
  * @pages:  array of pages to be maybe marked dirty, and definitely released.
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are


