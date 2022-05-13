Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3039C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383750AbiEMTWb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383782AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CF836151
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0F97CE330E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D866C34117;
        Fri, 13 May 2022 19:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469699;
        bh=uElaepSXzQgDJ+XJLw5ffeq0v35L6sW+xLPvr7pka80=;
        h=Date:To:From:Subject:From;
        b=gos+Z85QQ3dS0qdnz98MSO9jjqQcfgMMkFbonxCTqu8MjymJ2CLOKFn3RcBZIVK0S
         55aII8GzrC9pCYcJiOa2UEY4RclD6VQfgS0tgLMh+uvHoP0ut9X5dlFL2vCu2b64U4
         p2K3ywSL1I7McYRQyraWSOwomln4cizfAoNUkCmw=
Date:   Fri, 13 May 2022 12:21:38 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        akpm@linux-foundation.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch removed from -mm tree
Message-Id: <20220513192139.1D866C34117@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: don't use NUMA_NO_NODE as indicator of page on different node
has been removed from the -mm tree.  Its filename was
     mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: don't use NUMA_NO_NODE as indicator of page on different node

Now we are sure there is at least one page on page_list, so it is safe to
get the nid of it.  This means it is not necessary to use NUMA_NO_NODE as
an indicator for the beginning of iteration or a page on different node.

Link: https://lkml.kernel.org/r/20220429014426.29223-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node
+++ a/mm/vmscan.c
@@ -2562,7 +2562,7 @@ static unsigned int reclaim_page_list(st
 
 unsigned long reclaim_pages(struct list_head *page_list)
 {
-	int nid = NUMA_NO_NODE;
+	int nid;
 	unsigned int nr_reclaimed = 0;
 	LIST_HEAD(node_page_list);
 	struct page *page;
@@ -2573,10 +2573,9 @@ unsigned long reclaim_pages(struct list_
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
+	nid = page_to_nid(lru_to_page(page_list));
 	do {
 		page = lru_to_page(page_list);
-		if (nid == NUMA_NO_NODE)
-			nid = page_to_nid(page);
 
 		if (nid == page_to_nid(page)) {
 			ClearPageActive(page);
@@ -2585,7 +2584,7 @@ unsigned long reclaim_pages(struct list_
 		}
 
 		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
-		nid = NUMA_NO_NODE;
+		nid = page_to_nid(lru_to_page(page_list));
 	} while (!list_empty(page_list));
 
 	nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


