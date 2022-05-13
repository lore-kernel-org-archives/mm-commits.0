Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE40C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383682AbiEMTW2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383778AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAF53A18B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B03FB83176
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0B3C34100;
        Fri, 13 May 2022 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469698;
        bh=STZrkF+n1/BeTSIWyzQm1eVvCe4849Hi5dM1Fmn5rMk=;
        h=Date:To:From:Subject:From;
        b=bil1LRz6K2yfTG0bthO/lBtJ5Bh7jfMH2cjKnsYcJeNUKyCoSOoS00OuSQqO5U6s3
         7IJsMuVhb3WKCZGj069DiWUrZFJMrO/tBwmnTcCVwB8d3I6maPYOjJ2mBkzUPW0DH9
         DmHswiAvH6PTHPSIRrWgBjsv4z+Bveilk1RIxRX8=
Date:   Fri, 13 May 2022 12:21:37 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        akpm@linux-foundation.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-filter-empty-page_list-at-the-beginning.patch removed from -mm tree
Message-Id: <20220513192138.1F0B3C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: filter empty page_list at the beginning
has been removed from the -mm tree.  Its filename was
     mm-vmscan-filter-empty-page_list-at-the-beginning.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: filter empty page_list at the beginning

node_page_list would always be !empty on finishing the loop, except
page_list is empty.

Let's handle empty page_list before doing any real work including touching
PF_MEMALLOC flag.

Link: https://lkml.kernel.org/r/20220429014426.29223-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-filter-empty-page_list-at-the-beginning
+++ a/mm/vmscan.c
@@ -2568,9 +2568,12 @@ unsigned long reclaim_pages(struct list_
 	struct page *page;
 	unsigned int noreclaim_flag;
 
+	if (list_empty(page_list))
+		return nr_reclaimed;
+
 	noreclaim_flag = memalloc_noreclaim_save();
 
-	while (!list_empty(page_list)) {
+	do {
 		page = lru_to_page(page_list);
 		if (nid == NUMA_NO_NODE)
 			nid = page_to_nid(page);
@@ -2583,10 +2586,9 @@ unsigned long reclaim_pages(struct list_
 
 		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
 		nid = NUMA_NO_NODE;
-	}
+	} while (!list_empty(page_list));
 
-	if (!list_empty(&node_page_list))
-		nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
+	nr_reclaimed += reclaim_page_list(&node_page_list, NODE_DATA(nid));
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


