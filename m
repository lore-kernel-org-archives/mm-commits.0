Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED34C35270
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386FA22D0A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgLOX7Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgLOXXc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:32 -0500
Date:   Tue, 15 Dec 2020 15:21:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074515;
        bh=RSfdSNjSc3zseXUhSGfSGHrY4Guf9k+biIy63U3ZD4s=;
        h=From:To:Subject:From;
        b=BDZx/mN8jtioXOMCSimp4/bLMA2tBmhIK8aqUj4YPLNFRVW/1rJRldDIwIdkR5XbH
         z4ytkAofU0XXFbCZpmJ1ca6XZxmNkbJi2vH97XapC1olC1kuaCLx0yec6hM7vpSANI
         rSzPqtteuxcH8RmwxQIena3Y3xj9r2Qhm5E9l19o=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged]
 mm-page_alloc-add-__free_pages-documentation.patch removed from -mm tree
Message-ID: <20201215232155.Yn25RUFpZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add __free_pages() documentation
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-__free_pages-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: add __free_pages() documentation

Provide some guidance towards when this might not be the right interface
to use.

Link: https://lkml.kernel.org/r/20201027025523.3235-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-__free_pages-documentation
+++ a/mm/page_alloc.c
@@ -5043,6 +5043,26 @@ static inline void free_the_page(struct
 		__free_pages_ok(page, order, FPI_NONE);
 }
 
+/**
+ * __free_pages - Free pages allocated with alloc_pages().
+ * @page: The page pointer returned from alloc_pages().
+ * @order: The order of the allocation.
+ *
+ * This function can free multi-page allocations that are not compound
+ * pages.  It does not check that the @order passed in matches that of
+ * the allocation, so it is easy to leak memory.  Freeing more memory
+ * than was allocated will probably emit a warning.
+ *
+ * If the last reference to this page is speculative, it will be released
+ * by put_page() which only frees the first page of a non-compound
+ * allocation.  To prevent the remaining pages from being leaked, we free
+ * the subsequent pages here.  If you want to use the page's reference
+ * count to decide when to free the allocation, you should allocate a
+ * compound page, and use put_page() instead of __free_pages().
+ *
+ * Context: May be called in interrupt context or while holding a normal
+ * spinlock, but not in NMI context or while holding a raw spinlock.
+ */
 void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page))
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

