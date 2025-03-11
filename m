Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C12825F985
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719052; cv=none; b=g7np730O9OEYJks368tvjzVnuircixCf3B2rxnOdDvsbpWKREbMnqU/1X+pAh5ugS7z/HUzaPjYzbPv/BM6Ex/nwspBOSEPA5uGtvUKroMRUud1jAF/77picxKXFwL0RObyApmKOk7OZ6r2fnpUIM+H5tkoEY0b0WB/CY7IucKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719052; c=relaxed/simple;
	bh=xqDAHFHrF+XzB6Xw2aiJS48fJ144w99O5s9lGygykSg=;
	h=Date:To:From:Subject:Message-Id; b=u87sgSMToL7rj/EEj7N86wzPQAMvzmxD2NxaCrlLcxC5+Ii1Eu8c2s++0DnJL8S7lgaTuox4lk8q8b31SqTO86IpXRaF3HRULl+Lf5Pa8QNuk+5OzIRZf3dDRwMy2l38IAOHJrKtqPczYromsSCQDG5200JKBZMwAkSE1Mvcqao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bTXcVXoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bTXcVXoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A83FC4CEE9;
	Tue, 11 Mar 2025 18:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741719052;
	bh=xqDAHFHrF+XzB6Xw2aiJS48fJ144w99O5s9lGygykSg=;
	h=Date:To:From:Subject:From;
	b=bTXcVXoRSwg4fPV/mgK5oTxCEAVUQY2nyZnBCkBZKhnVCV3jFAX5Mr8JZIHqmF4Ke
	 JzRq48891fGYBpc8/KOFYQ3gZ8sf/+HkZ3ys5WMTuPejOu3ktPHDAF0iVweazoq8CZ
	 77upH58o+83XLEcWPahOhY/eUEwXOGsxihyBCAfo=
Date: Tue, 11 Mar 2025 11:50:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added to mm-nonmm-unstable branch
Message-Id: <20250311185052.2A83FC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/interval_tree: skip the check before go to the right subtree
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

mm-mm_initc-use-round_up-to-align-movable-range.patch
mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch
mm-mm_initc-use-round_up-to-calculate-usermap-size.patch
lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch
lib-rbtree-split-tests.patch
lib-rbtree-add-random-seed.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch
lib-interval_tree-add-test-case-for-span-iteration.patch
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

