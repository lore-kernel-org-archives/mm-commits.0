Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DE21C8FBD
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668028; cv=none; b=LKdWyycU2S1HCMHi6Qn94/9BM0u4qMyYFAc1O7Ia1BGQZmIa7Kg5DjsFlsFHxQdUljBR5Ogu57JFFw0Z3iD12Z4tT9A4aTPbeUrgudIQ7ICQdrk/jantMem8B01HiKmQ6sODFoRHhT2NIaCXcVU2cahpT3hi9pNghM4EdWmAhj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668028; c=relaxed/simple;
	bh=h7K4p0wkTTktdfXBm7Fb39xvA5T2XAk4r3IJSJLQ0lo=;
	h=Date:To:From:Subject:Message-Id; b=tAlHFYKEdT+1mmwT0T6IW6RWnEIzi60oTF05hAzWEpS6K8dk6ESikZ1MzAWoe8kDbPWV01d/bb8E7+JMKpRSm2+zrphHOOJJditCPkNDkIZiIEqfJb/Gt4lK/0rxYD6b1Sq9uTgtgzBf5uo6L2G67ZtaO7t/PqRjI5n42N3jH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UXUPSA17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UXUPSA17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BD8C116B1;
	Wed, 14 Aug 2024 20:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668027;
	bh=h7K4p0wkTTktdfXBm7Fb39xvA5T2XAk4r3IJSJLQ0lo=;
	h=Date:To:From:Subject:From;
	b=UXUPSA17euLlJ8GqS1A0H0dB7xA8AjshMscmQpgEDoylRmAIGmteqq/gOWeb1N+aw
	 rHR3qeB4+VeMZTOwLjval+NnnudG0nCi6fKQdzPCfPakgZy67ea+I3DSdiPvfZJY93
	 3U0QQ76bOZ+YFq2eD3s0P/C0Xg93NkXXXPnEFjeo=
Date: Wed, 14 Aug 2024 13:40:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-mas_destroy-from-mas_nomem.patch added to mm-unstable branch
Message-Id: <20240814204027.93BD8C116B1@smtp.kernel.org>
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
Date: Wed, 14 Aug 2024 12:19:32 -0400

Separate call to mas_destroy() from mas_nomem() so we can check for no
memory errors without destroying the current maple state in
mas_store_gfp().  We then add calls to mas_destroy() to callers of
mas_nomem().

Link: https://lkml.kernel.org/r/20240814161944.55347-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   37 ++++++++++++++++++-----------
 tools/testing/radix-tree/maple.c |   10 ++++---
 2 files changed, 30 insertions(+), 17 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-mas_destroy-from-mas_nomem
+++ a/lib/maple_tree.c
@@ -4519,6 +4519,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+	mas_destroy(mas);
 	return ret;
 }
 EXPORT_SYMBOL(mas_alloc_cyclic);
@@ -5601,21 +5602,25 @@ int mas_store_gfp(struct ma_state *mas,
 	unsigned long index = mas->index;
 	unsigned long last = mas->last;
 	MA_WR_STATE(wr_mas, mas, entry);
+	int ret = 0;
 
-	mas_wr_store_setup(&wr_mas);
-	trace_ma_write(__func__, mas, 0, entry);
 retry:
-	mas_wr_store_entry(&wr_mas);
+	mas_wr_preallocate(&wr_mas, entry);
 	if (unlikely(mas_nomem(mas, gfp))) {
 		if (!entry)
 			__mas_set_range(mas, index, last);
 		goto retry;
 	}
 
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
 
@@ -6374,6 +6379,7 @@ write_retry:
 		goto write_retry;
 	}
 
+	mas_destroy(mas);
 	return entry;
 }
 EXPORT_SYMBOL_GPL(mas_erase);
@@ -6388,10 +6394,8 @@ EXPORT_SYMBOL_GPL(mas_erase);
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
@@ -6469,6 +6473,7 @@ int mtree_store_range(struct maple_tree
 {
 	MA_STATE(mas, mt, index, last);
 	MA_WR_STATE(wr_mas, &mas, entry);
+	int ret = 0;
 
 	trace_ma_write(__func__, &mas, 0, entry);
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
@@ -6484,10 +6489,12 @@ retry:
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
 
@@ -6523,6 +6530,7 @@ int mtree_insert_range(struct maple_tree
 		unsigned long last, void *entry, gfp_t gfp)
 {
 	MA_STATE(ms, mt, first, last);
+	int ret = 0;
 
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
 		return -EINVAL;
@@ -6538,9 +6546,10 @@ retry:
 
 	mtree_unlock(mt);
 	if (mas_is_err(&ms))
-		return xa_err(ms.node);
+		ret = xa_err(ms.node);
 
-	return 0;
+	mas_destroy(&ms);
+	return ret;
 }
 EXPORT_SYMBOL(mtree_insert_range);
 
@@ -6595,6 +6604,7 @@ retry:
 
 unlock:
 	mtree_unlock(mt);
+	mas_destroy(&mas);
 	return ret;
 }
 EXPORT_SYMBOL(mtree_alloc_range);
@@ -6676,6 +6686,7 @@ retry:
 
 unlock:
 	mtree_unlock(mt);
+	mas_destroy(&mas);
 	return ret;
 }
 EXPORT_SYMBOL(mtree_alloc_rrange);
--- a/tools/testing/radix-tree/maple.c~maple_tree-remove-mas_destroy-from-mas_nomem
+++ a/tools/testing/radix-tree/maple.c
@@ -120,7 +120,7 @@ static noinline void __init check_new_no
 	MT_BUG_ON(mt, mas.alloc->slot[0] == NULL);
 	mas_push_node(&mas, mn);
 	mas_reset(&mas);
-	mas_nomem(&mas, GFP_KERNEL); /* free */
+	mas_destroy(&mas);
 	mtree_unlock(mt);
 
 
@@ -144,7 +144,7 @@ static noinline void __init check_new_no
 	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	mas.status = ma_start;
-	mas_nomem(&mas, GFP_KERNEL);
+	mas_destroy(&mas);
 	/* Allocate 3 nodes, will fail. */
 	mas_node_count(&mas, 3);
 	/* Drop the lock and allocate 3 nodes. */
@@ -161,7 +161,7 @@ static noinline void __init check_new_no
 	MT_BUG_ON(mt, mas_allocated(&mas) != 3);
 	/* Free. */
 	mas_reset(&mas);
-	mas_nomem(&mas, GFP_KERNEL);
+	mas_destroy(&mas);
 
 	/* Set allocation request to 1. */
 	mas_set_alloc_req(&mas, 1);
@@ -277,6 +277,7 @@ static noinline void __init check_new_no
 		}
 		mas_reset(&mas);
 		MT_BUG_ON(mt, mas_nomem(&mas, GFP_KERNEL));
+		mas_destroy(&mas);
 
 	}
 
@@ -299,7 +300,7 @@ static noinline void __init check_new_no
 	}
 	MT_BUG_ON(mt, mas_allocated(&mas) != total);
 	mas_reset(&mas);
-	mas_nomem(&mas, GFP_KERNEL); /* Free. */
+	mas_destroy(&mas); /* Free. */
 
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	for (i = 1; i < 128; i++) {
@@ -35847,6 +35848,7 @@ static noinline void __init check_nomem(
 	mas_store(&ms, &ms); /* insert 1 -> &ms */
 	mas_nomem(&ms, GFP_KERNEL); /* Node allocated in here. */
 	mtree_unlock(mt);
+	mas_destroy(&ms);
 	mtree_destroy(mt);
 }
 
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

