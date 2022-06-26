Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82729C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiFZUjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFZUjk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0EEDD8
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26089B80DFB
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE263C34114;
        Sun, 26 Jun 2022 20:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275976;
        bh=/jTK6Yh1ajMc1lXsA3bE7dH25aO0ZIAe/IjK+T2vY+E=;
        h=Date:To:From:Subject:From;
        b=DsMLMEPIKu3cY/9k1fRTSOJKkKmKrTp6qyaqt7VQ7U06w3+8EJbTo0Ine8XaFsQER
         ITrTwzTBNBAOK4g1BjwBCf5gZ4ijBpjXwO2INc0gYEx/qZOSi2SMpKQnOrBEcJRjXA
         J23gSF/v3dYLG/iAsnr+n63qWHDlPf9Wfj201JsM=
Date:   Sun, 26 Jun 2022 13:39:36 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_maple_tree-add-testing-for-maple-tree-fix.patch added to mm-unstable branch
Message-Id: <20220626203936.BE263C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_maple_tree: add test for spanning store of entire range
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
Subject: test_maple_tree: add test for spanning store of entire range
Date: Sat, 25 Jun 2022 00:39:07 +0000

Entire range store over an existing tree would cause an underflow in
mas_spanning_store() when the tree is multiple levels.  Add a testcase to
ensure it doesn't happen again.

Link: https://lkml.kernel.org/r/20220625003854.1230114-3-Liam.Howlett@oracle.com
Fixes: 51282228cdd4 (lib/test_maple_tree: add testing for maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/lib/test_maple_tree.c~lib-test_maple_tree-add-testing-for-maple-tree-fix
+++ a/lib/test_maple_tree.c
@@ -35676,6 +35676,19 @@ static noinline void check_spanning_writ
 	mtree_unlock(mt);
 	mtree_destroy(mt);
 
+	for (i = 1; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	mtree_lock(mt);
+	mas_set_range(&mas, 9, 50006); /* Will expand to 0 - ULONG_MAX */
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mas_set(&mas, 1205);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	mtree_unlock(mt);
+	mt_dump(mt);
+	mt_validate(mt);
+	mtree_destroy(mt);
+
 	/* Test spanning store that requires a right cousin rebalance */
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	for (i = 0; i <= max; i++)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

