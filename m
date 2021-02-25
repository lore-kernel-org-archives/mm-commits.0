Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A09C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB9DC64F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhBYTcU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhBYTaF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A799864F9E;
        Thu, 25 Feb 2021 19:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280609;
        bh=P7/3rMlRee4t5TikkM9HpwXv+M+kLi92Vgx4lJoI2a8=;
        h=Date:From:To:Subject:From;
        b=SuxV0OCl+t0+Qe7EZ6lVCbGzISBlfit3mQz/ORkjAxOq8uMY99WLAkvIOTFghRAmJ
         vzhCULTSmixJHglelOVpbDY+1LyyeRyP2pBwL9KgQg+7eQSeKtvaZSkUXNFmGc+m3f
         E+fLKmsm1up2VZVCAMzSc4Q8uzLyouSgwMVR7+mk=
Date:   Thu, 25 Feb 2021 11:16:49 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-simplify-the-calculation-of-variables.patch removed from -mm
 tree
Message-ID: <20210225191649.avcPkItzh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: simplify the calculation of variables
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-simplify-the-calculation-of-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: mm/hugetlb: simplify the calculation of variables

Fix the following coccicheck warnings:

./mm/hugetlb.c:3372:20-22: WARNING !A || A && B is equivalent to
!A || B.

Link: https://lkml.kernel.org/r/1611643468-52233-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-simplify-the-calculation-of-variables
+++ a/mm/hugetlb.c
@@ -3420,8 +3420,7 @@ static unsigned int allowed_mems_nr(stru
 	mpol_allowed = policy_nodemask_current(gfp_mask);
 
 	for_each_node_mask(node, cpuset_current_mems_allowed) {
-		if (!mpol_allowed ||
-		    (mpol_allowed && node_isset(node, *mpol_allowed)))
+		if (!mpol_allowed || node_isset(node, *mpol_allowed))
 			nr += array[node];
 	}
 
_

Patches currently in -mm which might be from abaci-bugfix@linux.alibaba.com are


