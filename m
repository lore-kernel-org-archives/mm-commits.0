Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7212DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDB661A24
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhCXX3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231895AbhCXX3K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA7E619C7;
        Wed, 24 Mar 2021 23:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616628549;
        bh=QJl9qhKBhc1jdU1XvpkYGywqDQR1oINGLPp1yHlCIFo=;
        h=Date:From:To:Subject:From;
        b=Li2UnWkP5LFZqC12l3gUrlnzMO/4oRq09uDo0EHTY4wbFoA/Z0Kiui/xZDOhmn0pu
         a8mDTnT396T1vdNWNIcv3zH7fGgPTHcBUW43JOoESlMB50JFmkRg1cA934Tu8gtNPH
         353bByEWTZjiOIciaBZajF+duSe8VTefnedYnF28=
Date:   Wed, 24 Mar 2021 16:29:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        jhubbard@nvidia.com, corbet@lwn.net, willy@infradead.org
Subject:  + mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch added to
 -mm tree
Message-ID: <20210324232909.AGL3j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: fix page_maybe_dma_pinned kerneldoc
has been added to the -mm tree.  Its filename is
     mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch

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
Subject: mm/doc: fix page_maybe_dma_pinned kerneldoc

make htmldocs reports:

./include/linux/mm.h:1341: warning: Excess function parameter 'Return' description in 'page_maybe_dma_pinned'

Fix a few other formatting nits while I'm editing this description.

Link: https://lkml.kernel.org/r/20210322195022.2143603-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-doc-fix-page_maybe_dma_pinned-kerneldoc
+++ a/include/linux/mm.h
@@ -1261,10 +1261,11 @@ void unpin_user_page_range_dirty_lock(st
 void unpin_user_pages(struct page **pages, unsigned long npages);
 
 /**
- * page_maybe_dma_pinned() - report if a page is pinned for DMA.
+ * page_maybe_dma_pinned - Report if a page is pinned for DMA.
+ * @page: The page.
  *
  * This function checks if a page has been pinned via a call to
- * pin_user_pages*().
+ * a function in the pin_user_pages() family.
  *
  * For non-huge pages, the return value is partially fuzzy: false is not fuzzy,
  * because it means "definitely not pinned for DMA", but true means "probably
@@ -1282,9 +1283,8 @@ void unpin_user_pages(struct page **page
  *
  * For more information, please see Documentation/core-api/pin_user_pages.rst.
  *
- * @page:	pointer to page to be queried.
- * @Return:	True, if it is likely that the page has been "dma-pinned".
- *		False, if the page is definitely not dma-pinned.
+ * Return: True, if it is likely that the page has been "dma-pinned".
+ * False, if the page is definitely not dma-pinned.
  */
 static inline bool page_maybe_dma_pinned(struct page *page)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-introduce-and-use-mapping_empty.patch
mm-stop-accounting-shadow-entries.patch
dax-account-dax-entries-as-nrpages.patch
mm-remove-nrexceptional-from-inode.patch
mm-move-page_mapping_file-to-pagemaph.patch
mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
mm-doc-turn-fault-flags-into-an-enum.patch
mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch

