Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17355EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 19:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjGQTyE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjGQTyA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 15:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D805BC0;
        Mon, 17 Jul 2023 12:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B8586123A;
        Mon, 17 Jul 2023 19:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD508C433C7;
        Mon, 17 Jul 2023 19:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689623637;
        bh=nFzyybQVXUnWEu7DUKHjnBsyRitwtFC+uzAGiqFGuSo=;
        h=Date:To:From:Subject:From;
        b=NzUvCBIVwwHk9OOadxnP88M1RpxpDxYP4P9ELJgwautRsWzcXdLLNV3Yeju4wXFnT
         ONcsAFnDt4UGPbbLle/ggbQgJstwpKuw9Sj8BzW5W6Qx/JLkfoyNmSTJivFAbd/aS3
         43fHMTZJwoNYzvBbtNqmNes2P30Y0srucqBf0vBA=
Date:   Mon, 17 Jul 2023 12:53:57 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, geert@linux-m68k.org,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-set-the-node-limit-when-creating-a-new-root-node.patch removed from -mm tree
Message-Id: <20230717195357.BD508C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: set the node limit when creating a new root node
has been removed from the -mm tree.  Its filename was
     maple_tree-set-the-node-limit-when-creating-a-new-root-node.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: set the node limit when creating a new root node
Date: Tue, 11 Jul 2023 11:54:37 +0800

Set the node limit of the root node so that the last pivot of all nodes is
the node limit (if the node is not full).

This patch also fixes a bug in mas_rev_awalk().  Effectively, always
setting a maximum makes mas_logical_pivot() behave as mas_safe_pivot(). 
Without this fix, it is possible that very small tasks would fail to find
the correct gap.  Although this has not been observed with real tasks, it
has been reported to happen in m68k nommu running the maple tree tests.

Link: https://lkml.kernel.org/r/20230711035444.526-1-zhangpeng.00@bytedance.com
Link: https://lore.kernel.org/linux-mm/CAMuHMdV4T53fOw7VPoBgPR7fP6RYqf=CBhD_y_vOg53zZX_DnA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230711035444.526-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-set-the-node-limit-when-creating-a-new-root-node
+++ a/lib/maple_tree.c
@@ -3692,7 +3692,8 @@ static inline int mas_root_expand(struct
 	mas->offset = slot;
 	pivots[slot] = mas->last;
 	if (mas->last != ULONG_MAX)
-		slot++;
+		pivots[++slot] = ULONG_MAX;
+
 	mas->depth = 1;
 	mas_set_height(mas);
 	ma_set_meta(node, maple_leaf_64, 0, slot);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

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

