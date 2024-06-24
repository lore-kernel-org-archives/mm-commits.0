Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6322233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261525; cv=none; b=IOIFV5ci/4SM61myuPkCfgXBa0JDh1XHCkTd6O186X9SI/uIM5B+EE2niVVbfzLwRKZhWcUx+KyK84VuOkzMpb/YgcF2wREjLwgY35GQmT91IegrC4lTHtZ9Z0ZJ46N08xlTVSt+oq+mHXvItHvRvqKF18zCFlU001S7nHmN6kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261525; c=relaxed/simple;
	bh=mr55nPBlwEUK5TnU7ci8XAWWIXwfiJEj3Gut3CLwwA0=;
	h=Date:To:From:Subject:Message-Id; b=ufb7Fz5XPX32JHP3x/oqfNWuQMGmYhu/17ehnXSwNsTW9hMbLbv6NaaioKWdjSrfO5/eo5Ojr1JGd13AME68VtEnLK+dG3OKAmFq+fF5PL3zNB5GnJxH4I2aldHg6yrW/EIB9FsSFjk0YO4tWR2v92jFJzJ7A33hSZ0/1rOcka0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RovAHdYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RovAHdYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F418DC2BBFC;
	Mon, 24 Jun 2024 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261525;
	bh=mr55nPBlwEUK5TnU7ci8XAWWIXwfiJEj3Gut3CLwwA0=;
	h=Date:To:From:Subject:From;
	b=RovAHdYNxrHQa50vEsN4uymY8iSwP/VrkiiL+qRnQeUlgexRHKoYQGFoFxqWcn3b7
	 L7g5UWDSXtr82Je8R24H/eDQ+SdZJdjtJ7uMd3fuvmNeQgEOlFl/PKsQ1LcRuWH8AY
	 kmdUX5QJ9QX9z0eB8dT80EPKQ9MU6YHgrVlwo+Ig=
Date: Mon, 24 Jun 2024 13:38:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-have-mas_store-allocate-nodes-if-needed.patch added to mm-unstable branch
Message-Id: <20240624203844.F418DC2BBFC@smtp.kernel.org>
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
Date: Tue, 18 Jun 2024 13:47:47 -0700

Not all users of mas_store() enter with nodes already preallocated.  Check
for the MA_STATE_PREALLOC flag to decide whether to preallocate nodes
within mas_store() rather than relying on future write helper functions to
perform the allocations.  This allows the write helper functions to be
simplified as they do not have to do checks to make sure there are enough
allocated nodes to perform the write.

Link: https://lkml.kernel.org/r/20240618204750.79512-14-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-have-mas_store-allocate-nodes-if-needed
+++ a/lib/maple_tree.c
@@ -5536,13 +5536,12 @@ static inline void mte_destroy_walk(stru
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
@@ -5565,7 +5564,24 @@ void *mas_store(struct ma_state *mas, vo
 	 */
 	mas_wr_prealloc_setup(&wr_mas);
 	mas_wr_store_type(&wr_mas);
+	WARN_ON_ONCE(mas->store_type == wr_invalid);
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

