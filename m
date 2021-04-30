Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C1FC43600
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE0A61493
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhD3GCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhD3GCN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E902461482;
        Fri, 30 Apr 2021 06:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762485;
        bh=cMWpH8JpEZVGPl+2Qs6ST/UDJLAjlcLjWTiSfA1+cgA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oeDKrUEe2pOpOs4QXSFsmwfH9rnsx7vd2GleS1fX3biuD7AlVYE6mq30JTo48exBs
         o8t+JiYi6THi6/oypDQjOk6krdsUfPwI9jT71uIqROKJMflpn/nTqulrmr8OnVDAkQ
         2HtOTTqCL0r+xTwU64fpi4rzkhUjDXVNzyE0yPe0=
Date:   Thu, 29 Apr 2021 23:01:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 160/178] mm/mempolicy: rewrite alloc_pages_vma
 documentation
Message-ID: <20210430060124.F8EE6az4r%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: rewrite alloc_pages_vma documentation

The current formatting doesn't quite work with kernel-doc.

Link: https://lkml.kernel.org/r/20210225150642.2582252-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-rewrite-alloc_pages_vma-documentation
+++ a/mm/mempolicy.c
@@ -2153,30 +2153,22 @@ static struct page *alloc_page_interleav
 }
 
 /**
- * 	alloc_pages_vma	- Allocate a page for a VMA.
+ * alloc_pages_vma - Allocate a page for a VMA.
+ * @gfp: GFP flags.
+ * @order: Order of the GFP allocation.
+ * @vma: Pointer to VMA or NULL if not available.
+ * @addr: Virtual address of the allocation.  Must be inside @vma.
+ * @node: Which node to prefer for allocation (modulo policy).
+ * @hugepage: For hugepages try only the preferred node if possible.
  *
- * 	@gfp:
- *      %GFP_USER    user allocation.
- *      %GFP_KERNEL  kernel allocations,
- *      %GFP_HIGHMEM highmem/user allocations,
- *      %GFP_FS      allocation should not call back into a file system.
- *      %GFP_ATOMIC  don't sleep.
+ * Allocate a page for a specific address in @vma, using the appropriate
+ * NUMA policy.  When @vma is not NULL the caller must hold the mmap_lock
+ * of the mm_struct of the VMA to prevent it from going away.  Should be
+ * used for all allocations for pages that will be mapped into user space.
  *
- *	@order:Order of the GFP allocation.
- * 	@vma:  Pointer to VMA or NULL if not available.
- *	@addr: Virtual Address of the allocation. Must be inside the VMA.
- *	@node: Which node to prefer for allocation (modulo policy).
- *	@hugepage: for hugepages try only the preferred node if possible
- *
- * 	This function allocates a page from the kernel page pool and applies
- *	a NUMA policy associated with the VMA or the current process.
- *	When VMA is not NULL caller must read-lock the mmap_lock of the
- *	mm_struct of the VMA to prevent it from going away. Should be used for
- *	all allocations for pages that will be mapped into user space. Returns
- *	NULL when no page can be allocated.
+ * Return: The page on success or NULL if allocation fails.
  */
-struct page *
-alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
+struct page *alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr, int node, bool hugepage)
 {
 	struct mempolicy *pol;
_
