Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73341C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FC9964F45
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhCQXzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCQXym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1171A64F24;
        Wed, 17 Mar 2021 23:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616025282;
        bh=fVEQi6T9kg+nNRFKLt+te4bAbqOIlzUf8tCb8jnLB4M=;
        h=Date:From:To:Subject:From;
        b=R1mK5T2D7a5Qijs72PXChgRyC4oSlH7hwv7Hs4kI+RUubXAdev7rV26CnV3fytT7C
         Gs98/rdPUHpH1ZEnvRyMTrmVfvBLYOgpEJR+2vRpqv8k0qJOQftwFrDOQLBH0bmg3r
         468yj5fzqCkBZxXfEL1sf2i+GI86LJSDftJK9vNw=
Date:   Wed, 17 Mar 2021 16:54:41 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch added to
 -mm tree
Message-ID: <20210317235441.HBYVZsPaf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add a range variant of unpin_user_pages_dirty_lock()
has been added to the -mm tree.  Its filename is
     mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/gup: add a range variant of unpin_user_pages_dirty_lock()

Add an unpin_user_page_range_dirty_lock() API which takes a starting page
and how many consecutive pages we want to unpin and optionally dirty.

To that end, define another iterator for_each_compound_range() that
operates in page ranges as opposed to page array.

For users (like RDMA mr_dereg) where each sg represents a contiguous set
of pages, we're able to more efficiently unpin pages without having to
supply an array of pages much of what happens today with
unpin_user_pages().

Link: https://lkml.kernel.org/r/20210212130843.13865-4-joao.m.martins@oracle.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 mm/gup.c           |   62 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

--- a/include/linux/mm.h~mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock
+++ a/include/linux/mm.h
@@ -1255,6 +1255,8 @@ static inline void put_page(struct page
 void unpin_user_page(struct page *page);
 void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
 				 bool make_dirty);
+void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
+				      bool make_dirty);
 void unpin_user_pages(struct page **pages, unsigned long npages);
 
 /**
--- a/mm/gup.c~mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock
+++ a/mm/gup.c
@@ -213,6 +213,32 @@ void unpin_user_page(struct page *page)
 }
 EXPORT_SYMBOL(unpin_user_page);
 
+static inline void compound_range_next(unsigned long i, unsigned long npages,
+				       struct page **list, struct page **head,
+				       unsigned int *ntails)
+{
+	struct page *next, *page;
+	unsigned int nr = 1;
+
+	if (i >= npages)
+		return;
+
+	next = *list + i;
+	page = compound_head(next);
+	if (PageCompound(page) && compound_order(page) >= 1)
+		nr = min_t(unsigned int,
+			   page + compound_nr(page) - next, npages - i);
+
+	*head = page;
+	*ntails = nr;
+}
+
+#define for_each_compound_range(__i, __list, __npages, __head, __ntails) \
+	for (__i = 0, \
+	     compound_range_next(__i, __npages, __list, &(__head), &(__ntails)); \
+	     __i < __npages; __i += __ntails, \
+	     compound_range_next(__i, __npages, __list, &(__head), &(__ntails)))
+
 static inline void compound_next(unsigned long i, unsigned long npages,
 				 struct page **list, struct page **head,
 				 unsigned int *ntails)
@@ -302,6 +328,42 @@ void unpin_user_pages_dirty_lock(struct
 EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
 
 /**
+ * unpin_user_page_range_dirty_lock() - release and optionally dirty
+ * gup-pinned page range
+ *
+ * @page:  the starting page of a range maybe marked dirty, and definitely released.
+ * @npages: number of consecutive pages to release.
+ * @make_dirty: whether to mark the pages dirty
+ *
+ * "gup-pinned page range" refers to a range of pages that has had one of the
+ * pin_user_pages() variants called on that page.
+ *
+ * For the page ranges defined by [page .. page+npages], make that range (or
+ * its head pages, if a compound page) dirty, if @make_dirty is true, and if the
+ * page range was previously listed as clean.
+ *
+ * set_page_dirty_lock() is used internally. If instead, set_page_dirty() is
+ * required, then the caller should a) verify that this is really correct,
+ * because _lock() is usually required, and b) hand code it:
+ * set_page_dirty_lock(), unpin_user_page().
+ *
+ */
+void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
+				      bool make_dirty)
+{
+	unsigned long index;
+	struct page *head;
+	unsigned int ntails;
+
+	for_each_compound_range(index, &page, npages, head, ntails) {
+		if (make_dirty && !PageDirty(head))
+			set_page_dirty_lock(head);
+		put_compound_head(head, ntails, FOLL_PIN);
+	}
+}
+EXPORT_SYMBOL(unpin_user_page_range_dirty_lock);
+
+/**
  * unpin_user_pages() - release an array of gup-pinned pages.
  * @pages:  array of pages to be marked dirty and released.
  * @npages: number of pages in the @pages array.
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-gup-add-compound-page-list-iterator.patch
mm-gup-decrement-head-page-once-for-group-of-subpages.patch
mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch
rdma-umem-batch-page-unpin-in-__ib_umem_release.patch

