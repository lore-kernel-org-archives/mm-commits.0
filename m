Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8558B1C57B7
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668038; cv=none; b=coOhHbZcVnqgCuJZ31k/g0h37UfUAEBdwAM5ts0M4M6J/olZIFCrwOs14lx7ckYuGfvRfzR2Bvv9UzXYB2HF41teiLmwH3y8E9lvVXwBQxBccV+YfrkJC6vjYxIyHWi/T9uwyD3qeoOXh9HWYunXcsqGElfxv5qQTy51d5NhjvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668038; c=relaxed/simple;
	bh=QZdxDl6JrVcD5KijGCU3pD722XVFvgVKOwF7m12Xwl0=;
	h=Date:To:From:Subject:Message-Id; b=RxnvJeWEM05lYtULdxuMj5L+Y+ggQlbrjHaoI46bkrQ+EFjfYGuxIDunWnw+wmOQMTTPA0b5iNfpLuJePbUHINszLw1BRJ3KIqEwcJ5S5lLa7eCe2eZJNnUp6HFfFe1YVjmFABC0AzPIVKIfk+N0MgkhKbpY6FbycplnU47FF7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHYIE9N3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHYIE9N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D08C116B1;
	Wed, 14 Aug 2024 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668038;
	bh=QZdxDl6JrVcD5KijGCU3pD722XVFvgVKOwF7m12Xwl0=;
	h=Date:To:From:Subject:From;
	b=lHYIE9N3yxLAtrDVr+hLsKcxoN1D4lU6GWZvKYFGkzm+79vhvcqSWAxQkkRHWK5Ze
	 mmwkNcB7DZbe/U9JbME6X+n5K43LFs/0xjVm+MynG+agfHJJ9T2Q/ixr/qnxODwCK4
	 RcpQZizDnJyc/QBn7pbeN5feKMwke1x2bcKFjxaA=
Date: Wed, 14 Aug 2024 13:40:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-have-mas_store-allocate-nodes-if-needed.patch added to mm-unstable branch
Message-Id: <20240814204038.55D08C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: have mas_store() allocate nodes if needed
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-have-mas_store-allocate-nodes-if-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-have-mas_store-allocate-nodes-if-needed.patch

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
Subject: maple_tree: have mas_store() allocate nodes if needed
Date: Wed, 14 Aug 2024 12:19:40 -0400

Not all users of mas_store() enter with nodes already preallocated.
Check for the MA_STATE_PREALLOC flag to decide whether to preallocate nodes
within mas_store() rather than relying on future write helper functions
to perform the allocations. This allows the write helper functions to be
simplified as they do not have to do checks to make sure there are
enough allocated nodes to perform the write.

Link: https://lkml.kernel.org/r/20240814161944.55347-14-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-have-mas_store-allocate-nodes-if-needed
+++ a/lib/maple_tree.c
@@ -5477,13 +5477,12 @@ static inline void mte_destroy_walk(stru
  * @entry: The entry to store.
  *
  * The @mas->index and @mas->last is used to set the range for the @entry.
- * Note: The @mas should have pre-allocated entries to ensure there is memory to
- * store the entry.  Please see mas_expected_entries()/mas_destroy() for more details.
  *
  * Return: the first entry between mas->index and mas->last or %NULL.
  */
 void *mas_store(struct ma_state *mas, void *entry)
 {
+	int request;
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	trace_ma_write(__func__, mas, 0, entry);
@@ -5506,7 +5505,23 @@ void *mas_store(struct ma_state *mas, vo
 	 */
 	mas_wr_prealloc_setup(&wr_mas);
 	mas_wr_store_type(&wr_mas);
+	if (mas->mas_flags & MA_STATE_PREALLOC) {
+		mas_wr_store_entry(&wr_mas);
+		MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
+		return wr_mas.content;
+	}
+
+	request = mas_prealloc_calc(mas, entry);
+	if (!request)
+		goto store;
+
+	mas_node_count(mas, request);
+	if (mas_is_err(mas))
+		return NULL;
+
+store:
 	mas_wr_store_entry(&wr_mas);
+	mas_destroy(mas);
 	return wr_mas.content;
 }
 EXPORT_SYMBOL_GPL(mas_store);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch
maple_tree-add-test-to-replicate-low-memory-race-conditions.patch
maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-preallocate-nodes-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
maple_tree-make-write-helper-functions-void.patch

