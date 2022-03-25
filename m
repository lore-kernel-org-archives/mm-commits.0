Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CC3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242461AbiCYBev (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357496AbiCYBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87CDBF53C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BA21B8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC86C340EC;
        Fri, 25 Mar 2022 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171885;
        bh=nVPiZZdhXRPE9ojV4144Q2j00eY0kAybmTpxmW39Y+U=;
        h=Date:To:From:Subject:From;
        b=QmTudGgEWgRxxBPgDGA/jXdcXw44f3baPcnFSpP3bOSGYyaES3N5qWkIf4JLqVgsp
         pOm7eJBD2uZbYFzM/50GoNd5bEdzDQxI2+q74B005D6ozuT0FO8UCv3qrQYq+cBdxI
         617ozgLHYNxSZSKbb5+RjmENiSerqRCKpPMN5hYU=
Date:   Thu, 24 Mar 2022 18:31:24 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch removed from -mm tree
Message-Id: <20220325013125.4BC86C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: track range of active PCP lists during bulk free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: track range of active PCP lists during bulk free

free_pcppages_bulk() frees pages in a round-robin fashion.  Originally,
this was dealing only with migratetypes but storing high-order pages means
that there can be many more empty lists that are uselessly checked.  Track
the minimum and maximum active pindex to reduce the search space.

Link: https://lkml.kernel.org/r/20220217002227.5739-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1447,6 +1447,8 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp)
 {
 	int pindex = 0;
+	int min_pindex = 0;
+	int max_pindex = NR_PCP_LISTS - 1;
 	int batch_free = 0;
 	int nr_freed = 0;
 	unsigned int order;
@@ -1472,13 +1474,20 @@ static void free_pcppages_bulk(struct zo
 		 */
 		do {
 			batch_free++;
-			if (++pindex == NR_PCP_LISTS)
-				pindex = 0;
+			if (++pindex > max_pindex)
+				pindex = min_pindex;
 			list = &pcp->lists[pindex];
-		} while (list_empty(list));
+			if (!list_empty(list))
+				break;
+
+			if (pindex == max_pindex)
+				max_pindex--;
+			if (pindex == min_pindex)
+				min_pindex++;
+		} while (1);
 
 		/* This is the only non-empty list. Free them all. */
-		if (batch_free == NR_PCP_LISTS)
+		if (batch_free >= max_pindex - min_pindex)
 			batch_free = count;
 
 		order = pindex_to_order(pindex);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


