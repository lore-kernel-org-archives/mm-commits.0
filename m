Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1B8C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 19:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245347AbiEKTA4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 15:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345744AbiEKTAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 15:00:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE26D5F4A
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 12:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88DDB6106E
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC05C340EE;
        Wed, 11 May 2022 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652295644;
        bh=QaRz9XJit5PzWG6mvHI9V38dMNPqpKuWf+OfqRJi8Xs=;
        h=Date:To:From:Subject:From;
        b=qcMPvzvB54yEFYIQOjYFf7zFPAQFMImVmxiECyEeXIBxpcYQSda0pfhqJIKAk3BwT
         OzOSlogziJdUAuCuu3yyiO6EOcMLFFzwxY/RDHVj9sXHlrsz3UdunwZLFuBuPELm34
         yueO8VG2ecj5HaFf3WPHTQwXaH6ycXrTjuV3t8jI=
Date:   Wed, 11 May 2022 12:00:43 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_maple_tree-add-testing-for-maple-tree-fix.patch added to mm-unstable branch
Message-Id: <20220511190043.DBC05C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_maple_tree: add null expansion tests
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_maple_tree-add-testing-for-maple-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_maple_tree-add-testing-for-maple-tree-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: test_maple_tree: add null expansion tests

Link: https://lkml.kernel.org/r/20220511144304.1430851-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   55 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/lib/test_maple_tree.c~lib-test_maple_tree-add-testing-for-maple-tree-fix
+++ a/lib/test_maple_tree.c
@@ -35537,6 +35537,57 @@ static noinline void check_root_expand(s
 	mas_unlock(&mas);
 }
 
+static noinline void check_null_expand(struct maple_tree *mt)
+{
+	unsigned long i, max = 100;
+	unsigned char data_end;
+	MA_STATE(mas, mt, 959, 959);
+
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+	/* Test expanding null at start. */
+	mas_walk(&mas);
+	data_end = mas_data_end(&mas);
+	mas_set_range(&mas, 959, 963);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, mtree_load(mt, 963) != NULL);
+	MT_BUG_ON(mt, data_end != mas_data_end(&mas));
+
+	/* Test expanding null at end. */
+	mas_set(&mas, 880);
+	mas_walk(&mas);
+	data_end = mas_data_end(&mas);
+	mas_set_range(&mas, 884, 887);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, mtree_load(mt, 884) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 889) != NULL);
+	MT_BUG_ON(mt, data_end != mas_data_end(&mas));
+
+	/* Test expanding null at start and end. */
+	mas_set(&mas, 890);
+	mas_walk(&mas);
+	data_end = mas_data_end(&mas);
+	mas_set_range(&mas, 900, 905);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, mtree_load(mt, 899) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 900) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 905) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 906) != NULL);
+	MT_BUG_ON(mt, data_end - 2 != mas_data_end(&mas));
+
+	/* Test expanding null across multiple slots. */
+	mas_set(&mas, 800);
+	mas_walk(&mas);
+	data_end = mas_data_end(&mas);
+	mas_set_range(&mas, 810, 825);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, mtree_load(mt, 809) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 810) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 825) != NULL);
+	MT_BUG_ON(mt, mtree_load(mt, 826) != NULL);
+	MT_BUG_ON(mt, data_end - 4 != mas_data_end(&mas));
+}
+
 static noinline void check_gap_combining(struct maple_tree *mt)
 {
 	struct maple_enode *mn1, *mn2;
@@ -37627,6 +37678,10 @@ static int maple_tree_seed(void)
 	check_new_node(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_null_expand(&tree);
+	mtree_destroy(&tree);
+
 	mt_init_flags(&tree, 0);
 	check_dfs_preorder(&tree);
 	mtree_destroy(&tree);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch

