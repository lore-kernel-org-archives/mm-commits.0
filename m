Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE7AC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 19:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiLPTgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 14:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLPTgP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 14:36:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F0F15832
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 11:36:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D253B621E4
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 19:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB3FC433D2;
        Fri, 16 Dec 2022 19:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671219373;
        bh=DreZ3R4WroFmOlkNRcRBZBygbvNLlzSAsx7tIDTVN1k=;
        h=Date:To:From:Subject:From;
        b=LE7TzOGQ4HumEgpN1fv4zutEAm0Hl+rQVobZ5w6Pl2SEppSNkxDu0WLkf4Fq2niko
         WemB+Fw4gdQi0sH2fJ7gFgSKFnrFgU/tD4zA8rL2hhT3KZh4XZ3nN0Y0wlv38tVWfH
         NlQ8X6e6TvB/4O58ngNX2fS0EPewYG4LM188Bqh8=
Date:   Fri, 16 Dec 2022 11:36:12 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        rppt@kernel.org, Liam.Howlett@oracle.com, avagin@gmail.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch added to mm-hotfixes-unstable branch
Message-Id: <20221216193613.1CB3FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_spanning_rebalance() on insufficient data
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_spanning_rebalance() on insufficient data
Date: Fri, 16 Dec 2022 18:53:15 +0000

Mike Rapoport contacted me off-list with a regression in running criu. 
Periodic tests fail with an RCU stall during execution.  Although rare, it
is possible to hit this with other uses so this patch should be backported
to fix the regression.

An insufficient node was causing an out-of-bounds access on the node in
mas_leaf_max_gap().  The cause was the faulty detection of the new node
being a root node when overwriting many entries at the end of the tree.

Fix the detection of a new root and ensure there is sufficient data prior
to entering the spanning rebalance loop.

Add a testcase to the maple tree test suite for this issue.

Link: https://lkml.kernel.org/r/20221216185233.2036415-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Mike Rapoport <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |    4 +++-
 lib/test_maple_tree.c |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_spanning_rebalance-on-insufficient-data
+++ a/lib/maple_tree.c
@@ -2994,7 +2994,9 @@ static int mas_spanning_rebalance(struct
 	mast->free = &free;
 	mast->destroy = &destroy;
 	l_mas.node = r_mas.node = m_mas.node = MAS_NONE;
-	if (!(mast->orig_l->min && mast->orig_r->max == ULONG_MAX) &&
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
--- a/lib/test_maple_tree.c~maple_tree-fix-mas_spanning_rebalance-on-insufficient-data
+++ a/lib/test_maple_tree.c
@@ -2498,6 +2498,25 @@ static noinline void check_dup(struct ma
 	}
 }
 
+static noinline void check_bnode_min_spanning(struct maple_tree *mt)
+{
+	int i = 50;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(9999);
+	mas_lock(&mas);
+	do {
+		mas_set_range(&mas, i*10, i*10+9);
+		mas_store(&mas, check_bnode_min_spanning);
+	} while (i--);
+
+	mas_set_range(&mas, 240, 509);
+	mas_store(&mas, NULL);
+	mas_unlock(&mas);
+	mas_destroy(&mas);
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2742,6 +2761,10 @@ static int maple_tree_seed(void)
 	check_dup(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_bnode_min_spanning(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_spanning_rebalance-on-insufficient-data.patch

