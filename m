Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BB2233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261519; cv=none; b=azNGeeSn3mQrMDxfCFBm2mULjfkZzUNhpivDn3eIXYhWOevM1hmLF3fMVfSfAyiMzq97cFxd4yhihOPhn7iJgmJdzFyqsZvt5y7O7ltpe1/FYFK+GqwD9Ys7zzkQT2oBCZV5O6xDUiKr0QjaH06p+lePGjpRkgLvQZq2zTv2c0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261519; c=relaxed/simple;
	bh=VXccMepcKV97JMwLF4q4m2L7+tOCaOpP8n9ElZmFGAU=;
	h=Date:To:From:Subject:Message-Id; b=l5/tr/1MF3+qHfWQSgcozWLpxJYg9ToCvILdZVxkHqDPm+wldOBALY3AETgXAFOKhCr1hdVDxYvWD6m8mIgZIiXzTSqhds1gWngUdgo0Ojd4N7VzbLIBsdYPzRfUHK/SuGwy82hpXKSCIeNgaHL+KipUo6qZthHNcynBxRs+Vwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dd8dpLn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dd8dpLn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8537CC2BBFC;
	Mon, 24 Jun 2024 20:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261519;
	bh=VXccMepcKV97JMwLF4q4m2L7+tOCaOpP8n9ElZmFGAU=;
	h=Date:To:From:Subject:From;
	b=dd8dpLn/U7cWLBNsN97ACSUOpA52tXzTPzXY9dsW28HJKuOQ/X7wE0IeXM0ed2YaT
	 H/I5l0e86sDdsC6bTD+4dnTIPpOyCBYLogWdQQf/47RC7A/bw+fidNQqMhrzvkPR0d
	 m3Er4OA8u0chhAWhqy6BFDFTZwgd9SMUyR+ZlXM0=
Date: Mon, 24 Jun 2024 13:38:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-convert-mas_insert-to-preallocate-nodes.patch added to mm-unstable branch
Message-Id: <20240624203839.8537CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: convert mas_insert() to preallocate nodes
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-convert-mas_insert-to-preallocate-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-convert-mas_insert-to-preallocate-nodes.patch

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
Subject: maple_tree: convert mas_insert() to preallocate nodes
Date: Tue, 18 Jun 2024 13:47:44 -0700

By setting the store type in mas_insert(), we no longer need to use
mas_wr_modify() to determine the correct store function to use.  Instead,
set the store type and call mas_wr_store_entry().  Also, pass in the
requested gfp flags to mas_insert() so they can be passed to the call to
mas_wr_preallocate().

Link: https://lkml.kernel.org/r/20240618204750.79512-11-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/lib/maple_tree.c~maple_tree-convert-mas_insert-to-preallocate-nodes
+++ a/lib/maple_tree.c
@@ -4442,11 +4442,12 @@ static inline void mas_wr_preallocate(st
  * mas_insert() - Internal call to insert a value
  * @mas: The maple state
  * @entry: The entry to store
+ * @gfp: The GFP_FLAGS to use for allocations
  *
  * Return: %NULL or the contents that already exists at the requested index
  * otherwise.  The maple state needs to be checked for error conditions.
  */
-static inline void *mas_insert(struct ma_state *mas, void *entry)
+static inline void *mas_insert(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
@@ -4468,26 +4469,24 @@ static inline void *mas_insert(struct ma
 	if (wr_mas.content)
 		goto exists;
 
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_store_root(mas, entry);
+	mas_wr_preallocate(&wr_mas, entry, gfp);
+	if (mas_is_err(mas))
 		return NULL;
-	}
 
 	/* spanning writes always overwrite something */
-	if (!mas_wr_walk(&wr_mas))
+	if (mas->store_type == wr_spanning_store)
 		goto exists;
 
 	/* At this point, we are at the leaf node that needs to be altered. */
-	wr_mas.offset_end = mas->offset;
-	wr_mas.end_piv = wr_mas.r_max;
-
-	if (wr_mas.content || (mas->last > wr_mas.r_max))
-		goto exists;
+	if (mas->store_type != wr_new_root && mas->store_type != wr_store_root) {
+		wr_mas.offset_end = mas->offset;
+		wr_mas.end_piv = wr_mas.r_max;
 
-	if (!entry)
-		return NULL;
+		if (wr_mas.content || (mas->last > wr_mas.r_max))
+			goto exists;
+	}
 
-	mas_wr_modify(&wr_mas);
+	mas_wr_store_entry(&wr_mas);
 	return wr_mas.content;
 
 exists:
@@ -4532,7 +4531,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		return ret;
 
 	do {
-		mas_insert(mas, entry);
+		mas_insert(mas, entry, gfp);
 	} while (mas_nomem(mas, gfp));
 	if (mas_is_err(mas))
 		return xa_err(mas->node);
@@ -6536,7 +6535,7 @@ int mtree_insert_range(struct maple_tree
 
 	mtree_lock(mt);
 retry:
-	mas_insert(&ms, entry);
+	mas_insert(&ms, entry, gfp);
 	if (mas_nomem(&ms, gfp))
 		goto retry;
 
@@ -6585,7 +6584,7 @@ retry:
 	if (ret)
 		goto unlock;
 
-	mas_insert(&mas, entry);
+	mas_insert(&mas, entry, gfp);
 	/*
 	 * mas_nomem() may release the lock, causing the allocated area
 	 * to be unavailable, so try to allocate a free area again.
@@ -6667,7 +6666,7 @@ retry:
 	if (ret)
 		goto unlock;
 
-	mas_insert(&mas, entry);
+	mas_insert(&mas, entry, gfp);
 	/*
 	 * mas_nomem() may release the lock, causing the allocated area
 	 * to be unavailable, so try to allocate a free area again.
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

