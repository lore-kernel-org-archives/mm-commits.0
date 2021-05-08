Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85C7C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC4D6140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWlx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhEHWlw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF1561415;
        Sat,  8 May 2021 22:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513649;
        bh=MmrjIC9DYwhdQOWrqjPNaS81Vme/c8P10yOsJ6BC/Pg=;
        h=Date:From:To:Subject:From;
        b=uzMvhgb6u0rDfcmlxiD/Qp0ROQfncnQqrH/ubRhs/MhdZqvq9ZsafwU6ZPVXyVf8Z
         3AFbvS5Yo3i67Ljrp8U1egH4uUhCDzMrsRYSXP/boX/D1rtOsj7eUAnqQBkykX55yF
         poOiviNT1ThgTdWwARLFh2iqgotrQOYaWzTI1axA=
Date:   Sat, 08 May 2021 15:40:49 -0700
From:   akpm@linux-foundation.org
To:     dledford@redhat.com, hch@infradead.org, jgg@nvidia.com,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 rdma-umem-batch-page-unpin-in-__ib_umem_release.patch removed from -mm tree
Message-ID: <20210508224049.2VefNozQN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: RDMA/umem: batch page unpin in __ib_umem_release()
has been removed from the -mm tree.  Its filename was
     rdma-umem-batch-page-unpin-in-__ib_umem_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


