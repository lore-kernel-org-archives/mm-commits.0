Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432D14EC46
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728771097; cv=none; b=AB3u5uAc/313uQ8gX6Frvdy/K2ZYmQ2sTzyJtA1t+bCAuGB2tWbgM5q3u3T80HU/35zXRBkQQwUBePN68e5dHGgr50QWYJ3MMuJsybZxnH7YUwIIOrUCIaqmRt4AtsUvdpMN489DauGKI8Be1E2CoOnmhbm4Z6/tymydAyKCJHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728771097; c=relaxed/simple;
	bh=KQVtfoqAN+wdftVfCxVi6EToKyxAf5NFTriI63pnAVw=;
	h=Date:To:From:Subject:Message-Id; b=TosGZ4MoIjFZEW5nzg1xF57cD6lIax5Gf6fUQZecVryfN1Emv90dILQsvdmYpvO4uX8RtK80tmwkoBHk3M1w+61/imIH7DuFM2JtEXlPZks9EEfPxDfFTacpb1RzLelMpq/HPpaBZACUtb6ZFKX/tq6d2J9v3j4uvcsMWFXjhpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c/Q6BcYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c/Q6BcYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C174C4CEC6;
	Sat, 12 Oct 2024 22:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728771096;
	bh=KQVtfoqAN+wdftVfCxVi6EToKyxAf5NFTriI63pnAVw=;
	h=Date:To:From:Subject:From;
	b=c/Q6BcYb5QNDOza621eyD+XwXHmVJixeVyrYCjKbggW9bLQhal0zMOPZ4BPBFAVvJ
	 2OofvWg/H7ML5lq6FebcV7HUOghwe+TjBdoJfel2MIoILlLOL2h34hPzDWyRmRk0tw
	 5x5CYVyOjMqcSCfTMUW3IyITOiLsNKy4QWQedkDc=
Date: Sat, 12 Oct 2024 15:11:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance.patch added to mm-hotfixes-unstable branch
Message-Id: <20241012221136.8C174C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: check for MA_STATE_BULK on setting wr_rebalance
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: check for MA_STATE_BULK on setting wr_rebalance
Date: Fri, 11 Oct 2024 17:44:50 -0400

It is possible for a bulk operation (MA_STATE_BULK is set) to enter the
new_end < mt_min_slots[type] case and set wr_rebalance as a store type. 
This is incorrect as bulk stores do not rebalance per write, but rather
after the all of the writes are done through the mas_bulk_rebalance()
path.  Therefore, add a check to make sure MA_STATE_BULK is not set before
we return wr_rebalance as the store type.

Also add a test to make sure wr_rebalance is never the store type when
doing bulk operations via mas_expected_entries()

This is a hotfix for this rc however it has no userspace effects as there
are no users of the bulk insertion mode.

Link: https://lkml.kernel.org/r/20241011214451.7286-1-sidhartha.kumar@oracle.com
Fixes: 5d659bbb52a2 ("maple_tree: introduce mas_wr_store_type()")
Suggested-by: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Sidhartha <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |    2 +-
 tools/testing/radix-tree/maple.c |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance
+++ a/lib/maple_tree.c
@@ -4218,7 +4218,7 @@ static inline void mas_wr_store_type(str
 
 	/* Potential spanning rebalance collapsing a node */
 	if (new_end < mt_min_slots[wr_mas->type]) {
-		if (!mte_is_root(mas->node)) {
+		if (!mte_is_root(mas->node) && !(mas->mas_flags & MA_STATE_BULK)) {
 			mas->store_type = wr_rebalance;
 			return;
 		}
--- a/tools/testing/radix-tree/maple.c~maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance
+++ a/tools/testing/radix-tree/maple.c
@@ -36317,6 +36317,28 @@ static inline int check_vma_modification
 	return 0;
 }
 
+/*
+ * test to check that bulk stores do not use wr_rebalance as the store
+ * type.
+ */
+static inline void check_bulk_rebalance(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, ULONG_MAX, ULONG_MAX);
+	int max = 10;
+
+	build_full_tree(mt, 0, 2);
+
+	/* erase every entry in the tree */
+	do {
+		/* set up bulk store mode */
+		mas_expected_entries(&mas, max);
+		mas_erase(&mas);
+		MT_BUG_ON(mt, mas.store_type == wr_rebalance);
+	} while (mas_prev(&mas, 0) != NULL);
+
+	mas_destroy(&mas);
+}
+
 void farmer_tests(void)
 {
 	struct maple_node *node;
@@ -36328,6 +36350,10 @@ void farmer_tests(void)
 	check_vma_modification(&tree);
 	mtree_destroy(&tree);
 
+	mt_init(&tree);
+	check_bulk_rebalance(&tree);
+	mtree_destroy(&tree);
+
 	tree.ma_root = xa_mk_value(0);
 	mt_dump(&tree, mt_dump_dec);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance.patch
maple_tree-remove-conditionals-to-detect-wr_node_store.patch

