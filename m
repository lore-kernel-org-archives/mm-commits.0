Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED214194C96
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770140458; cv=none; b=Tk3Zhauii2BnE3QpT52YQLybSewZoORWquicidSvAd+/GCs8ixAnIsS7R9XWfjf2KDkENNhmt24vO1v1/NCkkLeYp/MaHanClX89xEtLLW5HukyLVfQTCss+2Z0wodtVlN9lIG/+lpfy2kUxrIFzPW9wYbin8g1sBZQl2k2yZng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770140458; c=relaxed/simple;
	bh=17fZSV6p96aJ4sK/WqmTxpE5UcsWnIxtpJytmpBbt3A=;
	h=Date:To:From:Subject:Message-Id; b=QZIG5I3LG6GJcVjcQc+BszU4tVKwmDBiJJxsgtBeYpFGaHl3Sw5tefKzABUmrvVYcx68UqXBDawmpt9w+kBMqjO/iKrGXSb2zRSOc3wzG6KTbGiISkrGMIurDwGM7O5SRDZYCs0oCLkRK7F+ROoW+Xl4kSs6E1Lf1EW8UnbXcv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nLVWN9o8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nLVWN9o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487AAC116D0;
	Tue,  3 Feb 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770140457;
	bh=17fZSV6p96aJ4sK/WqmTxpE5UcsWnIxtpJytmpBbt3A=;
	h=Date:To:From:Subject:From;
	b=nLVWN9o8V/GKX+P0GxpZh4NQURfgl2/OkYRCi+61HtmtDVXSyk4/SyJbaqbBYO1Zo
	 ntFAYgFnevW0IxGgJJUX1Nbd4MkhlOYhBWJY81qkhv7eDh2gPKbrUazBuIZDTcEtu6
	 pcMp627hUKPhxmkeC7NoUdY/aEtPoERjN9ejAP3c=
Date: Tue, 03 Feb 2026 09:40:56 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-cp_is_new_root-helper-fix.patch added to mm-new branch
Message-Id: <20260203174057.487AAC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-add-cp_is_new_root-helper-fix
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-add-cp_is_new_root-helper-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-cp_is_new_root-helper-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree-add-cp_is_new_root-helper-fix
Date: Tue, 3 Feb 2026 12:26:44 -0500

remove warnings on older compilers

Link: https://lkml.kernel.org/r/malwmirqnpuxqkqrobcmzfkmmxipoyzwfs2nwc5fbpxlt2r2ej@wchmjtaljvw3
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-add-cp_is_new_root-helper-fix
+++ a/lib/maple_tree.c
@@ -3361,7 +3361,7 @@ static inline bool cp_is_new_root(struct
 		 * read-side operations that can view it until it is insert into
 		 * the tree after an rcu_assign_pointer() call.
 		 */
-		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
+		ma_init_slot(cp->slot[0], cp->dst[0].node, mt);
 		cp->height++;
 	}
 	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-relocate-the-page-table-ceiling-and-floor-definitions.patch
mm-mmap-move-exit_mmap-trace-point.patch
mm-mmap-abstract-vma-clean-up-from-exit_mmap.patch
mm-vma-add-limits-to-unmap_region-for-vmas.patch
mm-memory-add-tree-limit-to-free_pgtables.patch
mm-vma-add-page-table-limit-to-unmap_region.patch
mm-change-dup_mmap-recovery.patch
mm-introduce-unmap_desc-struct-to-reduce-function-arguments.patch
mm-vma-use-unmap_desc-in-exit_mmap-and-vms_clear_ptes.patch
mm-vma-use-unmap_region-in-vms_clear_ptes.patch
mm-use-unmap_desc-struct-for-freeing-page-tables.patch
maple_tree-fix-mas_dup_alloc-sparse-warning.patch
maple_tree-move-mas_spanning_rebalance-loop-to-function.patch
maple_tree-extract-use-of-big-node-from-mas_wr_spanning_store.patch
maple_tree-remove-unnecessary-assignment-of-orig_l-index.patch
maple_tree-inline-mas_spanning_rebalance-into-mas_wr_spanning_rebalance.patch
maple_tree-make-ma_wr_states-reliable-for-reuse-in-spanning-store.patch
maple_tree-remove-l_wr_mas-from-mas_wr_spanning_rebalance.patch
maple_tree-dont-pass-through-height-in-mas_wr_spanning_store.patch
maple_tree-move-maple_subtree_state-from-mas_wr_spanning_store-to-mas_wr_spanning_rebalance.patch
maple_tree-correct-right-ma_wr_state-end-pivot-in-mas_wr_spanning_store.patch
maple_tree-introduce-maple_copy-node-and-use-it-in-mas_spanning_rebalance.patch
maple_tree-testing-update-for-spanning-store.patch
maple_tree-inline-mas_spanning_rebalance_loop-into-mas_wr_spanning_rebalance.patch
maple_tree-change-initial-big-node-setup-in-mas_wr_spanning_rebalance.patch
maple_tree-introduce-ma_leaf_max_gap.patch
maple_tree-add-gap-support-slot-and-pivot-sizes-for-maple-copy.patch
maple_tree-start-using-maple-copy-node-for-destination.patch
maple_tree-inline-mas_wr_spanning_rebalance.patch
maple_tree-remove-unnecessary-return-statements.patch
maple_tree-separate-wr_split_store-and-wr_rebalance-store-type-code-path.patch
maple_tree-add-cp_is_new_root-helper.patch
maple_tree-add-cp_is_new_root-helper-fix.patch
maple_tree-use-maple-copy-node-for-mas_wr_rebalance-operation.patch
maple_tree-add-test-for-rebalance-calculation-off-by-one.patch
maple_tree-add-copy_tree_location-helper.patch
maple_tree-add-cp_converged-helper.patch
maple_tree-use-maple-copy-node-for-mas_wr_split.patch
maple_tree-remove-maple-big-node-and-subtree-structs.patch
maple_tree-pass-maple-copy-node-to-mas_wmb_replace.patch
maple_tree-dont-pass-end-to-mas_wr_append.patch
maple_tree-clean-up-mas_wr_node_store.patch

