Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF39C3526F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328F322D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgLPAAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730029AbgLOX0n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:43 -0500
Date:   Tue, 15 Dec 2020 15:17:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074260;
        bh=RVBo/qbVmJ1mup08Nnii9x6jYTc172cXtTDCL+nM6jU=;
        h=From:To:Subject:From;
        b=JchRQU2+58ZeeqW4CzcBXyWEGbeLVatDH8Q9p54hWQ536yjgeJE7pU3FCtxFAWjKZ
         3IvLfXEzoQtaddkiL7qiA477s4sn3IFk0k6veYOYYj947DuW77bfLVew7Diyv2+OKe
         rVVXELG31AentM8B+owJCnrgqLlsvGR2bqQkaWB8=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com,
        hch@infradead.org, ira.weiny@intel.com, jack@suse.cz,
        jane.chu@oracle.com, jgg@nvidia.com, jhubbard@nvidia.com,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shuah@kernel.org,
        songmuchun@bytedance.com, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-up-combine-put_compound_head-and-unpin_user_page.patch removed from -mm
 tree
Message-ID: <20201215231739.h3Z_7kmun%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: combine put_compound_head() and unpin_user_page()
has been removed from the -mm tree.  Its filename was
     mm-up-combine-put_compound_head-and-unpin_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: combine put_compound_head() and unpin_user_page()

These functions accomplish the same thing but have different
implementations.

unpin_user_page() has a bug where it calls mod_node_page_state() after
calling put_page() which creates a risk that the page could have been
hot-uplugged from the system.

Fix this by using put_compound_head() as the only implementation.

__unpin_devmap_managed_user_page() and related can be deleted as well in
favour of the simpler, but slower, version in put_compound_head() that has
an extra atomic page_ref_sub, but always calls put_page() which internally
contains the special devmap code.

Move put_compound_head() to be directly after try_grab_compound_head() so
people can find it in future.

Link: https://lkml.kernel.org/r/0-v1-6730d4ee0d32+40e6-gup_combine_put_jgg@nvidia.com
Fixes: 1970dc6f5226 ("mm/gup: /proc/vmstat: pin_user_pages (FOLL_PIN) reporting")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
CC: Joao Martins <joao.m.martins@oracle.com>
CC: Jonathan Corbet <corbet@lwn.net>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jane Chu <jane.chu@oracle.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Michal Hocko <mhocko@suse.com>
CC: Mike Kravetz <mike.kravetz@oracle.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Muchun Song <songmuchun@bytedance.com>
CC: Vlastimil Babka <vbabka@suse.cz>
CC: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  102 +++++++++++------------------------------------------
 1 file changed, 23 insertions(+), 79 deletions(-)

--- a/mm/gup.c~mm-up-combine-put_compound_head-and-unpin_user_page
+++ a/mm/gup.c
@@ -123,6 +123,28 @@ static __maybe_unused struct page *try_g
 	return NULL;
 }
 
+static void put_compound_head(struct page *page, int refs, unsigned int flags)
+{
+	if (flags & FOLL_PIN) {
+		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED,
+				    refs);
+
+		if (hpage_pincount_available(page))
+			hpage_pincount_sub(page, refs);
+		else
+			refs *= GUP_PIN_COUNTING_BIAS;
+	}
+
+	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
+	/*
+	 * Calling put_page() for each ref is unnecessarily slow. Only the last
+	 * ref needs a put_page().
+	 */
+	if (refs > 1)
+		page_ref_sub(page, refs - 1);
+	put_page(page);
+}
+
 /**
  * try_grab_page() - elevate a page's refcount by a flag-dependent amount
  *
@@ -177,41 +199,6 @@ bool __must_check try_grab_page(struct p
 	return true;
 }
 
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-static bool __unpin_devmap_managed_user_page(struct page *page)
-{
-	int count, refs = 1;
-
-	if (!page_is_devmap_managed(page))
-		return false;
-
-	if (hpage_pincount_available(page))
-		hpage_pincount_sub(page, 1);
-	else
-		refs = GUP_PIN_COUNTING_BIAS;
-
-	count = page_ref_sub_return(page, refs);
-
-	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
-	/*
-	 * devmap page refcounts are 1-based, rather than 0-based: if
-	 * refcount is 1, then the page is free and the refcount is
-	 * stable because nobody holds a reference on the page.
-	 */
-	if (count == 1)
-		free_devmap_managed_page(page);
-	else if (!count)
-		__put_page(page);
-
-	return true;
-}
-#else
-static bool __unpin_devmap_managed_user_page(struct page *page)
-{
-	return false;
-}
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
-
 /**
  * unpin_user_page() - release a dma-pinned page
  * @page:            pointer to page to be released
@@ -223,28 +210,7 @@ static bool __unpin_devmap_managed_user_
  */
 void unpin_user_page(struct page *page)
 {
-	int refs = 1;
-
-	page = compound_head(page);
-
-	/*
-	 * For devmap managed pages we need to catch refcount transition from
-	 * GUP_PIN_COUNTING_BIAS to 1, when refcount reach one it means the
-	 * page is free and we need to inform the device driver through
-	 * callback. See include/linux/memremap.h and HMM for details.
-	 */
-	if (__unpin_devmap_managed_user_page(page))
-		return;
-
-	if (hpage_pincount_available(page))
-		hpage_pincount_sub(page, 1);
-	else
-		refs = GUP_PIN_COUNTING_BIAS;
-
-	if (page_ref_sub_and_test(page, refs))
-		__put_page(page);
-
-	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
+	put_compound_head(compound_head(page), 1, FOLL_PIN);
 }
 EXPORT_SYMBOL(unpin_user_page);
 
@@ -2010,28 +1976,6 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  */
 #ifdef CONFIG_HAVE_FAST_GUP
 
-static void put_compound_head(struct page *page, int refs, unsigned int flags)
-{
-	if (flags & FOLL_PIN) {
-		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED,
-				    refs);
-
-		if (hpage_pincount_available(page))
-			hpage_pincount_sub(page, refs);
-		else
-			refs *= GUP_PIN_COUNTING_BIAS;
-	}
-
-	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
-	/*
-	 * Calling put_page() for each ref is unnecessarily slow. Only the last
-	 * ref needs a put_page().
-	 */
-	if (refs > 1)
-		page_ref_sub(page, refs - 1);
-	put_page(page);
-}
-
 static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
 					    unsigned int flags,
 					    struct page **pages)
_

Patches currently in -mm which might be from jgg@nvidia.com are


