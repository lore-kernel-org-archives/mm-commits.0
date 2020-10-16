Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F743C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ACAA20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814546;
	bh=5qdKa++wn8yLJbFBoTt8iUBqLsVyixNTQdcFy1aX/Bk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tB4/VCNLBw+WF9C2n9yRAFqhUVg2ak85V3Ia/X5w0scd8K5fKLIH5ALytsBhxiDdx
	 vigjTvWp5e13TewwJs0Y8KHmMBFZObskFr9vYZ1ejaIjpQYBFFHPLopIRIHytn1PSB
	 JUOGVgg86yKCdO0THZRwozzHKZrsK+4uznO3xBnQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbgJPCPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390154AbgJPCPp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:15:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D86A20878;
        Fri, 16 Oct 2020 02:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814544;
        bh=5qdKa++wn8yLJbFBoTt8iUBqLsVyixNTQdcFy1aX/Bk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jI2piH+IlYFSCDmjJnxX6jDpouhLY3/brBNgDyOD4tBeZSnH93YzQPnJz6D5xoDo0
         /EPHBzn8yP5p65Q2GddoUv/bOMIz+/KbEZ5tMHYmq1xA1EqA4wC0sfjUL6G3YPsYzH
         9eJG0dbegqNYrBJ7iIqH32oZq2VQuQpU5Guuk2qE=
Date:   Thu, 15 Oct 2020 19:15:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [folded-merged]
 mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
 removed from -mm tree
Message-ID: <20201016021543.dVuXWecmb%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix remove page fault assumption of compound page size
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch

This patch was dropped because it was folded into mm-memory-remove-page-fault-assumption-of-compound-page-size.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: Fix remove page fault assumption of compound page size

page_order() and compound_order() are different things

Link: https://lkml.kernel.org/r/20201001152259.14932-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-remove-page-fault-assumption-of-compound-page-size-fix
+++ a/mm/memory.c
@@ -3749,7 +3749,7 @@ static vm_fault_t do_set_pmd(struct vm_f
 		return ret;
 
 	page = compound_head(page);
-	if (page_order(page) != HPAGE_PMD_ORDER)
+	if (compound_order(page) != HPAGE_PMD_ORDER)
 		return ret;
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

