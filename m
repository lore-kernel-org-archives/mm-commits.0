Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17018C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 17:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiD2R6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 13:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376402AbiD2R6i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 13:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778EB5A159
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 10:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146A162431
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 17:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BC2C385A7;
        Fri, 29 Apr 2022 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651254917;
        bh=vxH+EqCr6DaaqgteKdAAissDnkxLuOgykT0h0CBK6Y0=;
        h=Date:To:From:Subject:From;
        b=15ldJ7kdSZPEoK1UNVviMjxqWyiDs2CaGCWmSxf59J9kTDX32SzSsTtKSZRP7TUDt
         gq8XSye5qD4uM7BJfde6/adaPjYuoGJtfTDopxicxHzQGt4vOt0HdVs+gGGo5jF3sp
         8V61ShM/T0mY1K8uwjQqGkkCWe72YL6PZsE4Q9Dg=
Date:   Fri, 29 Apr 2022 10:55:16 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        akpm@linux-foundation.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-filter-empty-page_list-at-the-beginning.patch added to mm-unstable branch
Message-Id: <20220429175517.55BC2C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: filter empty page_list at the beginning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-filter-empty-page_list-at-the-beginning.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

