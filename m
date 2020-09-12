Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C64C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F204D21D40
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937909;
	bh=PhppgLWJ+/XGXNLdEjitq4WfbTfWmD6CQIq7IRg1Aks=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=N0KEtgStpPksS0h2Tr6f0hcwBVO+N9idGj8MLXr8UVaMY71qYHu+FBe3a/vsNunZ+
	 3IHAGBkSNPdCGUEZoX/HUn8j2LW1xbHdCMe5ZQ+lGZF7kRbI2jeR3PAmeKVif1m0pR
	 +wClyK5lPU2idPUGEDyzaXQM6OP7gHv0ixLQfxrI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgILTLs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgILTLr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:47 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1AE21D40;
        Sat, 12 Sep 2020 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937906;
        bh=PhppgLWJ+/XGXNLdEjitq4WfbTfWmD6CQIq7IRg1Aks=;
        h=Date:From:To:Subject:From;
        b=Jgh2wHm7Eb4Q+wViV0etiTuo87+rNPh+I2fdBSZ6BYvrLUz/SHtldFWaN8CUIbkeN
         rHwB9GOX44q0Y63BHnGH8xnDRHjj1j88QdsIiWNE0sfoXoDNoODDmlXn6EwKa4Z9vw
         ZVdIIKBrjx6GInHS5AggN85BROP0GM4d1StNO1s4=
Date:   Sat, 12 Sep 2020 12:11:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  +
 mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch added to -mm
 tree
Message-ID: <20200912191146.v5EI8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate: fix truncation for pages of arbitrary size
has been added to the -mm tree.  Its filename is
     mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/truncate: fix truncation for pages of arbitrary size

Remove the assumption that a compound page is HPAGE_PMD_SIZE, and the
assumption that any page is PAGE_SIZE.

Link: https://lkml.kernel.org/r/20200908195539.25896-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
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
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

