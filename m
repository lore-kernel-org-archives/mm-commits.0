Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49E0C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769A62073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026940;
	bh=4Rnx/52CQ5ZO/bSKRAIRSrBrVfVQ1ZPXZAHTRq4e0HA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RbH9r23rR68l/ozpqY8z1jy0/EGLbuyHjF8uM+FrXUb+3hgALGQmqsfHqYSwyw6fU
	 mBv4NssW3Vvt5mRwBdvHJTzA79/wkyyVhVFHel3Z0sw3ULzaWqfNIMdXXBuTDauB01
	 k/EtXdTwKqe+lAuinDXeTu1rsxMltOjHjsqGOWDY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB312065D;
        Mon, 10 Aug 2020 02:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026939;
        bh=4Rnx/52CQ5ZO/bSKRAIRSrBrVfVQ1ZPXZAHTRq4e0HA=;
        h=Date:From:To:Subject:From;
        b=WHSnzYHAFWs3Luj03G+4ujGCePhBekMFZBbTbO7gKEuL4qbqMr4uZHndAchvsKwb0
         3uvpaBxidBj0CxUGXD1h2oz9G7RqlITPb7JAeZpEqr0W51Dyjtxq9526EDMeD8W0aC
         m5zKW7PxZIUk1RnlOOKHXNm/CIdnkMDIxeBEau6s=
Date:   Sun, 09 Aug 2020 19:35:38 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mm-handle-page-mapping-better-in-dump_page.patch
 removed from -mm tree
Message-ID: <20200810023538.6iPMhongx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: handle page->mapping better in dump_page
has been removed from the -mm tree.  Its filename was
     mm-handle-page-mapping-better-in-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: handle page->mapping better in dump_page

Patch series "Improvements for dump_page()", v2.

Here's a sample dump of a pagecache tail page with all of the patches
applied:

page:000000006d1c49ca refcount:6 mapcount:0 mapping:00000000136b8d90 index:0x109 pfn:0x6c645
head:000000008bd38076 order:2 compound_mapcount:0 compound_pincount:0
aops:xfs_address_space_operations ino:800042 dentry name:"fd"
flags: 0x4000000000012014(uptodate|lru|private|head)
raw: 4000000000000000 ffffd46ac1b19101 ffffffff00000202 dead000000000004
raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
head: 4000000000012014 ffffd46ac1b1bbc8 ffffd46ac1b1bc08 ffff91976f659560
head: 0000000000000108 ffff919773220680 00000006ffffffff 0000000000000000
page dumped because: testing


This patch (of 6):

If we can't call page_mapping() to get the page mapping, handle the
anon/ksm/movable bits correctly.

[akpm@linux-foundation.org: augmented code comment from John]
  Link: http://lkml.kernel.org/r/15cff11a-6762-8a6a-3f0e-dd227280cd6f@nvidia.com
Link: http://lkml.kernel.org/r/20200709202117.7216-1-willy@infradead.org
Link: http://lkml.kernel.org/r/20200709202117.7216-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/debug.c~mm-handle-page-mapping-better-in-dump_page
+++ a/mm/debug.c
@@ -69,8 +69,19 @@ void __dump_page(struct page *page, cons
 	}
 
 	if (page < head || (page >= head + MAX_ORDER_NR_PAGES)) {
-		/* Corrupt page, cannot call page_mapping */
-		mapping = page->mapping;
+		/*
+		 * Corrupt page, so we cannot call page_mapping. Instead, do a
+		 * safe subset of the steps that page_mapping() does. Caution:
+		 * this will be misleading for tail pages, PageSwapCache pages,
+		 * and potentially other situations. (See the page_mapping()
+		 * implementation for what's missing here.)
+		 */
+		unsigned long tmp = (unsigned long)page->mapping;
+
+		if (tmp & PAGE_MAPPING_ANON)
+			mapping = NULL;
+		else
+			mapping = (void *)(tmp & ~PAGE_MAPPING_FLAGS);
 		head = page;
 		compound = false;
 	} else {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
poison-remove-obsolete-comment.patch

