Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238C1C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9462087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817768;
	bh=j92j6O+egQM8PwJJxd8NmL7Flw61gGSr0JZ3a9JdcCU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wN3dyI/FqjAXq0jOhLZkBzuyLt/80UyqeXbUW3stWogb1arcYwuqyFV0N+BLi/9EL
	 pbvGEVkFdKTpxNagyG8uMeep+N1I4NlC9DHbeJX3hvYp4qqccNnHwQKytKLRpGNPTI
	 5vKP/LGXju+SwWV9Sx7Auey1jRAQXZpvLfmKzgV8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbgJPDJ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJPDJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:09:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F3020897;
        Fri, 16 Oct 2020 03:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817767;
        bh=j92j6O+egQM8PwJJxd8NmL7Flw61gGSr0JZ3a9JdcCU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hPBMBCF8Q94jqhbkxJuuS8Zy8QTSZIxQdZ8I/HUMs7tcVpW/7XOSLqj7shP90216V
         iEVTV5Qp0aJMbAS7PUKiu2um23T1018g6w3gYEqo298LaKbo8ndyGzGHcPKx1n13LP
         th1d8SDR5vr3Ek1Ywt9HqB5j0dZv75j8wzm0UhvA=
Date:   Thu, 15 Oct 2020 20:09:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        cheloha@linux.ibm.com, dave.hansen@intel.com, david@redhat.com,
        haiyangz@microsoft.com, kys@microsoft.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sthemmin@microsoft.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, wei.liu@kernel.org,
        willy@infradead.org
Subject:  [patch 080/156] mm/page_alloc: place pages to tail in
 __putback_isolated_page()
Message-ID: <20201016030926.UI5aPjGQs%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: place pages to tail in __putback_isolated_page()

__putback_isolated_page() already documents that pages will be placed to
the tail of the freelist - this is, however, not the case for "order >=
MAX_ORDER - 2" (see buddy_merge_likely()) - which should be the case for
all existing users.

This change affects two users:
- free page reporting
- page isolation, when undoing the isolation (including memory onlining).

This behavior is desirable for pages that haven't really been touched
lately, so exactly the two users that don't actually read/write page
content, but rather move untouched pages.

The new behavior is especially desirable for memory onlining, where we
allow allocation of newly onlined pages via undo_isolate_page_range() in
online_pages().  Right now, we always place them to the head of the
freelist, resulting in undesireable behavior: Assume we add individual
memory chunks via add_memory() and online them right away to the NORMAL
zone.  We create a dependency chain of unmovable allocations e.g., via the
memmap.  The memmap of the next chunk will be placed onto previous chunks
- if the last block cannot get offlined+removed, all dependent ones cannot
get offlined+removed.  While this can already be observed with individual
DIMMs, it's more of an issue for virtio-mem (and I suspect also ppc
DLPAR).

Document that this should only be used for optimizations, and no code
should rely on this behavior for correction (if the order of the freelists
ever changes).

We won't care about page shuffling: memory onlining already properly
shuffles after onlining.  free page reporting doesn't care about
physically contiguous ranges, and there are already cases where page
isolation will simply move (physically close) free pages to (currently)
the head of the freelists via move_freepages_block() instead of shuffling.
If this becomes ever relevant, we should shuffle the whole zone when
undoing isolation of larger ranges, and after free_contig_range().

Link: https://lkml.kernel.org/r/20201005121534.15649-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page
+++ a/mm/page_alloc.c
@@ -94,6 +94,18 @@ typedef int __bitwise fpi_t;
  */
 #define FPI_SKIP_REPORT_NOTIFY	((__force fpi_t)BIT(0))
 
+/*
+ * Place the (possibly merged) page to the tail of the freelist. Will ignore
+ * page shuffling (relevant code - e.g., memory onlining - is expected to
+ * shuffle the whole zone).
+ *
+ * Note: No code should rely on this flag for correctness - it's purely
+ *       to allow for optimizations when handing back either fresh pages
+ *       (memory onlining) or untouched pages (page isolation, free page
+ *       reporting).
+ */
+#define FPI_TO_TAIL		((__force fpi_t)BIT(1))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
@@ -1044,7 +1056,9 @@ continue_merging:
 done_merging:
 	set_page_order(page, order);
 
-	if (is_shuffle_order(order))
+	if (fpi_flags & FPI_TO_TAIL)
+		to_tail = true;
+	else if (is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
@@ -3306,7 +3320,7 @@ void __putback_isolated_page(struct page
 
 	/* Return isolated page to tail of freelist. */
 	__free_one_page(page, page_to_pfn(page), zone, order, mt,
-			FPI_SKIP_REPORT_NOTIFY);
+			FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
 }
 
 /*
_
