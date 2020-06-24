From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 14:54:51 -0700
Message-ID: <20200624215451.3-Wla%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390200AbgFXVyx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/page_alloc.c: extract the common part in pfn_to_bitidx()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc.c: extract the common part in pfn_to_bitidx()

The return value calculation is the same both for SPARSEMEM or not.

Just take it out.

Link: http://lkml.kernel.org/r/20200623124201.8199-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx
+++ a/mm/page_alloc.c
@@ -462,11 +462,10 @@ static inline int pfn_to_bitidx(struct p
 {
 #ifdef CONFIG_SPARSEMEM
 	pfn &= (PAGES_PER_SECTION-1);
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
 	pfn = pfn - round_down(page_zone(page)->zone_start_pfn, pageblock_nr_pages);
-	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
+	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 }
 
 /**
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
