Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319472207D;
	Wed, 13 Dec 2023 20:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aI9mQUwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9219EC433C7;
	Wed, 13 Dec 2023 20:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702499428;
	bh=Irtpp9V7ik4Xbd9eS39T3P1p9fSJXjMKg1rnsw86Va0=;
	h=Date:To:From:Subject:From;
	b=aI9mQUwXw+/+HoTI9GP5vlC+exYAOK1XDrJjQww0a90Tgdjbzl4hr6+qdKWZeOzUt
	 T3NDM4TV45OinUpZrlHH2qCmQniufEg1hVD/61FFaju9nD2iFwjJQ1+YGR2IgzOw+G
	 9NNS0SuT1HMA/x32MK6lXpuhnx8dukT/fg2k0loQ=
Date: Wed, 13 Dec 2023 12:30:28 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,stable@vger.kernel.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-do-not-preallocate-nodes-for-slot-stores.patch removed from -mm tree
Message-Id: <20231213203028.9219EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: do not preallocate nodes for slot stores
has been removed from the -mm tree.  Its filename was
     maple_tree-do-not-preallocate-nodes-for-slot-stores.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: do not preallocate nodes for slot stores
Date: Tue, 12 Dec 2023 11:46:40 -0800

mas_preallocate() defaults to requesting 1 node for preallocation and then
,depending on the type of store, will update the request variable.  There
isn't a check for a slot store type, so slot stores are preallocating the
default 1 node.  Slot stores do not require any additional nodes, so add a
check for the slot store case that will bypass node_count_gfp().  Update
the tests to reflect that slot stores do not require allocations.

User visible effects of this bug include increased memory usage from the
unneeded node that was allocated.

Link: https://lkml.kernel.org/r/20231212194640.217966-1-sidhartha.kumar@oracle.com
Fixes: 0b8bb544b1a7 ("maple_tree: update mas_preallocate() testing")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |    6 ++++++
 tools/testing/radix-tree/maple.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-do-not-preallocate-nodes-for-slot-stores
+++ a/lib/maple_tree.c
@@ -5501,6 +5501,12 @@ int mas_preallocate(struct ma_state *mas
 
 	mas_wr_end_piv(&wr_mas);
 	node_size = mas_wr_new_end(&wr_mas);
+
+	/* Slot store, does not require additional nodes */
+	if ((node_size == mas->end) && ((!mt_in_rcu(mas->tree))
+		|| (wr_mas.offset_end - mas->offset == 1)))
+		return 0;
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


