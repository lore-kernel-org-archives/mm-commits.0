Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C642B2233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261528; cv=none; b=Iy/IhebroVIUyet9ULrpCAg1+GWtKXYNlTOb/dY1klp5CfIv/syib/cOuxAzZaG5e57pDFFvpeFiB2piCjV+zhiK0YL+zbU5LRHtjLwJ2ZoSV3b55QHxTUxAP3HgN2T0xbk0KaYFcerEoEVSBvgU//NvlE+XNjWgZqi8fVRGzsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261528; c=relaxed/simple;
	bh=PZEos2C4qHu7qYl6/APmIBAFR0PXw1Rlk0Jn42KKuYo=;
	h=Date:To:From:Subject:Message-Id; b=DQTkDxWuFsKdAjlzY64zIPBZenNDBB7Sr+JFZ1XIiLiEItuEfj2538qsOLZ+1xATnkdU5vfmuJh6n33GamnqP7SViFBwo2b1BmU2w9Sf+GPiFx9q83jCNpkU/QDfHbPTfczdKEhfkJh2VdwtBv0kqZP/ElAieMYrg/D8Jzl3d4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CiPH4ioH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CiPH4ioH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8D2C2BBFC;
	Mon, 24 Jun 2024 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261528;
	bh=PZEos2C4qHu7qYl6/APmIBAFR0PXw1Rlk0Jn42KKuYo=;
	h=Date:To:From:Subject:From;
	b=CiPH4ioH7r1yWbLHrO4mCemV4bW7Wl660t4yQc+Dszu28bcK0aUeP+V7udX/7MEPu
	 ArVJLeXILXsv8UA6cNcr4V4nQ4wMmv//Fld6WAYulvZjxJAfd1sYuhiMdgxgx7J/Kn
	 IN8m8DZn+cLS+1hYxBXARMEBrbvpP7wB+7E2+zGA=
Date: Mon, 24 Jun 2024 13:38:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch added to mm-unstable branch
Message-Id: <20240624203848.9B8D2C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove repeated sanity checks from mas_wr_append()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-repeated-sanity-checks-from-mas_wr_append.patch

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
Subject: maple_tree: remove repeated sanity checks from mas_wr_append()
Date: Tue, 18 Jun 2024 13:47:49 -0700

These sanity checks are now redundant as they are already checked in
mas_wr_store_type().  We can remove them from mas_wr_append().

Link: https://lkml.kernel.org/r/20240618204750.79512-16-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-repeated-sanity-checks-from-mas_wr_append
+++ a/lib/maple_tree.c
@@ -4061,17 +4061,9 @@ static inline unsigned char mas_wr_new_e
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas,
 		unsigned char new_end)
 {
-	struct ma_state *mas;
+	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
-	unsigned char end;
-
-	mas = wr_mas->mas;
-	if (mt_in_rcu(mas->tree))
-		return false;
-
-	end = mas->end;
-	if (mas->offset != end)
-		return false;
+	unsigned char end = mas->end;
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
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

