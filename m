Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCD02233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261521; cv=none; b=NACY45++qpkHhGwm2jiZ42gboh/FBDPJnCl+9xNBk5n9vjcnRiPplvjGxT6H+hJRP/w3fGkOvfEYoFP/xK5OW8sG20D3i/5UI2dpVMx0L+jMsHFgXwVggb3G3kggDeviWyDjqgoF4CpxVims23x3HrKwtsD54fg6JUEkAzoCGao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261521; c=relaxed/simple;
	bh=m7BKS0c+/scsZl40Mrhc8eszVJN9hBOtIB7pKiMyGuE=;
	h=Date:To:From:Subject:Message-Id; b=lbTdJ9jQIhE+eopnQPkJrl69e8mJNlI24uktPauVq4cJTqAzhckv4JoaN5uSybOS4+v/7W+THs+Fw77HiSqvOZWx6HfKKNvcRiKxkzZq0IlBzK2JHcuSIOvJrA0309NJwiiymusKKRdGVdlgdl9ieDV7ZpB1/TmYegtEq06J9LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rMQAplxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rMQAplxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60248C2BBFC;
	Mon, 24 Jun 2024 20:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261521;
	bh=m7BKS0c+/scsZl40Mrhc8eszVJN9hBOtIB7pKiMyGuE=;
	h=Date:To:From:Subject:From;
	b=rMQAplxDq8PUbKIB8w8ZccE3F58o1gpKE3rFHCh1ZgA0p6G1a/NsVYiz7tN/9JxOU
	 pgMw3j02pXij0/nENwb/MLWEMz0rmLodYkw6SNVgaen9NHp7hY1bqv+Qyaz7e1+40k
	 Q4mUzOD8RZTQzhChXF85tn5Jw8TzESkBqcAXzmds=
Date: Mon, 24 Jun 2024 13:38:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-simplify-mas_commit_b_node.patch added to mm-unstable branch
Message-Id: <20240624203841.60248C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: simplify mas_commit_b_node()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-simplify-mas_commit_b_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-simplify-mas_commit_b_node.patch

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
Subject: maple_tree: simplify mas_commit_b_node()
Date: Tue, 18 Jun 2024 13:47:45 -0700

Use mas->store_type to simplify the logic of identifying the type of
write.  We can also use mas_new_ma_node() instead of mt_mk_node() to
remove b_type and clean up the local variables.

Link: https://lkml.kernel.org/r/20240618204750.79512-12-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_commit_b_node
+++ a/lib/maple_tree.c
@@ -3431,18 +3431,14 @@ static inline bool mas_reuse_node(struct
 static noinline_for_kasan int mas_commit_b_node(struct ma_wr_state *wr_mas,
 			    struct maple_big_node *b_node, unsigned char end)
 {
-	struct maple_node *node;
-	struct maple_enode *old_enode;
-	unsigned char b_end = b_node->b_end;
-	enum maple_type b_type = b_node->type;
+	unsigned char b_end = 0;
+	struct maple_enode *new_enode;
+	struct maple_enode *old_enode = wr_mas->mas->node;
 
-	old_enode = wr_mas->mas->node;
-	if ((b_end < mt_min_slots[b_type]) &&
-	    (!mte_is_root(old_enode)) &&
-	    (mas_mt_height(wr_mas->mas) > 1))
+	if (wr_mas->mas->store_type == wr_rebalance)
 		return mas_rebalance(wr_mas->mas, b_node);
 
-	if (b_end >= mt_slots[b_type])
+	if (wr_mas->mas->store_type == wr_split_store)
 		return mas_split(wr_mas->mas, b_node);
 
 	if (mas_reuse_node(wr_mas, b_node, end))
@@ -3452,9 +3448,10 @@ static noinline_for_kasan int mas_commit
 	if (mas_is_err(wr_mas->mas))
 		return 0;
 
-	node = mas_pop_node(wr_mas->mas);
-	node->parent = mas_mn(wr_mas->mas)->parent;
-	wr_mas->mas->node = mt_mk_node(node, b_type);
+	b_end = b_node->b_end;
+	new_enode = mas_new_ma_node(wr_mas->mas, b_node);
+	mte_to_node(new_enode)->parent = mte_to_node(old_enode)->parent;
+	wr_mas->mas->node = new_enode;
 	mab_mas_cp(b_node, 0, b_end, wr_mas->mas, false);
 	mas_replace_node(wr_mas->mas, old_enode);
 reuse_node:
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

