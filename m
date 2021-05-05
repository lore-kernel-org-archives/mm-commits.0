Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A00C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AAEE61422
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhEEBin (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 186F161421;
        Wed,  5 May 2021 01:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178666;
        bh=cJXsnOwAOpy6x1NOGFB5yKl1lVdZ+zBSRi+bSHBLyl4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ieDZMKmXEwVxv0wnZkrJQm2CTc/dj/4Ytu2Qmi0jYlLZ34DVac87gfacYiPPoe62L
         tEgRGmLl0B0X3pyWoTUUDGxX17S7HJ9UOKUgkxj+LyiAZxAIbTcSlHJzGhTb2E0h6t
         kUU2xXqk4KBsuuzAxvx1t8FkdtfbCiU1lFqXhZHM=
Date:   Tue, 04 May 2021 18:37:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 094/143] ksm: fix potential missing rmap_item for
 stable_node
Message-ID: <20210505013745.UH7iM8WOW%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
