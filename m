Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900D3C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E05C216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881318;
	bh=8xO0MOQy/nDvKM8FkCM1oE9hKplxyL37hK+2aTKmjyA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ho19ek062bojP8KqzfYziXjtfAvEhu4ulsSDz2yNZRpvCdHZ5tuYdxJ5Uokoxi/nk
	 TVq1cX3E2AZGNnx1BlnkbiuazQ3Wp8VQbS9VVBvpoeABqJItZz6Cjh15qHtyfgJbyU
	 jWQ+PZ4H0L9uFcbJPJoRfVtxz17/VibYi2eU4jak=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392703AbgJPUsh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUsh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:37 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D1F214DB;
        Fri, 16 Oct 2020 20:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881317;
        bh=8xO0MOQy/nDvKM8FkCM1oE9hKplxyL37hK+2aTKmjyA=;
        h=Date:From:To:Subject:From;
        b=WsCj2z5hYrTszU62kVwuL0mKKrkJFxplG+/q9arfDvGireu7tASbU0BLmH++/Uyrg
         qpcgPpDlQTPbTHuhRhj0lO8+FO6eYdpJ/cFEqqjbD0JUioW4nuqlRuFSvlSTFmPGVC
         Wc/MBqjR4bcZhcQzxBRkLtdB9dKlfhqeFiLgVRSM=
Date:   Fri, 16 Oct 2020 13:48:36 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch removed
 from -mm tree
Message-ID: <20201016204836.xqfha6YcC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: support tail pages in wait_for_stable_page
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page-writeback: support tail pages in wait_for_stable_page

page->mapping is undefined for tail pages, so operate exclusively on the
head page.

Link: https://lkml.kernel.org/r/20200908195539.25896-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~mm-page-writeback-support-tail-pages-in-wait_for_stable_page
+++ a/mm/page-writeback.c
@@ -2849,6 +2849,7 @@ EXPORT_SYMBOL_GPL(wait_on_page_writeback
  */
 void wait_for_stable_page(struct page *page)
 {
+	page = thp_head(page);
 	if (page->mapping->host->i_sb->s_iflags & SB_I_STABLE_WRITES)
 		wait_on_page_writeback(page);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

