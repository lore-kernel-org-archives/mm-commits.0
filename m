Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A97DC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C6261074
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345768AbhIBVVD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344043AbhIBVVC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D2406102A;
        Thu,  2 Sep 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617604;
        bh=RCycvDPeS4Z5RKTcWSR/+kuDZmLBbcPk0L0W4/+PGAY=;
        h=Date:From:To:Subject:From;
        b=jNoWsjU5ejscinNAKW9+McVt6+qe/DiyN2jAvnJhCIJojzTAwWikhjKJiWAKY1h1S
         0NOV3ECwLU6GreZz4AzvNYeQwsdpBzYbCo71oNbsln3lbdn3UQqXtWQMUqaLhtjFkO
         FVr03p0c5+qZQKKSzY6k9cP2LeVJjlS93VzTMdAQ=
Date:   Thu, 02 Sep 2021 14:20:03 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [folded-merged]
 mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch
 removed from -mm tree
Message-ID: <20210902212003.ha9pLFGyX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch

This patch was dropped because it was folded into mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11

Rename can_demote_anon_pages() to can_demote() to reflect the fact that
the function is for anon and file pages.

Link: https://lkml.kernel.org/r/20210715055145.195411-7-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210721063926.3024591-6-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11
+++ a/mm/vmscan.c
@@ -2753,7 +2753,7 @@ static bool can_age_anon_pages(struct pg
 		return true;
 
 	/* Also valuable if anon pages can be demoted: */
-	return can_demote_anon_pages(pgdat->node_id, sc);
+	return can_demote(pgdat->node_id, sc);
 }
 
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-numa-automatically-generate-node-migration-order.patch
mm-migrate-update-node-demotion-order-on-hotplug-events.patch
mm-migrate-demote-pages-during-reclaim.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch
mm-vmscan-never-demote-for-memcg-reclaim.patch
mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch

