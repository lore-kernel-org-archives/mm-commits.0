Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6824B19F464
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719261516; cv=none; b=DCAI2J0VbmJLyFNcYFS+JjoVco8gvgwJw4ogiDGKHnuQ2Nd/+NhUWmuCpbaLOnICmTr+IbllttqWnDnnfX6lxTAhPnpLDuklDcmXRl6WyfXRjheHSTFGALVTrmr8r7V4/KrGOddWZt/BGS2t9NHNrLh8ik68SnIz1fND3yRsmG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719261516; c=relaxed/simple;
	bh=tUcC+rF3YCO+s1wUd8IFOayAa1bWSvghyFsQsuK0ktQ=;
	h=Date:To:From:Subject:Message-Id; b=C5hzRHgBC5xzwbr5PN7/pNDRhLazwL0CBVWOdisiPGhDDJnrEUjMPOeYz0CMbK04Bnrv1uQ+P3ibMe2d9bHfTPqVZvLL64bEGDnCuXoV7KnPJb2ATygZH3YBsSFR7Tp0i0ANOuzWOzAKkzP9Abe3l2txeNzgGsNildasXFY9G6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=isJmagVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="isJmagVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC68C32781;
	Mon, 24 Jun 2024 20:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719261515;
	bh=tUcC+rF3YCO+s1wUd8IFOayAa1bWSvghyFsQsuK0ktQ=;
	h=Date:To:From:Subject:From;
	b=isJmagVIzuoLod3H3aOgekYrNcwKImga5okNlsTEG+FOrDOQ8qbYMOD9PZmiGqfK9
	 pSOhJuaELJGfqE7gTOOcukXoPq6/3mqcj/X8OrI9AZFUgFlikgtb3MYn6+M+KXmsPN
	 kvyU7KiXQ0H9LjD761ov/NxAfGWszoHaQ1ksKW+w=
Date: Mon, 24 Jun 2024 13:38:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-print-store-type-in-mas_dump.patch added to mm-unstable branch
Message-Id: <20240624203835.CAC68C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: print store type in mas_dump()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-print-store-type-in-mas_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-print-store-type-in-mas_dump.patch

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
Subject: maple_tree: print store type in mas_dump()
Date: Tue, 18 Jun 2024 13:47:42 -0700

Knowing the store type of the maple state could be helpful for debugging. 
Have mas_dump() print mas->store_type.

Link: https://lkml.kernel.org/r/20240618204750.79512-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/lib/maple_tree.c~maple_tree-print-store-type-in-mas_dump
+++ a/lib/maple_tree.c
@@ -7728,6 +7728,43 @@ void mas_dump(const struct ma_state *mas
 		break;
 	}
 
+	pr_err("Store Type: ");
+	switch (mas->store_type) {
+	case wr_invalid:
+		pr_err("invalid store type\n");
+		break;
+	case wr_new_root:
+		pr_err("new_root\n");
+		break;
+	case wr_store_root:
+		pr_err("store_root\n");
+		break;
+	case wr_exact_fit:
+		pr_err("exact_fit\n");
+		break;
+	case wr_split_store:
+		pr_err("split_store\n");
+		break;
+	case wr_slot_store:
+		pr_err("slot_store\n");
+		break;
+	case wr_append:
+		pr_err("append\n");
+		break;
+	case wr_node_store:
+		pr_err("node_store\n");
+		break;
+	case wr_spanning_store:
+		pr_err("spanning_store\n");
+		break;
+	case wr_rebalance:
+		pr_err("rebalance\n");
+		break;
+	case wr_bnode:
+		pr_err("write_bnode\n");
+		break;
+	}
+
 	pr_err("[%u/%u] index=%lx last=%lx\n", mas->offset, mas->end,
 	       mas->index, mas->last);
 	pr_err("     min=%lx max=%lx alloc=%p, depth=%u, flags=%x\n",
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

