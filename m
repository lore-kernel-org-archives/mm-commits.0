Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E554C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiCVVpa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiCVVp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53EB5F8D4
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CF8961347
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFC5C340EC;
        Tue, 22 Mar 2022 21:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985419;
        bh=1sREwPqsoklvKO9TTinMABRXKUs84U+dTlddvMWZ4Sk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=QgJAwkajMt1MxK3aqVK3NEFE90p6sL9qzBbvM9GDkcTpawj0lNzhzfO5AinhNevqW
         fgfQZVTMDrLnaDNl94FS025UuK4e4fFuWd9TDPdnE+8Uxi5CZLJtRk8KjXQZL0z6OH
         7Lj1YDWcH3zGN2IFMh5234CxObWx+W8Axopzg0xI=
Date:   Tue, 22 Mar 2022 14:43:38 -0700
To:     vbabka@suse.cz, mhocko@kernel.org, dave.hansen@linux.intel.com,
        brouer@redhat.com, aaron.lu@intel.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 101/227] mm/page_alloc: drain the requested list first during bulk free
Message-Id: <20220322214339.8FFC5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
