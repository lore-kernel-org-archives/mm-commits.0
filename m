Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB223A115
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836966; cv=none; b=flU/TtVxOCzn+sXpSfL9IRWdCOUWT9LIb5IRyVYKdgonX4NBysSr92anNw51WCUMGuQfWsoFj2Iw5rascNcW+MeiNnEGluVG2Nmmn5Ts6+NYir31y2iLSLKTzVph6w65V3qJm0pmCqFt33H/El7ONj4EK9pxggwT6aXFHe42ghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836966; c=relaxed/simple;
	bh=STLmhx7oL9VA5V+CGXoQiCfEj17g4wTGvZ7GDteSGNg=;
	h=Date:To:From:Subject:Message-Id; b=b4BhVApRAA/dIXBT0pBnUHR+S7jByBv6mZh0ebuE9adWPWIeilamBnoavYcFzUk0b7Pki8mb4mhRs2zJzADij8nrhEXz45T2HrVkkq8M6P/Upeyl+v1JE9DnD6dd8qdKqbAt79EXDtjWKHDnsFi2Y5SxWcp1fsXIuuuXnZDOyLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LuGXA14B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LuGXA14B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FF1C4CEDD;
	Tue, 14 Jan 2025 06:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836966;
	bh=STLmhx7oL9VA5V+CGXoQiCfEj17g4wTGvZ7GDteSGNg=;
	h=Date:To:From:Subject:From;
	b=LuGXA14BKFKSh5uwc1+I736yR3ZsD28ShhNvaaomVPLsDmTTfidanKdKd1hFe81hx
	 FtBzc+43d6NW5d7+Ukklt2SLD2M86LnMPern5xTDxQY9/At/TWgDujeyVfQQiN4ZM7
	 UqN/6xtE7MtCzlPR2IulvYayiZb1ok9Xep3ItEPc=
Date: Mon, 13 Jan 2025 22:42:45 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-a-test-check-deficient-node.patch removed from -mm tree
Message-Id: <20250114064246.31FF1C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add a test check deficient node
has been removed from the -mm tree.  Its filename was
     maple_tree-add-a-test-check-deficient-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


