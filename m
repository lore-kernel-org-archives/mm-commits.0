Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348CFC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiEJERx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiEJEQm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B45B2415C6
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0931B81AFE
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA80C385A6;
        Tue, 10 May 2022 04:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155933;
        bh=TcG5uC/09lk7KMy/Hkv3FbDm7XBX10LdUrJyFkb25V8=;
        h=Date:To:From:Subject:From;
        b=PIE4F64mo354PL9/U5dVf8pBXQBocP6vjCyXMLtCGfiki6DIsV2OiICsK7V9eLx26
         OKHNAx7WyHtH4ZR9vjKeSjDFRz8GCRSc4YBtDBVmn0KPvWpuRrBZRKUzYcGQcgQ8CI
         eHIoI7K62esMU1wKW5uPq7V0s9Jp7wBMrgnUZDnU=
Date:   Mon, 09 May 2022 21:12:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.l.verma@intel.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, jgg@ziepe.ca, jane.chu@oracle.com,
        hch@lst.de, dan.j.williams@intel.com, corbet@lwn.net,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch removed from -mm tree
Message-Id: <20220510041213.8DA80C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: reuse tail struct pages for compound devmaps
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/page_alloc: reuse tail struct pages for compound devmaps

Currently memmap_init_zone_device() ends up initializing 32768 pages when
it only needs to initialize 128 given tail page reuse.  That number is
worse with 1GB compound pages, 262144 instead of 128.  Update
memmap_init_zone_device() to skip redundant initialization, detailed
below.

When a pgmap @vmemmap_shift is set, all pages are mapped at a given huge
page alignment and use compound pages to describe them as opposed to a
struct per 4K.

With @vmemmap_shift > 0 and when struct pages are stored in ram (!altmap)
most tail pages are reused.  Consequently, the amount of unique struct
pages is a lot smaller than the total amount of struct pages being mapped.

The altmap path is left alone since it does not support memory savings
based on compound pages devmap.

Link: https://lkml.kernel.org/r/20220420155310.9712-6-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps
+++ a/mm/page_alloc.c
@@ -6596,6 +6596,21 @@ static void __ref __init_zone_device_pag
 	}
 }
 
+/*
+ * With compound page geometry and when struct pages are stored in ram most
+ * tail pages are reused. Consequently, the amount of unique struct pages to
+ * initialize is a lot smaller that the total amount of struct pages being
+ * mapped. This is a paired / mild layering violation with explicit knowledge
+ * of how the sparse_vmemmap internals handle compound pages in the lack
+ * of an altmap. See vmemmap_populate_compound_pages().
+ */
+static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+					      unsigned long nr_pages)
+{
+	return is_power_of_2(sizeof(struct page)) &&
+		!altmap ? 2 * (PAGE_SIZE / sizeof(struct page)) : nr_pages;
+}
+
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -6660,7 +6675,7 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are


