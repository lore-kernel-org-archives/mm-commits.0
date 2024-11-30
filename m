Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3F329B0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732941140; cv=none; b=PjlUuCXlPh8duYOEYoAPB9aC0S+aN+NpLGsqumqz5FPJu/P07TZo/O7evXavi+YO56+5rLJ6QeVHc06gkf9gapQHAAYI0UoOTjkzxybtaz7Bl5BSOvYT69G1lg3IykBidm3xGo8+aknKNL8AsFq5xl+5A87Kv340J2kQkuYSukc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732941140; c=relaxed/simple;
	bh=apMuaDbxQvcGDJ/5G7ewdkK74XueRlZ7mp4ngMfv+EI=;
	h=Date:To:From:Subject:Message-Id; b=Proin9OiO0IaNb7XYa0ZYB9mJneXBe3zn1L6mecFC7cqZ1+rnHsYmO9RTQLONScwvzrvuVJxtc3+mGjElgR5yEtozxZoVfBJjAxLhXLxtWFzeB/POcPpcgXcEUBsiSpFciAFvmjtwKF7cBwRXZxRotmzdKRdVdyCsjpuD3vet8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXTrNrIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXTrNrIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B22C4CECC;
	Sat, 30 Nov 2024 04:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732941140;
	bh=apMuaDbxQvcGDJ/5G7ewdkK74XueRlZ7mp4ngMfv+EI=;
	h=Date:To:From:Subject:From;
	b=IXTrNrIx0mz2EZFweIzV7wVEu/QFielAUhRWWUsPBNyuQs2LWjwAQ0aimnYMSytSI
	 GQvrlNV6zAsJyuj0lzNqKBDWHy8WrBQBr0VoAKxFja08FPXrHLXc8a7ZI/9aNJqqaU
	 PPF6xEB8ZUZIcg3yO1U6PNlSsCGiRExO9/Emyufo=
Date: Fri, 29 Nov 2024 20:32:19 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-a-test-check-deficient-node.patch added to mm-unstable branch
Message-Id: <20241130043220.33B22C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add a test check deficient node
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-a-test-check-deficient-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-a-test-check-deficient-node.patch

This patch will later appear in the mm-unstable branch at
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
Subject: maple_tree: add a test check deficient node
Date: Wed, 13 Nov 2024 03:16:15 +0000

Add a test to assert when resulting a deficient node on splitting.

We can achieve this by build a tree with two nodes. With the left
node with consecutive data from 0 and leave some room for the final
insert to locate in left node. And the right node a full node to force
the split happens on the left node.

Link: https://lkml.kernel.org/r/20241113031616.10530-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-a-test-check-deficient-node
+++ a/lib/test_maple_tree.c
@@ -1563,6 +1563,30 @@ static noinline void __init check_root_e
 	mas_unlock(&mas);
 }
 
+static noinline void __init check_deficient_node(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, 0, 0);
+	int count;
+
+	mas_lock(&mas);
+	for (count = 0; count < 10; count++) {
+		mas_set(&mas, count);
+		mas_store_gfp(&mas, xa_mk_value(count), GFP_KERNEL);
+	}
+
+	for (count = 20; count < 39; count++) {
+		mas_set(&mas, count);
+		mas_store_gfp(&mas, xa_mk_value(count), GFP_KERNEL);
+	}
+
+	for (count = 10; count < 12; count++) {
+		mas_set(&mas, count);
+		mas_store_gfp(&mas, xa_mk_value(count), GFP_KERNEL);
+	}
+	mas_unlock(&mas);
+	mt_validate(mt);
+}
+
 static noinline void __init check_gap_combining(struct maple_tree *mt)
 {
 	struct maple_enode *mn1, *mn2;
@@ -3797,6 +3821,10 @@ static int __init maple_tree_seed(void)
 #endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_deficient_node(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_store_null(&tree);
 	mtree_destroy(&tree);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch
maple_tree-simplify-split-calculation.patch
maple_tree-add-a-test-check-deficient-node.patch
maple_tree-only-root-node-could-be-deficient.patch

