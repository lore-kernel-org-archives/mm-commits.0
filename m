Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09359C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiCVVp3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbiCVVpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444F75F8C2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D942FB81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B0DC340F3;
        Tue, 22 Mar 2022 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985413;
        bh=6rFJhdM8DpdUmiWloX+OzeAm5fksq9BQ8wrsG4qfAa8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jWC7TeGPiqTuOVK4FvS7uYiFQn+RRjUWSjjmwX83IlZBrdfcs9usbJ3sOxSapLi3B
         4u0Tuw855LHK3sHcP22fJJ6t5MlqWPn+vt9nQmJoysibiIMtQ4FLhLP6zctzB2tRbB
         wKYP8cUq7TmzqRBOqf1PiFtw+eJXTGtkk7gWRH7s=
Date:   Tue, 22 Mar 2022 14:43:33 -0700
To:     vbabka@suse.cz, mhocko@kernel.org, dave.hansen@linux.intel.com,
        brouer@redhat.com, aaron.lu@intel.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 099/227] mm/page_alloc: track range of active PCP lists during bulk free
Message-Id: <20220322214333.98B0DC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
