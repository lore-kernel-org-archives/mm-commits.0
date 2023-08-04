Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A285C04A6A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjHDRoA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjHDRn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240924C02
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1270620D1
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADC1C433C8;
        Fri,  4 Aug 2023 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691171037;
        bh=Yb8mzpFN1L71BhyLGTWND4+bwCxxOutYNmG0VQye6Js=;
        h=Date:To:From:Subject:From;
        b=lT4YEH9OpL1zPpgMrK4giROSz4ambcKrfBdaH4CpywFvLVYVMLy1CvLpMNxZ71HKq
         T8JEI4K+b0FYdLvEOKsdQgo/zsGuqov4C7KyPsaY/fn84SGJSsE//M7Uo+D6duCRqU
         qt/Sb4dX3yb0Sq12UlBWAGXnsZTyXtxD1k8rjgz4=
Date:   Fri, 04 Aug 2023 10:43:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        paulmck@kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-mas_put_in_tree.patch added to mm-unstable branch
Message-Id: <20230804174357.0ADC1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: introduce mas_put_in_tree()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-mas_put_in_tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-mas_put_in_tree.patch

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
Subject: maple_tree: introduce mas_put_in_tree()
Date: Fri, 4 Aug 2023 12:59:48 -0400

mas_replace() has a single user that takes a flag which is now always
true.  Replace this function with mas_put_in_tree() to better align with
mas_replace_node().  Inline the remaining logic into the only caller;
mas_wmb_replace().

Link: https://lkml.kernel.org/r/20230804165951.2661157-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   73 ++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 46 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_put_in_tree
+++ a/lib/maple_tree.c
@@ -1715,45 +1715,32 @@ static inline void mas_adopt_children(st
 }
 
 /*
- * mas_replace() - Replace a maple node in the tree with mas->node.  Uses the
- * parent encoding to locate the maple node in the tree.
- * @mas - the ma_state to use for operations.
- * @advanced - boolean to adopt the child nodes and free the old node (false) or
- * leave the node (true) and handle the adoption and free elsewhere.
+ * mas_put_in_tree() - Put a new node in the tree, smp_wmb(), and mark the old
+ * node as dead.
+ * @mas - the maple state with the new node
+ * @old_enode - The old maple encoded node to replace.
  */
-static inline void mas_replace(struct ma_state *mas, bool advanced)
+static inline void mas_put_in_tree(struct ma_state *mas,
+		struct maple_enode *old_enode)
 	__must_hold(mas->tree->ma_lock)
 {
-	struct maple_node *mn = mas_mn(mas);
-	struct maple_enode *old_enode;
-	unsigned char offset = 0;
-	void __rcu **slots = NULL;
-
-	if (ma_is_root(mn)) {
-		old_enode = mas_root_locked(mas);
-	} else {
-		offset = mte_parent_slot(mas->node);
-		slots = ma_slots(mte_parent(mas->node),
-				 mas_parent_type(mas, mas->node));
-		old_enode = mas_slot_locked(mas, slots, offset);
-	}
-
-	if (!advanced && !mte_is_leaf(mas->node))
-		mas_adopt_children(mas, mas->node);
+	unsigned char offset;
+	void __rcu **slots;
 
 	if (mte_is_root(mas->node)) {
-		mn->parent = ma_parent_ptr(
+		mas_mn(mas)->parent = ma_parent_ptr(
 			      ((unsigned long)mas->tree | MA_ROOT_PARENT));
 		rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
 		mas_set_height(mas);
 	} else {
+
+		offset = mte_parent_slot(mas->node);
+		slots = ma_slots(mte_parent(mas->node),
+				 mas_parent_type(mas, mas->node));
 		rcu_assign_pointer(slots[offset], mas->node);
 	}
 
-	if (!advanced) {
-		mte_set_node_dead(old_enode);
-		mas_free(mas, old_enode);
-	}
+	mte_set_node_dead(old_enode);
 }
 
 /*
@@ -1767,22 +1754,7 @@ static inline void mas_replace_node(stru
 		struct maple_enode *old_enode)
 	__must_hold(mas->tree->ma_lock)
 {
-	if (mte_is_root(mas->node)) {
-		mas_mn(mas)->parent = ma_parent_ptr(
-			      ((unsigned long)mas->tree | MA_ROOT_PARENT));
-		rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-		mas_set_height(mas);
-	} else {
-		unsigned char offset = 0;
-		void __rcu **slots = NULL;
-
-		offset = mte_parent_slot(mas->node);
-		slots = ma_slots(mte_parent(mas->node),
-				 mas_parent_type(mas, mas->node));
-		rcu_assign_pointer(slots[offset], mas->node);
-	}
-
-	mte_set_node_dead(old_enode);
+	mas_put_in_tree(mas, old_enode);
 	mas_free(mas, old_enode);
 }
 
@@ -2789,11 +2761,20 @@ static inline void mas_wmb_replace(struc
 				   struct ma_topiary *free,
 				   struct ma_topiary *destroy)
 {
-	/* All nodes must see old data as dead prior to replacing that data */
-	smp_wmb(); /* Needed for RCU */
+	struct maple_enode *old_enode;
+
+	if (mte_is_root(mas->node)) {
+		old_enode = mas_root_locked(mas);
+	} else {
+		unsigned char offset = mte_parent_slot(mas->node);
+		void __rcu **slots = ma_slots(mte_parent(mas->node),
+					      mas_parent_type(mas, mas->node));
+
+		old_enode = mas_slot_locked(mas, slots, offset);
+	}
 
 	/* Insert the new data in the tree */
-	mas_replace(mas, true);
+	mas_put_in_tree(mas, old_enode);
 
 	if (!mte_is_leaf(mas->node))
 		mas_descend_adopt(mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maintainers-add-maple-tree-mailing-list.patch
mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

