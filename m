Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ADA2233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261502; cv=none; b=mixI5DKZa9CmnqnDiHMiLCHZiF3wReIBfd3757rw4LvoP4Qf5clTpkKAsz5T5sNWVXnYrJCLNorIJAIsHpRL7sGHUry6NJVzCfSFUrp3m5NJu4zBOKKsdt1fyYS4AInCkHTDBK2VC2CJyj9zZmqZi5SyGE4/lAdjw57SS08WiXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261502; c=relaxed/simple;
	bh=MvsscpwsvJ0VHEx8Nwq1kGg/WNlxPS7RaWhDQHdTuc4=;
	h=Date:To:From:Subject:Message-Id; b=ozYUoQ37Pl8airmea7iuh4VQkXtEDkm5xjJkR8BoXsz49uynkKDFLTpOAzRySqXyPaIUJP4vRDM5dMn1IADbc4G5fLdNOFiuQpbhUH5Q060VnCt7HAdS69tLnihjBMc13Q1unwBgi0b9BVPjgO1EOOPL1BjpxVtqrhwFfH7+zko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRVgZbSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRVgZbSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA8CC2BBFC;
	Mon, 24 Jun 2024 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261502;
	bh=MvsscpwsvJ0VHEx8Nwq1kGg/WNlxPS7RaWhDQHdTuc4=;
	h=Date:To:From:Subject:From;
	b=KRVgZbSD5W4THm3dOtXxUMtIr06OtxenkoYv58Fvoe4NWUl2WtVIvK4MNKKrfp98E
	 dQhWWjRJSdudTMH8v4lppL7vS49ALhTTrT/wblG5k1CGthuXZepE2YLERwTXK/dYok
	 YZ2bFqnHvjsXgMs8LYlx257b27bTAPscZGtGwr9I=
Date: Mon, 24 Jun 2024 13:38:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-store_type-enum.patch added to mm-unstable branch
Message-Id: <20240624203821.DDA8CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: introduce store_type enum
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-store_type-enum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-store_type-enum.patch

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
Subject: maple_tree: introduce store_type enum
Date: Tue, 18 Jun 2024 13:47:35 -0700

This series implements two work items[1]: "aligning mas_store_gfp() with
mas_preallocate()" and "enum for store type".  

mas_store_gfp() is modified to preallocate nodes.  This simplies many of
the write helper functions by allowing them to use mas_store_gfp() rather
than open coding node allocation and error handling.

The enum defines the following store types:

enum store_type {
	wr_invalid,
	wr_new_root,
	wr_store_root,
	wr_exact_fit,
	wr_spanning_store,
	wr_split_store,
	wr_rebalance,
	wr_append,
	wr_node_store,
	wr_slot_store,
	wr_bnode
};

In the current maple tree code, a walk down the tree is done in
mas_preallocate() to determine the number of nodes needed for this write. 
After node allocation, mas_wr_store_entry() will perform another walk to
determine which write helper function to use to complete the write.

Rather than performing the second walk, we can store the type of write in
the maple write state during node allocation and read this field to
complete the write.

================================ RESULTS =================================

                  v6.10_mmap     v6.10_mmap_store_type
Duration User           9.80        8.69
Duration System      2295.94     2243.85
Duration Elapsed     1010.50     1009.44

================================ TESTING =================================

Testing was done with the maple tree test suite. A new test case is also
added to validate the order in which we test for and assign the store type.

[1]: https://lists.infradead.org/pipermail/maple-tree/2023-December/003098.html





Add a store_type enum that is stored in ma_state.  This will be used to
keep track of partial walks of the tree so that subsequent walks can pick
up where a previous walk left off.

Link: https://lkml.kernel.org/r/20240618204750.79512-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20240618204750.79512-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-introduce-store_type-enum
+++ a/include/linux/maple_tree.h
@@ -148,6 +148,19 @@ enum maple_type {
 	maple_arange_64,
 };
 
+enum store_type {
+	wr_invalid,
+	wr_new_root,
+	wr_store_root,
+	wr_exact_fit,
+	wr_spanning_store,
+	wr_split_store,
+	wr_rebalance,
+	wr_append,
+	wr_node_store,
+	wr_slot_store,
+	wr_bnode
+};
 
 /**
  * DOC: Maple tree flags
@@ -436,6 +449,7 @@ struct ma_state {
 	unsigned char offset;
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
+	enum store_type store_type;	/* The type of store needed for this operation */
 };
 
 struct ma_wr_state {
@@ -477,6 +491,7 @@ struct ma_wr_state {
 		.max = ULONG_MAX,					\
 		.alloc = NULL,						\
 		.mas_flags = 0,						\
+		.store_type = wr_invalid,				\
 	}
 
 #define MA_WR_STATE(name, ma_state, wr_entry)				\
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

