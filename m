Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D7CC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F690610E5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347567AbhIBWAb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347891AbhIBWA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6860A60F12;
        Thu,  2 Sep 2021 21:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619970;
        bh=D16OA151Vtwjrpdv0CNg/AkIJWVfNXLlsPCbXM1050U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rVR7JvjVcaKe8zL+f1ADp4WM4HB7CodAXJuckvtilgC1zGXySMAyQdug03Dus9ubH
         Ft8tQM60okzv+2TTDgDSBfMvNY5/BU82KPvMKGhaKPJcWKGULpEQ8gIc9YFTCsWod/
         2tvY1mBRFmONlDswSTE0kfCGwfmJLyR4Fg7nCGJ0=
Date:   Thu, 02 Sep 2021 14:59:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com, gthelen@google.com,
        kbusch@kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        weixugc@google.com, yang.shi@linux.alibaba.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 180/212] mm/vmscan: never demote for memcg reclaim
Message-ID: <20210902215930.MtR2KoOu5%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/vmscan: never demote for memcg reclaim

Global reclaim aims to reduce the amount of memory used on a given node or
set of nodes.  Migrating pages to another node serves this purpose.

memcg reclaim is different.  Its goal is to reduce the total memory
consumption of the entire memcg, across all nodes.  Migration does not
assist memcg reclaim because it just moves page contents between nodes
rather than actually reducing memory consumption.

Link: https://lkml.kernel.org/r/20210715055145.195411-9-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-never-demote-for-memcg-reclaim
+++ a/mm/vmscan.c
@@ -524,8 +524,13 @@ static long add_nr_deferred(long nr, str
 
 static bool can_demote(int nid, struct scan_control *sc)
 {
-	if (sc && sc->no_demotion)
-		return false;
+	if (sc) {
+		if (sc->no_demotion)
+			return false;
+		/* It is pointless to do demotion in memcg reclaim */
+		if (cgroup_reclaim(sc))
+			return false;
+	}
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
 
_
