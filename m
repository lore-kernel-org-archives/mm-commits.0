Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2728C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382621AbiDTVog (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382636AbiDTVo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A94488AB
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA72D6197E
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E924C385A0;
        Wed, 20 Apr 2022 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650490886;
        bh=W/TjYqFsKEmIa3B/TJEcPNVu5H56Jy0lSf20HbSnBJ4=;
        h=Date:To:From:Subject:From;
        b=LoO/jq8AboSPLERJMa65xjl4ck31SimVFs67Xq38b4S2PVMt0J5eiHEco0HgOQJb7
         fnuuMu5CCrCWFGFR+YSjOqkauX/nHxXDBxWRIaMGjLq0e28Fv7P/qLP5U2PQgA2U67
         Q6A0sH/gHGCPbhSaU3ZW8anPx1axp+klF40x/Qm0=
Date:   Wed, 20 Apr 2022 14:41:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.l.verma@intel.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, jgg@ziepe.ca, jane.chu@oracle.com,
        hch@lst.de, dan.j.williams@intel.com, corbet@lwn.net,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch added to -mm tree
Message-Id: <20220420214126.0E924C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: reuse tail struct pages for compound devmaps
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

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
@@ -6588,6 +6588,21 @@ static void __ref __init_zone_device_pag
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
@@ -6652,7 +6667,7 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     pfns_per_compound);
+				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch
mm-sparse-vmemmap-refactor-core-of-vmemmap_populate_basepages-to-helper.patch
mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch
mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch
mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

