Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E7EC43334
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 22:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiF2Wbz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiF2Wbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 18:31:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5430611A22
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 15:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 139BAB82726
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 22:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98C1C34114;
        Wed, 29 Jun 2022 22:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656541911;
        bh=4U+SzBbxlD2fc+c4WfHw66QObTKOOzco5ZLOikDKfJ0=;
        h=Date:To:From:Subject:From;
        b=Qq4vexoUuZM+AJIWJMGLS2VRyIS9c2VrYarxCdJQYkrMqEAIaU2Ua04NxwmGpSkVb
         aLJbztG8IeXBJvbxGzEZAdao3kTXJlZeZuwFeV4+ptphPyIs8KNtnpaYaMp5NSjrEk
         QaeOjIwTqBQjoR2hwIFyEaN8kv0Lch4nt8BEfEiM=
Date:   Wed, 29 Jun 2022 15:31:51 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-2.patch added to mm-unstable branch
Message-Id: <20220629223151.C98C1C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_spanning_rebalance() corner case
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-2.patch

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
Subject: maple_tree: fix mas_spanning_rebalance() corner case
Date: Wed, 29 Jun 2022 15:23:50 +0000

When a node is insufficient during a spanning rebalance loop and
mast_spanning_rebalance() is called to combine neighbouring nodes, the
loop should not terminate regardless of if neighbours exist or not.  This
will allow the data to be stored in the correct node.

Link: https://lkml.kernel.org/r/20220629152340.3451959-2-Liam.Howlett@oracle.com
Fixes: 37a4d714b7d9 (maple_tree: fix underflow in mas_spanning_rebalance())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-2
+++ a/lib/maple_tree.c
@@ -3029,8 +3029,7 @@ static int mas_spanning_rebalance(struct
 		if (mas_is_root_limits(mast->orig_l))
 			break;
 
-		if (!mast_spanning_rebalance(mast))
-			break;
+		mast_spanning_rebalance(mast);
 
 		/* rebalancing from other nodes may require another loop. */
 		if (!count)
@@ -6521,6 +6520,7 @@ static inline void *mas_first_entry(stru
 	max = mas->max;
 	mas->offset = 0;
 	while (likely(!ma_is_leaf(mt))) {
+		MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
 		slots = ma_slots(mn, mt);
 		pivots = ma_pivots(mn, mt);
 		max = pivots[0];
@@ -6531,6 +6531,7 @@ static inline void *mas_first_entry(stru
 		mn = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 	}
+	MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
 
 	mas->max = max;
 	slots = ma_slots(mn, mt);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

