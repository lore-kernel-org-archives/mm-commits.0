Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCEDC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2695F64F25
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhCDA6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354498AbhCDAJY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:09:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF2CF64F73;
        Thu,  4 Mar 2021 00:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816454;
        bh=9/2OKWb8vVof63oNFkT9xAW5LgJwYnxvT9sO/4QsLOQ=;
        h=Date:From:To:Subject:From;
        b=yPGSJiawRB22qD/g6cD1UUC5yoC1J/imxDnhZS4A/hSPv2IAqQgL3V8jWzNeDElhi
         Ul/0reolgSuDmm21FttyzOvr8m2dRrZz9goPrA3rNFom5RvMA3aHbA6mBBQlebixPc
         XjFVmFcvxdz2rFmgsPrL1LuRvYJEgf7P3ndyPpRg=
Date:   Wed, 03 Mar 2021 16:07:33 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  + mm-mempolicy-rewrite-alloc_pages-documentation.patch
 added to -mm tree
Message-ID: <20210304000733.akRkThegs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: rewrite alloc_pages documentation
has been added to the -mm tree.  Its filename is
     mm-mempolicy-rewrite-alloc_pages-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-rewrite-alloc_pages-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-rewrite-alloc_pages-documentation.patch

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
Subject: mm/mempolicy: rewrite alloc_pages documentation

Document alloc_pages() for both NUMA and non-NUMA cases as kernel-doc
doesn't care.

Link: https://lkml.kernel.org/r/20210225150642.2582252-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-rewrite-alloc_pages-documentation
+++ a/mm/mempolicy.c
@@ -2245,19 +2245,18 @@ out:
 EXPORT_SYMBOL(alloc_pages_vma);
 
 /**
- * 	alloc_pages - Allocate pages.
+ * alloc_pages - Allocate pages.
+ * @gfp: GFP flags.
+ * @order: Power of two of number of pages to allocate.
  *
- *	@gfp:
- *		%GFP_USER   user allocation,
- *      	%GFP_KERNEL kernel allocation,
- *      	%GFP_HIGHMEM highmem allocation,
- *      	%GFP_FS     don't call back into a file system.
- *      	%GFP_ATOMIC don't sleep.
- *	@order: Power of two of allocation size in pages. 0 is a single page.
+ * Allocate 1 << @order contiguous pages.  The physical address of the
+ * first page is naturally aligned (eg an order-3 allocation will be aligned
+ * to a multiple of 8 * PAGE_SIZE bytes).  The NUMA policy of the current
+ * process is honoured when in process context.
  *
- *	Allocate a page from the kernel page pool.  When not in
- *	interrupt context and apply the current process NUMA policy.
- *	Returns NULL when no page can be allocated.
+ * Context: Can be called from any context, providing the appropriate GFP
+ * flags are used.
+ * Return: The page on success or NULL if allocation fails.
  */
 struct page *alloc_pages(gfp_t gfp, unsigned order)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

