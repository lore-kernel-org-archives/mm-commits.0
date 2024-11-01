Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD2BE4F
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420448; cv=none; b=qtR6/odPr9mo0QxgCc/s67WDky6q6hC29d8linyKwKJX22bl5IQPm1dYIMlJGrLAfC2aFE7J3n0hxy0I4L/+RVOHySXwdmLoVv7tcg5i1dD6vcKoBCSRBP8vj7Y0J/81hQ2sJTEyBkKspHjzixPF/cvc3f3tzhir6byNszrZ5q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420448; c=relaxed/simple;
	bh=ti1irYDUmmHHiHBeMrVeQcbRdOHgzsFvdFHKEnK5MhY=;
	h=Date:To:From:Subject:Message-Id; b=c/dFTqoGl0aWKiOlTIROWtJBk1zpiHam6pSVpq8EYqGHRGeeLpVffzVNwVKVw7wZNwRizIMSFPRxpmK85RGRsMKBi19QiTHj/9tZNM2YqyVjQcNciDeEb63LEFbUA6rRmLG1+jTzeal2tuFLjfT6dyBuC7Ew5hil/3mgV7+cYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rLP//Q/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rLP//Q/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE915C4CEC3;
	Fri,  1 Nov 2024 00:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420447;
	bh=ti1irYDUmmHHiHBeMrVeQcbRdOHgzsFvdFHKEnK5MhY=;
	h=Date:To:From:Subject:From;
	b=rLP//Q/BG47AfCk5pd7f1RvBJaHLkHOFt4fMUlMxmRqn5/uToJPooNn0MxCkMr4Pj
	 Tgqyfuz3YIR1HVNsslE+RGWC0RUDcoYS7OZrPpVzGFR2Ov0+VnsXU+zEqgFrEU3KOa
	 iEPvJwdWzqWe9f/0sZ4iRsHeuIyhHenf5DlfNpxA=
Date: Thu, 31 Oct 2024 17:20:47 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-a-test-checking-storing-null.patch added to mm-unstable branch
Message-Id: <20241101002047.CE915C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add a test checking storing null
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-a-test-checking-storing-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-a-test-checking-storing-null.patch

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
Subject: maple_tree: add a test checking storing null
Date: Thu, 31 Oct 2024 23:16:27 +0000

Add a test to assert that, when storing null to am empty tree or a
single entry tree it will not result into:

  * a root node with range [0, ULONG_MAX] set to NULL
  * a root node with consecutive slot set to NULL

Link: https://lkml.kernel.org/r/20241031231627.14316-6-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   90 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-a-test-checking-storing-null
+++ a/lib/test_maple_tree.c
@@ -1387,6 +1387,92 @@ static noinline void __init check_prev_e
 	mas_unlock(&mas);
 }
 
+static noinline void __init check_store_null(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, 0, ULONG_MAX);
+
+	/*
+	 * Store NULL at range [0, ULONG_MAX] to an empty tree should result
+	 * in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at any range to an empty tree should result in an empty
+	 * tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set_range(&mas, 3, 10);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [0, ULONG_MAX] to a single entry tree should
+	 * result in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set(&mas, 0);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	mas_set_range(&mas, 0, ULONG_MAX);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [0, n] to a single entry tree should
+	 * result in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set(&mas, 0);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	mas_set_range(&mas, 0, 5);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [m, n] where m > 0 to a single entry tree
+	 * should still be a single entry tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set(&mas, 0);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	mas_set_range(&mas, 2, 5);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, mtree_empty(mt));
+	MT_BUG_ON(mt, xa_is_node(mas_root(&mas)));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [0, ULONG_MAX] to a tree with node should
+	 * result in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set_range(&mas, 1, 3);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	MT_BUG_ON(mt, !xa_is_node(mas_root(&mas)));
+	mas_set_range(&mas, 0, ULONG_MAX);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+}
+
 static noinline void __init check_root_expand(struct maple_tree *mt)
 {
 	MA_STATE(mas, mt, 0, 0);
@@ -3711,6 +3797,10 @@ static int __init maple_tree_seed(void)
 #endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_store_null(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_root_expand(&tree);
 	mtree_destroy(&tree);
 
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

