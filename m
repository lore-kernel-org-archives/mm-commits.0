Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E17C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE752087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817553;
	bh=zj5Qi72+JcUV02+1z7NhEspgEON4ujFhOiOxPWE0y5w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rC2eWKfdGv3+91ac2JFMks98sESjafvRrzKo/KAd/BLuSQDK0tiYJHDw5aE+85Ld/
	 DEC45CyWHSh4mi46ycKQqtp0yWgqtXxjbRJ9uBtdaN8Ua3AK7P2X7psirB1uy9qQ2g
	 mPCBucOCtHn029j2t86KDWG+9eZcrSQk7DV8xzk8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393944AbgJPDFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C5B420878;
        Fri, 16 Oct 2020 03:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817550;
        bh=zj5Qi72+JcUV02+1z7NhEspgEON4ujFhOiOxPWE0y5w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EfCbFE3gTjMwuOIie+yqO61x1C/0H7dd6KVBwuHx6BbTiDPEcXTrI/1OQEgA2/yG7
         M7qjYc20rgQHTJ9ph4iKrEKgZk/8aVp46jFzAhXv9LDbWWLy/prrPk7itho2efpJ+D
         vdm7lD6XRVFXcCT9KqLfKbf/PjGvXmMs7etxrS+4=
Date:   Thu, 15 Oct 2020 20:05:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 027/156] mm/truncate: fix truncation for pages of
 arbitrary size
Message-ID: <20201016030550.8gjfJpEeW%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/truncate: fix truncation for pages of arbitrary size

Remove the assumption that a compound page is HPAGE_PMD_SIZE, and the
assumption that any page is PAGE_SIZE.

Link: https://lkml.kernel.org/r/20200908195539.25896-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/truncate.c~mm-truncate-fix-truncation-for-pages-of-arbitrary-size
+++ a/mm/truncate.c
@@ -168,7 +168,7 @@ void do_invalidatepage(struct page *page
  * becomes orphaned.  It will be left on the LRU and may even be mapped into
  * user pagetables if we're racing with filemap_fault().
  *
- * We need to bale out if page->mapping is no longer equal to the original
+ * We need to bail out if page->mapping is no longer equal to the original
  * mapping.  This happens a) when the VM reclaimed the page while we waited on
  * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
@@ -177,12 +177,12 @@ static void
 truncate_cleanup_page(struct address_space *mapping, struct page *page)
 {
 	if (page_mapped(page)) {
-		pgoff_t nr = PageTransHuge(page) ? HPAGE_PMD_NR : 1;
+		unsigned int nr = thp_nr_pages(page);
 		unmap_mapping_pages(mapping, page->index, nr, false);
 	}
 
 	if (page_has_private(page))
-		do_invalidatepage(page, 0, PAGE_SIZE);
+		do_invalidatepage(page, 0, thp_size(page));
 
 	/*
 	 * Some filesystems seem to re-dirty the page even after
_
