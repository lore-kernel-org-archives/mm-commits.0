Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F93C43334
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiFXTIR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiFXTIO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:08:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9C632053
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C90B5B82B92
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A170C34114;
        Fri, 24 Jun 2022 19:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656097690;
        bh=EHyp0sSiB7kRIgIZxxhghoeYu7GIDITw0Q7RVarS9Ms=;
        h=Date:To:From:Subject:From;
        b=XH0UOtcY7E005C3ADW3kZLT6ibQheKP+OPZURJnXC3H+cp1dV+LnlYJhYM+UqBm20
         dYeseOnBoXP92m6IvFSP8GNHtwo+Ermz1t/NCwQdyvbJvOU4q4DMuM0ASAhIHaNl1+
         X6q8/2EU8jMfdT3C34PqyUUOgDGk7hLtqcWfC+OE=
Date:   Fri, 24 Jun 2022 12:08:09 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, hughd@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch added to mm-unstable branch
Message-Id: <20220624190810.7A170C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use only one PCP list for THP-sized allocations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: use only one PCP list for THP-sized allocations
Date: Fri, 24 Jun 2022 13:54:18 +0100

The per_cpu_pages is cache-aligned on a standard x86-64 distribution
configuration but a later patch will add a new field which would push the
structure into the next cache line.  Use only one list to store THP-sized
pages on the per-cpu list.  This assumes that the vast majority of
THP-sized allocations are GFP_MOVABLE but even if it was another type, it
would not contribute to serious fragmentation that potentially causes a
later THP allocation failure.  Align per_cpu_pages on the cacheline
boundary to ensure there is no false cache sharing.

After this patch, the structure sizing is;

struct per_cpu_pages {
        int                        count;                /*     0     4 */
        int                        high;                 /*     4     4 */
        int                        batch;                /*     8     4 */
        short int                  free_factor;          /*    12     2 */
        short int                  expire;               /*    14     2 */
        struct list_head           lists[13];            /*    16   208 */

        /* size: 256, cachelines: 4, members: 6 */
        /* padding: 32 */
} __attribute__((__aligned__(64)));

Link: https://lkml.kernel.org/r/20220624125423.6126-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++++----
 mm/page_alloc.c        |    4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations
+++ a/include/linux/mmzone.h
@@ -355,15 +355,18 @@ enum zone_watermarks {
 };
 
 /*
- * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER plus one additional
- * for pageblock size for THP if configured.
+ * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER. One additional list
+ * for THP which will usually be GFP_MOVABLE. Even if it is another type,
+ * it should not contribute to serious fragmentation causing THP allocation
+ * failures.
  */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define NR_PCP_THP 1
 #else
 #define NR_PCP_THP 0
 #endif
-#define NR_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1 + NR_PCP_THP))
+#define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
+#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
 
 /*
  * Shift to encode migratetype and order in the same integer, with order
@@ -389,7 +392,7 @@ struct per_cpu_pages {
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[NR_PCP_LISTS];
-};
+} ____cacheline_aligned_in_smp;
 
 struct per_cpu_zonestat {
 #ifdef CONFIG_SMP
--- a/mm/page_alloc.c~mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations
+++ a/mm/page_alloc.c
@@ -653,7 +653,7 @@ static inline unsigned int order_to_pind
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != pageblock_order);
-		base = PAGE_ALLOC_COSTLY_ORDER + 1;
+		return NR_LOWORDER_PCP_LISTS;
 	}
 #else
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
@@ -667,7 +667,7 @@ static inline int pindex_to_order(unsign
 	int order = pindex / MIGRATE_PCPTYPES;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
+	if (pindex == NR_LOWORDER_PCP_LISTS)
 		order = pageblock_order;
 #else
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

