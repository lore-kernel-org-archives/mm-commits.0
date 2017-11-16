From: akpm@linux-foundation.org
Subject: [patch 100/131] mm: move clearing of page->mapping to
 page_cache_tree_delete()
Date: Wed, 15 Nov 2017 17:37:26 -0800
Message-ID: <20171116013726.rdf0OnKX4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933632AbdKPBh2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:37:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
