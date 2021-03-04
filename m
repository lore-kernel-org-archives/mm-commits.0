Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D00BC433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DD864EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbhCDA6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236665AbhCDAJZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:09:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF1164F43;
        Thu,  4 Mar 2021 00:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816451;
        bh=8ExmAoZNu/lfJcCjTdFRQrGVxrcHBf6B5jx1CSrMzWc=;
        h=Date:From:To:Subject:From;
        b=lo+s5Y9q96g5gul3/FBIFRxrr31TuUSvgPEkNOtJuqKkNlWtf7czSKltK0xFsqREk
         i9ZrV1d9S9vcSyEJTxKbFUrw0mZIZ0iw/cITOeW7wUfJzu822bNB7uLJfzr4xvjwmg
         LWNtt0zw9iQ1KE4ZR15BLcBg7mu6Fxebah24TwrA=
Date:   Wed, 03 Mar 2021 16:07:30 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch added to -mm
 tree
Message-ID: <20210304000730.Q2GHjoytS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: rename alloc_pages_current to alloc_pages
has been added to the -mm tree.  Its filename is
     mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch

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
Subject: mm/mempolicy: rename alloc_pages_current to alloc_pages

When CONFIG_NUMA is enabled, alloc_pages() is a wrapper around
alloc_pages_current().  This is pointless, just implement alloc_pages()
directly.

Link: https://lkml.kernel.org/r/20210225150642.2582252-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 +-------
 mm/mempolicy.c      |    6 +++---
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/include/linux/gfp.h~mm-mempolicy-rename-alloc_pages_current-to-alloc_pages
+++ a/include/linux/gfp.h
@@ -546,13 +546,7 @@ static inline struct page *alloc_pages_n
 }
 
 #ifdef CONFIG_NUMA
-extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
-
-static inline struct page *
-alloc_pages(gfp_t gfp_mask, unsigned int order)
-{
-	return alloc_pages_current(gfp_mask, order);
-}
+struct page *alloc_pages(gfp_t gfp, unsigned int order);
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
 			int node, bool hugepage);
--- a/mm/mempolicy.c~mm-mempolicy-rename-alloc_pages_current-to-alloc_pages
+++ a/mm/mempolicy.c
@@ -2245,7 +2245,7 @@ out:
 EXPORT_SYMBOL(alloc_pages_vma);
 
 /**
- * 	alloc_pages_current - Allocate pages.
+ * 	alloc_pages - Allocate pages.
  *
  *	@gfp:
  *		%GFP_USER   user allocation,
@@ -2259,7 +2259,7 @@ EXPORT_SYMBOL(alloc_pages_vma);
  *	interrupt context and apply the current process NUMA policy.
  *	Returns NULL when no page can be allocated.
  */
-struct page *alloc_pages_current(gfp_t gfp, unsigned order)
+struct page *alloc_pages(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
 	struct page *page;
@@ -2280,7 +2280,7 @@ struct page *alloc_pages_current(gfp_t g
 
 	return page;
 }
-EXPORT_SYMBOL(alloc_pages_current);
+EXPORT_SYMBOL(alloc_pages);
 
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
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

