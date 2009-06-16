From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:32 -0700
Message-ID: <200906162241.n5GMfW5Y003536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488AbZFPWmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ksm: fix rmap_item use after free
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix rmap_item use after free
From: Andrea Arcangeli <aarcange@redhat.com>

This avoid crashing with slab debugging enabled by removing a window for
memory corruption if freed slab entries are reused before we read the next
pointer.  Against mmotm.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free
+++ a/mm/ksm.c
@@ -892,7 +892,7 @@ static struct rmap_item *stable_tree_sea
 {
 	struct rb_node *node = root_stable_tree.rb_node;
 	struct tree_item *tree_item;
-	struct rmap_item *found_rmap_item;
+	struct rmap_item *found_rmap_item, *next_rmap_item;
 
 	while (node) {
 		int ret;
@@ -907,9 +907,11 @@ static struct rmap_item *stable_tree_sea
 			      found_rmap_item->address == rmap_item->address)) {
 				if (!is_zapped_item(found_rmap_item, page2))
 					break;
+				next_rmap_item = found_rmap_item->next;
 				remove_rmap_item_from_tree(found_rmap_item);
-			}
-			found_rmap_item = found_rmap_item->next;
+				found_rmap_item = next_rmap_item;
+			} else
+				found_rmap_item = found_rmap_item->next;
 		}
 		if (!found_rmap_item)
 			goto out_didnt_find;
@@ -959,7 +961,7 @@ static int stable_tree_insert(struct pag
 
 	while (*new) {
 		int ret;
-		struct rmap_item *insert_rmap_item;
+		struct rmap_item *insert_rmap_item, *next_rmap_item;
 
 		tree_item = rb_entry(*new, struct tree_item, node);
 		BUG_ON(!tree_item);
@@ -973,9 +975,11 @@ static int stable_tree_insert(struct pag
 			     insert_rmap_item->address == rmap_item->address)) {
 				if (!is_zapped_item(insert_rmap_item, page2))
 					break;
+				next_rmap_item = insert_rmap_item->next;
 				remove_rmap_item_from_tree(insert_rmap_item);
-			}
-			insert_rmap_item = insert_rmap_item->next;
+				insert_rmap_item = next_rmap_item;
+			} else
+				insert_rmap_item = insert_rmap_item->next;
 		}
 		if (!insert_rmap_item)
 			return 1;
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

