Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4FFC43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiFOUTV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244905AbiFOUSh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945743FBC5
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19DE261597
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0A2C3411B;
        Wed, 15 Jun 2022 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655324315;
        bh=CDYWUnTfjy9kLMgjBCQvDHPXo3wLqANUBOxRf9Y9mxU=;
        h=Date:To:From:Subject:From;
        b=xaMz7cHlMTfUNgbTRYciUmc7YF5vcH2J5Q9w05MEqYLW1lcu7Md0SWQpO6ccpaWn0
         6vALnWrnQZOE+Gr6091tkRzyZ1Oe8Tsgd3mhtAk2AhxLIHl3L4LOLAPQUQQBVlNUzB
         Mctq6QPfOGR6uZgJM5FnvktF/WfcOMJ7HMESfVCs=
Date:   Wed, 15 Jun 2022 13:18:34 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-9.patch added to mm-unstable branch
Message-Id: <20220615201835.6C0A2C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: make mas_prealloc() error checking more generic
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-9.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-9.patch

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
Subject: maple_tree: make mas_prealloc() error checking more generic
Date: Wed, 15 Jun 2022 17:42:20 +0000

Return the error regardless of what it is.  This is a safer option.

Link: https://lkml.kernel.org/r/20220615174213.738849-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-9
+++ a/lib/maple_tree.c
@@ -5670,16 +5670,15 @@ void mas_store_prealloc(struct ma_state
  */
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
-
 	mas_set_alloc_req(mas, 1 + mas_mt_height(mas) * 3);
 	mas_alloc_nodes(mas, gfp);
-	if (likely(mas->node != MA_ERROR(-ENOMEM)))
+	if (likely(!mas_is_err(mas)))
 		return 0;
 
 	mas_set_alloc_req(mas, 0);
 	mas_destroy(mas);
 	mas->node = MAS_START;
-	return -ENOMEM;
+	return xa_err(mas->node);
 }
 
 /*
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
maple-tree-add-new-data-structure-fix-9.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-3.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

