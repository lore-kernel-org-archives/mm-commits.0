Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF068C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 17:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379488AbiD2R6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 13:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376402AbiD2R6l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 13:58:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33D56162B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 10:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEA16B83698
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 17:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3702FC385A7;
        Fri, 29 Apr 2022 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651254919;
        bh=xzNBidCXTn8ej4wyeJ1D+De32lc+pJKXrp67s7+jnbI=;
        h=Date:To:From:Subject:From;
        b=cJlgrpf4pYGAeYox3Kp5wOZr+ZCESFX6LFNQE3Y9RcqOlunAYL3KtJimVpo0eYJWU
         UzgBLIMYMNgRNu27ev+iM8j6dLvSaSHB0iHZ0ubdYE7mC++4aanecCVAatNtn6fZi+
         VBlWDgzzOJQIgM3fhXhM6bpndI3ho5p6vUCTO56Q=
Date:   Fri, 29 Apr 2022 10:55:18 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        akpm@linux-foundation.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch added to mm-unstable branch
Message-Id: <20220429175519.3702FC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: don't use NUMA_NO_NODE as indicator of page on different node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

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

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

