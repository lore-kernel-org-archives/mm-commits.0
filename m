From: akpm@linux-foundation.org
Subject: [folded-merged]
 ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes-v2.patch removed from -mm tree
Date: Thu, 05 Nov 2015 18:28:36 -0800
Message-ID: <563c1054.yUVDRoU7G16pKa8o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: don't fail stable tree lookups if walking over stale stable_nodes
has been removed from the -mm tree.  Its filename was
     ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes-v2.patch

This patch was dropped because it was folded into ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: don't fail stable tree lookups if walking over stale stable_nodes

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/ksm.c~ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes-v2 mm/ksm.c
--- a/mm/ksm.c~ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes-v2
+++ a/mm/ksm.c
@@ -1177,7 +1177,7 @@ again:
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
 		tree_page = get_ksm_page(stable_node, false);
-		if (!tree_page)
+		if (!tree_page) {
 			/*
 			 * If we walked over a stale stable_node,
 			 * get_ksm_page() will call rb_erase() and it
@@ -1185,11 +1185,10 @@ again:
 			 * restart the search from scratch. Returning
 			 * NULL would be safe too, but we'd generate
 			 * false negative insertions just because some
-			 * stable_node was stale which would waste CPU
-			 * by doing the preparation work twice at the
-			 * next KSM pass.
+			 * stable_node was stale.
 			 */
 			goto again;
+		}
 
 		ret = memcmp_pages(page, tree_page);
 		put_page(tree_page);
@@ -1282,7 +1281,7 @@ again:
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
 		tree_page = get_ksm_page(stable_node, false);
-		if (!tree_page)
+		if (!tree_page) {
 			/*
 			 * If we walked over a stale stable_node,
 			 * get_ksm_page() will call rb_erase() and it
@@ -1290,11 +1289,10 @@ again:
 			 * restart the search from scratch. Returning
 			 * NULL would be safe too, but we'd generate
 			 * false negative insertions just because some
-			 * stable_node was stale which would waste CPU
-			 * by doing the preparation work twice at the
-			 * next KSM pass.
+			 * stable_node was stale.
 			 */
 			goto again;
+		}
 
 		ret = memcmp_pages(kpage, tree_page);
 		put_page(tree_page);
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page-v2.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch
ksm-unstable_tree_search_insert-error-checking-cleanup-v2.patch

