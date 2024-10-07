Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549161D968B
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728326506; cv=none; b=Slcwa/F0hNdZi0a+9mZM0S6ghNj2HkyPujd+0q5rCT6LRc/8BjBjdMYVXxbM7g0rmJWt3V1zh4D0BEWRgTZerubhG7ErEHvS2kkby4BlNR7FpfMZigxVY6FvyrSpJqcVSXDMg6iGthp/p3VwetKIYRKiXkP4VyDT6lD2dJetkhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728326506; c=relaxed/simple;
	bh=11YqXbQwrddgvncYGDLHWV6FNlzzwolEA5Tbmh3CIyY=;
	h=Date:To:From:Subject:Message-Id; b=LdIhjgKMH+WennHViLN54DdqvzrfSE/eonBD9EZm7uIoB3+VrGK0H30HPwY1TnKV37UqK7r+qA+JIAjgF/t9N8b04fwZGECIKwqaRZxYtoQNuNTz3jPtdWZ+nmWIQmnuHci7oNhvsOt68SD6y6FrnYJLfAvbGDVYmyTgMwIdYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=efShd+F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efShd+F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB9CC4CEC6;
	Mon,  7 Oct 2024 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728326506;
	bh=11YqXbQwrddgvncYGDLHWV6FNlzzwolEA5Tbmh3CIyY=;
	h=Date:To:From:Subject:From;
	b=efShd+F+Sge+Rd2sCBq00ZZ+LkPIhRjWlTv/dABeW8Pi94gaf7ScNd8KtB8HtgUSc
	 83AipuyExkOvZQjQmBbl7uItFwzN6/Z++nki7wZz7eK7IjCuimie4IHMUBOFmdz+c5
	 SjfgxHAqkfawBmRnigl3NGovJTp+xLQoJJwRbghg=
Date: Mon, 07 Oct 2024 11:41:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,spasswolf@web.de,sidhartha.kumar@oracle.com,mikhail.v.gavrilov@gmail.com,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-regression-test-for-spanning-store-bug.patch added to mm-hotfixes-unstable branch
Message-Id: <20241007184146.1DB9CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add regression test for spanning store bug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-add-regression-test-for-spanning-store-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-regression-test-for-spanning-store-bug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   84 +++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-add-regression-test-for-spanning-store-bug
+++ a/tools/testing/radix-tree/maple.c
@@ -36406,9 +36406,93 @@ void farmer_tests(void)
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

mm-mmap-correct-error-handling-in-mmap_region.patch
maple_tree-correct-tree-corruption-on-spanning-store.patch
maple_tree-add-regression-test-for-spanning-store-bug.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch

