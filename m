Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFEEC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E829A223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgLODGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgLODGL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:11 -0500
Date:   Mon, 14 Dec 2020 19:05:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001556;
        bh=Vpvc8JTQpQJHqfNcnhpmoMK3594F1lsIOGkHmHPsT7s=;
        h=From:To:Subject:In-Reply-To:From;
        b=FuUllS0/DvrJSbfrCV7otP1fxmxu1V0EmP3HWnw+XwfTcd9muThAGb1RhYxgyN9Fb
         fnP7ZgcUbGaPMzN4vjNFvwF7en/shlo7cG30RRt3L/6A9wIfUhGY1jbJODQbSMp6/p
         SpoAKLuEii3gx5zckILGk6AjN5H6mpQQN3jluFck=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        dan.j.williams@intel.com, hch@lst.de, jgg@nvidia.com,
        jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 047/200] mm: handle zone device pages in
 release_pages()
Message-ID: <20201215030555.QvhJGD0Lz%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: handle zone device pages in release_pages()

release_pages() is an optimized, inlined version of __put_pages() except
that zone device struct pages that are not page_is_devmap_managed() (i.e.,
memory_type MEMORY_DEVICE_GENERIC and MEMORY_DEVICE_PCI_P2PDMA), fall
through to the code that could return the zone device page to the page
allocator instead of adjusting the pgmap reference count.

Clearly these type of pages are not having the reference count decremented
to zero via release_pages() or page allocation problems would be seen. 
Just to be safe, handle the 1 to zero case in release_pages() like
__put_page() does.

Link: https://lkml.kernel.org/r/20201021194733.11530-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swap.c~mm-handle-zone-device-pages-in-release_pages
+++ a/mm/swap.c
@@ -909,6 +909,9 @@ void release_pages(struct page **pages,
 				put_devmap_managed_page(page);
 				continue;
 			}
+			if (put_page_testzero(page))
+				put_dev_pagemap(page->pgmap);
+			continue;
 		}
 
 		if (!put_page_testzero(page))
_
