From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:35 -0700
Message-ID: <200906162241.n5GMfZ4D003539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758938AbZFPWmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ksm: fix losing visibility of part of rmap_item->next list
has been removed from the -mm tree.  Its filename was
     ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix losing visibility of part of rmap_item->next list
From: Andrea Arcangeli <aarcange@redhat.com>


The tree_item->rmap_item is the head of the list and as such it must
not be overwritten except in the case that the element we removed
(rmap_item) was the previous head of the list, in which case it would
also have rmap_item->prev set to null.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list mm/ksm.c
--- a/mm/ksm.c~ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list
+++ a/mm/ksm.c
@@ -397,10 +397,10 @@ static void remove_rmap_item_from_tree(s
 				free_tree_item(tree_item);
 				nnodes_stable_tree--;
 			} else if (!rmap_item->prev) {
+				BUG_ON(tree_item->rmap_item != rmap_item);
 				tree_item->rmap_item = rmap_item->next;
-			} else {
-				tree_item->rmap_item = rmap_item->prev;
-			}
+			} else
+				BUG_ON(tree_item->rmap_item == rmap_item);
 		} else {
 			/*
 			 * We dont rb_erase(&tree_item->node) here, beacuse
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch

