Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E36C432C3
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC6664EBD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbhCDA6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354499AbhCDAJY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:09:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D460164F1A;
        Thu,  4 Mar 2021 00:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816456;
        bh=LaSc+MjujariQmweavtE7oR1ftk7ZNyooiVNbHH3LNE=;
        h=Date:From:To:Subject:From;
        b=06tFIiGAelZ0OtMeJQQThVZthk/02VpgrRFaLWwZ3jwFPpqnmEOMoafVyXcEI++NC
         SeWmaqcGTbE2HyE5u8kCcdoCPbPZ+t8b1HVa63Iun0B5wVc0g1yunzRqT20C6wqWip
         5NEpjaUZMSjaMTgMn3dUMY9/YVS1P47RLkMvh92c=
Date:   Wed, 03 Mar 2021 16:07:35 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch added to -mm tree
Message-ID: <20210304000735.W5X1Zlr6v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: rewrite alloc_pages_vma documentation
has been added to the -mm tree.  Its filename is
     mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch

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
Subject: mm/mempolicy: rewrite alloc_pages_vma documentation

The current formatting doesn't quite work with kernel-doc.

Link: https://lkml.kernel.org/r/20210225150642.2582252-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

