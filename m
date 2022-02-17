Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0187C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 01:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiBQB1U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:27:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiBQB1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 20:27:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80595C3304
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 17:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE9261A74
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 01:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34C6C004E1;
        Thu, 17 Feb 2022 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645061225;
        bh=zjok0Ungn9GWKDXYmh6J+DYuThzDXhwMIN8hlXjzhls=;
        h=Date:To:From:Subject:From;
        b=mbeEI1N/88ifsaXP0X0tKJ4serVP0PFYmJ/fHC8NYTN7UcnmZf4olwC9sf58+bjUV
         3ckjh8aQicmI1sTKgUU8+CID8RXFUkZy821pqEiYsEFTCQI0YRBlB+0pXKW0sDgHcx
         Xc+gzEUXjYICutPI4iKRoWLv8fFXS9WGftDWrzOQ=
Date:   Wed, 16 Feb 2022 17:27:04 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch added to -mm tree
Message-Id: <20220217012704.D34C6C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: track range of active PCP lists during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: track range of active PCP lists during bulk free

free_pcppages_bulk() frees pages in a round-robin fashion.  Originally,
this was dealing only with migratetypes but storing high-order pages means
that there can be many more empty lists that are uselessly checked.  Track
the minimum and maximum active pindex to reduce the search space.

Link: https://lkml.kernel.org/r/20220217002227.5739-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1450,6 +1450,8 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp)
 {
 	int pindex = 0;
+	int min_pindex = 0;
+	int max_pindex = NR_PCP_LISTS - 1;
 	int batch_free = 0;
 	int nr_freed = 0;
 	unsigned int order;
@@ -1475,13 +1477,20 @@ static void free_pcppages_bulk(struct zo
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

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

