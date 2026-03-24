Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D3E248F6F
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386676; cv=none; b=SiV0gtsI4m9t7g4T5cpr7rIpQOEPrYKOE8N5WhFPqoweFFQiw23MqHRaNcwPSa46VXKA18WGq7I+BBJbolADydyDwKgvU1B0h0IDURm+h9a0cDoSWD/JAAgnfh8Dnb+ZQMiXGtEyyjv9knuK32fYpDV6cgAUPgCDFiuVkEVch8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386676; c=relaxed/simple;
	bh=sNu+uY93Qp3o9mDKxL1LVCT6VeKGoUS6KnxDSKy1dRk=;
	h=Date:To:From:Subject:Message-Id; b=Spl1sQzheDtkuhjEmR39Bz2KS07+msGRtWGGUIj4jX1kraOtQ6AIF/Lv4tSoVasM+0qdRI9xGzpIpBM9xNuU2HW22z+gWd17suKeMu48wcluPQeYlvzEuQFKK3ljKQDs1y+8lOzagJ3V4kDEwbV4yIyQC8BlkoFRX4/Olj4E+OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xKhueAK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xKhueAK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8DBC19424;
	Tue, 24 Mar 2026 21:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386675;
	bh=sNu+uY93Qp3o9mDKxL1LVCT6VeKGoUS6KnxDSKy1dRk=;
	h=Date:To:From:Subject:From;
	b=xKhueAK4kdqNKYc2k/Qlbt1C5gUxAEIEf0hge3v+KaNGUHkHkttLSpGibp+579XeS
	 +fkr3Eu5Byb8nkfe1GoioC5X9nfBXepBDfHWWw+7HqVEsaYU7Dfl4vewggbSGkoj3y
	 oFMIz9IA16e6PidFjJe6Tq//76bpG44u1r3wG0ss=
Date: Tue, 24 Mar 2026 14:11:15 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-add-cp_is_new_root-helper-fix.patch removed from -mm tree
Message-Id: <20260324211115.8B8DBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree-add-cp_is_new_root-helper-fix
has been removed from the -mm tree.  Its filename was
     maple_tree-add-cp_is_new_root-helper-fix.patch

This patch was dropped because it was folded into maple_tree-add-cp_is_new_root-helper.patch

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
maple_tree-use-maple-copy-node-for-mas_wr_rebalance-operation.patch
maple_tree-add-test-for-rebalance-calculation-off-by-one.patch
maple_tree-add-copy_tree_location-helper.patch
maple_tree-add-cp_converged-helper.patch
maple_tree-use-maple-copy-node-for-mas_wr_split.patch
maple_tree-remove-maple-big-node-and-subtree-structs.patch
maple_tree-pass-maple-copy-node-to-mas_wmb_replace.patch
maple_tree-dont-pass-end-to-mas_wr_append.patch
maple_tree-clean-up-mas_wr_node_store.patch

