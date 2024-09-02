Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0617224EF
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247841; cv=none; b=qwrOhBSXM/4XgBFfsYiHipfJmPLv5P//sPUCJf4LIiVAZjfGnEdYwUPJqCIQbrDrh4mVWQBcpJogHdssPQVCQ+PycmQru2aQgPhLsYj3vSIQYcCCLpYja5n5WAYQEGQI5PLQpNzYU+036z3hz09s4acSGXiEONf9+1547iVtEaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247841; c=relaxed/simple;
	bh=Cx1+AgvVNxlKBFAUZa6+JgT5hmRkbzvpsuVKatrUvhY=;
	h=Date:To:From:Subject:Message-Id; b=Ex4qIAG2db3f4ot2qQczF+fFW5DcYIv9S6muad8ziuLcck7xHqzGREUehxQxdRHL5NgRYchQZie6rPbK0pOtbrK9oC85uKBhA4X2w3pbyYrplQwb0A6M0D0J4/1NmevXGP2nOW93jyHoYgoEhh3hKTLf0W+oiYc/LQSq9UHEBrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRnxNCF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRnxNCF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78FAC4CEC2;
	Mon,  2 Sep 2024 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247840;
	bh=Cx1+AgvVNxlKBFAUZa6+JgT5hmRkbzvpsuVKatrUvhY=;
	h=Date:To:From:Subject:From;
	b=WRnxNCF0PThvwYlpbtqfjRUg6fOEoUcPcuPM/NREdPfGwTKKc9IK92aJYRGN8RmNU
	 GomAxG4oKzpMhNAr3Fpgos7N+Lc/jlLRRyFgV9dPRV6+8pkB8PxvS/qwvoYrUAyvuN
	 2EJoRbDiuioyPzH/pKYi36W0bGNepN8yHCUfXAM8=
Date: Sun, 01 Sep 2024 20:30:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-node-allocations-from-various-write-helper-functions.patch removed from -mm tree
Message-Id: <20240902033040.C78FAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove node allocations from various write helper functions
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-node-allocations-from-various-write-helper-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove node allocations from various write helper functions
Date: Wed, 14 Aug 2024 12:19:41 -0400

These write helper functions are all called from store paths which
preallocate enough nodes that will be needed for the write. There is no
more need to allocate within the functions themselves.

Link: https://lkml.kernel.org/r/20240814161944.55347-15-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-node-allocations-from-various-write-helper-functions
+++ a/lib/maple_tree.c
@@ -2976,9 +2976,6 @@ static inline int mas_rebalance(struct m
 	 * tries to combine the data in the same way.  If one node contains the
 	 * entire range of the tree, then that node is used as a new root node.
 	 */
-	mas_node_count(mas, empty_count * 2 - 1);
-	if (mas_is_err(mas))
-		return 0;
 
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
@@ -3029,11 +3026,6 @@ static inline void mas_destroy_rebalance
 
 	/* set up node. */
 	if (in_rcu) {
-		/* Allocate for both left and right as well as parent. */
-		mas_node_count(mas, 3);
-		if (mas_is_err(mas))
-			return;
-
 		newnode = mas_pop_node(mas);
 	} else {
 		newnode = &reuse;
@@ -3341,10 +3333,6 @@ static int mas_split(struct ma_state *ma
 
 	trace_ma_op(__func__, mas);
 	mas->depth = mas_mt_height(mas);
-	/* Allocation failures will happen early. */
-	mas_node_count(mas, 1 + mas->depth * 2);
-	if (mas_is_err(mas))
-		return 0;
 
 	mast.l = &l_mas;
 	mast.r = &r_mas;
@@ -3427,10 +3415,6 @@ static inline int mas_root_expand(struct
 	unsigned long *pivots;
 	int slot = 0;
 
-	mas_node_count(mas, 1);
-	if (unlikely(mas_is_err(mas)))
-		return 0;
-
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
@@ -3699,10 +3683,6 @@ static inline int mas_new_root(struct ma
 		goto done;
 	}
 
-	mas_node_count(mas, 1);
-	if (mas_is_err(mas))
-		return 0;
-
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
@@ -3765,9 +3745,6 @@ static noinline int mas_wr_spanning_stor
 	 * entries per level plus a new root.
 	 */
 	height = mas_mt_height(mas);
-	mas_node_count(mas, 1 + height * 3);
-	if (mas_is_err(mas))
-		return 0;
 
 	/*
 	 * Set up right side.  Need to get to the next offset after the spanning
@@ -3851,10 +3828,6 @@ static inline bool mas_wr_node_store(str
 
 	/* set up node. */
 	if (in_rcu) {
-		mas_node_count(mas, 1);
-		if (mas_is_err(mas))
-			return false;
-
 		newnode = mas_pop_node(mas);
 	} else {
 		memset(&reuse, 0, sizeof(struct maple_node));
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


