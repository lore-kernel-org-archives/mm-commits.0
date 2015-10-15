From: akpm@linux-foundation.org
Subject: +
 ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
 added to -mm tree
Date: Thu, 15 Oct 2015 12:34:57 -0700
Message-ID: <561fffe1.uxb9oNzY/Ht21k/6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbJOTe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: don't fail stable tree lookups if walking over stale stable_nodes
has been added to the -mm tree.  Its filename is
     ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: don't fail stable tree lookups if walking over stale stable_nodes

The stable_nodes can become stale at any time if the underlying pages gets
freed.  The stable_node gets collected and removed from the stable rbtree
if that is detected during the rbtree tree lookups.

Don't fail the lookup if running into stale stable_nodes, just restart the
lookup after collecting the stale entries.  Otherwise the CPU spent in the
preparation stage is wasted and the lookup must be repeated at the next
loop potentially failing a second time in a second stale entry.

This also will contribute to pruning the stable tree and releasing the
stable_node memory more efficiently.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes mm/ksm.c
--- a/mm/ksm.c~ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes
+++ a/mm/ksm.c
@@ -1225,7 +1225,18 @@ again:
 		stable_node = rb_entry(*new, struct stable_node, node);
 		tree_page = get_ksm_page(stable_node, false);
 		if (!tree_page)
-			return NULL;
+			/*
+			 * If we walked over a stale stable_node,
+			 * get_ksm_page() will call rb_erase() and it
+			 * may rebalance the tree from under us. So
+			 * restart the search from scratch. Returning
+			 * NULL would be safe too, but we'd generate
+			 * false negative insertions just because some
+			 * stable_node was stale which would waste CPU
+			 * by doing the preparation work twice at the
+			 * next KSM pass.
+			 */
+			goto again;
 
 		ret = memcmp_pages(page, tree_page);
 		put_page(tree_page);
@@ -1301,12 +1312,14 @@ static struct stable_node *stable_tree_i
 	unsigned long kpfn;
 	struct rb_root *root;
 	struct rb_node **new;
-	struct rb_node *parent = NULL;
+	struct rb_node *parent;
 	struct stable_node *stable_node;
 
 	kpfn = page_to_pfn(kpage);
 	nid = get_kpfn_nid(kpfn);
 	root = root_stable_tree + nid;
+again:
+	parent = NULL;
 	new = &root->rb_node;
 
 	while (*new) {
@@ -1317,7 +1330,18 @@ static struct stable_node *stable_tree_i
 		stable_node = rb_entry(*new, struct stable_node, node);
 		tree_page = get_ksm_page(stable_node, false);
 		if (!tree_page)
-			return NULL;
+			/*
+			 * If we walked over a stale stable_node,
+			 * get_ksm_page() will call rb_erase() and it
+			 * may rebalance the tree from under us. So
+			 * restart the search from scratch. Returning
+			 * NULL would be safe too, but we'd generate
+			 * false negative insertions just because some
+			 * stable_node was stale which would waste CPU
+			 * by doing the preparation work twice at the
+			 * next KSM pass.
+			 */
+			goto again;
 
 		ret = memcmp_pages(kpage, tree_page);
 		put_page(tree_page);
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-fix-rmap_item-anon_vma-memory-corruption-and-vma-user-after-free.patch
ksm-add-cond_resched-to-the-rmap_walks.patch
ksm-dont-fail-stable-tree-lookups-if-walking-over-stale-stable_nodes.patch
ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch
ksm-use-find_mergeable_vma-in-try_to_merge_with_ksm_page.patch
ksm-unstable_tree_search_insert-error-checking-cleanup.patch

