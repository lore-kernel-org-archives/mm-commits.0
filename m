Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D857BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiFQXJp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378993AbiFQXJo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57F5C86C
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0299F61562
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FC0C3411B;
        Fri, 17 Jun 2022 23:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507382;
        bh=7HwCSiTB6XPB6m58RCI3KXUjtbxlu16+VkQxRNIdP2s=;
        h=Date:To:From:Subject:From;
        b=XdySlLCouLQbhlf7FvBG7nWK/AzH9xQdeh8D+uGoZG0o5XVHu6uufikKAVwJCC0VB
         okXUQtIx+2oKRMDSly00ei+mHhQ56MQ+a8iwowNG2JvNXJKhJMYoOyO0aVt1grUhB2
         K5jxdMSDXJLW6w7kkUl7skADLEuLtGLBU5nbwA4w=
Date:   Fri, 17 Jun 2022 16:09:41 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        quic_qiancai@quicinc.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-10.patch added to mm-unstable branch
Message-Id: <20220617230942.58FC0C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix return from mas_prealloc()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-10.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-10.patch

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
Subject: maple_tree: fix return from mas_prealloc()
Date: Fri, 17 Jun 2022 13:46:20 +0000

Record the error code before overwriting the node pointer and return the
error.

Link: https://lkml.kernel.org/r/20220617134609.1771611-1-Liam.Howlett@oracle.com
Fixes: 2ef6c13ee71e (maple_tree: make mas_prealloc() error checking more generic)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-10
+++ a/lib/maple_tree.c
@@ -5654,6 +5654,8 @@ void mas_store_prealloc(struct ma_state
  */
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
+	int ret;
+
 	mas_set_alloc_req(mas, 1 + mas_mt_height(mas) * 3);
 	mas_alloc_nodes(mas, gfp);
 	if (likely(!mas_is_err(mas)))
@@ -5661,8 +5663,9 @@ int mas_preallocate(struct ma_state *mas
 
 	mas_set_alloc_req(mas, 0);
 	mas_destroy(mas);
+	ret = xa_err(mas->node);
 	mas->node = MAS_START;
-	return xa_err(mas->node);
+	return ret;
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
maple-tree-add-new-data-structure-fix-8-fix.patch
maple-tree-add-new-data-structure-fix-9.patch
maple-tree-add-new-data-structure-fix-10.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-3.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch
mm-remove-the-vma-linked-list-fix-4.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

