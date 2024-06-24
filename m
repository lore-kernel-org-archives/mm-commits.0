Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515632233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261518; cv=none; b=gdwicXnGR5BuR8ehvCzb6kOMT79GTkU7XWtvfCpZdbt5TNWmR2Yf98Of9JrSFK6O+AEsDcZuVo1AmT7CzdHc25sHeNoki0XdpcX6dA55+VSGSN+SWyTfvKfpoGmjjvv4SQy0BJOsgND9OGkGtpO9Uo/B07W9Aptrr4zz+eaz0uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261518; c=relaxed/simple;
	bh=Bxd34pEJ/M+lRpFSWgaVW/LC5RABXsYpVlpZehH43zA=;
	h=Date:To:From:Subject:Message-Id; b=LPRfyvMBMEIQcbGJcGdLrzGFxbTXtG8kM/hj+5GTSZL2Jiu5X23XHL15gIzCKv7Lt9EBJzJT6WRTpwbNOzHTdnHzUsg1ZejmMH5AAOqVQY48Ty2SrOhOcodgMTTDsUASLqV7Y9qTTQVz+FiRBGrUZHuT8yzc0Ycazq3I/JV0OQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UNI58p90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UNI58p90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49DCC2BBFC;
	Mon, 24 Jun 2024 20:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261517;
	bh=Bxd34pEJ/M+lRpFSWgaVW/LC5RABXsYpVlpZehH43zA=;
	h=Date:To:From:Subject:From;
	b=UNI58p90aWLJBMLyqUmA4a4gc5gT9CKWkCgsSm29UkD1PFJQCd+77eNdnEvKn343s
	 DZ0Sg+PHXhfT5JLD/fCqscLF6zScRHe4cHcSU9jvc1LFr0zSResjUOC15UOZaqFQBc
	 BIPyi96URHkTsFF2om2TW7+5aeOtnLfmNEFbsBdg=
Date: Mon, 24 Jun 2024 13:38:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-store-type-in-mas_wr_store_entry.patch added to mm-unstable branch
Message-Id: <20240624203837.A49DCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use store type in mas_wr_store_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-store-type-in-mas_wr_store_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-store-type-in-mas_wr_store_entry.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: use store type in mas_wr_store_entry()
Date: Tue, 18 Jun 2024 13:47:43 -0700

When storing an entry, we can read the store type that was set from a
previous partial walk of the tree.  Now that the type of store is known,
select the correct write helper function to use to complete the store.

Also noinline mas_wr_spanning_store() to limit stack frame usage in
mas_wr_store_entry() as it allocates a maple_big_node on the stack.

Link: https://lkml.kernel.org/r/20240618204750.79512-10-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   54 ++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 17 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-store-type-in-mas_wr_store_entry
+++ a/lib/maple_tree.c
@@ -3780,7 +3780,7 @@ done:
  *
  * Return: 0 on error, positive on success.
  */
-static inline int mas_wr_spanning_store(struct ma_wr_state *wr_mas)
+static noinline int mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
@@ -4206,25 +4206,43 @@ slow_path:
 static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
+	unsigned char new_end = mas_wr_new_end(wr_mas);
 
-	wr_mas->content = mas_start(mas);
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_store_root(mas, wr_mas->entry);
+	switch (mas->store_type) {
+	case wr_invalid:
+		MT_BUG_ON(mas->tree, 1);
 		return;
-	}
-
-	if (unlikely(!mas_wr_walk(wr_mas))) {
+	case wr_new_root:
+		mas_new_root(mas, wr_mas->entry);
+		break;
+	case wr_store_root:
+		mas_store_root(mas, wr_mas->entry);
+		break;
+	case wr_exact_fit:
+		rcu_assign_pointer(wr_mas->slots[mas->offset], wr_mas->entry);
+		if (!!wr_mas->entry ^ !!wr_mas->content)
+			mas_update_gap(mas);
+		break;
+	case wr_append:
+		mas_wr_append(wr_mas, new_end);
+		break;
+	case wr_slot_store:
+		mas_wr_slot_store(wr_mas);
+		break;
+	case wr_node_store:
+		mas_wr_node_store(wr_mas, new_end);
+		break;
+	case wr_spanning_store:
 		mas_wr_spanning_store(wr_mas);
-		return;
+		break;
+	case wr_split_store:
+	case wr_rebalance:
+	case wr_bnode:
+		mas_wr_bnode(wr_mas);
+		break;
 	}
 
-	/* At this point, we are at the leaf node that needs to be altered. */
-	mas_wr_end_piv(wr_mas);
-	/* New root for a single pointer */
-	if (unlikely(!mas->index && mas->last == ULONG_MAX))
-		mas_new_root(mas, wr_mas->entry);
-	else
-		mas_wr_modify(wr_mas);
+	return;
 }
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
@@ -5587,7 +5605,8 @@ void *mas_store(struct ma_state *mas, vo
 	 * want to examine what happens if a single store operation was to
 	 * overwrite multiple entries within a self-balancing B-Tree.
 	 */
-	mas_wr_store_setup(&wr_mas);
+	mas_wr_prealloc_setup(&wr_mas);
+	mas_wr_store_type(&wr_mas);
 	mas_wr_store_entry(&wr_mas);
 	return wr_mas.content;
 }
@@ -5636,7 +5655,8 @@ void mas_store_prealloc(struct ma_state
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	mas_wr_store_setup(&wr_mas);
+	mas_wr_prealloc_setup(&wr_mas);
+	mas_wr_store_type(&wr_mas);
 	trace_ma_write(__func__, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-remove-setclearhpage-macros.patch
mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch
maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-use-mas_store_gfp-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
tools-testing-radix-tree-add-missing-module_description-definition.patch

