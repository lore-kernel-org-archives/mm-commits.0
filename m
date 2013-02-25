From: akpm@linux-foundation.org
Subject: [merged] ksm-treat-unstable-nid-like-in-stable-tree.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:02 -0800
Message-ID: <20130225205602.AAEDF5A42E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:35121 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3BYU4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:03 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348639yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: treat unstable nid like in stable tree
has been removed from the -mm tree.  Its filename was
     ksm-treat-unstable-nid-like-in-stable-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: treat unstable nid like in stable tree

An inconsistency emerged in reviewing the NUMA node changes to KSM: when
meeting a page from the wrong NUMA node in a stable tree, we say that it's
okay for comparisons, but not as a leaf for merging; whereas when meeting
a page from the wrong NUMA node in an unstable tree, we bail out
immediately.

Now, it might be that a wrong NUMA node in an unstable tree is more likely
to correlate with instablility (different content, with rbnode now
misplaced) than page migration; but even so, we are accustomed to
instablility in the unstable tree.

Without strong evidence for which strategy is generally better, I'd rather
be consistent with what's done in the stable tree: accept a page from the
wrong NUMA node for comparison, but not as a leaf for merging.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/ksm.c~ksm-treat-unstable-nid-like-in-stable-tree mm/ksm.c
--- a/mm/ksm.c~ksm-treat-unstable-nid-like-in-stable-tree
+++ a/mm/ksm.c
@@ -1342,16 +1342,6 @@ struct rmap_item *unstable_tree_search_i
 			return NULL;
 		}
 
-		/*
-		 * If tree_page has been migrated to another NUMA node, it
-		 * will be flushed out and put into the right unstable tree
-		 * next time: only merge with it if merge_across_nodes.
-		 */
-		if (!ksm_merge_across_nodes && page_to_nid(tree_page) != nid) {
-			put_page(tree_page);
-			return NULL;
-		}
-
 		ret = memcmp_pages(page, tree_page);
 
 		parent = *new;
@@ -1361,6 +1351,15 @@ struct rmap_item *unstable_tree_search_i
 		} else if (ret > 0) {
 			put_page(tree_page);
 			new = &parent->rb_right;
+		} else if (!ksm_merge_across_nodes &&
+			   page_to_nid(tree_page) != nid) {
+			/*
+			 * If tree_page has been migrated to another NUMA node,
+			 * it will be flushed out and put in the right unstable
+			 * tree next time: only merge with it when across_nodes.
+			 */
+			put_page(tree_page);
+			return NULL;
 		} else {
 			*tree_pagep = tree_page;
 			return tree_rmap_item;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

