Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EDCC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356772AbhK1ApN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:45:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356649AbhK1AnN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:43:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8151260F55
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF79C53FBF;
        Sun, 28 Nov 2021 00:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638059997;
        bh=SPjI+JyPjB6CS4JILub7GYft2+wiJaOy84r2Xa4vshM=;
        h=Date:From:To:Subject:From;
        b=GfG1VTDM6KxQV6zSGMfnp1o7yArgKb/MvcQlCBLlfNGlS2rxZ2W7u7aUVCpvHGITZ
         yeN+I0XT4esVg3eUL04ijEtalcU0c8Cb/bFJyzvH+n8ckExuuiz4SPEqOgAjf92dox
         AFVaCK/sQKYP0v7czAnLyAEPOw5X35oCie1tRFAY=
Date:   Sat, 27 Nov 2021 16:39:57 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, colin.i.king@gmail.com,
        colin.i.king@googlemail.com, joe@perches.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  + hugetlb-add-hugetlbnuma_stat-file-fix.patch added to
 -mm tree
Message-ID: <20211128003957.d6YjODi8e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: Fix spelling mistake "hierarichal" -> "hierarchical"
has been added to the -mm tree.  Its filename is
     hugetlb-add-hugetlbnuma_stat-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-hugetlbnuma_stat-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-hugetlbnuma_stat-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@googlemail.com>
Subject: hugetlb: Fix spelling mistake "hierarichal" -> "hierarchical"

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

hugetlb-add-hugetlbnuma_stat-file-fix.patch

