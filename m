From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-clearing-of-page-mapping-to-page_cache_tree_delete.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:03:57 -0800
Message-ID: <20171116200357.57dynBRVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934285AbdKPUD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:03:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move clearing of page->mapping to page_cache_tree_delete()
has been removed from the -mm tree.  Its filename was
     mm-move-clearing-of-page-mapping-to-page_cache_tree_delete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: move clearing of page->mapping to page_cache_tree_delete()

Clearing of page->mapping makes sense in page_cache_tree_delete() as well
and it will help us with batching things this way.

Link: http://lkml.kernel.org/r/20171010151937.26984-6-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-move-clearing-of-page-mapping-to-page_cache_tree_delete mm/filemap.c
--- a/mm/filemap.c~mm-move-clearing-of-page-mapping-to-page_cache_tree_delete
+++ a/mm/filemap.c
@@ -165,6 +165,9 @@ static void page_cache_tree_delete(struc
 				     workingset_update_node, mapping);
 	}
 
+	page->mapping = NULL;
+	/* Leave page->index set: truncation lookup relies upon it */
+
 	if (shadow) {
 		mapping->nrexceptional += nr;
 		/*
@@ -250,9 +253,6 @@ void __delete_from_page_cache(struct pag
 					     inode_to_wb(mapping->host));
 	}
 	page_cache_tree_delete(mapping, page, shadow);
