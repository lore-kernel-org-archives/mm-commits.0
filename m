Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49963C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 22:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiF2WdQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiF2WdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 18:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD813E0F
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 15:33:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A75B82726
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 22:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3742C34114;
        Wed, 29 Jun 2022 22:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656541989;
        bh=tTi8XIIITOVpprWPIOs968Fp7pl/WYSDLoGGynVodTI=;
        h=Date:To:From:Subject:From;
        b=qjSH7VcusTtEqIEfnluZJ+z2m/ZYZkF3XNNMpzBltztYg3qmssa+/wCBsIjywX1LJ
         ZbsyoBAJRJ7Ft/YTqX61cvOZ1we64Y2nxMXMbYjm7ZYOdjDfsJpPhXZwtHsYfMHnUF
         29QYpsp1HgA7rA+oYY00lpfcU6JH08mUdzT1U0dU=
Date:   Wed, 29 Jun 2022 15:33:09 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch added to mm-unstable branch
Message-Id: <20220629223309.C3742C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_maple_tree: add test for spanning store to most of the tree
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch

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
Subject: test_maple_tree: add test for spanning store to most of the tree
Date: Wed, 29 Jun 2022 15:23:51 +0000

Test spanning almost the entire tree to detect if the root is dead and the
node is placed in the wrong location.

Link: https://lkml.kernel.org/r/20220629152340.3451959-3-Liam.Howlett@oracle.com
Fixes: 1d3ae73e4e86 (test_maple_tree: Add test for spanning store to most of the tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/lib/test_maple_tree.c~lib-test_maple_tree-add-testing-for-maple-tree-fix-2
+++ a/lib/test_maple_tree.c
@@ -35685,7 +35685,6 @@ static noinline void check_spanning_writ
 	mas_set(&mas, 1205);
 	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
 	mtree_unlock(mt);
-	mt_dump(mt);
 	mt_validate(mt);
 	mtree_destroy(mt);
 
@@ -35817,6 +35816,15 @@ static noinline void check_spanning_writ
 	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
 	mtree_unlock(mt);
 	mtree_destroy(mt);
+
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= 100; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mtree_lock(mt);
+	mas_set_range(&mas, 76, 875);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mtree_unlock(mt);
 }
 
 static noinline void check_null_expand(struct maple_tree *mt)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

