Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0F2C0018A
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjKFReT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjKFReP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB550B7
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1F7C433C8;
        Mon,  6 Nov 2023 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292052;
        bh=/772tn54I/SYt7ZZ79upQ0E6a8ho0qtcmWFaW4SfY1Y=;
        h=Date:To:From:Subject:From;
        b=hMzQ6C3RohCHAjmWtuL05eZvFqH0BsXUnqj0zXDQvIZudybxaNI4zv2bXkYCtyfUX
         UL5oc9YjclpOBW3LofhnSoWdLrNzCi2gKnp522+4WYLG0g+kc+P4PU3y3PxKR/i5Cv
         hbG+lYu7gpN9q8h2L5TyxW+VS0nqMAqOjTUg9f7M=
Date:   Mon, 06 Nov 2023 09:34:11 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-end-of-node-tracking-to-the-maple-state.patch added to mm-unstable branch
Message-Id: <20231106173412.7B1F7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add end of node tracking to the maple state
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-end-of-node-tracking-to-the-maple-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-end-of-node-tracking-to-the-maple-state.patch

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
Subject: maple_tree: add end of node tracking to the maple state
Date: Wed, 1 Nov 2023 13:16:21 -0400

Analysis of the mas_for_each() iteration showed that there is a
significant time spent finding the end of a node.  This time can be
greatly reduced if the end of the node is cached in the maple state.  Care
must be taken to update & invalidate as necessary.

Link: https://lkml.kernel.org/r/20231101171629.3612299-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    1 +
 lib/maple_tree.c                 |    7 +++++++
 tools/testing/radix-tree/maple.c |    1 +
 3 files changed, 9 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-add-end-of-node-tracking-to-the-maple-state
+++ a/include/linux/maple_tree.h
@@ -393,6 +393,7 @@ struct ma_state {
 	unsigned char depth;		/* depth of tree descent during write */
 	unsigned char offset;
 	unsigned char mas_flags;
+	unsigned char end;		/* The end of the node */
 };
 
 struct ma_wr_state {
--- a/lib/maple_tree.c~maple_tree-add-end-of-node-tracking-to-the-maple-state
+++ a/lib/maple_tree.c
@@ -2841,6 +2841,7 @@ next:
 			goto dead_node;
 	} while (!ma_is_leaf(type));
 
+	mas->end = end;
 	mas->offset = offset;
 	mas->index = min;
 	mas->last = max;
@@ -3507,6 +3508,7 @@ static noinline_for_kasan int mas_commit
 	mas_replace_node(wr_mas->mas, old_enode);
 reuse_node:
 	mas_update_gap(wr_mas->mas);
+	wr_mas->mas->end = b_end;
 	return 1;
 }
 
@@ -4010,6 +4012,7 @@ done:
 	}
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
+	mas->end = new_end;
 	return true;
 }
 
@@ -4190,6 +4193,7 @@ static inline bool mas_wr_append(struct
 	if (!wr_mas->content || !wr_mas->entry)
 		mas_update_gap(mas);
 
+	mas->end = new_end;
 	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
 	return  true;
 }
@@ -4428,6 +4432,7 @@ static inline int mas_prev_node(struct m
 	if (unlikely(mte_dead_node(mas->node)))
 		return 1;
 
+	mas->end = mas->offset;
 	return 0;
 
 no_entry:
@@ -5074,6 +5079,7 @@ int mas_empty_area(struct ma_state *mas,
 	if (mas->index < min)
 		mas->index = min;
 	mas->last = mas->index + size - 1;
+	mas->end = mas_data_end(mas);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mas_empty_area);
@@ -5134,6 +5140,7 @@ int mas_empty_area_rev(struct ma_state *
 		mas->last = max;
 
 	mas->index = mas->last - size + 1;
+	mas->end = mas_data_end(mas);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mas_empty_area_rev);
--- a/tools/testing/radix-tree/maple.c~maple_tree-add-end-of-node-tracking-to-the-maple-state
+++ a/tools/testing/radix-tree/maple.c
@@ -945,6 +945,7 @@ retry:
 		goto retry;
 	}
 
+	mas->end = mas_data_end(mas);
 	return ret;
 
 not_found:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

