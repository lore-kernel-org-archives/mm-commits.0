Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA19218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189583; cv=none; b=tCCu4Fw3Cfd5FjI4QhFGy8Ara8PlWodgyYzIExIs+WqTG+JMynSGAK4LAxgNVtslW5vY0Ce4cdD4HQswwSkNnYGObLt+e7ay4LuZ4FogTfopETZyV+KBqU6rm8/SE0sQjLQiYmVKg38j52UTG+pqRvPyHLzSPts6y+Ye/nkpCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189583; c=relaxed/simple;
	bh=ddiMXh/sDo7oe4lWf8I/s1vwGsI9YSeAhLhxvP5fuY0=;
	h=Date:To:From:Subject:Message-Id; b=GhS9vxRetvw55KXzpE4Q6o9IJYWcOwsz8Gznm/Q1u4nWWpXhr0g3Lc2V274UqcxwYpDHmQpzhJUEIpLjHIwzRah/52PncuUlnL4P1CwFJsdXjwrs7cuwHyBvF17tI4nfGHGSdH/S8m2sRy56IMmMdJKE7EQ7x4FUTFaICRiOU9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvAOHd3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvAOHd3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FAEC4CEEC;
	Mon, 17 Mar 2025 05:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189582;
	bh=ddiMXh/sDo7oe4lWf8I/s1vwGsI9YSeAhLhxvP5fuY0=;
	h=Date:To:From:Subject:From;
	b=vvAOHd3ENx7WKjmwCqJziY4Ut5cth9oYkK06NMtnAlfsVIrP/ObYpxwMm0J5yqQxE
	 JNn9ODK/V8nkDF7PFra4luwASzPy8EEb1NhMM8FJ8iYMHEiFaZoed+cRmHh4d3LfPY
	 +hX9ZCqlAyPF+im0TtT1OwKyTupP8Ru40Y8LskGo=
Date: Sun, 16 Mar 2025 22:33:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch removed from -mm tree
Message-Id: <20250317053302.B3FAEC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/interval_tree: skip the check before go to the right subtree
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib/interval_tree: skip the check before go to the right subtree
Date: Mon, 10 Mar 2025 07:49:37 +0000

The interval_tree_subtree_search() holds the loop invariant:

    start <= node->ITSUBTREE

Let's say we have a following tree:

         node
         /  \
      left  right

So we know node->ITSUBTREE is contributed by one of the following:

  * left->ITSUBTREE
  * ITLAST(node)
  * right->ITSUBTREE

When we come to the right node, we are sure the first two don't
contribute to node->ITSUBTREE and it must be the right node does the
job.

So skip the check before go to the right subtree.

Link: https://lkml.kernel.org/r/20250310074938.26756-7-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interval_tree_generic.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/include/linux/interval_tree_generic.h~lib-interval_tree-skip-the-check-before-go-to-the-right-subtree
+++ a/include/linux/interval_tree_generic.h
@@ -104,12 +104,8 @@ ITPREFIX ## _subtree_search(ITSTRUCT *no
 		if (ITSTART(node) <= last) {		/* Cond1 */	      \
 			if (start <= ITLAST(node))	/* Cond2 */	      \
 				return node;	/* node is leftmost match */  \
-			if (node->ITRB.rb_right) {			      \
-				node = rb_entry(node->ITRB.rb_right,	      \
-						ITSTRUCT, ITRB);	      \
-				if (start <= node->ITSUBTREE)		      \
-					continue;			      \
-			}						      \
+			node = rb_entry(node->ITRB.rb_right, ITSTRUCT, ITRB); \
+			continue;					      \
 		}							      \
 		return NULL;	/* No match */				      \
 	}								      \
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


