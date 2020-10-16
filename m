Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08D0C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CDCC216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881315;
	bh=pNLkKTaXA1QUPIdssRtL4Rs8YbA/KEVViJz2ySqyW/U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=egRyIaOtY5VU1fQ7Y40ZgYZzv/q6I5Wwqq9LV95Pz1dk8r/ZvU2lFA8WA5mkFLE3Y
	 TFQLB3s9f6MCjoAujvW+0cGGo65rNTpzBziPvudpbb39+yqEEhnxudaJrxFz9KzLkz
	 h/5VCQYsQTVckJCOYlV5G5r4e+cWcq/wzSO3Ztoo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392702AbgJPUse (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUse (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD196214DB;
        Fri, 16 Oct 2020 20:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881314;
        bh=pNLkKTaXA1QUPIdssRtL4Rs8YbA/KEVViJz2ySqyW/U=;
        h=Date:From:To:Subject:From;
        b=c++aOLerE9Id6nYvSD0aBxS3YTh+WTUVoqq8G/tlhXsckrrRhpAM4ejRxe9by6gGm
         2O4kPQ0ZNV798cQufZbQb4cEYnXQf4500hePQGCbglre7GedliLM4nI5KaJA1gAwBo
         VEJZuGmskMvpChFQHeSJjXpxM+58M+EFEuF/kYFc=
Date:   Fri, 16 Oct 2020 13:48:33 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch removed from
 -mm tree
Message-ID: <20201016204833.hG761VWFH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate: fix truncation for pages of arbitrary size
has been removed from the -mm tree.  Its filename was
     mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

