Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DD6C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665576141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhEHWlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhEHWlu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7684B6140E;
        Sat,  8 May 2021 22:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513647;
        bh=cHpL7bho19UQTNX/XGyGDK+6MRu67C1WLxZBLCzZ7ts=;
        h=Date:From:To:Subject:From;
        b=FzsQKmrato9CKdGLUEKLL/fRD07ZcwK16OdubcAYj+97Qjo5/PqGEJ6AmH3VwZk4H
         oyfe4PHH6/PRLf1/56NXHr3Hn5cgZEzmzY8uoGCNc04rkmAZBpdSZq2ftONrwegOTf
         Y2Iw55qirgI92Keh/JIb6p0Qcs77g5oKjOnvxmco=
Date:   Sat, 08 May 2021 15:40:47 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch removed
 from -mm tree
Message-ID: <20210508224047.hNb2G_zaL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: add a range variant of unpin_user_pages_dirty_lock()
has been removed from the -mm tree.  Its filename was
     mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1265,6 +1265,8 @@ static inline void put_page(struct page
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


