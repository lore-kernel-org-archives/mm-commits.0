Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13673C88CB5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjFLV2N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjFLV1i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1A192
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9507F62AC0
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E867CC433EF;
        Mon, 12 Jun 2023 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605245;
        bh=m7brmK4ZEl4pzHpYxomY94y4B5H4usey+xrbkzrqEjk=;
        h=Date:To:From:Subject:From;
        b=pRImJhtGLgdy9lzkccDMS3EBy9wGCwjV2nl2SJDARSIVw5/iF1VB6/ocKn8clIVhX
         ZN79r4pIiw3acr1oY0kIlX5GaOx/B8HZ50IHrxusA1B+fkIwPw3A2HjNREWwv03Lae
         dbOpZ4p57hWZQSf+dv5LntpRsmZi72hOAt//Nwuc=
Date:   Mon, 12 Jun 2023 14:27:24 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-adjust-node-allocation-on-mas_rebalance.patch added to mm-unstable branch
Message-Id: <20230612212724.E867CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: adjust node allocation on mas_rebalance()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-adjust-node-allocation-on-mas_rebalance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-adjust-node-allocation-on-mas_rebalance.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: adjust node allocation on mas_rebalance()
Date: Mon, 12 Jun 2023 16:39:45 -0400

mas_rebalance() is called to rebalance an insufficient node into a single
node or two sufficient nodes.  The preallocation estimate is always too
many in this case as the height of the tree will never grow and there is
no possibility to have a three way split in this case, so revise the node
allocation count.

Link: https://lkml.kernel.org/r/20230612203953.2093911-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-adjust-node-allocation-on-mas_rebalance
+++ a/lib/maple_tree.c
@@ -3166,7 +3166,7 @@ static inline int mas_rebalance(struct m
 	 * tries to combine the data in the same way.  If one node contains the
 	 * entire range of the tree, then that node is used as a new root node.
 	 */
-	mas_node_count(mas, 1 + empty_count * 3);
+	mas_node_count(mas, empty_count * 2 - 1);
 	if (mas_is_err(mas))
 		return 0;
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

