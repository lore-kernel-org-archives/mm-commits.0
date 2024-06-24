Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1072E2233B
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261504; cv=none; b=TrwILiXFzuiCnhNdmyD7sFgs31lpopA7vMapjZWq50ielV/ZhrZv6tgFOdVxHV3UrTZrmHVUuV0u52JjPNmZ0C1LYitmEfYhLg05jaBpT0bjYasXJuaf28YEegggSexOOHbv7oBkIBK8Hy1BoCNH5kYcKRsrYbgHuilwv33xjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261504; c=relaxed/simple;
	bh=ulQnpMWt65xzoTNEKCYZHdE/2urtbqTJmaG4kWuwyfs=;
	h=Date:To:From:Subject:Message-Id; b=DSX0xjIDVbdUlcSLo7GMh9YmvK53OtXGxTUgjQg9EV4oUhoAivkGxji2a47m9z4Il3mYdllFQayF/fQRn7XibV2v5ZgG5j0XXfiBIYt57LnOGaBVd5DqCECz0Bjbx4Yaht3x+TyK3ZaTR1gODDLKAChza4F2ADLXdW14R0X41DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GLGwPiLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GLGwPiLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C6AC2BBFC;
	Mon, 24 Jun 2024 20:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261503;
	bh=ulQnpMWt65xzoTNEKCYZHdE/2urtbqTJmaG4kWuwyfs=;
	h=Date:To:From:Subject:From;
	b=GLGwPiLKY4VT5A0DYFul5Qshs4U8yjZrDlKyMC+xFoGMj1okNRYmS60kwC0jK7yQG
	 +eLQngtHKavOU8a8CeMooLqWoKLHc/LGCD3cSlELweiqBKqDiq3wFfU3YnZdktZlm4
	 nIrmNE4IWMrsKPlRZCcx2eu/HaISwxWZajOfyEvA=
Date: Mon, 24 Jun 2024 13:38:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-mas_wr_prealloc_setup.patch added to mm-unstable branch
Message-Id: <20240624203823.B9C6AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: introduce mas_wr_prealloc_setup()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-mas_wr_prealloc_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-mas_wr_prealloc_setup.patch

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
Subject: maple_tree: introduce mas_wr_prealloc_setup()
Date: Tue, 18 Jun 2024 13:47:36 -0700

Introduce a helper function, mas_wr_prealoc_setup(), that will set up a
maple write state in order to start a walk of a maple tree.

Link: https://lkml.kernel.org/r/20240618204750.79512-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_wr_prealloc_setup
+++ a/lib/maple_tree.c
@@ -5399,6 +5399,13 @@ reset:
 	mas_reset(wr_mas->mas);
 }
 
+static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_wr_store_setup(wr_mas);
+	wr_mas->content = mas_start(mas);
+}
 /* Interface */
 
 /**
@@ -5504,8 +5511,7 @@ int mas_preallocate(struct ma_state *mas
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		goto ask_now;
 
-	mas_wr_store_setup(&wr_mas);
-	wr_mas.content = mas_start(mas);
+	mas_wr_prealloc_setup(&wr_mas);
 	/* Root expand */
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		goto ask_now;
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

