Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0F320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560096; cv=none; b=PiJ7vACLOQQlrZfZJ3IUCOCTdXK8wKH10JUZTRlOUQ7vCJx514Ljl6Gx6g4OHNKQVK2zHDraXbj/W7vVJN88ugR8sq70qimlSHCcqkP7NxJ3KErSBGR/LfhReN8G5/ql8+fq/+1hIeIFerSTSh1wFTG0QuMUvtu5FuhBS/ZdhoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560096; c=relaxed/simple;
	bh=DmCSe84OdJ6omP1idRtrsCWmozNJv/KDdL5L+k1ezDY=;
	h=Date:To:From:Subject:Message-Id; b=iIHjYvsBuf+rZPUUeRmy+/EoWJxQk6NIqAyIjvHyWgbfeII23L6TMHa61kBUlrBA/TWGKR/X+D2jR0gpsBSk5ByOTUPMzincJn3hkqrnc2bB9OX7chlZ2OjCEmpN/JHuOw2ci0AmmCNr5D9jLB38oNkZvX7XK+1I/dKb9cIYcOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JujHjiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JujHjiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FFAC433C7;
	Thu, 22 Feb 2024 00:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560096;
	bh=DmCSe84OdJ6omP1idRtrsCWmozNJv/KDdL5L+k1ezDY=;
	h=Date:To:From:Subject:From;
	b=2JujHjiuYxNUYqr2ne4Cso0HzD1sueAv8miRmwJ3MYPNUqBrjKfz+u31OUqvJn6UH
	 gxDa+wRiqbTpRjoDK2SqBqJ3j4qWZ+nPSOY+UjrUXEDgX9eOTMWF3GUErAt52Ea2Bd
	 qzHO2IiGxjkhLCf+dMkvz5HpngR8gdda+u8KR/iw=
Date: Wed, 21 Feb 2024 16:01:35 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,ying.huang@intel.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch removed from -mm tree
Message-Id: <20240222000136.84FFAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: remove unnecessary trees cleanups in zswap_swapoff()
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: remove unnecessary trees cleanups in zswap_swapoff()
Date: Wed, 24 Jan 2024 04:51:12 +0000

During swapoff, try_to_unuse() makes sure that zswap_invalidate() is
called for all swap entries before zswap_swapoff() is called.  This means
that all zswap entries should already be removed from the tree.  Simplify
zswap_swapoff() by removing the trees cleanup code, and leave an assertion
in its place.

Link: https://lkml.kernel.org/r/20240124045113.415378-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff
+++ a/mm/zswap.c
@@ -1808,19 +1808,9 @@ void zswap_swapoff(int type)
 	if (!trees)
 		return;
 
-	for (i = 0; i < nr_zswap_trees[type]; i++) {
-		struct zswap_tree *tree = trees + i;
-		struct zswap_entry *entry, *n;
-
-		/* walk the tree and free everything */
-		spin_lock(&tree->lock);
-		rbtree_postorder_for_each_entry_safe(entry, n,
-						     &tree->rbroot,
-						     rbnode)
-			zswap_free_entry(entry);
-		tree->rbroot = RB_ROOT;
-		spin_unlock(&tree->lock);
-	}
+	/* try_to_unuse() invalidated all the entries already */
+	for (i = 0; i < nr_zswap_trees[type]; i++)
+		WARN_ON_ONCE(!RB_EMPTY_ROOT(&trees[i].rbroot));
 
 	kvfree(trees);
 	nr_zswap_trees[type] = 0;
_

Patches currently in -mm which might be from yosryahmed@google.com are


