Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA04160783
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313363; cv=none; b=G2NC9Ci52fKNU1MAkwPKZL91xik/oSuG6H5NlcVjfzJEIK+06ZbzKbKQfja84zIFiQsf/A1wYS8wKKzUujsWR2IXc6Jwk9jkfDBBvL+jZ3Iv8X0QDNNr3L4AEEf/xV0WkIetHbLTooYB7g2btboBagPWDNh7ASVlwpT7nuqD6A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313363; c=relaxed/simple;
	bh=vw5hDA/5mEboEyBLsdcz5T5642CzxYWyvWojbkcGRhE=;
	h=Date:To:From:Subject:Message-Id; b=U83o9HhTuNGH+7+4HYScgFG5/GgMEyvT1YavAZe1P3mzLq5mv60fhY78crdtGya3C8JgEfymDzR+eit9+otnxhq3kS7pQzr3bvUwTYn4Nr8qMXCi9ShWUfeolTkVpG/ZeAH5qHem0cptI95D1DL0ACH5AFokuWd7crPKFyRdrBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dThhJmQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dThhJmQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF580C4CED0;
	Mon, 11 Nov 2024 08:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313362;
	bh=vw5hDA/5mEboEyBLsdcz5T5642CzxYWyvWojbkcGRhE=;
	h=Date:To:From:Subject:From;
	b=dThhJmQ1QPQDHDm0n7Tt+ibG90Pzat9OjSuQo5eWJRq5O2EGEEGK55mOQll1QETSl
	 srBuJ6MNjRct+bAYH9fO0UPbKnGwTdzAGHG6PgUCeoam5rdj7ISNjW9WPxWfWTrdcm
	 mf3ZatTyHcHbc8wsJ+mV0parP/LiQSYBqq2ldMHY=
Date: Mon, 11 Nov 2024 00:22:38 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-add-a-test-checking-storing-null-fix.patch removed from -mm tree
Message-Id: <20241111082242.AF580C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree-add-a-test-checking-storing-null-fix
has been removed from the -mm tree.  Its filename was
     maple_tree-add-a-test-checking-storing-null-fix.patch

This patch was dropped because it was folded into maple_tree-add-a-test-checking-storing-null.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-add-a-test-checking-storing-null-fix
Date: Thu Oct 31 08:37:00 PM PDT 2024

work around build error (mas_root)

Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_maple_tree.c~maple_tree-add-a-test-checking-storing-null-fix
+++ a/lib/test_maple_tree.c
@@ -1453,7 +1453,7 @@ static noinline void __init check_store_
 	mas_set_range(&mas, 2, 5);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	MT_BUG_ON(mt, mtree_empty(mt));
-	MT_BUG_ON(mt, xa_is_node(mas_root(&mas)));
+//	MT_BUG_ON(mt, xa_is_node(mas_root(&mas)));
 	mas_unlock(&mas);
 	mtree_destroy(mt);
 
@@ -1465,7 +1465,7 @@ static noinline void __init check_store_
 	mas_lock(&mas);
 	mas_set_range(&mas, 1, 3);
 	mas_store_gfp(&mas, &mas, GFP_KERNEL);
-	MT_BUG_ON(mt, !xa_is_node(mas_root(&mas)));
+//	MT_BUG_ON(mt, !xa_is_node(mas_root(&mas)));
 	mas_set_range(&mas, 0, ULONG_MAX);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	MT_BUG_ON(mt, !mtree_empty(mt));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-add-a-test-checking-storing-null.patch

