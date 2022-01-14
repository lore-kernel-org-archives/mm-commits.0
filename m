Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E04C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiANVaG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiANVaE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:30:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F90C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D451B82A3C
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1070C36AE5;
        Fri, 14 Jan 2022 21:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195801;
        bh=/0EyKZ1tHv82sSQXJRPn5gMWoST6KcFyiEbYidvkld4=;
        h=Date:From:To:Subject:From;
        b=GWwG7UQJnfNeZN25Si364RTLVyB+g7f8uSv3rjbFjS+Pa9ZI0t5FHNnuyQ6A77uM9
         xpQZ6sAXUIyqVuz5vqXfAYs6xxAbj6bHpSQNSbnaHaU7VgEpjLgElJi63swJPJI7+z
         +rgQvYB7PKbGc/qkREJEJqq/XBMmwyjZ9A6x8Pe8=
Date:   Fri, 14 Jan 2022 13:30:00 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, colin.i.king@gmail.com,
        colin.i.king@googlemail.com, joe@perches.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [folded-merged]
 hugetlb-add-hugetlbnuma_stat-file-fix.patch removed from -mm tree
Message-ID: <20220114213000.fX6lPK4eM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix spelling mistake "hierarichal" -> "hierarchical"
has been removed from the -mm tree.  Its filename was
     hugetlb-add-hugetlbnuma_stat-file-fix.patch

This patch was dropped because it was folded into hugetlb-add-hugetlbnuma_stat-file.patch

------------------------------------------------------
From: Colin Ian King <colin.i.king@googlemail.com>
Subject: hugetlb: fix spelling mistake "hierarichal" -> "hierarchical"

There is a spelling mistake in a literal string and a comment. Fix them.

Link: https://lkml.kernel.org/r/20211125090635.23508-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb-add-hugetlbnuma_stat-file-fix
+++ a/mm/hugetlb_cgroup.c
@@ -495,11 +495,11 @@ static int hugetlb_cgroup_read_numa_stat
 	 * The hierarchical total is pretty much the value recorded by the
 	 * counter, so use that.
 	 */
-	seq_printf(seq, "%stotal=%lu", legacy ? "hierarichal_" : "",
+	seq_printf(seq, "%stotal=%lu", legacy ? "hierarchical_" : "",
 		   page_counter_read(&h_cg->hugepage[idx]) * PAGE_SIZE);
 
 	/*
-	 * For each node, transverse the css tree to obtain the hierarichal
+	 * For each node, transverse the css tree to obtain the hierarchical
 	 * node usage.
 	 */
 	for_each_node_state(nid, N_MEMORY) {
_

Patches currently in -mm which might be from colin.i.king@googlemail.com are

hugetlb-add-hugetlbnuma_stat-file.patch

