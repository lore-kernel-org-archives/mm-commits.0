Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA271EB19D
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 20:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811612; cv=none; b=DifHoeV3lZJEKhBugwdEbUohwir4iK3qDQE2JoPQfsf+QrHz6306IYPOLEYlT+iESavfEBO764Het3Wjmyopk09cBf5Qd8G87RS3svgT2QAQ5q2tj1BEJD7n6p+VruW/yFyhFgbzXZH2mr+BKVBI48R09rO2XJSANdZd08QQC1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811612; c=relaxed/simple;
	bh=cMZiuqRNKLYIWY9JdRCX3KFDdpdlwb5e4/SwkXXwguA=;
	h=Date:To:From:Subject:Message-Id; b=Y6UM82UnKbVOdvHlmtcm1kYUTaXm8gqA6nzh4iWyIol5Oc13UNWDIm4hsJIDSZQW/dSsrULVaf4S63HNKXxxJe7Yg7X3aiEAeg5gxfMuEMPhHZXG4uEqXrMn0axWoSBNjaSx3FTdlR99Zh9eACJR3ct2/bYaFy3WHcN0Rz1iWbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yw0KRWfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yw0KRWfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315D1C4CEDD;
	Wed, 12 Mar 2025 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741811611;
	bh=cMZiuqRNKLYIWY9JdRCX3KFDdpdlwb5e4/SwkXXwguA=;
	h=Date:To:From:Subject:From;
	b=yw0KRWfUeseNwXX4iyL5W6NNo3z1druRojOMgRDbZLCeZxPHGYUZRk49ntqFh0lg8
	 NKN8gaDLES4VA25p5A8sM7J4XpviS03zgCrRvellQIThjKEi4ZMDt7P2NJhvWuwAPI
	 1KnLqiNkb8yF8SbuWhnrXE5WD5xAXeGQqoLizXVg=
Date: Wed, 12 Mar 2025 13:33:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch added to mm-nonmm-unstable branch
Message-Id: <20250312203331.315D1C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/interval_tree: fix the comment of interval_tree_span_iter_next_gap()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

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
Subject: lib/interval_tree: fix the comment of interval_tree_span_iter_next_gap()
Date: Mon, 10 Mar 2025 07:49:38 +0000

The comment of interval_tree_span_iter_next_gap() is not exact, nodes[1]
is not always !NULL.

There are threes cases here. If there is an interior hole, the statement
is correct. If there is a tailing hole or the contiguous used range span
to the end, nodes[1] is NULL.

Link: https://lkml.kernel.org/r/20250310074938.26756-8-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/lib/interval_tree.c~lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap
+++ a/lib/interval_tree.c
@@ -20,9 +20,15 @@ EXPORT_SYMBOL_GPL(interval_tree_iter_nex
 /*
  * Roll nodes[1] into nodes[0] by advancing nodes[1] to the end of a contiguous
  * span of nodes. This makes nodes[0]->last the end of that contiguous used span
- * indexes that started at the original nodes[1]->start. nodes[1] is now the
- * first node starting the next used span. A hole span is between nodes[0]->last
- * and nodes[1]->start. nodes[1] must be !NULL.
+ * of indexes that started at the original nodes[1]->start.
+ *
+ * If there is an interior hole, nodes[1] is now the first node starting the
+ * next used span. A hole span is between nodes[0]->last and nodes[1]->start.
+ *
+ * If there is a tailing hole, nodes[1] is now NULL. A hole span is between
+ * nodes[0]->last and last_index.
+ *
+ * If the contiguous used range span to last_index, nodes[1] is set to NULL.
  */
 static void
 interval_tree_span_iter_next_gap(struct interval_tree_span_iter *state)
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

