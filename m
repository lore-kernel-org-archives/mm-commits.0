Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949E32233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261530; cv=none; b=HpQ4Tt6ZewlP6WN4tQEdDM3Oo7jdRsb6GZTG8WP0la00UVqb50AUuCuJctOBDN5tqCK0Nn6antm58RsV+tLLI8axS64Cu8GlQI5/9krdo+2bGemyjKuHGZX/rH8lQkZpbmnkchQ7jbzVXhrq8RfhOuv3IuRwGCWJAP73Ul8HmN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261530; c=relaxed/simple;
	bh=lWT+zKhFxYBFeO5YscSymR+A/fGeyLF35DUoUw5EUEE=;
	h=Date:To:From:Subject:Message-Id; b=Qh+ZzEkjTlyGJU9zV/o58nCRdJwgBKcyhfm0kun9pVc4OW3IxXbBuCPV4cW+AkXnpsVhXQAlDedZgna5n2gyFjBdpRCRN5t/ixyumeguRBQ7i2Uhy4u255MyIRIB5vO61al5BmNh8h4jUMsycAdES+BKJA65bo72csQ5TU9ibJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uHnmMO9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uHnmMO9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A589C2BBFC;
	Mon, 24 Jun 2024 20:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261530;
	bh=lWT+zKhFxYBFeO5YscSymR+A/fGeyLF35DUoUw5EUEE=;
	h=Date:To:From:Subject:From;
	b=uHnmMO9uyFHmkWV4AxHcF9ugNd5jYOUWOmkB3CG3rnF9kQhE8svkPDsQCYLwm26Vc
	 aYLV2BYYTMf6CTIlkQIbjMva40IR2FKLvm0tQwFrPIKLVQe2FXTxjORZVdjxnBfFfy
	 9dJhV8nn+ErBJTXC1+ZaVV2nhn1cpbWPOc/GflVs=
Date: Mon, 24 Jun 2024 13:38:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch added to mm-unstable branch
Message-Id: <20240624203850.6A589C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove unneeded mas_wr_walk() in mas_store_prealloc()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch

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
Subject: maple_tree: remove unneeded mas_wr_walk() in mas_store_prealloc()
Date: Tue, 18 Jun 2024 13:47:50 -0700

Users of mas_store_prealloc() enter this function with nodes already
preallocated.  This means the store type must be already set.  We can then
remove the call to mas_wr_store_type() and initialize the write state to
continue the partial walk that was done when determining the store type.

Link: https://lkml.kernel.org/r/20240618204750.79512-17-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc
+++ a/lib/maple_tree.c
@@ -4027,9 +4027,6 @@ static inline void mas_wr_end_piv(struct
 		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
 	else
 		wr_mas->end_piv = wr_mas->mas->max;
-
-	if (!wr_mas->entry)
-		mas_wr_extend_null(wr_mas);
 }
 
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
@@ -5590,8 +5587,19 @@ void mas_store_prealloc(struct ma_state
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	mas_wr_prealloc_setup(&wr_mas);
-	mas_wr_store_type(&wr_mas);
+	if (mas->store_type == wr_store_root) {
+		mas_wr_prealloc_setup(&wr_mas);
+		goto store;
+	}
+
+	mas_wr_walk_descend(&wr_mas);
+	if (mas->store_type != wr_spanning_store) {
+		/* set wr_mas->content to current slot */
+		wr_mas.content = mas_slot_locked(mas, wr_mas.slots, mas->offset);
+		mas_wr_end_piv(&wr_mas);
+	}
+
+store:
 	trace_ma_write(__func__, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
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

