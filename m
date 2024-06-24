Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D092233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261523; cv=none; b=NqThdL0NBRYqvyNXSwBsq+RuQHEeaiA/mfq8kdITi4t+Yhnu9RHkuVcMtjT59V5HaK8JJgrRwZoklO5trTR132hb8LDN8IG013yEn/HwVBc+knefKpWS6ZuEgYJ+5WCJJ1j7SvcNT9ZrFcmt6c7ZW7exGs8snRd6fJo5ttEMxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261523; c=relaxed/simple;
	bh=GpJXHeIk7MLlzVZ3EjPNt429MkNSCjx1nHzqcQNgUHg=;
	h=Date:To:From:Subject:Message-Id; b=cBA4MJlsebTSennXV4m3nJx0hj6CFj+OiAu9efiGsxu+TXcix/MVbrWBPhO9kZjCn1yVr6C2h6hdezlcKRzKWRn7yZklP1dRIyhWF2ZYQSAoNzV8LmJWVT+LepbE5V/5Dm5ZZ8rliIISyvopHSHgWzL61wTdidBWrFkvCihMUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JcU/3ZrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JcU/3ZrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EB6C2BBFC;
	Mon, 24 Jun 2024 20:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261523;
	bh=GpJXHeIk7MLlzVZ3EjPNt429MkNSCjx1nHzqcQNgUHg=;
	h=Date:To:From:Subject:From;
	b=JcU/3ZrTPSgwCfjDLMJxfhPB8UewiC14E6pS1Hoidpo3QGlxNVpLjPt7deuHo8JPz
	 8MaMXQjOH19IUwCIJW+t2MpP3BYZHmI6rt9LyI4OaZ3sGcbxfNPRMIjZDeAdHD6Oxo
	 zE/A4PcbHq1u5X6MQS7revQgIMK1WSJAgph6++Uc=
Date: Mon, 24 Jun 2024 13:38:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-mas_wr_modify.patch added to mm-unstable branch
Message-Id: <20240624203843.38EB6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove mas_wr_modify()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-mas_wr_modify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-mas_wr_modify.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove mas_wr_modify()
Date: Tue, 18 Jun 2024 13:47:46 -0700

There are no more users of the function, safely remove it.

Link: https://lkml.kernel.org/r/20240618204750.79512-13-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-mas_wr_modify
+++ a/lib/maple_tree.c
@@ -4155,44 +4155,6 @@ static void mas_wr_bnode(struct ma_wr_st
 	mas_commit_b_node(wr_mas, &b_node, wr_mas->mas->end);
 }
 
-static inline void mas_wr_modify(struct ma_wr_state *wr_mas)
-{
-	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end;
-
-	/* Direct replacement */
-	if (wr_mas->r_min == mas->index && wr_mas->r_max == mas->last) {
-		rcu_assign_pointer(wr_mas->slots[mas->offset], wr_mas->entry);
-		if (!!wr_mas->entry ^ !!wr_mas->content)
-			mas_update_gap(mas);
-		return;
-	}
-
-	/*
-	 * new_end exceeds the size of the maple node and cannot enter the fast
-	 * path.
-	 */
-	new_end = mas_wr_new_end(wr_mas);
-	if (new_end >= mt_slots[wr_mas->type])
-		goto slow_path;
-
-	/* Attempt to append */
-	if (mas_wr_append(wr_mas, new_end))
-		return;
-
-	if (new_end == mas->end && mas_wr_slot_store(wr_mas))
-		return;
-
-	if (mas_wr_node_store(wr_mas, new_end))
-		return;
-
-	if (mas_is_err(mas))
-		return;
-
-slow_path:
-	mas_wr_bnode(wr_mas);
-}
-
 /*
  * mas_wr_store_entry() - Internal call to store a value
  * @mas: The maple state
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-remove-setclearhpage-macros.patch
mm-hugetlb-mm-memory_hotplug-use-a-folio-in-scan_movable_pages.patch
maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-use-mas_store_gfp-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
tools-testing-radix-tree-add-missing-module_description-definition.patch

