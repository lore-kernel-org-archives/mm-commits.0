Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128B7495DA;
	Wed, 20 Dec 2023 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlgtB6+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FE8C433C8;
	Wed, 20 Dec 2023 21:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108834;
	bh=BXQsLmbahm+192FFTDaG7gqcBiGet3CQVhAgSjHequ4=;
	h=Date:To:From:Subject:From;
	b=IlgtB6+g6HT42EH/Hdtj3wlgmcjC7vaBKMJr70jf/uE6ilZ7y1JGHwAvaqA5h8xwJ
	 KDYNkDjhrzPxLbtBJGvivZBq3972pWp80lrMum2aak0GZrJQKvTmofUJU6pU0/0Cux
	 ykoFxpm+x4e3JuO9lRWk8Xn2sao/xsGtQI1qQ0C0=
Date: Wed, 20 Dec 2023 13:47:14 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,stable@vger.kernel.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-do-not-preallocate-nodes-for-slot-stores.patch removed from -mm tree
Message-Id: <20231220214714.91FE8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: do not preallocate nodes for slot stores
has been removed from the -mm tree.  Its filename was
     maple_tree-do-not-preallocate-nodes-for-slot-stores.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: do not preallocate nodes for slot stores
Date: Wed, 13 Dec 2023 12:50:57 -0800

mas_preallocate() defaults to requesting 1 node for preallocation and then
,depending on the type of store, will update the request variable.  There
isn't a check for a slot store type, so slot stores are preallocating the
default 1 node.  Slot stores do not require any additional nodes, so add a
check for the slot store case that will bypass node_count_gfp().  Update
the tests to reflect that slot stores do not require allocations.

User visible effects of this bug include increased memory usage from the
unneeded node that was allocated.

Link: https://lkml.kernel.org/r/20231213205058.386589-1-sidhartha.kumar@oracle.com
Fixes: 0b8bb544b1a7 ("maple_tree: update mas_preallocate() testing")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   11 +++++++++++
 tools/testing/radix-tree/maple.c |    2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-do-not-preallocate-nodes-for-slot-stores
+++ a/lib/maple_tree.c
@@ -5501,6 +5501,17 @@ int mas_preallocate(struct ma_state *mas
 
 	mas_wr_end_piv(&wr_mas);
 	node_size = mas_wr_new_end(&wr_mas);
+
+	/* Slot store, does not require additional nodes */
+	if (node_size == wr_mas.node_end) {
+		/* reuse node */
+		if (!mt_in_rcu(mas->tree))
+			return 0;
+		/* shifting boundary */
+		if (wr_mas.offset_end - mas->offset == 1)
+			return 0;
+	}
+
 	if (node_size >= mt_slots[wr_mas.type]) {
 		/* Split, worst case for now. */
 		request = 1 + mas_mt_height(mas) * 2;
--- a/tools/testing/radix-tree/maple.c~maple_tree-do-not-preallocate-nodes-for-slot-stores
+++ a/tools/testing/radix-tree/maple.c
@@ -35538,7 +35538,7 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
-	MT_BUG_ON(mt, allocated != 1);
+	MT_BUG_ON(mt, allocated != 0);
 	mas_store_prealloc(&mas, ptr);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


