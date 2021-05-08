Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93FFC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB07613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhEHWud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EAE1613EA;
        Sat,  8 May 2021 22:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514171;
        bh=E9Pd0w7vgUztbAcW4eT4p5Ca9ucs7eK5eiZ56YFrL6E=;
        h=Date:From:To:Subject:From;
        b=koMNS/U8ivP09AJEeC1GDtQG7W4wCO0c6RZCxwcvXnFEDEMxZPHEIKW0lgMWvWdmy
         ViKaB6ptQMjmcAXloBywiK22fKq1DKRzSgsIbL/KiAG9wCbBYDyOuSu6WRBEuEnaZO
         Tju+asbbp0O51qaTlc81nhaRs/I5F9FAFiG96lHQ=
Date:   Sat, 08 May 2021 15:49:31 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch removed
 from -mm tree
Message-ID: <20210508224931.EIS2nyKQp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: remove redundant VM_BUG_ON_PAGE() on stable_tree_search()
has been removed from the -mm tree.  Its filename was
     ksm-remove-redundant-vm_bug_on_page-on-stable_tree_search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


