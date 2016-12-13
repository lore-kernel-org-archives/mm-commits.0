From: akpm@linux-foundation.org
Subject: [patch 067/123] mm: workingset: restore refault tracking for
 single-page files
Date: Mon, 12 Dec 2016 16:43:55 -0800
Message-ID: <584f444b.LWMT8LZgisPe6WqC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41344 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753033AbcLMAn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@linuxonhyperv.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: restore refault tracking for single-page files

Shadow entries in the page cache used to be accounted behind the radix
tree implementation's back in the upper bits of node->count, and the radix
tree code extending a single-entry tree with a shadow entry in root->rnode
would corrupt that counter.  As a result, we could not put shadow entries
at index 0 if the tree didn't have any other entries, and that means no
refault detection for any single-page file.

Now that the shadow entries are tracked natively in the radix tree's
exceptional counter, this is no longer necessary.  Extending and shrinking
the tree from and to single entries in root->rnode now does the right
thing when the entry is exceptional, remove that limitation.

Link: http://lkml.kernel.org/r/20161117193244.GF23430@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/filemap.c~mm-workingset-restore-refault-tracking-for-single-page-files mm/filemap.c
--- a/mm/filemap.c~mm-workingset-restore-refault-tracking-for-single-page-files
+++ a/mm/filemap.c
@@ -167,14 +167,7 @@ static void page_cache_tree_delete(struc
 		__radix_tree_lookup(&mapping->page_tree, page->index + i,
 				    &node, &slot);
 
-		if (!node) {
-			VM_BUG_ON_PAGE(nr != 1, page);
-			/*
-			 * We need a node to properly account shadow
-			 * entries. Don't plant any without. XXX
-			 */
-			shadow = NULL;
-		}
+		VM_BUG_ON_PAGE(!node && nr != 1, page);
 
 		radix_tree_clear_tags(&mapping->page_tree, node, slot);
 		__radix_tree_replace(&mapping->page_tree, node, slot, shadow,
_
