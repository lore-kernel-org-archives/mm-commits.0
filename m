Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A2FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50738207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266137;
	bh=nBwrs1GbHvWUQxAQgLYTCY0i/QXv62ZV2VkBguQwA5U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZfqRI/NEo2JpZYTDbIJWvGboSxCdTWeL6F4D6kX4MvKfZQ5ewMKBofz+dOyesjfan
	 n2QrYUBDl/F1cpCPrqwAaOkLZA/5jPo3wFJxJwGaflLvpZ8QvmE8cRFBxJ7wpTz5b2
	 6AjbGtdbsKKX+Op1D2mb/kfL7cx1Zpj6pxGbxjA0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLVCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B8020774;
        Wed, 12 Aug 2020 21:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266136;
        bh=nBwrs1GbHvWUQxAQgLYTCY0i/QXv62ZV2VkBguQwA5U=;
        h=Date:From:To:Subject:From;
        b=DEQuNm/ArZd3s0WqigVXjkNFESUK6JU68LYBF+voig1yWYYvZJwcWgt4WjpYlcDr9
         8jhL2YC20Qg7g4evzp58XenvVKQHoY3c/d9e7X59KYShLo9sB5bX3d/InSyJkb0OY8
         KMaliUKWTDp79QUl/R6d9XrPzeTwePUOLxew2CRw=
Date:   Wed, 12 Aug 2020 14:02:16 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        song.bao.hua@hisilicon.com
Subject:  [merged] mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
 removed from -mm tree
Message-ID: <20200812210216.OgIUSC2ZG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix the name of hugetlb CMA
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-the-name-of-hugetlb-cma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm: hugetlb: fix the name of hugetlb CMA

Once we enable CMA_DEBUGFS, we will get the below errors: directory
'cma-hugetlb' with parent 'cma' already present.

We should have different names for different CMA areas.

Link: http://lkml.kernel.org/r/20200616223131.33828-3-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-the-name-of-hugetlb-cma
+++ a/mm/hugetlb.c
@@ -5707,12 +5707,14 @@ void __init hugetlb_cma_reserve(int orde
 	reserved = 0;
 	for_each_node_state(nid, N_ONLINE) {
 		int res;
+		char name[20];
 
 		size = min(per_node, hugetlb_cma_size - reserved);
 		size = round_up(size, PAGE_SIZE << order);
 
+		snprintf(name, 20, "hugetlb%d", nid);
 		res = cma_declare_contiguous_nid(0, size, 0, PAGE_SIZE << order,
-						 0, false, "hugetlb",
+						 0, false, name,
 						 &hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


