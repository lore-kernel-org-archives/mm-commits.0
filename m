From: akpm@linux-foundation.org
Subject: [merged]
 mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:20 -0800
Message-ID: <58519ca0.NuIpV/mKphw2XXD4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: fix radix tree node leak in shmem collapse error path
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: khugepaged: fix radix tree node leak in shmem collapse error path

The radix tree counts valid entries in each tree node.  Entries stored in
the tree cannot be removed by simpling storing NULL in the slot or the
internal counters will be off and the node never gets freed again.

When collapsing a shmem page fails, restore the holes that were filled
with radix_tree_insert() with a proper radix tree deletion.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Link: http://lkml.kernel.org/r/20161117191138.22769-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/khugepaged.c~mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path mm/khugepaged.c
--- a/mm/khugepaged.c~mm-khugepaged-fix-radix-tree-node-leak-in-shmem-collapse-error-path
+++ a/mm/khugepaged.c
@@ -1525,9 +1525,11 @@ tree_unlocked:
 			if (!page || iter.index < page->index) {
 				if (!nr_none)
 					break;
-				/* Put holes back where they were */
-				radix_tree_replace_slot(slot, NULL);
 				nr_none--;
+				/* Put holes back where they were */
+				radix_tree_delete(&mapping->page_tree,
+						  iter.index);
+				slot = radix_tree_iter_next(&iter);
 				continue;
 			}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


