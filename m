Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31951C56201
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 03:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7EB4207CD
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 03:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TtrdCjBq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgK1DpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 22:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730942AbgK1Dlc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 22:41:32 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B833207CD;
        Sat, 28 Nov 2020 03:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606534891;
        bh=i/FkubaYfBa7nfu+yLfTWa0av44cCLUeVoyKp8BJ84Q=;
        h=Date:From:To:Subject:From;
        b=TtrdCjBqPHw5EoXTKPngG4elP2JD8ZoEeV8p+gCpbz9f0L4v391f1UpBmiJ1ngydv
         KLhizbUtwBa4M/P/KvKd6idwsOp6JNaq0ug4/H2R/yIkCwF+kIbcbsqGEdgfDU9CJN
         PFlQhm1tzYIWOy8VotFZTNpi11FgFKFxPGLFGtzY=
Date:   Fri, 27 Nov 2020 19:41:30 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [obsolete]
 =?US-ASCII?Q?mm-page=5Falloc-clear-pages-in-alloc=5Fcontig=5Fpages-with?=
 =?US-ASCII?Q?-init=5Fon=5Falloc=3D1-or-=5F=5Fgfp=5Fzero.patch?= removed
 from -mm tree
Message-ID: <20201128034130.TW68MfnqT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: clear pages in alloc_contig_pages() with init_on_alloc=1 or __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc=1-or-__gfp_zero.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: clear pages in alloc_contig_pages() with init_on_alloc=1 or __GFP_ZERO

commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and
init_on_free=1 boot options") resulted with init_on_alloc=1 in all pages
leaving the buddy via alloc_pages() and friends to be
initialized/cleared/zeroed on allocation.

However, the same logic is currently not applied to alloc_contig_pages():
allocated pages leaving the buddy aren't cleared with init_on_alloc=1 and
init_on_free=0.  Let's also properly clear pages on that allocation path
and add support for __GFP_ZERO.

With this change, we will see double clearing of pages in some cases.  One
example are gigantic pages (either allocated via CMA, or allocated
dynamically via alloc_contig_pages()) - which is the right thing to do
(and to be optimized outside of the buddy in the callers) as discussed in
https://lkml.kernel.org/r/20201019182853.7467-1-gpiccoli@canonical.com

This change implies that with init_on_alloc=1
- All CMA allocations will be cleared
- Gigantic pages allocated via alloc_contig_pages() will be cleared
- virtio-mem memory to be unplugged will be cleared. While this is
  suboptimal, it's similar to memory balloon drivers handling, where
  all pages to be inflated will get cleared as well.

__GFP_ZERO is not used yet.  It's intended to be used in
https://lkml.kernel.org/r/20201029162718.29910-1-david@redhat.com and I
can move that change into a separate patch if desired.

Link: https://lkml.kernel.org/r/20201110193240.25401-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc=1-or-__gfp_zero
+++ a/mm/page_alloc.c
@@ -8477,6 +8477,19 @@ static int __alloc_contig_migrate_range(
 	return 0;
 }
 
+static void __alloc_contig_clear_range(unsigned long start_pfn,
+				       unsigned long end_pfn)
+{
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES) {
+		cond_resched();
+		kernel_init_free_pages(pfn_to_page(pfn),
+				       min_t(unsigned long, end_pfn - pfn,
+					     MAX_ORDER_NR_PAGES));
+	}
+}
+
 /**
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
@@ -8485,7 +8498,8 @@ static int __alloc_contig_migrate_range(
  *			#MIGRATE_MOVABLE or #MIGRATE_CMA).  All pageblocks
  *			in range must have the same migratetype and it must
  *			be either of the two.
- * @gfp_mask:	GFP mask to use during compaction
+ * @gfp_mask:	GFP mask to use during compaction. __GFP_ZERO clears allocated
+ *		pages.
  *
  * The PFN range does not have to be pageblock or MAX_ORDER_NR_PAGES
  * aligned.  The PFN range must belong to a single zone.
@@ -8512,7 +8526,7 @@ int alloc_contig_range(unsigned long sta
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
-		.gfp_mask = current_gfp_context(gfp_mask),
+		.gfp_mask = current_gfp_context(gfp_mask & ~__GFP_ZERO),
 		.alloc_contig = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -8626,6 +8640,9 @@ int alloc_contig_range(unsigned long sta
 	if (end != outer_end)
 		free_contig_range(end, outer_end - end);
 
+	if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
+		__alloc_contig_clear_range(start, end);
+
 done:
 	undo_isolate_page_range(pfn_max_align_down(start),
 				pfn_max_align_up(end), migratetype);
@@ -8679,7 +8696,8 @@ static bool zone_spans_last_pfn(const st
 /**
  * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
  * @nr_pages:	Number of contiguous pages to allocate
- * @gfp_mask:	GFP mask to limit search and used during compaction
+ * @gfp_mask:	GFP mask to limit search and used during compaction. __GFP_ZERO
+ *		clears allocated pages.
  * @nid:	Target node
  * @nodemask:	Mask for other possible nodes
  *
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1.patch

