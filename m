Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997AEC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6BC2063A
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529566;
	bh=atWj1s3AaQIvM+CfnbhCRtapJx17HPQVSzXzeyu+MhM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RgGyvgv76EbULjoCKFsdhTU3D8W69g9E/70YiL5lCOz3JafDWXrKnCJRPTeH27Ig6
	 evfTNP0gVR14z98At7ENsBuwUk/EfPsCke61UVpcvtoFywhvu2Q8H4i7gYRjoZ8yYV
	 l1KSW03jPMnBfBRQ5KMg0c11CaVw09obpJE/xowU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgHOWK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgHOWKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1824920774;
        Sat, 15 Aug 2020 00:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451424;
        bh=atWj1s3AaQIvM+CfnbhCRtapJx17HPQVSzXzeyu+MhM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z6cYPBmzf7JApweVs88eAgJEJCBSVB061UM1Q5gtGEyNgecpY6/aogBYB6Jud2cUa
         RlUxuX0xFtJQvtXFt8tv/5+Fsevb8EYIfp0CiGtaYXIfGETWwrXuTATzNu4Utzx7fE
         i8AC78yno0zeISd7EffQMGSrw3fTlAtDwvzk4BVM=
Date:   Fri, 14 Aug 2020 17:30:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 07/39] mm: store compound_nr as well as
 compound_order
Message-ID: <20200815003023.62xy4KMOu%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: store compound_nr as well as compound_order

Patch series "THP prep patches".

These are some generic cleanups and improvements, which I would like
merged into mmotm soon.  The first one should be a performance improvement
for all users of compound pages, and the others are aimed at getting code
to compile away when CONFIG_TRANSPARENT_HUGEPAGE is disabled (ie small
systems).  Also better documented / less confusing than the current prefix
mixture of compound, hpage and thp.


This patch (of 7):

This removes a few instructions from functions which need to know how many
pages are in a compound page.  The storage used is either page->mapping on
64-bit or page->index on 32-bit.  Both of these are fine to overlay on
tail pages.

Link: http://lkml.kernel.org/r/20200629151959.15779-1-willy@infradead.org
Link: http://lkml.kernel.org/r/20200629151959.15779-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    5 ++++-
 include/linux/mm_types.h |    1 +
 mm/page_alloc.c          |    5 +++--
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-store-compound_nr-as-well-as-compound_order
+++ a/include/linux/mm.h
@@ -922,12 +922,15 @@ static inline int compound_pincount(stru
 static inline void set_compound_order(struct page *page, unsigned int order)
 {
 	page[1].compound_order = order;
+	page[1].compound_nr = 1U << order;
 }
 
 /* Returns the number of pages in this potentially compound page. */
 static inline unsigned long compound_nr(struct page *page)
 {
-	return 1UL << compound_order(page);
+	if (!PageHead(page))
+		return 1;
+	return page[1].compound_nr;
 }
 
 /* Returns the number of bytes in this potentially compound page. */
--- a/include/linux/mm_types.h~mm-store-compound_nr-as-well-as-compound_order
+++ a/include/linux/mm_types.h
@@ -134,6 +134,7 @@ struct page {
 			unsigned char compound_dtor;
 			unsigned char compound_order;
 			atomic_t compound_mapcount;
+			unsigned int compound_nr; /* 1 << compound_order */
 		};
 		struct {	/* Second tail page of compound page */
 			unsigned long _compound_pad_1;	/* compound_head */
--- a/mm/page_alloc.c~mm-store-compound_nr-as-well-as-compound_order
+++ a/mm/page_alloc.c
@@ -666,8 +666,6 @@ void prep_compound_page(struct page *pag
 	int i;
 	int nr_pages = 1 << order;
 
-	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
-	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
@@ -675,6 +673,9 @@ void prep_compound_page(struct page *pag
 		p->mapping = TAIL_MAPPING;
 		set_compound_head(p, page);
 	}
+
+	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+	set_compound_order(page, order);
 	atomic_set(compound_mapcount_ptr(page), -1);
 	if (hpage_pincount_available(page))
 		atomic_set(compound_pincount_ptr(page), 0);
_
