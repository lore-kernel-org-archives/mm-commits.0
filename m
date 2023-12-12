Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631C210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1xv1TjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766DFC433C8;
	Tue, 12 Dec 2023 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702406780;
	bh=VCrPBxOlrxT+zuP6BjssVd8Z50kwrl5xcWay3Ni1b5g=;
	h=Date:To:From:Subject:From;
	b=B1xv1TjNnc7+2FbJtnHpzgdOu33V3eZEG5ON4GGB4CKmPTrF47MmC8/v+BgVDkL2Q
	 OkcobtMcNRAKrSRM5D175n6eNvUsRCSZECFY/Fh5ytd9qibcRuNkucQkC/BUmJ/2oi
	 ySw4wQha3OUycbiunrSwgYgxjG+FMIwGOApg7m3Q=
Date: Tue, 12 Dec 2023 10:46:19 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-separate-ma_state-node-from-status-fix-1.patch removed from -mm tree
Message-Id: <20231212184620.766DFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix comments about MAS_*
has been removed from the -mm tree.  Its filename was
     maple_tree-separate-ma_state-node-from-status-fix-1.patch

This patch was dropped because it was folded into maple_tree-separate-ma_state-node-from-status.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix comments about MAS_*
Date: Mon, 6 Nov 2023 10:41:24 -0500

Missed some documentation changes when separating the nodes from the
status of the maple state.

Link: https://lkml.kernel.org/r/20231106154124.614247-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/lib/maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix-1
+++ a/lib/maple_tree.c
@@ -2228,12 +2228,10 @@ static inline bool mas_next_sibling(stru
 }
 
 /*
- * mte_node_or_node() - Return the encoded node or MAS_NONE.
+ * mte_node_or_none() - Set the enode and state.
  * @enode: The encoded maple node.
  *
- * Shorthand to avoid setting %NULLs in the tree or maple_subtree_state.
- *
- * Return: @enode or MAS_NONE
+ * Set the node to the enode and the status.
  */
 static inline void mas_node_or_none(struct ma_state *mas,
 		struct maple_enode *enode)
@@ -4377,11 +4375,13 @@ static __always_inline bool mas_rewalk_i
 
 /*
  * mas_prev_node() - Find the prev non-null entry at the same level in the
- * tree.  The prev value will be mas->node[mas->offset] or MAS_NONE.
+ * tree.  The prev value will be mas->node[mas->offset] or the status will be
+ * ma_none.
  * @mas: The maple state
  * @min: The lower limit to search
  *
- * The prev node value will be mas->node[mas->offset] or MAS_NONE.
+ * The prev node value will be mas->node[mas->offset] or the status will be
+ * ma_none.
  * Return: 1 if the node is dead, 0 otherwise.
  */
 static int mas_prev_node(struct ma_state *mas, unsigned long min)
@@ -4903,7 +4903,7 @@ done:
  * @mas: The maple state.
  *
  * mas->index and mas->last will be set to the range if there is a value.  If
- * mas->node is MAS_NONE, reset to mas_start
+ * mas->status is ma_none, reset to ma_start
  *
  * Return: the entry at the location or %NULL.
  */
@@ -5870,7 +5870,7 @@ static bool mas_prev_setup(struct ma_sta
  * @min: The minimum value to check.
  *
  * Must hold rcu_read_lock or the write lock.
- * Will reset mas to MAS_START if the node is MAS_NONE.  Will stop on not
+ * Will reset mas to ma_start if the status is ma_none.  Will stop on not
  * searchable nodes.
  *
  * Return: the previous value or %NULL.
@@ -5893,7 +5893,7 @@ EXPORT_SYMBOL_GPL(mas_prev);
  *
  * Sets @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
- * Will reset mas to MAS_START if the node is MAS_NONE.  Will stop on not
+ * Will reset mas to ma_start if the node is ma_none.  Will stop on not
  * searchable nodes.
  *
  * Return: the previous value or %NULL.
@@ -6049,7 +6049,7 @@ ptr_out_of_range:
  *
  * Must hold rcu_read_lock or the write lock.
  * If an entry exists, last and index are updated accordingly.
- * May set @mas->node to MAS_NONE.
+ * May set @mas->status to ma_overflow.
  *
  * Return: The entry or %NULL.
  */
@@ -6076,7 +6076,7 @@ EXPORT_SYMBOL_GPL(mas_find);
  *
  * Must hold rcu_read_lock or the write lock.
  * If an entry exists, last and index are updated accordingly.
- * May set @mas->node to MAS_NONE.
+ * May set @mas->status to ma_overflow.
  *
  * Return: The entry or %NULL.
  */
@@ -6190,7 +6190,7 @@ none:
  *
  * Must hold rcu_read_lock or the write lock.
  * If an entry exists, last and index are updated accordingly.
- * May set @mas->node to MAS_NONE.
+ * May set @mas->status to ma_underflow.
  *
  * Return: The entry or %NULL.
  */
@@ -6216,7 +6216,7 @@ EXPORT_SYMBOL_GPL(mas_find_rev);
  *
  * Must hold rcu_read_lock or the write lock.
  * If an entry exists, last and index are updated accordingly.
- * May set @mas->node to MAS_NONE.
+ * May set @mas->status to ma_underflow.
  *
  * Return: The entry or %NULL.
  */
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
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-separate-ma_state-node-from-status-fix.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

