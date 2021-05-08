Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4F3C43470
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEFE261430
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEHWuj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWuj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FB3661426;
        Sat,  8 May 2021 22:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514177;
        bh=LcjWi1nejrgdctJYHyK1e25ftKbQ/tt03FvlKhWaFIM=;
        h=Date:From:To:Subject:From;
        b=jEDmxOnFIMcWG8lh0rfNKBDOToBdih8Zid3aB4/bqIF2AnQJsFSDHSleChjJGs9AU
         UxSCWsGr4Xg5W60uSiIwkXDWEo4S7idEnyGSBqXEWZyMg/P4XQsw2N48kCYifGAOcP
         QfICx0mQZrE5hrmsbC+GUewfml8T0uC0NpSrcH9s=
Date:   Sat, 08 May 2021 15:49:37 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 ksm-fix-potential-missing-rmap_item-for-stable_node.patch removed from -mm
 tree
Message-ID: <20210508224937.5UAHHuuYk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: fix potential missing rmap_item for stable_node
has been removed from the -mm tree.  Its filename was
     ksm-fix-potential-missing-rmap_item-for-stable_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: ksm: fix potential missing rmap_item for stable_node

When removing rmap_item from stable tree, STABLE_FLAG of rmap_item is
cleared with head reserved.  So the following scenario might happen: For
ksm page with rmap_item1:

cmp_and_merge_page
  stable_node->head = &migrate_nodes;
  remove_rmap_item_from_tree, but head still equal to stable_node;
  try_to_merge_with_ksm_page failed;
  return;

For the same ksm page with rmap_item2, stable node migration succeed this
time.  The stable_node->head does not equal to migrate_nodes now.  For ksm
page with rmap_item1 again:

cmp_and_merge_page
 stable_node->head != &migrate_nodes && rmap_item->head == stable_node
 return;

We would miss the rmap_item for stable_node and might result in failed
rmap_walk_ksm().  Fix this by set rmap_item->head to NULL when rmap_item
is removed from stable tree.

Link: https://lkml.kernel.org/r/20210330140228.45635-5-linmiaohe@huawei.com
Fixes: 4146d2d673e8 ("ksm: make !merge_across_nodes migration safe")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/ksm.c~ksm-fix-potential-missing-rmap_item-for-stable_node
+++ a/mm/ksm.c
@@ -791,6 +791,7 @@ static void remove_rmap_item_from_tree(s
 		stable_node->rmap_hlist_len--;
 
 		put_anon_vma(rmap_item->anon_vma);
+		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & UNSTABLE_FLAG) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


