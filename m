Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB39218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189584; cv=none; b=U9Ey8BDl5TuxiWJO8u+DOvSxpYfYft9Q40k4vvIor9+9UhLXVegniSp+IYxYkIh+o766rDDaLhMX04dIiEhcpNuik5dXhx98MNLadEuGa4uGnIgVRsmVSudIRxrsvlE9L7OjzJvilhnipL1vTRralDBC7k8IZl+udww8ybXg24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189584; c=relaxed/simple;
	bh=gVFF02A1P0m2L9iPvfKY3PQh9tDY5i3TyAN/xj2ZwoU=;
	h=Date:To:From:Subject:Message-Id; b=RF33ZnFqB45g8sdum4sqL/qYca4mcPjw3SxTWnoEjv1MYVaMuHFTlchlbzV/qBNXaDxjhByH8mmeCAsZU2gLcUED0H68EKczizJY4KClp4Mid7hSrAozIkF1+MfREmfdV4+dtX9w3GxIWGkMfRdqxAjq+H8t3v02GbDtuqOartM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WVAyAMxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVAyAMxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF27C4CEEC;
	Mon, 17 Mar 2025 05:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189584;
	bh=gVFF02A1P0m2L9iPvfKY3PQh9tDY5i3TyAN/xj2ZwoU=;
	h=Date:To:From:Subject:From;
	b=WVAyAMxBDesSqJx/fxG7DQq2ymxea+79PC6FT2SWmC7zujdRpvJS8/MNRtlKYDDHY
	 pno2Wnpy26WwX8IEEFh0AwLp3cY6wJAhX8WgGp5f+j7RyDlFl/6M0KgFc63k5V9ZHu
	 jxqVdrvLloAysGRrHc7Nllu7mn+JcgQefNyXt5O4=
Date: Sun, 16 Mar 2025 22:33:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch removed from -mm tree
Message-Id: <20250317053304.0FF27C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/interval_tree: fix the comment of interval_tree_span_iter_next_gap()
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


