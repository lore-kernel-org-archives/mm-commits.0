Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C2AC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357372AbiCYBe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357500AbiCYBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316E7BF941
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5981B82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6368DC340EC;
        Fri, 25 Mar 2022 01:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171887;
        bh=7xAM+caKfN2PfsVCyYkdl2twg7m9nX7ubN9sdoXPL6o=;
        h=Date:To:From:Subject:From;
        b=xRcVUZzBLecOMOpD5URJDZJeUGMXyazVQ+QE3M5Md0SQi5kTE8oegX8BVC2TAEpZG
         Hmr1JPyg1GdD6ezeNdbG5efW1lzHYck/mj/24cg8P5MOkSrBguUveBIDOJPHlzm+gt
         52yOwY3l8TFERXctCJ3L9/JGD/vIpwG6hHn6Eu1w=
Date:   Thu, 24 Mar 2022 18:31:26 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch removed from -mm tree
Message-Id: <20220325013127.6368DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: drain the requested list first during bulk free
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-drain-the-requested-list-first-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1460,6 +1460,10 @@ static void free_pcppages_bulk(struct zo
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


