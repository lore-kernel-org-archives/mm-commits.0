Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936051D968B
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 18:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728326504; cv=none; b=TKu2K436p+PpgZPt8VkCjYiu0D7xFQp6hC3VA+eNMJPlP7nI4l3YUdqMDdDQMJx6JFHcv2rVxCMC6wqLWbx1kvYB4dUTECMYXWxjN7GaBadjBgbP4/IjL52mI4ukrGLD4kOdUEQzuIlbxe2lXbN7k3nwYrmCiJLnS/LK5G6zKvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728326504; c=relaxed/simple;
	bh=ksaqvNN0a8ob2t9evtxV/dpwnSTmAk8qiSD1U/jSqww=;
	h=Date:To:From:Subject:Message-Id; b=YqAUw3K6Bxc3lhUMLSlDd13+i22m9YVGBZ02eBuYLrcUGBkfRgNytXTSj+RvilQhP93Id4ZujTHrJSSwAUp2Jw5oPXJMyIuxYQHpOAmrd/k5m+mc1aLaTTYZqTD0AQOjX5s/Htsv/InekOBbJRh5ojWpF/rXKNvGXCO86TjUvpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c4+hV4gF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c4+hV4gF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10957C4CEC6;
	Mon,  7 Oct 2024 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728326504;
	bh=ksaqvNN0a8ob2t9evtxV/dpwnSTmAk8qiSD1U/jSqww=;
	h=Date:To:From:Subject:From;
	b=c4+hV4gF9f/KqnpLBMluJkz/hEW/Y+Fzpg/fzJwdsBt7oUEsCcTNMNldhvM0ua2Dc
	 uO1k84AwC9HxS1QWp8lpGAX/Bpcx9oWNtW/uFU9qAIm+lO6BGEUUfCGb3ZcSjQKgF/
	 FTDDI8ImGNyFKktHRetAiXNSJ69rcD3Nr8fVOe/o=
Date: Mon, 07 Oct 2024 11:41:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,spasswolf@web.de,sidhartha.kumar@oracle.com,mikhail.v.gavrilov@gmail.com,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-correct-tree-corruption-on-spanning-store.patch added to mm-hotfixes-unstable branch
Message-Id: <20241007184144.10957C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: correct tree corruption on spanning store
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-correct-tree-corruption-on-spanning-store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-correct-tree-corruption-on-spanning-store.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: maple_tree: correct tree corruption on spanning store
Date: Mon, 7 Oct 2024 16:28:32 +0100

Patch series "maple_tree: correct tree corruption on spanning store", v3.

There has been a nasty yet subtle maple tree corruption bug that appears
to have been in existence since the inception of the algorithm.

This bug seems far more likely to happen since commit f8d112a4e657
("mm/mmap: avoid zeroing vma tree in mmap_region()"), which is the point
at which reports started to be submitted concerning this bug.

We were made definitely aware of the bug thanks to the kind efforts of
Bert Karwatzki who helped enormously in my being able to track this down
and identify the cause of it.

The bug arises when an attempt is made to perform a spanning store across
two leaf nodes, where the right leaf node is the rightmost child of the
shared parent, AND the store completely consumes the right-mode node.

This results in mas_wr_spanning_store() mitakenly duplicating the new and
existing entries at the maximum pivot within the range, and thus maple
tree corruption.

The fix patch corrects this by detecting this scenario and disallowing the
mistaken duplicate copy.

The fix patch commit message goes into great detail as to how this occurs.

This series also includes a test which reliably reproduces the issue, and
asserts that the fix works correctly.

Bert has kindly tested the fix and confirmed it resolved his issues.  Also
Mikhail Gavrilov kindly reported what appears to be precisely the same
bug, which this fix should also resolve.


This patch (of 2):

There has been a subtle bug present in the maple tree implementation from
its inception.

This arises from how stores are performed - when a store occurs, it will
overwrite overlapping ranges and adjust the tree as necessary to
accommodate this.

A range may always ultimately span two leaf nodes.  In this instance we
walk the two leaf nodes, determine which elements are not overwritten to
the left and to the right of the start and end of the ranges respectively
and then rebalance the tree to contain these entries and the newly
inserted one.

This kind of store is dubbed a 'spanning store' and is implemented by
mas_wr_spanning_store().

In order to reach this stage, mas_store_gfp() invokes
mas_wr_preallocate(), mas_wr_store_type() and mas_wr_walk() in turn to
walk the tree and update the object (mas) to traverse to the location
where the write should be performed, determining its store type.

When a spanning store is required, this function returns false stopping at
the parent node which contains the target range, and mas_wr_store_type()
marks the mas->store_type as wr_spanning_store to denote this fact.

When we go to perform the store in mas_wr_spanning_store(), we first
determine the elements AFTER the END of the range we wish to store (that
is, to the right of the entry to be inserted) - we do this by walking to
the NEXT pivot in the tree (i.e.  r_mas.last + 1), starting at the node we
have just determined contains the range over which we intend to write.

We then turn our attention to the entries to the left of the entry we are
inserting, whose state is represented by l_mas, and copy these into a 'big
node', which is a special node which contains enough slots to contain two
leaf node's worth of data.

We then copy the entry we wish to store immediately after this - the copy
and the insertion of the new entry is performed by mas_store_b_node().

After this we copy the elements to the right of the end of the range which
we are inserting, if we have not exceeded the length of the node (i.e. 
r_mas.offset <= r_mas.end).

Herein lies the bug - under very specific circumstances, this logic can
break and corrupt the maple tree.

Consider the following tree:

Height
  0                             Root Node
                                 /      \
                 pivot = 0xffff /        \ pivot = ULONG_MAX
                               /          \
  1                       A [-----]       ...
                             /   \
             pivot = 0x4fff /     \ pivot = 0xffff
                           /       \
  2 (LEAVES)          B [-----]  [-----] C
                                      ^--- Last pivot 0xffff.

Now imagine we wish to store an entry in the range [0x4000, 0xffff] (note
that all ranges expressed in maple tree code are inclusive):

1. mas_store_gfp() descends the tree, finds node A at <=0xffff, then
   determines that this is a spanning store across nodes B and C. The mas
   state is set such that the current node from which we traverse further
   is node A.

2. In mas_wr_spanning_store() we try to find elements to the right of pivot
   0xffff by searching for an index of 0x10000:

    - mas_wr_walk_index() invokes mas_wr_walk_descend() and
      mas_wr_node_walk() in turn.

        - mas_wr_node_walk() loops over entries in node A until EITHER it
          finds an entry whose pivot equals or exceeds 0x10000 OR it
          reaches the final entry.

        - Since no entry has a pivot equal to or exceeding 0x10000, pivot
          0xffff is selected, leading to node C.

    - mas_wr_walk_traverse() resets the mas state to traverse node C. We
      loop around and invoke mas_wr_walk_descend() and mas_wr_node_walk()
      in turn once again.

         - Again, we reach the last entry in node C, which has a pivot of
           0xffff.

3. We then copy the elements to the left of 0x4000 in node B to the big
   node via mas_store_b_node(), and insert the new [0x4000, 0xffff] entry
   too.

4. We determine whether we have any entries to copy from the right of the
   end of the range via - and with r_mas set up at the entry at pivot
   0xffff, r_mas.offset <= r_mas.end, and then we DUPLICATE the entry at
   pivot 0xffff.

5. BUG! The maple tree is corrupted with a duplicate entry.

This requires a very specific set of circumstances - we must be spanning
the last element in a leaf node, which is the last element in the parent
node.

spanning store across two leaf nodes with a range that ends at that shared
pivot.

A potential solution to this problem would simply be to reset the walk
each time we traverse r_mas, however given the rarity of this situation it
seems that would be rather inefficient.

Instead, this patch detects if the right hand node is populated, i.e.  has
anything we need to copy.

We do so by only copying elements from the right of the entry being
inserted when the maximum value present exceeds the last, rather than
basing this on offset position.

The patch also updates some comments and eliminates the unused bool return
value in mas_wr_walk_index().

The work performed in commit f8d112a4e657 ("mm/mmap: avoid zeroing vma
tree in mmap_region()") seems to have made the probability of this event
much more likely, which is the point at which reports started to be
submitted concerning this bug.

The motivation for this change arose from Bert Karwatzki's report of
encountering mm instability after the release of kernel v6.12-rc1 which,
after the use of CONFIG_DEBUG_VM_MAPLE_TREE and similar configuration
options, was identified as maple tree corruption.

After Bert very generously provided his time and ability to reproduce this
event consistently, I was able to finally identify that the issue
discussed in this commit message was occurring for him.

Link: https://lkml.kernel.org/r/cover.1728314402.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/48b349a2a0f7c76e18772712d0997a5e12ab0a3b.1728314403.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/all/20241001023402.3374-1-spasswolf@web.de/
Tested-by: Bert Karwatzki <spasswolf@web.de>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/all/CABXGCsOPwuoNOqSMmAvWO2Fz4TEmPnjFj-b7iF+XFRu1h7-+Dg@mail.gmail.com/
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-correct-tree-corruption-on-spanning-store
+++ a/lib/maple_tree.c
@@ -2196,6 +2196,8 @@ static inline void mas_node_or_none(stru
 
 /*
  * mas_wr_node_walk() - Find the correct offset for the index in the @mas.
+ *                      If @mas->index cannot be found within the containing
+ *                      node, we traverse to the last entry in the node.
  * @wr_mas: The maple write state
  *
  * Uses mas_slot_locked() and does not need to worry about dead nodes.
@@ -3532,7 +3534,7 @@ static bool mas_wr_walk(struct ma_wr_sta
 	return true;
 }
 
-static bool mas_wr_walk_index(struct ma_wr_state *wr_mas)
+static void mas_wr_walk_index(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 
@@ -3541,11 +3543,9 @@ static bool mas_wr_walk_index(struct ma_
 		wr_mas->content = mas_slot_locked(mas, wr_mas->slots,
 						  mas->offset);
 		if (ma_is_leaf(wr_mas->type))
-			return true;
+			return;
 		mas_wr_walk_traverse(wr_mas);
-
 	}
-	return true;
 }
 /*
  * mas_extend_spanning_null() - Extend a store of a %NULL to include surrounding %NULLs.
@@ -3765,8 +3765,8 @@ static noinline void mas_wr_spanning_sto
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
 	mas_store_b_node(&l_wr_mas, &b_node, l_mas.end);
-	/* Copy r_mas into b_node. */
-	if (r_mas.offset <= r_mas.end)
+	/* Copy r_mas into b_node if there is anything to copy. */
+	if (r_mas.max > r_mas.last)
 		mas_mab_cp(&r_mas, r_mas.offset, r_mas.end,
 			   &b_node, b_node.b_end + 1);
 	else
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mmap-correct-error-handling-in-mmap_region.patch
maple_tree-correct-tree-corruption-on-spanning-store.patch
maple_tree-add-regression-test-for-spanning-store-bug.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch

