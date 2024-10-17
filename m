Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3711DF25D
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729179343; cv=none; b=O+krb4YQbQZSxlby+ylgGh1l0VXjxlIGyWIQmU/Sgl/nD0p6yGgroCVMClTz7F2twaxY/R/D+/2n5qq5zHHVYVrRGz2aaaZhCHgu5A+tFHpdldtPcTGOwS34ZKFht9r2CK0KySa+lIPCOEGE4tfHUPVFOHkGg/Zb+AX9kqrcPJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729179343; c=relaxed/simple;
	bh=Ml0kB9MvXtsAwLJwQ28nAAMqTglSk9alGoWiYYvdzvk=;
	h=Date:To:From:Subject:Message-Id; b=SZAIhSTz2fUsT4p3CTBDTPHL9/uHOFBJsrfnivpgwk7oS4GK6IDXCuB3OzYzroEL1ydA+qFiZUsd7D1eGI+QFOu9UTepp2tEu/h0fAIRzjlLoncvqnFxReCW8xNpTyg7DFklZOuSZK3UlWPMgvdJ9e6VLDpIlNd3W46K2OwpdW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AeL1znTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AeL1znTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC4DC4CEC7;
	Thu, 17 Oct 2024 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729179342;
	bh=Ml0kB9MvXtsAwLJwQ28nAAMqTglSk9alGoWiYYvdzvk=;
	h=Date:To:From:Subject:From;
	b=AeL1znTNrpYSGf0z201sV4PR26OQQ4QfiZEwGoCKLGlX+WHG1xElXRVaaAYQfbdRE
	 2tQq7z93r6tHYUBdRBjo2UHSsSXSW2XWDGWdhHE41Gp9pUi1D5Kr/NvOHh1ulCnCEN
	 QpHbx9JPudllXYWAnguA0R6DN3ZdhN78zvGYc2lQ=
Date: Thu, 17 Oct 2024 08:35:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,spasswolf@web.de,sidhartha.kumar@oracle.com,richard.weiyang@gmail.com,mikhail.v.gavrilov@gmail.com,Liam.Howlett@Oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-add-regression-test-for-spanning-store-bug.patch removed from -mm tree
Message-Id: <20241017153542.DCC4DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add regression test for spanning store bug
has been removed from the -mm tree.  Its filename was
     maple_tree-add-regression-test-for-spanning-store-bug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: maple_tree: add regression test for spanning store bug
Date: Mon, 7 Oct 2024 16:28:33 +0100

Add a regression test to assert that, when performing a spanning store
which consumes the entirety of the rightmost right leaf node does not
result in maple tree corruption when doing so.

This achieves this by building a test tree of 3 levels and establishing a
store which ultimately results in a spanned store of this nature.

Link: https://lkml.kernel.org/r/30cdc101a700d16e03ba2f9aa5d83f2efa894168.1728314403.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   84 +++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-add-regression-test-for-spanning-store-bug
+++ a/tools/testing/radix-tree/maple.c
@@ -36432,9 +36432,93 @@ void farmer_tests(void)
 	check_nomem(&tree);
 }
 
+static unsigned long get_last_index(struct ma_state *mas)
+{
+	struct maple_node *node = mas_mn(mas);
+	enum maple_type mt = mte_node_type(mas->node);
+	unsigned long *pivots = ma_pivots(node, mt);
+	unsigned long last_index = mas_data_end(mas);
+
+	BUG_ON(last_index == 0);
+
+	return pivots[last_index - 1] + 1;
+}
+
+/*
+ * Assert that we handle spanning stores that consume the entirety of the right
+ * leaf node correctly.
+ */
+static void test_spanning_store_regression(void)
+{
+	unsigned long from = 0, to = 0;
+	DEFINE_MTREE(tree);
+	MA_STATE(mas, &tree, 0, 0);
+
+	/*
+	 * Build a 3-level tree. We require a parent node below the root node
+	 * and 2 leaf nodes under it, so we can span the entirety of the right
+	 * hand node.
+	 */
+	build_full_tree(&tree, 0, 3);
+
+	/* Descend into position at depth 2. */
+	mas_reset(&mas);
+	mas_start(&mas);
+	mas_descend(&mas);
+	mas_descend(&mas);
+
+	/*
+	 * We need to establish a tree like the below.
+	 *
+	 * Then we can try a store in [from, to] which results in a spanned
+	 * store across nodes B and C, with the maple state at the time of the
+	 * write being such that only the subtree at A and below is considered.
+	 *
+	 * Height
+	 *  0                              Root Node
+	 *                                  /      \
+	 *                    pivot = to   /        \ pivot = ULONG_MAX
+	 *                                /          \
+	 *   1                       A [-----]       ...
+	 *                              /   \
+	 *                pivot = from /     \ pivot = to
+	 *                            /       \
+	 *   2 (LEAVES)          B [-----]  [-----] C
+	 *                                       ^--- Last pivot to.
+	 */
+	while (true) {
+		unsigned long tmp = get_last_index(&mas);
+
+		if (mas_next_sibling(&mas)) {
+			from = tmp;
+			to = mas.max;
+		} else {
+			break;
+		}
+	}
+
+	BUG_ON(from == 0 && to == 0);
+
+	/* Perform the store. */
+	mas_set_range(&mas, from, to);
+	mas_store_gfp(&mas, xa_mk_value(0xdead), GFP_KERNEL);
+
+	/* If the regression occurs, the validation will fail. */
+	mt_validate(&tree);
+
+	/* Cleanup. */
+	__mt_destroy(&tree);
+}
+
+static void regression_tests(void)
+{
+	test_spanning_store_regression();
+}
+
 void maple_tree_tests(void)
 {
 #if !defined(BENCH)
+	regression_tests();
 	farmer_tests();
 #endif
 	maple_tree_seed();
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch

