Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7874E2233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261510; cv=none; b=EzqKcI0TA6Nkc4yPLL0r3kSDtiXfSyNhxOmrWuTXDVJ0BJHj9LlUkH7rLX9LelZ0pLUMCGYLDCOQhWWTGaU/EdAzdASMDfYgm9/QVaTi3iCEwWdqDudKcJB/xSOP1sPUKmjyWjVDMsL3ri6kGloWAm+j57ItkLerzhN6grGTYYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261510; c=relaxed/simple;
	bh=CMyIBa81RowBRhOjtGFls5Shq5ShM0guJmosv77+GRw=;
	h=Date:To:From:Subject:Message-Id; b=c0LfaP2b4Er2dc+AgvkntTuldCHcOcLJctaWFwaNAyPvrJDch9L6zX+a6Ey/8q+H8kw7qtvAtWQWvDYMHOWZYyMl1ICXwWYDn1I9Xc2RJcuXegs8MDTyyN2iFGELEgv2za/jnusK9ZQgDHrnbuDFtjEI9vWmKvfElMDnQzsbZyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7C0Mn/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7C0Mn/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE349C2BBFC;
	Mon, 24 Jun 2024 20:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261510;
	bh=CMyIBa81RowBRhOjtGFls5Shq5ShM0guJmosv77+GRw=;
	h=Date:To:From:Subject:From;
	b=i7C0Mn/K2On/1siW4Ugytfp5dconFe7ms7fSo3DRbER1K97uwpdUAXJEtqK4E45bi
	 Xw3Qhrn9k85ZZTYINe0mIwD6OWBQe33dIR6D1xjRUhGjvYu7Bf3VfRPMs7RDc3JN2g
	 6MBOmNa+Fsm1mszJZ4ivsyhgeCvfptPJXbcEnIZg=
Date: Mon, 24 Jun 2024 13:38:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-mas_destroy-from-mas_nomem.patch added to mm-unstable branch
Message-Id: <20240624203829.EE349C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove mas_destroy() from mas_nomem()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-mas_destroy-from-mas_nomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-mas_destroy-from-mas_nomem.patch

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
Subject: maple_tree: remove mas_destroy() from mas_nomem()
Date: Tue, 18 Jun 2024 13:47:39 -0700

Separate call to mas_destroy() from mas_nomem() so we can check for no
memory errors without destroying the current maple state in
mas_store_gfp().  We then add calls to mas_destroy() to callers of
mas_nomem().

Link: https://lkml.kernel.org/r/20240618204750.79512-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   39 +++++++++++++++++++----------
 tools/testing/radix-tree/maple.c |   10 ++++---
 2 files changed, 32 insertions(+), 17 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-mas_destroy-from-mas_nomem
+++ a/lib/maple_tree.c
@@ -4524,6 +4524,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+	mas_destroy(mas);
 	return ret;
 }
 EXPORT_SYMBOL(mas_alloc_cyclic);
@@ -5604,18 +5605,24 @@ EXPORT_SYMBOL_GPL(mas_store);
 int mas_store_gfp(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
+	int ret = 0;
 
-	mas_wr_store_setup(&wr_mas);
-	trace_ma_write(__func__, mas, 0, entry);
 retry:
-	mas_wr_store_entry(&wr_mas);
+	mas_wr_preallocate(&wr_mas, entry, gfp);
+	WARN_ON_ONCE(mas->store_type == wr_invalid);
+
 	if (unlikely(mas_nomem(mas, gfp)))
 		goto retry;
 
-	if (unlikely(mas_is_err(mas)))
-		return xa_err(mas->node);
+	if (mas_is_err(mas)) {
+		ret = xa_err(mas->node);
+		goto out;
+	}
 
-	return 0;
+	mas_wr_store_entry(&wr_mas);
+out:
+	mas_destroy(mas);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mas_store_gfp);
 
@@ -6363,6 +6370,7 @@ write_retry:
 	if (mas_nomem(mas, GFP_KERNEL))
 		goto write_retry;
 
+	mas_destroy(mas);
 	return entry;
 }
 EXPORT_SYMBOL_GPL(mas_erase);
@@ -6377,10 +6385,8 @@ EXPORT_SYMBOL_GPL(mas_erase);
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	__must_hold(mas->tree->ma_lock)
 {
-	if (likely(mas->node != MA_ERROR(-ENOMEM))) {
-		mas_destroy(mas);
+	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
-	}
 
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
@@ -6458,6 +6464,7 @@ int mtree_store_range(struct maple_tree
 {
 	MA_STATE(mas, mt, index, last);
 	MA_WR_STATE(wr_mas, &mas, entry);
+	int ret = 0;
 
 	trace_ma_write(__func__, &mas, 0, entry);
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
@@ -6473,10 +6480,12 @@ retry:
 		goto retry;
 
 	mtree_unlock(mt);
+
 	if (mas_is_err(&mas))
-		return xa_err(mas.node);
+		ret = xa_err(mas.node);
 
-	return 0;
+	mas_destroy(&mas);
+	return ret;
 }
 EXPORT_SYMBOL(mtree_store_range);
 
@@ -6512,6 +6521,7 @@ int mtree_insert_range(struct maple_tree
 		unsigned long last, void *entry, gfp_t gfp)
 {
 	MA_STATE(ms, mt, first, last);
+	int ret = 0;
 
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
 		return -EINVAL;
@@ -6527,9 +6537,10 @@ retry:
 
 	mtree_unlock(mt);
 	if (mas_is_err(&ms))
-		return xa_err(ms.node);
+		ret = xa_err(ms.node);
 
-	return 0;
+	mas_destroy(&ms);
+	return ret;
 }
 EXPORT_SYMBOL(mtree_insert_range);
 
@@ -6584,6 +6595,7 @@ retry:
 
 unlock:
 	mtree_unlock(mt);
+	mas_destroy(&mas);
 	return ret;
 }
 EXPORT_SYMBOL(mtree_alloc_range);
@@ -6665,6 +6677,7 @@ retry:
 
 unlock:
 	mtree_unlock(mt);
+	mas_destroy(&mas);
 	return ret;
 }
 EXPORT_SYMBOL(mtree_alloc_rrange);
--- a/tools/testing/radix-tree/maple.c~maple_tree-remove-mas_destroy-from-mas_nomem
+++ a/tools/testing/radix-tree/maple.c
@@ -119,7 +119,7 @@ static noinline void __init check_new_no
 	MT_BUG_ON(mt, mas.alloc->slot[0] == NULL);
 	mas_push_node(&mas, mn);
 	mas_reset(&mas);
-	mas_nomem(&mas, GFP_KERNEL); /* free */
+	mas_destroy(&mas);
 	mtree_unlock(mt);
 
 
@@ -143,7 +143,7 @@ static noinline void __init check_new_no
 	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	mas.status = ma_start;
-	mas_nomem(&mas, GFP_KERNEL);
+	mas_destroy(&mas);
 	/* Allocate 3 nodes, will fail. */
 	mas_node_count(&mas, 3);
 	/* Drop the lock and allocate 3 nodes. */
@@ -160,7 +160,7 @@ static noinline void __init check_new_no
 	MT_BUG_ON(mt, mas_allocated(&mas) != 3);
 	/* Free. */
 	mas_reset(&mas);
-	mas_nomem(&mas, GFP_KERNEL);
+	mas_destroy(&mas);
 
 	/* Set allocation request to 1. */
 	mas_set_alloc_req(&mas, 1);
@@ -276,6 +276,7 @@ static noinline void __init check_new_no
 		}
 		mas_reset(&mas);
 		MT_BUG_ON(mt, mas_nomem(&mas, GFP_KERNEL));
+		mas_destroy(&mas);
 
 	}
 
@@ -298,7 +299,7 @@ static noinline void __init check_new_no
 	}
 	MT_BUG_ON(mt, mas_allocated(&mas) != total);
 	mas_reset(&mas);
-	mas_nomem(&mas, GFP_KERNEL); /* Free. */
+	mas_destroy(&mas); /* Free. */
 
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	for (i = 1; i < 128; i++) {
@@ -35846,6 +35847,7 @@ static noinline void __init check_nomem(
 	mas_store(&ms, &ms); /* insert 1 -> &ms */
 	mas_nomem(&ms, GFP_KERNEL); /* Node allocated in here. */
 	mtree_unlock(mt);
+	mas_destroy(&ms);
 	mtree_destroy(mt);
 }
 
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

