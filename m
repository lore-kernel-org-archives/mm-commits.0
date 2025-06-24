Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C16230269
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796154; cv=none; b=IasgUxkLlKrpVzErSCxH/RROoyAg19c3QMnkUWNVwBb/vwXmJQ42TunlJdBSKRREZrg4jA0bOaLF8GY2vGZZ5Xw2gfKVaE9jzr6e3wNQEXWXi+1iFaMNfM4id0UC5TRCwLqxEJN0tNrdji874UtrhPIRhBRgMpBF3fSJofAUADI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796154; c=relaxed/simple;
	bh=U3rI2wQcuQ9Vjc5DAv/DscwHQbIs1JIlvbLccHBmwUo=;
	h=Date:To:From:Subject:Message-Id; b=AXRHubjc2qWHnkEXRTKIa9PMpw5QOxGeMX32lSIk/d3wW1ILCm8L2Te+lWzYwjIjibdSswLrcPHxY8OhCC7LgXFHC1y9RFkuncw12CB9lhRl2i8iu3DN9dr2WjMa1SdgnEvbIANVp9isGKjt7HOMuqOLfezzB7eoJpWgcjjJOgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oyeTRueZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oyeTRueZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB21C4CEEF;
	Tue, 24 Jun 2025 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750796154;
	bh=U3rI2wQcuQ9Vjc5DAv/DscwHQbIs1JIlvbLccHBmwUo=;
	h=Date:To:From:Subject:From;
	b=oyeTRueZL8ab7uSRwtO/LMVUu91j1r1HdQ954wnadymkpTcly9QMtcIdWTRw2GhSu
	 bab6O1X8vj90GYxfBW3t8CytqWeGysDnEOOvnRVwJNP5RP9PRsN6gJT0O4YWkR87qQ
	 Vc5ptkJFNWhHUDRRPwbSuFvvH8snJ2Kkl7vjY5qE=
Date: Tue, 24 Jun 2025 13:15:53 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch added to mm-new branch
Message-Id: <20250624201554.1AB21C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: assert retrieving new value on a tree containing just a leaf node
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: maple_tree: assert retrieving new value on a tree containing just a leaf node
Date: Tue, 24 Jun 2025 15:18:41 -0400

Original code may not get the new value after overwriting the whole range
on a maple tree containing just a leaf node.  The reason is we didn't set
the only root node dead during destroy.

Add a test case to ensure the new value is returned when overwriting a
tree containing just a leaf node.

[Liam.Howlett@oracle.com: use mtree_destroy, mas_set, and set val]
Link: https://lore.kernel.org/all/20250407231354.11771-1-richard.weiyang@gmail.com/
Link: https://lkml.kernel.org/r/20250624191841.64682-2-Liam.Howlett@oracle.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node
+++ a/tools/testing/radix-tree/maple.c
@@ -35257,6 +35257,32 @@ static noinline void __init check_rcu_si
 	MT_BUG_ON(mt, mas_prev(&mas_reader, 0) != xa_mk_value(val));
 	rcu_read_unlock();
 
+	/* Clear out tree & create one with only root node */
+	mtree_destroy(mt);
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_USE_RCU);
+	mas_pause(&mas_writer);
+	mas_lock(&mas_writer);
+	for (i = 0; i <= 5; i++) {
+		mas_writer.index = i * 10;
+		mas_writer.last = i * 10 + 5;
+		mas_store_gfp(&mas_writer, xa_mk_value(i), GFP_KERNEL);
+	}
+	mas_unlock(&mas_writer);
+	target = 10;
+	val = 20;
+	mas_set(&mas_reader, target);
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_walk(&mas_reader) != xa_mk_value(target/10));
+	MT_BUG_ON(mt, mte_is_leaf(mas_reader.node) != true);
+
+	/* Overwrite the whole range */
+	mas_lock(&mas_writer);
+	mas_set_range(&mas_writer, 0, ULONG_MAX);
+	mas_store_gfp(&mas_writer, xa_mk_value(val), GFP_KERNEL);
+	mas_unlock(&mas_writer);
+	MT_BUG_ON(mt, mas_walk(&mas_reader) != xa_mk_value(val));
+	rcu_read_unlock();
+
 	rcu_unregister_thread();
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch
maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

