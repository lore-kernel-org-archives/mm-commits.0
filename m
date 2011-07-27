From: akpm@linux-foundation.org
Subject: + radix_tree-clean-away-saw_unset_tag-leftovers.patch added to -mm tree
Date: Wed, 27 Jul 2011 16:22:51 -0700
Message-ID: <201107272322.p6RNMpL2014643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503Ab1G0XWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 19:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     radix_tree: clean away saw_unset_tag leftovers
has been added to the -mm tree.  Its filename is
     radix_tree-clean-away-saw_unset_tag-leftovers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix_tree: clean away saw_unset_tag leftovers
From: Hugh Dickins <hughd@google.com>

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
slub-partly-fix-freeze-in-__slab_free.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
tmpfs-radix_tree-locate_item-to-speed-up-swapoff.patch
mm-clarify-the-radix_tree-exceptional-cases.patch
prio_tree-debugging-patch.patch

