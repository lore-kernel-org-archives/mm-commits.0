Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA63C4332E
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE6A206D6
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhA0Csm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729685AbhAZVBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 16:01:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7E5022B3B;
        Tue, 26 Jan 2021 21:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611694856;
        bh=IFHhe3ITsobLhgAcRYwFFpePX/Meb27ck29Ubb9CBQU=;
        h=Date:From:To:Subject:From;
        b=tVBczDy4kTH88kTK2syBkRtnXmOPhlnx7x9fJb1DbNBWGx6Zwb0TN06dvRmQEqbON
         VKugdd96NpTZ8aNipJkxtdvfvZEc8akn5BaLgcdRjm+w5x40+KDuYvaGHVz6GAvlSm
         /SOAqKp3Q4gNI5/8OLOFLqUVfa+bmpP5xzgtzYIQ=
Date:   Tue, 26 Jan 2021 13:00:55 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  + mm-hugetlb-simplify-the-calculation-of-variables.patch
 added to -mm tree
Message-ID: <20210126210055.U0utagfxC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: simplify the calculation of variables
has been added to the -mm tree.  Its filename is
     mm-hugetlb-simplify-the-calculation-of-variables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-simplify-the-calculation-of-variables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-simplify-the-calculation-of-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-simplify-the-calculation-of-variables
+++ a/mm/hugetlb.c
@@ -3417,8 +3417,7 @@ static unsigned int allowed_mems_nr(stru
 	mpol_allowed = policy_nodemask_current(gfp_mask);
 
 	for_each_node_mask(node, cpuset_current_mems_allowed) {
-		if (!mpol_allowed ||
-		    (mpol_allowed && node_isset(node, *mpol_allowed)))
+		if (!mpol_allowed || node_isset(node, *mpol_allowed))
 			nr += array[node];
 	}
 
_

Patches currently in -mm which might be from abaci-bugfix@linux.alibaba.com are

mm-swap_slotsc-remove-redundant-null-check.patch
mm-memcontrol-remove-redundant-null-check.patch
vmalloc-remove-redundant-null-check.patch
mm-hugetlb-simplify-the-calculation-of-variables.patch

