From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?mm-page=5Fallocc-replace-the-definition-of-nr=5Fmigratetype?=
 =?us-ascii?Q?=5Fbits-with-pb=5Fmigratetype=5Fbits.patch?= added to -mm
 tree
Date: Wed, 24 Jun 2020 14:54:47 -0700
Message-ID: <20200624215447.CqnOe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgFXVyu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/page_alloc.c: replace the definition of NR_MIGRATETYPE_BITS with PB_migratetype_bits
has been added to the -mm tree.  Its filename is
     mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch

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
Subject: mm/page_alloc.c: replace the definition of NR_MIGRATETYPE_BITS with PB_migratetype_bits

We already have the definition of PB_migratetype_bits and current
NR_MIGRATETYPE_BITS looks like a cyclic definition.

Just use PB_migratetype_bits is enough.

Link: http://lkml.kernel.org/r/20200623124201.8199-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits
+++ a/include/linux/mmzone.h
@@ -88,8 +88,7 @@ static inline bool is_migrate_movable(in
 
 extern int page_group_by_mobility_disabled;
 
-#define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
-#define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
+#define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
 
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
