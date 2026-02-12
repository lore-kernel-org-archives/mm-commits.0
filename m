Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CD72C026E
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939818; cv=none; b=HrWrGbfZmQ0F++WE1k8LbM8rWCoGySDHKmWLJljtZo1Gm+G8FSgoMK5q5c98okOY8Mvd+jSvEOgJrq9ooOYsjQtnrU3mET6C7zKFkSgiYgcUKSmGmtYCUqe0z87URqzHF6j5+sRV9GRuposU2rjDaD6h5n+bJBuSro3mnOvTuUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939818; c=relaxed/simple;
	bh=up7FAoONXND2c4Rgh3obCzpC16r+23Q73KkQ51BDidA=;
	h=Date:To:From:Subject:Message-Id; b=f86QTAZMjcym04LA5+gyXyi2UrgcAufC/l+JgBba7ibNYfYv7bc/wJwnEz5K05YEfy2Qb1Bftz2KpHguRk58RrphfpO1jXPyPLtHQYTUNhpuHyjvJD3VijQH+BnUCG7Tw0RWBAFYx6U9A+qsikarANkUn7xBTWeNtBZ02zjHWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MuLZt3AM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MuLZt3AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBF0C4CEF7;
	Thu, 12 Feb 2026 23:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939817;
	bh=up7FAoONXND2c4Rgh3obCzpC16r+23Q73KkQ51BDidA=;
	h=Date:To:From:Subject:From;
	b=MuLZt3AMJnO/IUx66iph0hD7Q0lXLh+nfYFZb+h1a77dJjcK/vJ2mU1r+lvotYNhY
	 n5PF8DTU3Na260xVagP9RsuW/9mnkXDuyfVcpI16CqCz+IqsbcredaMQ9DquFO967Q
	 elSdll5J7Hnju207hgfQ4YZWYptp3HCaKk3AhSSI=
Date: Thu, 12 Feb 2026 15:43:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-move-exit_mmap-trace-point.patch removed from -mm tree
Message-Id: <20260212234337.BBBF0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: move exit_mmap() trace point
has been removed from the -mm tree.  Its filename was
     mm-mmap-move-exit_mmap-trace-point.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: move exit_mmap() trace point
Date: Wed, 21 Jan 2026 11:49:37 -0500

Move the trace point later in the function so that it is not skipped in
the event of a failed fork.

Link: https://lkml.kernel.org/r/20260121164946.2093480-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-move-exit_mmap-trace-point
+++ a/mm/mmap.c
@@ -1307,9 +1307,9 @@ void exit_mmap(struct mm_struct *mm)
 
 	BUG_ON(count != mm->map_count);
 
-	trace_exit_mmap(mm);
 destroy:
 	__mt_destroy(&mm->mm_mt);
+	trace_exit_mmap(mm);
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
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

