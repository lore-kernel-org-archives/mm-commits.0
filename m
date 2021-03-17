Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1ADC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC0E64F40
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCQXzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhCQXyp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E60D264F2B;
        Wed, 17 Mar 2021 23:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616025285;
        bh=1h6sXhDpeGv1gQDk/S9pHnkekR5mmv2GfeeMvtbt0Ww=;
        h=Date:From:To:Subject:From;
        b=DwHksHJ86s6o/PfwqeXRPSeWe2P/PePHsuoc0GrOypFrbll6PeuVjwSuwgf00nS1S
         wQzKRKPwSMb06/C2hyZBEAncbx8hZjv7lEMwXRa7NwbvISWoCP5RaL4lv9geQW6Rfq
         92d6BvkLtmZVe+bAS2/xU/jhWYV8Z4jG1FzpLxPs=
Date:   Wed, 17 Mar 2021 16:54:44 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + rdma-umem-batch-page-unpin-in-__ib_umem_release.patch
 added to -mm tree
Message-ID: <20210317235444.Prv5DLPon%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/umem: batch page unpin in __ib_umem_release()
has been added to the -mm tree.  Its filename is
     rdma-umem-batch-page-unpin-in-__ib_umem_release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rdma-umem-batch-page-unpin-in-__ib_umem_release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rdma-umem-batch-page-unpin-in-__ib_umem_release.patch

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
Subject: RDMA/umem: batch page unpin in __ib_umem_release()

Use the newly added unpin_user_page_range_dirty_lock() for more quickly
unpinning a consecutive range of pages represented as compound pages. 
This will also calculate number of pages to unpin (for the tail pages
which matching head page) and thus batch the refcount update.

Running a test program which calls memory range reg/unreg on a region 1G
in size and measures cost of both operations together (in a guest using
rxe) with THP and hugetlbfs:

Before:
590 rounds in 5.003 sec: 8480.335 usec / round
6898 rounds in 60.001 sec: 8698.367 usec / round

After:
2688 rounds in 5.002 sec: 1860.786 usec / round
32517 rounds in 60.001 sec: 1845.225 usec / round

Link: https://lkml.kernel.org/r/20210212130843.13865-5-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/core/umem.c~rdma-umem-batch-page-unpin-in-__ib_umem_release
+++ a/drivers/infiniband/core/umem.c
@@ -47,17 +47,17 @@
 
 static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int dirty)
 {
-	struct sg_page_iter sg_iter;
-	struct page *page;
+	bool make_dirty = umem->writable && dirty;
+	struct scatterlist *sg;
+	unsigned int i;
 
 	if (umem->nmap > 0)
 		ib_dma_unmap_sg(dev, umem->sg_head.sgl, umem->sg_nents,
 				DMA_BIDIRECTIONAL);
 
-	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
-		page = sg_page_iter_page(&sg_iter);
-		unpin_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
-	}
+	for_each_sg(umem->sg_head.sgl, sg, umem->sg_nents, i)
+		unpin_user_page_range_dirty_lock(sg_page(sg),
+			DIV_ROUND_UP(sg->length, PAGE_SIZE), make_dirty);
 
 	sg_free_table(&umem->sg_head);
 }
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-gup-add-compound-page-list-iterator.patch
mm-gup-decrement-head-page-once-for-group-of-subpages.patch
mm-gup-add-a-range-variant-of-unpin_user_pages_dirty_lock.patch
rdma-umem-batch-page-unpin-in-__ib_umem_release.patch

