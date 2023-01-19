Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDDFC678DB
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjASBRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjASBPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54786843B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 422DD61B20
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAFEC433EF;
        Thu, 19 Jan 2023 01:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090895;
        bh=JQKeWcyUfJoSmHFwL4hMRtlRwsBSrfmQnlhgT5FrPNY=;
        h=Date:To:From:Subject:From;
        b=c4xyrzcQkjGGKqnIZo6Brq+i1lkP5CbigHLW8dIDJ1jzjaa8akGtlI59GZCdY3sfC
         zmq2Guyjbt4epm6zT4Gq7YfPiOLgRwfBCbzrrR1InC1la8lTtlfuhpFKPV46zxgs5w
         syGPCKteEnfP5Il2tKdhDnBvMmhQYM4MZvhQrcDk=
Date:   Wed, 18 Jan 2023 17:14:55 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-extra-space-and-blank-line.patch removed from -mm tree
Message-Id: <20230119011455.9DAFEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: remove extra space and blank line
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-extra-space-and-blank-line.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: remove extra space and blank line
Date: Wed, 21 Dec 2022 14:00:52 +0800

Patch series "Clean up and refinement for maple tree", v2.

This patchset cleans up and refines some maple tree code.  A few small
changes make the code easier to understand and for better readability.


This patch (of 7):

These extra space and blank lines are unnecessary, so drop them.

Link: https://lkml.kernel.org/r/20221221060058.609003-1-vernon2gm@gmail.com
Link: https://lkml.kernel.org/r/20221221060058.609003-2-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 --
 lib/maple_tree.c           |   14 ++++----------
 2 files changed, 4 insertions(+), 12 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-extra-space-and-blank-line
+++ a/include/linux/maple_tree.h
@@ -517,7 +517,6 @@ static inline void mas_reset(struct ma_s
  * entry.
  *
  * Note: may return the zero entry.
- *
  */
 #define mas_for_each(__mas, __entry, __max) \
 	while (((__entry) = mas_find((__mas), (__max))) != NULL)
@@ -639,7 +638,6 @@ static inline void mt_set_in_rcu(struct
 }
 
 static inline unsigned int mt_height(const struct maple_tree *mt)
-
 {
 	return (mt->ma_flags & MT_FLAGS_HEIGHT_MASK) >> MT_FLAGS_HEIGHT_OFFSET;
 }
--- a/lib/maple_tree.c~maple_tree-remove-extra-space-and-blank-line
+++ a/lib/maple_tree.c
@@ -183,7 +183,6 @@ static void ma_free_rcu(struct maple_nod
 	call_rcu(&node->rcu, mt_free_rcu);
 }
 
-
 static void mas_set_height(struct ma_state *mas)
 {
 	unsigned int new_flags = mas->tree->ma_flags;
@@ -468,7 +467,7 @@ static inline
 void mte_set_parent(struct maple_enode *enode, const struct maple_enode *parent,
 		    unsigned char slot)
 {
-	unsigned long val = (unsigned long) parent;
+	unsigned long val = (unsigned long)parent;
 	unsigned long shift;
 	unsigned long type;
 	enum maple_type p_type = mte_node_type(parent);
@@ -502,7 +501,7 @@ void mte_set_parent(struct maple_enode *
  */
 static inline unsigned int mte_parent_slot(const struct maple_enode *enode)
 {
-	unsigned long val = (unsigned long) mte_to_node(enode)->parent;
+	unsigned long val = (unsigned long)mte_to_node(enode)->parent;
 
 	/* Root. */
 	if (val & 1)
@@ -1278,7 +1277,6 @@ nomem_one:
 		mas->alloc->total = success;
 	mas_set_err(mas, -ENOMEM);
 	return;
-
 }
 
 /*
@@ -2946,7 +2944,7 @@ next:
 	mas->min = prev_min;
 	mas->max = prev_max;
 	mas->node = last;
-	return (void *) next;
+	return (void *)next;
 
 dead_node:
 	mas_reset(mas);
@@ -3466,7 +3464,6 @@ static inline bool mas_push_data(struct
  */
 static int mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 {
-
 	struct maple_subtree_state mast;
 	int height = 0;
 	unsigned char mid_split, split = 0;
@@ -3892,7 +3889,7 @@ next:
 			goto dead_node;
 	} while (!ma_is_leaf(type));
 
-	return (void *) next;
+	return (void *)next;
 
 dead_node:
 	mas_reset(mas);
@@ -4710,7 +4707,6 @@ found:
 
 static inline void mas_rewalk(struct ma_state *mas, unsigned long index)
 {
-
 retry:
 	mas_set(mas, index);
 	mas_state_walk(mas);
@@ -4718,7 +4714,6 @@ retry:
 		goto retry;
 
 	return;
-
 }
 
 /*
@@ -5620,7 +5615,6 @@ static void mas_wr_store_setup(struct ma
 				mas_reset(wr_mas->mas);
 		}
 	}
-
 }
 
 /* Interface */
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

