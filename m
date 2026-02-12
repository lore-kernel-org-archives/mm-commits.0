Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F9B2DB78F
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939816; cv=none; b=mP0fR63UvcHujMswdvQN/MNAbOAwO6qB4OOOscnbBBr3KdVXuSZERNLmL1R7peh2dhhtJz/xfzTvkG5+MqbLHKUPmUblSGoftk0jLZX4/BSwKBP33oNRCs2cfnXPf6koM2QNHQTIN3bVY8za9qej2VS8GYf+wRDL5TbeJhLesgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939816; c=relaxed/simple;
	bh=+eq8obmEXnOZaq05r75gy/SqAWLZTCRzcQJa4ZHXrnw=;
	h=Date:To:From:Subject:Message-Id; b=rNT9DA8jSk684StjzmMqgY9Vs14lw9o80oVky3Mu+nY0MT2QuP7hzURCv0aRpkAEXgEsVdXQrrm9pQm3SeEObGg5oRo/8wRx5sUc20iclDjzY68SdiEoI3x13KyNYFgHTQM6Qbn+HSFfDwEktfmmo9/Qn6ukAdlg3fdOC1j6L+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VkYXcvLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VkYXcvLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FE2C4CEF7;
	Thu, 12 Feb 2026 23:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939816;
	bh=+eq8obmEXnOZaq05r75gy/SqAWLZTCRzcQJa4ZHXrnw=;
	h=Date:To:From:Subject:From;
	b=VkYXcvLb5N1MYWFvyyiF+xM8V+Gg0I6JeuSB/M6giGNXS48jXQKdPT7N4uStx7NVb
	 NkjuBMeD1C9PaNVGQTKR5shz9vQ+zZIHgJy4wDlRxjwqmP6+iS7k+A5uh8LU9HVvsi
	 qolJV9+phVpmj0Jg85U/d2GQym2icIXSr//72OOQ=
Date: Thu, 12 Feb 2026 15:43:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-relocate-the-page-table-ceiling-and-floor-definitions.patch removed from -mm tree
Message-Id: <20260212234336.46FE2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: relocate the page table ceiling and floor definitions
has been removed from the -mm tree.  Its filename was
     mm-relocate-the-page-table-ceiling-and-floor-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: relocate the page table ceiling and floor definitions
Date: Wed, 21 Jan 2026 11:49:36 -0500

Patch series " Remove XA_ZERO from error recovery of dup_mmap()", v3.

It is possible that the dup_mmap() call fails on allocating or setting up
a vma after the maple tree of the oldmm is copied.  Today, that failure
point is marked by inserting an XA_ZERO entry over the failure point so
that the exact location does not need to be communicated through to
exit_mmap().

However, a race exists in the tear down process because the dup_mmap()
drops the mmap lock before exit_mmap() can remove the partially set up vma
tree.  This means that other tasks may get to the mm tree and find the
invalid vma pointer (since it's an XA_ZERO entry), even though the mm is
marked as MMF_OOM_SKIP and MMF_UNSTABLE.

To remove the race fully, the tree must be cleaned up before dropping the
lock.  This is accomplished by extracting the vma cleanup in exit_mmap()
and changing the required functions to pass through the vma search limit. 
Any other tree modifications would require extra cycles which should be
spent on freeing memory.

This does run the risk of increasing the possibility of finding no vmas
(which is already possible!) in code that isn't careful.

The final four patches are to address the excessive argument lists being
passed between the functions.  Using the struct unmap_desc also allows
some special-case code to be removed in favour of the struct setup
differences.


This patch (of 11):

pgtables.h defines a fallback for ceiling and floor of the page tables
within the CONFIG_MMU section.  Moving the definitions to outside the
CONFIG_MMU allows for using them in generic code.

[akpm@linux-foundation.org: remove stray newline, per SeongJae]
Link: https://lkml.kernel.org/r/20260121164946.2093480-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20260121164946.2093480-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   38 +++++++++++++++++++-------------------
 mm/vma_internal.h       |    1 +
 2 files changed, 20 insertions(+), 19 deletions(-)

--- a/include/linux/pgtable.h~mm-relocate-the-page-table-ceiling-and-floor-definitions
+++ a/include/linux/pgtable.h
@@ -23,25 +23,6 @@
 #endif
 
 /*
- * On almost all architectures and configurations, 0 can be used as the
- * upper ceiling to free_pgtables(): on many architectures it has the same
- * effect as using TASK_SIZE.  However, there is one configuration which
- * must impose a more careful limit, to avoid freeing kernel pgtables.
- */
-#ifndef USER_PGTABLES_CEILING
-#define USER_PGTABLES_CEILING	0UL
-#endif
-
-/*
- * This defines the first usable user address. Platforms
- * can override its value with custom FIRST_USER_ADDRESS
- * defined in their respective <asm/pgtable.h>.
- */
-#ifndef FIRST_USER_ADDRESS
-#define FIRST_USER_ADDRESS	0UL
-#endif
-
-/*
  * This defines the generic helper for accessing PMD page
  * table page. Although platforms can still override this
  * via their respective <asm/pgtable.h>.
@@ -1630,6 +1611,25 @@ void arch_sync_kernel_mappings(unsigned
 #endif /* CONFIG_MMU */
 
 /*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
+/*
+ * This defines the first usable user address. Platforms
+ * can override its value with custom FIRST_USER_ADDRESS
+ * defined in their respective <asm/pgtable.h>.
+ */
+#ifndef FIRST_USER_ADDRESS
+#define FIRST_USER_ADDRESS	0UL
+#endif
+
+/*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
  */
--- a/mm/vma_internal.h~mm-relocate-the-page-table-ceiling-and-floor-definitions
+++ a/mm/vma_internal.h
@@ -46,6 +46,7 @@
 #include <linux/swap.h>
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/pgtable.h>
 
 #include <asm/current.h>
 #include <asm/tlb.h>
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

