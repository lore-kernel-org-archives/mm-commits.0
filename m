Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC1126C10
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854798; cv=none; b=rBYQ1+KyUQX8ovtySkTpbZ8ADeXy1M/zkt1+19uu2fwo107vuTerBEKIQPSfqhJ4TDzQUe8BILVgtW8CvNRy7CmlA8DiDFlr1bPJEew+je9eZhNOvgPHZs17sZwFejG9Cw394+zsJ/nln1t0+vLkfOYDG73vdQtv85Q8DJPU5p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854798; c=relaxed/simple;
	bh=hUTqXFkgiiFaUL/H2F+oZJmDWS7Dcp5o1UpZ1x2ClyI=;
	h=Date:To:From:Subject:Message-Id; b=cM0xRuLdeJNqXiWXHPNyc25yNN0v0yDYmCnMyEUn57Yzi2eJFl2ac884sH3CPE3TgK74OQ9ilKNJtiJbxOPUmETuZOGkP7afqWta03TkrZySYVqQu91insAxv6pOhsSMVTTJIZXMOACenLXpGpPPxTH5IelIDmwERaa7lFm5MQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOfDaaU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOfDaaU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E670EC4CECF;
	Wed,  6 Nov 2024 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854798;
	bh=hUTqXFkgiiFaUL/H2F+oZJmDWS7Dcp5o1UpZ1x2ClyI=;
	h=Date:To:From:Subject:From;
	b=UOfDaaU87AOb2x4auP5KI021KLBKb86BHsk8o5aS/Kl0kHqrUwkW1FivNEBy8ecFi
	 SGrZvmoHJuBSEwyjUPdLrriv9kAj0lFZ9gfhSB8qsWL4DKHHLWh0WjxuSpRhJcKDcs
	 f0T6uUr05qwbRmsi/HSVQH7JtM+8chjcSenQxNhw=
Date: Tue, 05 Nov 2024 16:59:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-refactor-mas_wr_store_type.patch removed from -mm tree
Message-Id: <20241106005957.E670EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: refactor mas_wr_store_type()
has been removed from the -mm tree.  Its filename was
     maple_tree-refactor-mas_wr_store_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: refactor mas_wr_store_type()
Date: Fri, 11 Oct 2024 17:44:51 -0400

In mas_wr_store_type(), we check if new_end < mt_slots[wr_mas->type].  If
this check fails, we know that ,after this, new_end is >= mt_min_slots. 
Checking this again when we detect a wr_node_store later in the function
is reduntant.  Because this check is part of an OR statement, the
statement will always evaluate to true, therefore we can just get rid of
it.

We also refactor mas_wr_store_type() to return the store type rather than
set it directly as it greatly cleans up the function.

Link: https://lkml.kernel.org/r/20241011214451.7286-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha <sidhartha.kumar@oracle.com>
Suggested-by: Liam Howlett <liam.howlett@oracle.com>
Suggested-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   72 +++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 47 deletions(-)

--- a/lib/maple_tree.c~maple_tree-refactor-mas_wr_store_type
+++ a/lib/maple_tree.c
@@ -4191,24 +4191,22 @@ static inline int mas_prealloc_calc(stru
 }
 
 /*
- * mas_wr_store_type() - Set the store type for a given
+ * mas_wr_store_type() - Determine the store type for a given
  * store operation.
  * @wr_mas: The maple write state
+ *
+ * Return: the type of store needed for the operation
  */
-static inline void mas_wr_store_type(struct ma_wr_state *wr_mas)
+static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char new_end;
 
-	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas))) {
-		mas->store_type = wr_store_root;
-		return;
-	}
+	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
+		return wr_store_root;
 
-	if (unlikely(!mas_wr_walk(wr_mas))) {
-		mas->store_type = wr_spanning_store;
-		return;
-	}
+	if (unlikely(!mas_wr_walk(wr_mas)))
+		return wr_spanning_store;
 
 	/* At this point, we are at the leaf node that needs to be altered. */
 	mas_wr_end_piv(wr_mas);
@@ -4216,50 +4214,30 @@ static inline void mas_wr_store_type(str
 		mas_wr_extend_null(wr_mas);
 
 	new_end = mas_wr_new_end(wr_mas);
-	if ((wr_mas->r_min == mas->index) && (wr_mas->r_max == mas->last)) {
-		mas->store_type = wr_exact_fit;
-		return;
-	}
+	if ((wr_mas->r_min == mas->index) && (wr_mas->r_max == mas->last))
+		return wr_exact_fit;
 
-	if (unlikely(!mas->index && mas->last == ULONG_MAX)) {
-		mas->store_type = wr_new_root;
-		return;
-	}
+	if (unlikely(!mas->index && mas->last == ULONG_MAX))
+		return wr_new_root;
 
 	/* Potential spanning rebalance collapsing a node */
 	if (new_end < mt_min_slots[wr_mas->type]) {
-		if (!mte_is_root(mas->node) && !(mas->mas_flags & MA_STATE_BULK)) {
-			mas->store_type = wr_rebalance;
-			return;
-		}
-		mas->store_type = wr_node_store;
-		return;
+		if (!mte_is_root(mas->node) && !(mas->mas_flags & MA_STATE_BULK))
+			return  wr_rebalance;
+		return wr_node_store;
 	}
 
-	if (new_end >= mt_slots[wr_mas->type]) {
-		mas->store_type = wr_split_store;
-		return;
-	}
+	if (new_end >= mt_slots[wr_mas->type])
+		return wr_split_store;
 
-	if (!mt_in_rcu(mas->tree) && (mas->offset == mas->end)) {
-		mas->store_type = wr_append;
-		return;
-	}
+	if (!mt_in_rcu(mas->tree) && (mas->offset == mas->end))
+		return wr_append;
 
 	if ((new_end == mas->end) && (!mt_in_rcu(mas->tree) ||
-		(wr_mas->offset_end - mas->offset == 1))) {
-		mas->store_type = wr_slot_store;
-		return;
-	}
-
-	if (mte_is_root(mas->node) || (new_end >= mt_min_slots[wr_mas->type]) ||
-		(mas->mas_flags & MA_STATE_BULK)) {
-		mas->store_type = wr_node_store;
-		return;
-	}
+		(wr_mas->offset_end - mas->offset == 1)))
+		return wr_slot_store;
 
-	mas->store_type = wr_invalid;
-	MAS_WARN_ON(mas, 1);
+	return wr_node_store;
 }
 
 /**
@@ -4274,7 +4252,7 @@ static inline void mas_wr_preallocate(st
 	int request;
 
 	mas_wr_prealloc_setup(wr_mas);
-	mas_wr_store_type(wr_mas);
+	mas->store_type = mas_wr_store_type(wr_mas);
 	request = mas_prealloc_calc(mas, entry);
 	if (!request)
 		return;
@@ -5446,7 +5424,7 @@ void *mas_store(struct ma_state *mas, vo
 	 * overwrite multiple entries within a self-balancing B-Tree.
 	 */
 	mas_wr_prealloc_setup(&wr_mas);
-	mas_wr_store_type(&wr_mas);
+	mas->store_type = mas_wr_store_type(&wr_mas);
 	if (mas->mas_flags & MA_STATE_PREALLOC) {
 		mas_wr_store_entry(&wr_mas);
 		MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
@@ -5549,7 +5527,7 @@ int mas_preallocate(struct ma_state *mas
 	int request;
 
 	mas_wr_prealloc_setup(&wr_mas);
-	mas_wr_store_type(&wr_mas);
+	mas->store_type = mas_wr_store_type(&wr_mas);
 	request = mas_prealloc_calc(mas, entry);
 	if (!request)
 		return ret;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


