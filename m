Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915D22233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261514; cv=none; b=CDVzHfvLyLggoiPvxsn4wjaNneGWNexytFpGSDS/P/LeZeOdn69VpknHPpocVXekP89UWNrjObVvabltBoIF3JiFQhycrZCZMOrPNQw1+Aqj8F2jheWemR3SyHy3PTh6tlZs/8HUlFsjtGD+UCzpobNtzKSNRh/kiTdW11vDz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261514; c=relaxed/simple;
	bh=TfDkuEfOXI4EnUDGXH4H8zNYgcUi7vJdzv8I3bbvE98=;
	h=Date:To:From:Subject:Message-Id; b=KQZY7c1ATL8t/9FmGNQjkCzqhPchNDr2AXir5z/eYRXbrIxuOQhqoIkDJXbIQgjwvco/JsJiK3eQX9e7fqPk3hkRkQ2zDUYWYzgfoZv+T25V1jq+4SzWNJw4FjM9sgWlTlBAfW3GKLBQCTtdP74p8abqigw83Fcq/Hf5LTZmVXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icOPKifA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icOPKifA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A5AC2BBFC;
	Mon, 24 Jun 2024 20:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261514;
	bh=TfDkuEfOXI4EnUDGXH4H8zNYgcUi7vJdzv8I3bbvE98=;
	h=Date:To:From:Subject:From;
	b=icOPKifAd/87U6b9hDGtjePTcZd9ZVPDxA1piLf+MoXUg3V8Kzh+1DLyDfncWwCHh
	 K50St3i5edEWFODOVTOazwKpd6nYt269rmM5BH1ZkxjPRJw89LIALmXh2x5tS47xON
	 179VwZD0cx+xGMjTM9daNCyLzsoXwAzQo7qtV6Io=
Date: Mon, 24 Jun 2024 13:38:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mas_store_gfp-in-mtree_store_range.patch added to mm-unstable branch
Message-Id: <20240624203834.06A5AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use mas_store_gfp() in mtree_store_range()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-mas_store_gfp-in-mtree_store_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mas_store_gfp-in-mtree_store_range.patch

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
Subject: maple_tree: use mas_store_gfp() in mtree_store_range()
Date: Tue, 18 Jun 2024 13:47:41 -0700

Refactor mtree_store_range() to use mas_store_gfp() which will abstract
the store, memory allocation, and error handling.

Link: https://lkml.kernel.org/r/20240618204750.79512-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_store_gfp-in-mtree_store_range
+++ a/lib/maple_tree.c
@@ -6456,7 +6456,6 @@ int mtree_store_range(struct maple_tree
 		unsigned long last, void *entry, gfp_t gfp)
 {
 	MA_STATE(mas, mt, index, last);
-	MA_WR_STATE(wr_mas, &mas, entry);
 	int ret = 0;
 
 	trace_ma_write(__func__, &mas, 0, entry);
@@ -6467,17 +6466,10 @@ int mtree_store_range(struct maple_tree
 		return -EINVAL;
 
 	mtree_lock(mt);
-retry:
-	mas_wr_store_entry(&wr_mas);
-	if (mas_nomem(&mas, gfp))
-		goto retry;
-
+	ret = mas_store_gfp(&mas, entry, gfp);
+	MT_BUG_ON(mas.tree, mas.store_type == wr_invalid);
 	mtree_unlock(mt);
 
-	if (mas_is_err(&mas))
-		ret = xa_err(mas.node);
-
-	mas_destroy(&mas);
 	return ret;
 }
 EXPORT_SYMBOL(mtree_store_range);
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

