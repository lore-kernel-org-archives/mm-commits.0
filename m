From: akpm@linux-foundation.org
Subject: + ksm-swap-the-two-output-parameters-of-chain-chain_prune.patch
 added to -mm tree
Date: Thu, 18 May 2017 12:54:20 -0700
Message-ID: <591dfbec.M6U7rstqOhWQgBRD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbdERTyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 15:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arjan@linux.intel.com, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dave@stgolabs.net, ederevea@redhat.com, gavin.guo@canonical.com, hughd@google.com, jay.vosburgh@canonical.com, mgorman@techsingularity.net, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: swap the two output parameters of chain/chain_prune
has been added to the -mm tree.  Its filename is
     ksm-swap-the-two-output-parameters-of-chain-chain_prune.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-swap-the-two-output-parameters-of-chain-chain_prune.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-swap-the-two-output-parameters-of-chain-chain_prune.patch

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
Subject: ksm: swap the two output parameters of chain/chain_prune

Some static checker complains if chain/chain_prune returns a potentially
stale pointer.

There are two output parameters to chain/chain_prune, one is tree_page the
other is stable_node_dup.  Like in get_ksm_page the caller has to check
tree_page is NULL before touching the stable_node.  Similarly in
chain/chain_prune the caller has to check tree_page before touching the
stable_node_dup returned or the original stable_node passed as parameter.

Because the tree_page is never returned as a stale pointer, it may be more
intuitive to return tree_page and to pass stable_node_dup for reference
instead of the reverse.

This patch purely swaps the two output parameters of chain/chain_prune as
a cleanup for the static checker and to mimic the get_ksm_page behavior
more closely.  There's no change to the caller at all except the swap,
it's purely a cleanup and it is a noop from the caller point of view.

Link: http://lkml.kernel.org/r/20170518173721.22316-3-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Evgheni Dereveanchin <ederevea@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Gavin Guo <gavin.guo@canonical.com>
Cc: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   78 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff -puN mm/ksm.c~ksm-swap-the-two-output-parameters-of-chain-chain_prune mm/ksm.c
--- a/mm/ksm.c~ksm-swap-the-two-output-parameters-of-chain-chain_prune
+++ a/mm/ksm.c
@@ -1313,14 +1313,14 @@ bool is_page_sharing_candidate(struct st
 	return __is_page_sharing_candidate(stable_node, 0);
 }
 
-static struct stable_node *stable_node_dup(struct stable_node **_stable_node,
-					   struct page **tree_page,
-					   struct rb_root *root,
-					   bool prune_stale_stable_nodes)
+struct page *stable_node_dup(struct stable_node **_stable_node_dup,
+			     struct stable_node **_stable_node,
+			     struct rb_root *root,
+			     bool prune_stale_stable_nodes)
 {
 	struct stable_node *dup, *found = NULL, *stable_node = *_stable_node;
 	struct hlist_node *hlist_safe;
-	struct page *_tree_page;
+	struct page *_tree_page, *tree_page = NULL;
 	int nr = 0;
 	int found_rmap_hlist_len;
 
@@ -1353,14 +1353,14 @@ static struct stable_node *stable_node_d
 			if (!found ||
 			    dup->rmap_hlist_len > found_rmap_hlist_len) {
 				if (found)
-					put_page(*tree_page);
+					put_page(tree_page);
 				found = dup;
 				found_rmap_hlist_len = found->rmap_hlist_len;
-				*tree_page = _tree_page;
+				tree_page = _tree_page;
 
+				/* skip put_page for found dup */
 				if (!prune_stale_stable_nodes)
 					break;
-				/* skip put_page */
 				continue;
 			}
 		}
@@ -1417,7 +1417,8 @@ static struct stable_node *stable_node_d
 		}
 	}
 
-	return found;
+	*_stable_node_dup = found;
+	return tree_page;
 }
 
 static struct stable_node *stable_node_dup_any(struct stable_node *stable_node,
@@ -1433,35 +1434,60 @@ static struct stable_node *stable_node_d
 			   typeof(*stable_node), hlist_dup);
 }
 
-static struct stable_node *__stable_node_chain(struct stable_node **_stable_node,
-					       struct page **tree_page,
-					       struct rb_root *root,
-					       bool prune_stale_stable_nodes)
+/*
+ * Like for get_ksm_page, this function can free the *_stable_node and
+ * *_stable_node_dup if the returned tree_page is NULL.
+ *
+ * It can also free and overwrite *_stable_node with the found
+ * stable_node_dup if the chain is collapsed (in which case
+ * *_stable_node will be equal to *_stable_node_dup like if the chain
+ * never existed). It's up to the caller to verify tree_page is not
+ * NULL before dereferencing *_stable_node or *_stable_node_dup.
+ *
+ * *_stable_node_dup is really a second output parameter of this
+ * function and will be overwritten in all cases, the caller doesn't
+ * need to initialize it.
+ */
+static struct page *__stable_node_chain(struct stable_node **_stable_node_dup,
+					struct stable_node **_stable_node,
+					struct rb_root *root,
+					bool prune_stale_stable_nodes)
 {
 	struct stable_node *stable_node = *_stable_node;
 	if (!is_stable_node_chain(stable_node)) {
 		if (is_page_sharing_candidate(stable_node)) {
-			*tree_page = get_ksm_page(stable_node, false);
-			return stable_node;
+			*_stable_node_dup = stable_node;
+			return get_ksm_page(stable_node, false);
 		}
+		/*
+		 * _stable_node_dup set to NULL means the stable_node
+		 * reached the ksm_max_page_sharing limit.
+		 */
+		*_stable_node_dup = NULL;
 		return NULL;
 	}
-	return stable_node_dup(_stable_node, tree_page, root,
+	return stable_node_dup(_stable_node_dup, _stable_node, root,
 			       prune_stale_stable_nodes);
 }
 
-static __always_inline struct stable_node *chain_prune(struct stable_node **s_n,
-						       struct page **t_p,
-						       struct rb_root *root)
+static __always_inline struct page *chain_prune(struct stable_node **s_n_d,
+						struct stable_node **s_n,
+						struct rb_root *root)
 {
-	return __stable_node_chain(s_n, t_p, root, true);
+	return __stable_node_chain(s_n_d, s_n, root, true);
 }
 
-static __always_inline struct stable_node *chain(struct stable_node *s_n,
-						 struct page **t_p,
-						 struct rb_root *root)
+static __always_inline struct page *chain(struct stable_node **s_n_d,
+					  struct stable_node *s_n,
+					  struct rb_root *root)
 {
-	return __stable_node_chain(&s_n, t_p, root, false);
+	struct stable_node *old_stable_node = s_n;
+	struct page *tree_page;
+
+	tree_page = __stable_node_chain(s_n_d, &s_n, root, false);
+	/* not pruning dups so s_n cannot have changed */
+	VM_BUG_ON(s_n != old_stable_node);
+	return tree_page;
 }
 
 /*
@@ -1502,7 +1528,7 @@ again:
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
 		stable_node_any = NULL;
-		stable_node_dup = chain_prune(&stable_node, &tree_page, root);
+		tree_page = chain_prune(&stable_node_dup, &stable_node,	root);
 		/*
 		 * NOTE: stable_node may have been freed by
 		 * chain_prune() if the returned stable_node_dup is
@@ -1743,7 +1769,7 @@ again:
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
 		stable_node_any = NULL;
-		stable_node_dup = chain(stable_node, &tree_page, root);
+		tree_page = chain(&stable_node_dup, stable_node, root);
 		if (!stable_node_dup) {
 			/*
 			 * Either all stable_node dups were full in
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-prevent-crash-after-write_protect_page-fails.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
ksm-fix-use-after-free-with-merge_across_nodes-=-0.patch
ksm-cleanup-stable_node-chain-collapse-case.patch
ksm-swap-the-two-output-parameters-of-chain-chain_prune.patch
ksm-optimize-refile-of-stable_node_dup-at-the-head-of-the-chain.patch

