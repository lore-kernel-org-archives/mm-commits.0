From: akpm@linux-foundation.org
Subject: [patch 060/123] mm: khugepaged: fix radix tree node leak in shmem collapse error path
Date: Mon, 12 Dec 2016 16:43:35 -0800
Message-ID: <584f4437.vRexmzkwo/xQ1s1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbcLMAng (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com

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
