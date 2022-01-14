Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F065C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiANWET (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiANWES (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2DB7B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F37C36AED;
        Fri, 14 Jan 2022 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197856;
        bh=aYIoNvdorZpC3opwE9aCghpmh6cUTrEoy7aFVNrAJg0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kCoKccPFKUMLVrqfCedpE9LvHSTtN6H9suwQ+c24+MVqMepQ6zd3YkZ/jO7gI8gcN
         q7KLqbv2884oy28pRU+Hv3losvhm2AVZP6+ISiF1axpa8uZaIDa6j5oM5S9i0znQmn
         u0y4n3z5jLEdSx0Nrxd4tfYU7Yt0H+PnFrOC+kRY=
Date:   Fri, 14 Jan 2022 14:04:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de,
        jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        willy@infradead.org
Subject:  [patch 026/146] mm/page_alloc: split prep_compound_page
 into head and tail subparts
Message-ID: <20220114220415.Wq5bV9-yy%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/page_alloc: split prep_compound_page into head and tail subparts

Patch series "mm, device-dax: Introduce compound pages in devmap", v7.

This series converts device-dax to use compound pages, and moves away from
the 'struct page per basepage on PMD/PUD' that is done today.  Doing so,
1) unlocks a few noticeable improvements on unpin_user_pages() and makes
device-dax+altmap case 4x times faster in pinning (numbers below and in
last patch) 2) as mentioned in various other threads it's one important
step towards cleaning up ZONE_DEVICE refcounting.

I've split the compound pages on devmap part from the rest based on recent
discussions on devmap pending and future work planned[5][6].  There is
consensus that device-dax should be using compound pages to represent its
PMD/PUDs just like HugeTLB and THP, and that leads to less specialization
of the dax parts.  I will pursue the rest of the work in parallel once
this part is merged, particular the GUP-{slow,fast} improvements [7] and
the tail struct page deduplication memory savings part[8].

To summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-3: Split the current utility function of prep_compound_page()
into head and tail and use those two helpers where appropriate to take
advantage of caches being warm after __init_single_page().  This is used
when initializing zone device when we bring up device-dax namespaces.

Patches 4-10: Add devmap support for compound pages in device-dax. 
memmap_init_zone_device() initialize its metadata as compound pages, and
it introduces a new devmap property known as vmemmap_shift which outlines
how the vmemmap is structured (defaults to base pages as done today).  The
property describe the page order of the metadata essentially.  While at it
do a few cleanups in device-dax in patches 5-9.  Finally enable device-dax
usage of devmap @vmemmap_shift to a value based on its own @align
property.  @vmemmap_shift returns 0 by default (which is today's case of
base pages in devmap, like fsdax or the others) and the usage of compound
devmap is optional.  Starting with device-dax (*not* fsdax) we enable it
by default.  There are a few pinning improvements particular on the
unpinning case and altmap, as well as unpin_user_page_range_dirty_lock()
being just as effective as THP/hugetlb[0] pages.

    $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
    [altmap]
    (pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms
    
     $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
    [altmap with -m 127004]
    (pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

Tested on x86 with 1Tb+ of pmem (alongside registering it with RDMA with
and without altmap), alongside gup_test selftests with dynamic dax regions
and static dax regions.  Coupled with ndctl unit tests for dynamic dax
devices that exercise all of this.  Note, for dynamic dax regions I had to
revert commit 8aa83e6395 ("x86/setup: Call early_reserve_memory()
earlier"), it is a known issue that this commit broke efi_fake_mem=.


This patch (of 11):

Split the utility function prep_compound_page() into head and tail
counterparts, and use them accordingly.

This is in preparation for sharing the storage for compound page
metadata.

Link: https://lkml.kernel.org/r/20211202204422.26777-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20211202204422.26777-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
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
