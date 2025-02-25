Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2BEEA9
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 04:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740457355; cv=none; b=svxiEiFJ1CEU3LYIGYB8Y1kXpqjXlnmxADi1gB6b1CDDTnaPVdWTmC5ZPEOJI4PmnL0W3ae5k8bn86v+IvrxAC8SnyCIulRedZBRjPLmoj/hcEElN12uWjtN9wqBdjZto8R+qgzQemwrh7SOQm+RLsqDI9TQnLWaFZ1klH80lAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740457355; c=relaxed/simple;
	bh=ItSpULqZXKNvW70EwVScf69VVovK57Mit7tsOiU7GZQ=;
	h=Date:To:From:Subject:Message-Id; b=nFBtIf4j9y2Wga0UycSYiWHJ5YuQofeUa9OmweP6cyf3Yt7Ngflk14h8jYWDGqUSAn3n2bBcoyGeMADOVuqACU2zpP+L31bvbINhuoiNmFiPaNdxEjbhIeXfFqDri14y1lgTqyGKWnCWMtLqAQVx9zJ6VsJq+A8e19lqgCuO0xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btwfXkNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btwfXkNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC256C4CEDD;
	Tue, 25 Feb 2025 04:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740457354;
	bh=ItSpULqZXKNvW70EwVScf69VVovK57Mit7tsOiU7GZQ=;
	h=Date:To:From:Subject:From;
	b=btwfXkNXXr3rmylVHBD17uAXMl12BrBRk5CpL7wl03mKfI+foHkqNut30A2mlyRAQ
	 OyrHcBaMH3c6uKueqLt97FJEmJEsFhOT/QOtuUinJUPm57jXvOVDZMJ2VQjWMftn5v
	 QGzjGN+152AQXjsnLP4xrvTeDk5of2e5NesYHEvk=
Date: Mon, 24 Feb 2025 20:22:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added to mm-nonmm-unstable branch
Message-Id: <20250225042234.AC256C4CEDD@smtp.kernel.org>
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
Date: Mon, 24 Feb 2025 02:22:39 +0000

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

Link: https://lkml.kernel.org/r/20250224022239.21976-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
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
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch

