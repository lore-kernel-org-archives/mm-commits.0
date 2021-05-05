Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16E0C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9842561422
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhEEBid (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D08061182;
        Wed,  5 May 2021 01:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178657;
        bh=QrbBWJHEaN6aVcWazOCDv66YqwGTtasBv3/fsapZnB4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XIf1AkFpaz9dAztQNODyptzCMwt+31lfxlGNshyTWSM6fwg5COM4DCUSq0NsGDpYP
         B7LV6ysMj4HzzZ7wOW07qDq2iZB7rXnJBCCf1HU2VK7YvLSvOA3JTChBsz06jlv1JN
         XCrh0F73ZRYo2+uxEW+p+77NYyTNEUYaSQHjZTnU=
Date:   Tue, 04 May 2021 18:37:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 091/143] ksm: remove redundant VM_BUG_ON_PAGE() on
 stable_tree_search()
Message-ID: <20210505013737.L7P2I8BS3%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: ksm: remove redundant VM_BUG_ON_PAGE() on stable_tree_search()

Patch series "Cleanup and fixup for ksm".

This series contains cleanups to remove unnecessary VM_BUG_ON_PAGE and
dedicated macro KSM_FLAG_MASK.  Also this fixes potential missing
rmap_item for stable_node which would result in failed rmap_walk_ksm(). 
More details can be found in the respective changelogs.


This patch (of 4):

The same VM_BUG_ON_PAGE() check is already done in the callee.  Remove
these extra caller one to simplify code slightly.

Link: https://lkml.kernel.org/r/20210330140228.45635-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210330140228.45635-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/ksm.c~ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search
+++ a/mm/ksm.c
@@ -1771,7 +1771,6 @@ chain_append:
 	 * stable_node_dup is the dup to replace.
 	 */
 	if (stable_node_dup == stable_node) {
-		VM_BUG_ON(is_stable_node_chain(stable_node_dup));
 		VM_BUG_ON(is_stable_node_dup(stable_node_dup));
 		/* chain is missing so create it */
 		stable_node = alloc_stable_node_chain(stable_node_dup,
@@ -1785,7 +1784,6 @@ chain_append:
 	 * of the current nid for this page
 	 * content.
 	 */
-	VM_BUG_ON(!is_stable_node_chain(stable_node));
 	VM_BUG_ON(!is_stable_node_dup(stable_node_dup));
 	VM_BUG_ON(page_node->head != &migrate_nodes);
 	list_del(&page_node->list);
_
