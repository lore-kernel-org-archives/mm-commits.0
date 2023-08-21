Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F5DEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjHUUlM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjHUUkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E001B0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC2B564B2D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E675C433C7;
        Mon, 21 Aug 2023 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650412;
        bh=X/+oYMQRw/URiheJeLwyjLgyHpkRx1O9X6m3wJobBnM=;
        h=Date:To:From:Subject:From;
        b=iHbAp22YdAaeQYmxhdmKdtKCJOv6eNVBTql4g+Gu46Hf9VPhH6jw4ypnel+kzs55y
         KMrj3cXs6qe9Bvh4vlJhN6jvBV9rF9xpC/vy1Oo3/+fohJsxaK4K8JucH5xFM0dgF5
         QUDe/7lww/MO53pPVW4HKpbEw3MN5XMd81+ZODbI=
Date:   Mon, 21 Aug 2023 13:40:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        paulmck@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-mas_tree_parent-definition.patch removed from -mm tree
Message-Id: <20230821204012.3E675C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: introduce mas_tree_parent() definition
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-mas_tree_parent-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: introduce mas_tree_parent() definition
Date: Fri, 4 Aug 2023 12:59:49 -0400

Add a definition to shorten long code lines and clarify what the code is
doing.  Use the new definition to get the maple tree parent pointer from
the maple state where possible.

Link: https://lkml.kernel.org/r/20230804165951.2661157-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_tree_parent-definition
+++ a/lib/maple_tree.c
@@ -75,6 +75,7 @@
 #define MA_STATE_PREALLOC	4
 
 #define ma_parent_ptr(x) ((struct maple_pnode *)(x))
+#define mas_tree_parent(x) ((unsigned long)(x->tree) | MA_ROOT_PARENT)
 #define ma_mnode_ptr(x) ((struct maple_node *)(x))
 #define ma_enode_ptr(x) ((struct maple_enode *)(x))
 static struct kmem_cache *maple_node_cache;
@@ -1728,8 +1729,7 @@ static inline void mas_put_in_tree(struc
 	void __rcu **slots;
 
 	if (mte_is_root(mas->node)) {
-		mas_mn(mas)->parent = ma_parent_ptr(
-			      ((unsigned long)mas->tree | MA_ROOT_PARENT));
+		mas_mn(mas)->parent = ma_parent_ptr(mas_tree_parent(mas));
 		rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
 		mas_set_height(mas);
 	} else {
@@ -2798,8 +2798,7 @@ static inline void mas_wmb_replace(struc
 static inline void mast_new_root(struct maple_subtree_state *mast,
 				 struct ma_state *mas)
 {
-	mas_mn(mast->l)->parent =
-		ma_parent_ptr(((unsigned long)mas->tree | MA_ROOT_PARENT));
+	mas_mn(mast->l)->parent = ma_parent_ptr(mas_tree_parent(mas));
 	if (!mte_dead_node(mast->orig_l->node) &&
 	    !mte_is_root(mast->orig_l->node)) {
 		do {
@@ -3661,8 +3660,7 @@ static inline int mas_root_expand(struct
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
-	node->parent = ma_parent_ptr(
-		      ((unsigned long)mas->tree | MA_ROOT_PARENT));
+	node->parent = ma_parent_ptr(mas_tree_parent(mas));
 	mas->node = mt_mk_node(node, type);
 
 	if (mas->index) {
@@ -3938,8 +3936,7 @@ static inline int mas_new_root(struct ma
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
-	node->parent = ma_parent_ptr(
-		      ((unsigned long)mas->tree | MA_ROOT_PARENT));
+	node->parent = ma_parent_ptr(mas_tree_parent(mas));
 	mas->node = mt_mk_node(node, type);
 	rcu_assign_pointer(slots[0], entry);
 	pivots[0] = mas->last;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-disable-mas_wr_append-when-other-readers-are-possible.patch
maple_tree-clean-up-mas_wr_append.patch

