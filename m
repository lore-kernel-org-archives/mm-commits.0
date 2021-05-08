Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1F6C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51AC061430
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhEHWtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWtV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5CF46101D;
        Sat,  8 May 2021 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514099;
        bh=L4Ej7gzUBmbf/ICfF8dYQEBPPr1qgTupiS/+xNH6DR4=;
        h=Date:From:To:Subject:From;
        b=Z94vsx75mcJfT7raY4rfgQrJ+HQPOJ3VbJJxfKIzGT7wRBvngYFC9YOzBtGcBwY2o
         or4n7F1IKpC/mRCnS5LL3O2IycX2YElz0N67tjQonXt6+xLIVfJ0x2qPbwogxLbZ+O
         wpAhjWHHMkd9f9kGHm0XfxXSgquJsey1dolKykxA=
Date:   Sat, 08 May 2021 15:48:18 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, ben.widawsky@intel.com, cai@lca.pw,
        cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dwagner@suse.de,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        tobin@kernel.org, ying.huang@intel.com
Subject:  [merged]
 mm-vmscan-replace-implicit-reclaim_zone-checks-with-explicit-checks.patch
 removed from -mm tree
Message-ID: <20210508224818.E-rM4zZLo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: replace implicit RECLAIM_ZONE checks with explicit checks
has been removed from the -mm tree.  Its filename was
     mm-vmscan-replace-implicit-reclaim_zone-checks-with-explicit-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/vmscan: replace implicit RECLAIM_ZONE checks with explicit checks

RECLAIM_ZONE was assumed to be unused because it was never explicitly used
in the kernel.  However, there were a number of places where it was
checked implicitly by checking 'node_reclaim_mode' for a zero value.

These zero checks are not great because it is not obvious what a zero mode
*means* in the code.  Replace them with a helper which makes it more
obvious: node_reclaim_enabled().

This helper also provides a handy place to explicitly check the
RECLAIM_ZONE bit itself.  Check it explicitly there to make it more
obvious where the bit can affect behavior.

This should have no functional impact.

Link: https://lkml.kernel.org/r/20210219172559.BF589C44@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 +++++++
 mm/khugepaged.c      |    2 +-
 mm/page_alloc.c      |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-replace-implicit-reclaim_zone-checks-with-explicit-checks
+++ a/include/linux/swap.h
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/atomic.h>
 #include <linux/page-flags.h>
+#include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
 struct notifier_block;
@@ -378,6 +379,12 @@ extern int sysctl_min_slab_ratio;
 #define node_reclaim_mode 0
 #endif
 
+static inline bool node_reclaim_enabled(void)
+{
+	/* Is any node_reclaim_mode bit set? */
+	return node_reclaim_mode & (RECLAIM_ZONE|RECLAIM_WRITE|RECLAIM_UNMAP);
+}
+
 extern void check_move_unevictable_pages(struct pagevec *pvec);
 
 extern int kswapd_run(int nid);
--- a/mm/khugepaged.c~mm-vmscan-replace-implicit-reclaim_zone-checks-with-explicit-checks
+++ a/mm/khugepaged.c
@@ -809,7 +809,7 @@ static bool khugepaged_scan_abort(int ni
 	 * If node_reclaim_mode is disabled, then no extra effort is made to
 	 * allocate memory locally.
 	 */
-	if (!node_reclaim_mode)
+	if (!node_reclaim_enabled())
 		return false;
 
 	/* If there is a count for this node already, it must be acceptable */
--- a/mm/page_alloc.c~mm-vmscan-replace-implicit-reclaim_zone-checks-with-explicit-checks
+++ a/mm/page_alloc.c
@@ -3968,7 +3968,7 @@ retry:
 			if (alloc_flags & ALLOC_NO_WATERMARKS)
 				goto try_this_zone;
 
-			if (node_reclaim_mode == 0 ||
+			if (!node_reclaim_enabled() ||
 			    !zone_allows_reclaim(ac->preferred_zoneref->zone, zone))
 				continue;
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


