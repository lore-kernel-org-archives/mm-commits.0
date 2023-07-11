Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD145C001DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjGKTOY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjGKTOX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1F0EA
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D730D615CD
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351DCC433C7;
        Tue, 11 Jul 2023 19:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102861;
        bh=230kOOobQT5krJ0/GemJ+9wenImraJO6r6oLIKqdlOQ=;
        h=Date:To:From:Subject:From;
        b=plmhfrm45IVvyxg+QCV0eKro9Dk8KlS86CKC1hsdYpWOWj5u4TrMHaEP1WNfBopqp
         WXXwvxde0G1oWn1UZ7rRspKUta66lvmIT8FEZZQNV5Rjbifs/UWJFDD/rTJkZuS74F
         I+wy82Rfgp3nQDk7m6yCCOzmZyrjpz3aVoYXYLWM=
Date:   Tue, 11 Jul 2023 12:14:20 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch added to mm-unstable branch
Message-Id: <20230711191421.351DCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_validate_child_slot() to check last missed slot
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix mas_validate_child_slot() to check last missed slot
Date: Tue, 11 Jul 2023 11:54:40 +0800

Don't break the loop before checking the last slot.  Also here check if
non-leaf nodes are missing children.

Link: https://lkml.kernel.org/r/20230711035444.526-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot
+++ a/lib/maple_tree.c
@@ -7093,11 +7093,12 @@ static void mas_validate_child_slot(stru
 
 	for (i = 0; i < mt_slots[type]; i++) {
 		child = mas_slot(mas, slots, i);
-		if (!pivots[i] || pivots[i] == mas->max)
-			break;
 
-		if (!child)
-			break;
+		if (!child) {
+			pr_err("Non-leaf node lacks child at %p[%u]\n",
+			       mas_mn(mas), i);
+			MT_BUG_ON(mas->tree, 1);
+		}
 
 		if (mte_parent_slot(child) != i) {
 			pr_err("Slot error at %p[%u]: child %p has pslot %u\n",
@@ -7112,6 +7113,9 @@ static void mas_validate_child_slot(stru
 			       mte_to_node(mas->node));
 			MT_BUG_ON(mas->tree, 1);
 		}
+
+		if (i < mt_pivots[type] && pivots[i] == mas->max)
+			break;
 	}
 }
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-set-the-node-limit-when-creating-a-new-root-node.patch
maple_tree-add-test-for-mas_wr_modify-fast-path.patch
maple_tree-add-test-for-expanding-range-in-rcu-mode.patch
maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch
maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch
maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch
maple_tree-make-mas_validate_gaps-to-check-metadata.patch
maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch
maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch
maple_tree-update-mt_validate.patch
maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot.patch
maple_tree-drop-mas_first_entry.patch

