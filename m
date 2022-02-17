Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E72C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 01:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiBQB10 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:27:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiBQB1W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 20:27:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D6C3304
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 17:27:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82DC861C2A
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 01:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AA7C004E1;
        Thu, 17 Feb 2022 01:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645061229;
        bh=GqSEj1uAYtoq/3d4GW4glwmZJiA9zV0nfnar6p9+xBs=;
        h=Date:To:From:Subject:From;
        b=SG0p9iYjIvg9wbvprV/VDxvQOI0Ub7xWAa2KjCK5XGfjg/950rLDOTjs6s2jNfF/d
         oiIElaHx8u+eNXaReT97b33lLChPX8O6b7eYyENcqtrItQ4t8NSqNMielEEOgYxfXp
         pVoeQOTtDxvaIxNxbxRIKtQXDnGuH4XEWJZJA8tA=
Date:   Wed, 16 Feb 2022 17:27:08 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch added to -mm tree
Message-Id: <20220217012708.D4AA7C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: drain the requested list first during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch

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
Subject: mm/page_alloc: drain the requested list first during bulk free

Prior to the series, pindex 0 (order-0 MIGRATE_UNMOVABLE) was always
skipped first and the precise reason is forgotten.  A potential reason may
have been to artificially preserve MIGRATE_UNMOVABLE but there is no
reason why that would be optimal as it depends on the workload.  The more
likely reason is that it was less complicated to do a pre-increment
instead of a post-increment in terms of overall code flow.  As
free_pcppages_bulk() now typically receives the pindex of the PCP list
that exceeded high, always start draining that list.

Link: https://lkml.kernel.org/r/20220217002227.5739-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-drain-the-requested-list-first-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1463,6 +1463,10 @@ static void free_pcppages_bulk(struct zo
 	 * below while (list_empty(list)) loop.
 	 */
 	count = min(pcp->count, count);
+
+	/* Ensure requested pindex is drained first. */
+	pindex = pindex - 1;
+
 	while (count > 0) {
 		struct list_head *list;
 		int nr_pages;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

