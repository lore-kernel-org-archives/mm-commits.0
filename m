Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15BEC433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C22564F8E
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhCDBUh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234191AbhCDBUD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:20:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD8564F3A;
        Thu,  4 Mar 2021 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820762;
        bh=82uPjIauYCa1IseF73oLlpxKcH0lu/ETcKWLqH55Umo=;
        h=Date:From:To:Subject:From;
        b=yMBYZ32rm1FuD8cAutdX+gZUm0f5DQQQol3LJlHc1eMNgFSZIQn7DQnSywxfyXexT
         dXixxL+v6ZCV1vuO0kA2LLsoILkjTk+EnYEAIbH6zt7TGX2Qtk2Tg2aJapTT/c9JcP
         a+7QrnYWzprWbcBUjcJtUc9RTNCCO8wPoySxMvbI=
Date:   Wed, 03 Mar 2021 17:19:22 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  +
 mm-interval_tree-add-comments-to-improve-code-reading.patch added to -mm
 tree
Message-ID: <20210304011922.4jmtCHAii%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/interval_tree: add comments to improve code readability
has been added to the -mm tree.  Its filename is
     mm-interval_tree-add-comments-to-improve-code-reading.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-interval_tree-add-comments-to-improve-code-reading.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-interval_tree-add-comments-to-improve-code-reading.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/interval_tree: add comments to improve code readability

Add a comment explaining the value of the ISSTATIC parameter, Inform the
reader that this is not a coding style issue.

Link: https://lkml.kernel.org/r/1613964695-17614-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/interval_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/interval_tree.c~mm-interval_tree-add-comments-to-improve-code-reading
+++ a/mm/interval_tree.c
@@ -22,7 +22,7 @@ static inline unsigned long vma_last_pgo
 
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
-		     vma_start_pgoff, vma_last_pgoff,, vma_interval_tree)
+		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
 
 /* Insert node immediately after prev in the interval tree */
 void vma_interval_tree_insert_after(struct vm_area_struct *node,
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch
mm-mempool-minor-coding-style-tweaks.patch

