Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D7F7F576
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MhSY5HlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FBFC433C9;
	Tue, 12 Dec 2023 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407547;
	bh=MjSVmjmxDzrjvsZEgbJ+grBFjcdIpr5TeSNWjEzv/OA=;
	h=Date:To:From:Subject:From;
	b=MhSY5HlP7/d6mQ899GHonPdjOcVLmgMRBysQ9HCWurPps84AeGnFAMbpSKrv0QsF6
	 8DQNrfeAsDS1ApVAV1YarrJVflR3YIa4TuTO8XCk5Wf08C/UxM8KgRTGS7Bs0u2Q1P
	 zDvFYbpnMT5aBXAi/WsMX5fkXhOweAaqXwProDMU=
Date: Tue, 12 Dec 2023 10:59:07 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-mas_searchable.patch removed from -mm tree
Message-Id: <20231212185907.D3FBFC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove mas_searchable()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-mas_searchable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: remove mas_searchable()
Date: Wed, 1 Nov 2023 13:16:26 -0400

Now that the status of the maple state is outside of the node, the
mas_searchable() function can be dropped for easier open-coding of what is
going on.

Link: https://lkml.kernel.org/r/20231101171629.3612299-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   66 +++++++----------------------
 tools/testing/radix-tree/maple.c |    4 +
 2 files changed, 19 insertions(+), 51 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-mas_searchable
+++ a/lib/maple_tree.c
@@ -285,17 +285,6 @@ static inline bool mas_is_underflow(stru
 	return mas->status == ma_underflow;
 }
 
-static inline bool mas_searchable(struct ma_state *mas)
-{
-	if (mas_is_none(mas))
-		return false;
-
-	if (mas_is_ptr(mas))
-		return false;
-
-	return true;
-}
-
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -6030,12 +6019,11 @@ static __always_inline bool mas_find_set
 
 	}
 
-	if (unlikely(!mas_searchable(mas))) {
-		if (unlikely(mas_is_ptr(mas)))
-			goto ptr_out_of_range;
+	if (unlikely(mas_is_ptr(mas)))
+		goto ptr_out_of_range;
 
+	if (unlikely(mas_is_none(mas)))
 		return true;
-	}
 
 	if (mas->index == max)
 		return true;
@@ -6162,20 +6150,18 @@ static bool mas_find_rev_setup(struct ma
 			return true;
 	}
 
-	if (unlikely(!mas_searchable(mas))) {
-		if (mas_is_ptr(mas))
-			goto none;
+	if (unlikely(mas_is_ptr(mas)))
+		goto none;
 
-		if (mas_is_none(mas)) {
-			/*
-			 * Walked to the location, and there was nothing so the
-			 * previous location is 0.
-			 */
-			mas->last = mas->index = 0;
-			mas->status = ma_root;
-			*entry = mas_root(mas);
-			return true;
-		}
+	if (unlikely(mas_is_none(mas))) {
+		/*
+		 * Walked to the location, and there was nothing so the previous
+		 * location is 0.
+		 */
+		mas->last = mas->index = 0;
+		mas->status = ma_root;
+		*entry = mas_root(mas);
+		return true;
 	}
 
 active:
@@ -6905,7 +6891,7 @@ retry:
 	if (entry)
 		goto unlock;
 
-	while (mas_searchable(&mas) && (mas.last < max)) {
+	while (mas_is_active(&mas) && (mas.last < max)) {
 		entry = mas_next_entry(&mas, max);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
@@ -6987,26 +6973,6 @@ unsigned int mt_nr_allocated(void)
 	return kmem_cache_nr_allocated(maple_node_cache);
 }
 
-/*
- * mas_dead_node() - Check if the maple state is pointing to a dead node.
- * @mas: The maple state
- * @index: The index to restore in @mas.
- *
- * Used in test code.
- * Return: 1 if @mas has been reset to MAS_START, 0 otherwise.
- */
-static inline int mas_dead_node(struct ma_state *mas, unsigned long index)
-{
-	if (unlikely(!mas_searchable(mas) || mas_is_start(mas)))
-		return 0;
-
-	if (likely(!mte_dead_node(mas->node)))
-		return 0;
-
-	mas_rewalk(mas, index);
-	return 1;
-}
-
 void mt_cache_shrink(void)
 {
 }
@@ -7558,7 +7524,7 @@ void mt_validate(struct maple_tree *mt)
 	MA_STATE(mas, mt, 0, 0);
 	rcu_read_lock();
 	mas_start(&mas);
-	if (!mas_searchable(&mas))
+	if (!mas_is_active(&mas))
 		goto done;
 
 	while (!mte_is_leaf(mas.node))
--- a/tools/testing/radix-tree/maple.c~maple_tree-remove-mas_searchable
+++ a/tools/testing/radix-tree/maple.c
@@ -974,8 +974,10 @@ retry:
 	if (likely(mas->offset != MAPLE_NODE_SLOTS))
 		entry = mas_get_slot(mas, mas->offset);
 
-	if (mas_dead_node(mas, index))
+	if (mas_is_active(mas) && mte_dead_node(mas->node)) {
+		mas_set(mas, index);
 		goto retry;
+	}
 
 	return entry;
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


