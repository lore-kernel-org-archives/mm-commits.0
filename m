From: akpm@linux-foundation.org
Subject: [merged] radix_tree-clean-away-saw_unset_tag-leftovers.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:03 -0700
Message-ID: <201111012108.pA1L835Z010021@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15198 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:06 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id pA1L84EM020445
	for <mm-commits@vger.kernel.org>; Tue, 1 Nov 2011 14:08:05 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: clean away saw_unset_tag leftovers
has been removed from the -mm tree.  Its filename was
     radix_tree-clean-away-saw_unset_tag-leftovers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: radix_tree: clean away saw_unset_tag leftovers

radix_tree_tag_get()'s BUG (when it sees a tag after saw_unset_tag) was
unsafe and removed in 2.6.34, but the pointless saw_unset_tag left behind.

Remove it now, and return 0 as soon as we see unset tag - we already rely
upon the root tag to be correct, returning 0 immediately if it's not set.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN lib/radix-tree.c~radix_tree-clean-away-saw_unset_tag-leftovers lib/radix-tree.c
--- a/lib/radix-tree.c~radix_tree-clean-away-saw_unset_tag-leftovers
+++ a/lib/radix-tree.c
@@ -576,7 +576,6 @@ int radix_tree_tag_get(struct radix_tree
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node;
-	int saw_unset_tag = 0;
 
 	/* check the root's tag bit */
 	if (!root_tag_get(root, tag))
@@ -603,15 +602,10 @@ int radix_tree_tag_get(struct radix_tree
 			return 0;
 
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-
-		/*
-		 * This is just a debug check.  Later, we can bale as soon as
-		 * we see an unset tag.
-		 */
 		if (!tag_get(node, tag, offset))
-			saw_unset_tag = 1;
+			return 0;
 		if (height == 1)
-			return !!tag_get(node, tag, offset);
+			return 1;
 		node = rcu_dereference_raw(node->slots[offset]);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
prio_tree-debugging-patch.patch

