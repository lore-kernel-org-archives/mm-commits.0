Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085BB7E785
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GzHGZu4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02ECC433C9;
	Tue, 12 Dec 2023 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702406781;
	bh=BpUMlFvtX+65cJBVLNz0B+VKKfr6aOuoe68nOVsP7Vk=;
	h=Date:To:From:Subject:From;
	b=GzHGZu4Qeb/LkQPmw1XiL4/r+dWm0i9v8FvaQX/DmqN5EvmXtkUXdivKQeDG9CUuJ
	 czTOIbwyiw1w0RiDgtCEJCuYil9OOOq6I9xvpja1v+PWrTFnOvNjhUf8Rx+Mckd5Bl
	 OXw/Em22El6CB3dKXyncNLxOJdPy4/qtLZmUjam0=
Date: Tue, 12 Dec 2023 10:46:21 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-separate-ma_state-node-from-status-fix-2.patch removed from -mm tree
Message-Id: <20231212184621.B02ECC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: update forking to separate maple state and node
has been removed from the -mm tree.  Its filename was
     maple_tree-separate-ma_state-node-from-status-fix-2.patch

This patch was dropped because it was folded into maple_tree-separate-ma_state-node-from-status.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: update forking to separate maple state and node
Date: Mon, 6 Nov 2023 10:45:51 -0500

Just a small change to the forking code after rebasing the maple status
changes on top.

Link: https://lkml.kernel.org/r/20231106154551.615042-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |    2 +-
 tools/testing/radix-tree/maple.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix-2
+++ a/lib/maple_tree.c
@@ -6693,7 +6693,7 @@ static inline void mas_dup_build(struct
 
 	node = mt_alloc_one(gfp);
 	if (!node) {
-		new_mas->node = MAS_NONE;
+		new_mas->status = ma_none;
 		mas_set_err(mas, -ENOMEM);
 		return;
 	}
--- a/tools/testing/radix-tree/maple.c~maple_tree-separate-ma_state-node-from-status-fix-2
+++ a/tools/testing/radix-tree/maple.c
@@ -35956,7 +35956,7 @@ static int __init compare_tree(struct ma
 
 	if (mas_is_ptr(&mas_a) || mas_is_ptr(&mas_b)) {
 		if (!(mas_is_ptr(&mas_a) && mas_is_ptr(&mas_b))) {
-			pr_err("One is MAS_ROOT and the other is not.\n");
+			pr_err("One is ma_root and the other is not.\n");
 			return -1;
 		}
 		return 0;
@@ -35965,7 +35965,7 @@ static int __init compare_tree(struct ma
 	while (!mas_is_none(&mas_a) || !mas_is_none(&mas_b)) {
 
 		if (mas_is_none(&mas_a) || mas_is_none(&mas_b)) {
-			pr_err("One is MAS_NONE and the other is not.\n");
+			pr_err("One is ma_none and the other is not.\n");
 			return -1;
 		}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

