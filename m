From: akpm@linux-foundation.org
Subject: [merged] ksm-three-remove_rmap_item_from_tree-cleanups.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:12 -0800
Message-ID: <200912152153.nBFLrCMS015255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761346AbZLOWNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: three remove_rmap_item_from_tree cleanups
has been removed from the -mm tree.  Its filename was
     ksm-three-remove_rmap_item_from_tree-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: three remove_rmap_item_from_tree cleanups
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

1. remove_rmap_item_from_tree() is called as a precaution from
   various places: don't dirty the rmap_item cacheline unnecessarily,
   just mask the flags out of the address when they have been set.

2. First get_next_rmap_item() removes an unstable rmap_item from its tree,
   then shortly afterwards cmp_and_merge_page() removes a stable rmap_item
   from its tree: it's easier just to do both at once (but definitely keep
   the BUG_ON(age > 1) which guards against a future omission).

3. When cmp_and_merge_page() moves an rmap_item from unstable to stable
   tree, it does its own rb_erase() and accounting: that's better
   expressed by remove_rmap_item_from_tree().

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN mm/ksm.c~ksm-three-remove_rmap_item_from_tree-cleanups mm/ksm.c
--- a/mm/ksm.c~ksm-three-remove_rmap_item_from_tree-cleanups
+++ a/mm/ksm.c
@@ -453,6 +453,7 @@ static void remove_rmap_item_from_tree(s
 		}
 
 		rmap_item->next = NULL;
+		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & NODE_FLAG) {
 		unsigned char age;
@@ -467,11 +468,11 @@ static void remove_rmap_item_from_tree(s
 		BUG_ON(age > 1);
 		if (!age)
 			rb_erase(&rmap_item->node, &root_unstable_tree);
+
 		ksm_pages_unshared--;
+		rmap_item->address &= PAGE_MASK;
 	}
 
-	rmap_item->address &= PAGE_MASK;
-
 	cond_resched();		/* we're called from many long loops */
 }
 
@@ -1086,8 +1087,7 @@ static void cmp_and_merge_page(struct pa
 	unsigned int checksum;
 	int err;
 
-	if (in_stable_tree(rmap_item))
-		remove_rmap_item_from_tree(rmap_item);
+	remove_rmap_item_from_tree(rmap_item);
 
 	/* We first start with searching the page inside the stable tree */
 	tree_rmap_item = stable_tree_search(page, page2, rmap_item);
@@ -1143,9 +1143,7 @@ static void cmp_and_merge_page(struct pa
 		 * tree, and insert it instead as new node in the stable tree.
 		 */
 		if (!err) {
-			rb_erase(&tree_rmap_item->node, &root_unstable_tree);
-			tree_rmap_item->address &= ~NODE_FLAG;
-			ksm_pages_unshared--;
+			remove_rmap_item_from_tree(tree_rmap_item);
 
 			/*
 			 * If we fail to insert the page into the stable tree,
@@ -1174,11 +1172,8 @@ static struct rmap_item *get_next_rmap_i
 
 	while (cur != &mm_slot->rmap_list) {
 		rmap_item = list_entry(cur, struct rmap_item, link);
-		if ((rmap_item->address & PAGE_MASK) == addr) {
-			if (!in_stable_tree(rmap_item))
-				remove_rmap_item_from_tree(rmap_item);
+		if ((rmap_item->address & PAGE_MASK) == addr)
 			return rmap_item;
-		}
 		if (rmap_item->address > addr)
 			break;
 		cur = cur->next;
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

