Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C0423768
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816355; cv=none; b=GjALIO59gCncOAt++RMup9911XQOavhW1omAMGpx1kKMwF3o02OG9Z8BJSOW9pq1lwiJRPGjzlT/PQWF8Q3AYpDi0BtmGhb8uAnzcBOUSRMhMxDtAb82DJPnoUc9fQGRu1JHjnE9uQdGGhRyvbqKNUMxgw+dh2iILwfYlIMzwkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816355; c=relaxed/simple;
	bh=GaW480JdJaGcumurW7qs/j5JuYKlm1iW76//jBnVuvI=;
	h=Date:To:From:Subject:Message-Id; b=dqrDVxfuh+TmGcLsxCQEDjA4CalWCrgVFq9zbmQ7x1sXUwyvgQQCbJYhqEtx/RBEjyTds3a1NwzXJDk1yinl60Fbkv3nttP0Aw/9tekzIB5EL7+QMC+kioew36LrABqLQPmRfLN48Hr0WcNyedQ4Md5b29mFW36IV/zUir2uzB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yfMCZdhX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yfMCZdhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A135C1F000E9;
	Tue,  4 Aug 2026 04:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816353;
	bh=WMNepfrxCVgTZd+V297PGRz9hX7Z8Bo52sl6AYRoVHc=;
	h=Date:To:From:Subject;
	b=yfMCZdhXVQWQHNFHnJEqixH/e/H/2wF7oZaMdLHC3VYldotj1kmmxA42b8LsyYaW/
	 x26Rz7L/h9NtVOYXguV/onZBs4J5FgLl1fWR+QSLuPz7LHDBydOqdI/Nv8FhDFoH98
	 rIGQYgVHi9yTgFQ1DnXqM8osqupY3/m/rFIgFUVE=
Date: Mon, 03 Aug 2026 21:05:53 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,peterz@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rbtree-fixup-kernel-doc-names.patch removed from -mm tree
Message-Id: <20260804040553.A135C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rbtree: fixup kernel-doc names
has been removed from the -mm tree.  Its filename was
     rbtree-fixup-kernel-doc-names.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: rbtree: fixup kernel-doc names
Date: Tue, 21 Jul 2026 22:07:59 -0700

Use the correct function parameter name in rb_next_match().  Use the
struct keyword when describing struct latch_tree_ops.

Prevents the following kernel-doc warnings:

Warning: ./include/linux/rbtree.h:510 function parameter 'node' not
 described in 'rb_next_match'
Warning: ./include/linux/rbtree.h:510 Excess function parameter 'tree'
 description in 'rb_next_match'
Warning: ./include/linux/rbtree_latch.h:63 cannot understand function
 prototype: 'struct latch_tree_ops'

Link: https://lore.kernel.org/20260722050759.3892887-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h       |    2 +-
 include/linux/rbtree_latch.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rbtree.h~rbtree-fixup-kernel-doc-names
+++ a/include/linux/rbtree.h
@@ -500,7 +500,7 @@ rb_find_first(const void *key, const str
 /**
  * rb_next_match() - find the next @key in @tree
  * @key: key to match
- * @tree: tree to search
+ * @node: tree to search
  * @cmp: operator defining node order
  *
  * Returns the next node matching @key, or NULL.
--- a/include/linux/rbtree_latch.h~rbtree-fixup-kernel-doc-names
+++ a/include/linux/rbtree_latch.h
@@ -47,7 +47,7 @@ struct latch_tree_root {
 };
 
 /**
- * latch_tree_ops - operators to define the tree order
+ * struct latch_tree_ops - operators to define the tree order
  * @less: used for insertion; provides the (partial) order between two elements.
  * @comp: used for lookups; provides the order between the search key and an element.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are


