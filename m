Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A702EC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8141861415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWmt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWms (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FABB61402;
        Sat,  8 May 2021 22:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513705;
        bh=McshHYiZQ7Lq6Ep85LFRpnNZgAfrAircd/6c4AZOCko=;
        h=Date:From:To:Subject:From;
        b=qOIw0D0BVsRxBzOLB7MYmnvyAczj+TReGNRMaD97LkwkW2dLurp4leD8L6Fb9FZc0
         BpEC2CopLxHXIc7KxSFcyRY96CmjU8h58TRu9H8ZUDVd4Pgptup/02p6WoHiMz1PIi
         3i3NKbGwik+BMbtqMOxQ6BLPl42Ew8YXSBGhKxYU=
Date:   Sat, 08 May 2021 15:41:45 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-interval_tree-add-comments-to-improve-code-reading.patch removed from
 -mm tree
Message-ID: <20210508224145.DnNxi-CER%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/interval_tree: add comments to improve code readability
has been removed from the -mm tree.  Its filename was
     mm-interval_tree-add-comments-to-improve-code-reading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


