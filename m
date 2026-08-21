Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359543655E7
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350919; cv=none; b=Z4nYOfZs5GYtZzW8SWzDwm4dem66krnZQ8oHB74Xa0i80jU0repwAtik0xee03TQLrmGqQEbtcXhIukwWRuZCQfPEiGiMZSA3oG8V/5SgPbyFOXv+vHsiye6ere9SaFv0nL4nZDcv9wTGZh5/FMRhKhH4Bcv5wuH0QFFnE8qJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350919; c=relaxed/simple;
	bh=Enp1spHaQBfcM0Yf3NWcnG9NXB08zcLFH4R+XiW0wpM=;
	h=Date:To:From:Subject:Message-Id; b=EeSG9hC5zxJd+XYCfWVl1InLMLmHUXZy6Gdn2ywsXggK78NL9xHPOu8lxsY0BBJclxAYRy6IgGn4ju4UOpM2Hc79JwwTznjnYILp038LbsWqREn4Q1IBkHDyScIlCO4fnYozGhdSrBgQY/ZyjystqaO6VnfvXvjjSuCUyoRoNS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oSl2iZcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oSl2iZcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7BC1F000E9;
	Fri, 21 Aug 2026 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350918;
	bh=QHOuW+mYjBcx2JKYDGx5E03R0dnRxlbzN5XH22mOZbo=;
	h=Date:To:From:Subject;
	b=oSl2iZcqWgO0nrN3VEsYRjI6GJS03UR0hsmka2+DvloSpF8iUbmZDD2RZr1jKVC/r
	 VugXBEjGhq3AU07To8JdB043LuS1O3oGgQtvNL/OpwJxuksU1CiIsZYVZuBzspbT7/
	 JRrHySHMBS3Yg7zP0t1N31Jv5PVtQQkpw2V9C8Ig=
Date: Fri, 21 Aug 2026 15:21:57 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-change-two-gfp-flags-in-tests.patch removed from -mm tree
Message-Id: <20260821222158.0E7BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: change two GFP flags in tests
has been removed from the -mm tree.  Its filename was
     maple_tree-change-two-gfp-flags-in-tests.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: change two GFP flags in tests
Date: Tue, 30 Jun 2026 15:08:40 -0400

The GFP flags in two tests are obviously incorrect.  Make the tests
correctly run by updating the GFP flags.

Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
Link: https://lore.kernel.org/20260630190843.3563858-17-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Joe Perches <joe@perches.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-change-two-gfp-flags-in-tests
+++ a/tools/testing/radix-tree/maple.c
@@ -35234,7 +35234,7 @@ static noinline void __init check_preall
 	mt_set_non_kernel(1);
 	/* Spanning store */
 	mas_set_range(&mas, 1, 100);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35257,7 +35257,7 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

