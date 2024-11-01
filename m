Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDF8BE4F
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420442; cv=none; b=I2rg43baguWdRVXaV27EZ6lwGnnY38L9ygLROBR27L1ot1ZMyI4MJwLBSfmtwC5HLKl0heCEigQG4cDMrvR7V4pNXWWThPfp9V3vKfl1T/uedThSzGa7DnJ25k572Upzvq56GQt+N7WvDtq33/oCP6YeAuqNVFt3AMLJkCH0WCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420442; c=relaxed/simple;
	bh=FvI2YK0GQF8t0Wk6pYM+Llepkv+EMowpDRvDqL/5kh4=;
	h=Date:To:From:Subject:Message-Id; b=bqEVNR4K+GZCCwCbbQuyZbQSnuAxMcfydgCXZn+TSkfxXmsiw354pou4bl1Y6F3KNp7DUyvIfme+0UEbUtttxXtlfa4/pfdfiOcWI4dpM5gOPBe8OwhJ51c0A2XZVSKArKhjPwjt8ReWtAZaTrc6pG69yjOohzIiJwfzcvS/yXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d3OI1c4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d3OI1c4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDEAC4CEC3;
	Fri,  1 Nov 2024 00:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420442;
	bh=FvI2YK0GQF8t0Wk6pYM+Llepkv+EMowpDRvDqL/5kh4=;
	h=Date:To:From:Subject:From;
	b=d3OI1c4OuFytI6uz2cGCPl3AjyhaUu5d9e8PSNfA5jU6TBcToX1wdgogxqz+GMk2D
	 dub2f5jtx1r3VYLVw8BHfSii10vnBx2PayXDDRibHd/Ny7fWgE9gDty6DzVxLAbn76
	 Q+2jLnt7oLY7HdAtvOC77UTDASqQCYY3SBAYOUQY=
Date: Thu, 31 Oct 2024 17:20:41 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch added to mm-unstable branch
Message-Id: <20241101002042.0EDEAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: the return value of mas_root_expand() is not used
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: the return value of mas_root_expand() is not used
Date: Thu, 31 Oct 2024 23:16:24 +0000

No user of the return value now, just remove it.

Link: https://lkml.kernel.org/r/20241031231627.14316-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-the-return-value-of-mas_root_expand-is-not-used
+++ a/lib/maple_tree.c
@@ -3408,7 +3408,7 @@ static noinline_for_kasan void mas_commi
  * @mas: The maple state
  * @entry: The entry to store into the tree
  */
-static inline int mas_root_expand(struct ma_state *mas, void *entry)
+static inline void mas_root_expand(struct ma_state *mas, void *entry)
 {
 	void *contents = mas_root_locked(mas);
 	enum maple_type type = maple_leaf_64;
@@ -3444,7 +3444,7 @@ static inline int mas_root_expand(struct
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	return slot;
+	return;
 }
 
 static inline void mas_store_root(struct ma_state *mas, void *entry)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

