Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34013C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB2561131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhICVBr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350526AbhICVBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9A2F6112E;
        Fri,  3 Sep 2021 21:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702835;
        bh=fnvX/1cAl5LugXmThQd6Cu2RFJ9BlIk8vUvgfX3+ZP0=;
        h=Date:From:To:Subject:From;
        b=ELfKVLc2Oj2L+v+iesnT7SBokpTUg8yUm+TuyYPCmAqxt1VnmW0QbmIKFKTObMTlZ
         tfuARvQ4as6hpisOThHg3+z+tMmJZGY+XZnJdVpt9m/kAQwUpBGIbIxbmFYPL0hBG7
         3Qx0XK1/1QfSdBgarFfaEgtSTTJqF2r8vzkv+WLU=
Date:   Fri, 03 Sep 2021 14:00:34 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch
 removed from -mm tree
Message-ID: <20210903210034.sHgqXh4oa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: add helper for querying ability to age anonymous pages
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/vmscan: add helper for querying ability to age anonymous pages

Anonymous pages are kept on their own LRU(s).  These lists could
theoretically always be scanned and maintained.  But, without swap, there
is currently nothing the kernel can *do* with the results of a scanned,
sorted LRU for anonymous pages.

A check for '!total_swap_pages' currently serves as a valid check as to
whether anonymous LRUs should be maintained.  However, another method will
be added shortly: page demotion.

Abstract out the 'total_swap_pages' checks into a helper, give it a
logically significant name, and check for the possibility of page
demotion.

[dave.hansen@linux.intel.com: v11]
  Link: https://lkml.kernel.org/r/20210715055145.195411-7-ying.huang@intel.com
  Link: https://lkml.kernel.org/r/20210721063926.3024591-6-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210715055145.195411-7-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages
+++ a/mm/vmscan.c
@@ -2734,6 +2734,21 @@ out:
 	}
 }
 
+/*
+ * Anonymous LRU management is a waste if there is
+ * ultimately no way to reclaim the memory.
+ */
+static bool can_age_anon_pages(struct pglist_data *pgdat,
+			       struct scan_control *sc)
+{
+	/* Aging the anon LRU is valuable if swap is present: */
+	if (total_swap_pages > 0)
+		return true;
+
+	/* Also valuable if anon pages can be demoted: */
+	return can_demote(pgdat->node_id, sc);
+}
+
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
@@ -2843,7 +2858,8 @@ static void shrink_lruvec(struct lruvec
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (total_swap_pages && inactive_is_low(lruvec, LRU_INACTIVE_ANON))
+	if (can_age_anon_pages(lruvec_pgdat(lruvec), sc) &&
+	    inactive_is_low(lruvec, LRU_INACTIVE_ANON))
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
 }
@@ -3678,7 +3694,7 @@ static void age_active_anon(struct pglis
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	if (!total_swap_pages)
+	if (!can_age_anon_pages(pgdat, sc))
 		return;
 
 	lruvec = mem_cgroup_lruvec(NULL, pgdat);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


