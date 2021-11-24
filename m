Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC8DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhKXVWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243500AbhKXVWM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F385560F5B;
        Wed, 24 Nov 2021 21:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788742;
        bh=xx0toMEElTuY3JASkx29c2Khf0DNqUCANajCTxTuwR8=;
        h=Date:From:To:Subject:From;
        b=eeR1e2TVRhUIJi8uOe7wZIZ37GZ7x1TVKjxY9sVXKxlITgbb6z0D2z6OIWRxwL9YK
         B5ngQFXcAtLtH1TN4/eWrujXoJCmPjcomXwctI7nmQ6N1TMQmygPITcRk8gad1QkLW
         2kX+jxouehM9wM1g1EI+9fDpPjbQNmBFO7fcCTuU=
Date:   Wed, 24 Nov 2021 13:19:01 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
 added to -mm tree
Message-ID: <20211124211901.4cP7KAlep%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: split prep_compound_page into head and tail subparts
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch

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
Subject: mm/page_alloc: split prep_compound_page into head and tail subparts

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for compound page metadata.

Link: https://lkml.kernel.org/r/20211124191005.20783-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts
+++ a/mm/page_alloc.c
@@ -726,23 +726,33 @@ void free_compound_page(struct page *pag
 	free_the_page(page, compound_order(page));
 }
 
+static void prep_compound_head(struct page *page, unsigned int order)
+{
+	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+	set_compound_order(page, order);
+	atomic_set(compound_mapcount_ptr(page), -1);
+	if (hpage_pincount_available(page))
+		atomic_set(compound_pincount_ptr(page), 0);
+}
+
+static void prep_compound_tail(struct page *head, int tail_idx)
+{
+	struct page *p = head + tail_idx;
+
+	p->mapping = TAIL_MAPPING;
+	set_compound_head(p, head);
+}
+
 void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
 	int nr_pages = 1 << order;
 
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
-		p->mapping = TAIL_MAPPING;
-		set_compound_head(p, page);
-	}
+	for (i = 1; i < nr_pages; i++)
+		prep_compound_tail(page, i);
 
-	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
-	set_compound_order(page, order);
-	atomic_set(compound_mapcount_ptr(page), -1);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	prep_compound_head(page, order);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-compound-devmap-support.patch

