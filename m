Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3B6C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A12B561493
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhD3GCL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhD3GCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D54461492;
        Fri, 30 Apr 2021 06:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762482;
        bh=/GyN5xfyJ2NeqHuBhdKuiL9VspyhK/ULolph5TNO0jU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bY43Mzu9aWALSHZ4oFl03k4fHNMEF5XToK062sqgPELRmiIqZiPLqs1CsYsr6pzrF
         5PVuFsxNhWCbG/EMUkiY9c33qDvsaRliw3t5Fjy3cwJMR6bwolnV+Zoc/TW9aAjW87
         c7FvQvDv0C65dMB7QjoU+Mu/1OzOclFsww70Bubg=
Date:   Thu, 29 Apr 2021 23:01:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 159/178] mm/mempolicy: rewrite alloc_pages
 documentation
Message-ID: <20210430060121.NXdQrAzty%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: rewrite alloc_pages documentation

Document alloc_pages() for both NUMA and non-NUMA cases as kernel-doc
doesn't care.

Link: https://lkml.kernel.org/r/20210225150642.2582252-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
