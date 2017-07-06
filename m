From: akpm@linux-foundation.org
Subject: [patch 033/108] ksm: cleanup stable_node chain collapse
 case
Date: Thu, 06 Jul 2017 15:37:02 -0700
Message-ID: <20170706223702.6pXOltmUz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbdGFWhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, arjan@linux.intel.com, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dave@stgolabs.net, ederevea@redhat.com, gavin.guo@canonical.com, hughd@google.com, jay.vosburgh@canonical.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, pholasek@redhat.com, torvalds@linux-foundation.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: cleanup stable_node chain collapse case

Patch series "KSMscale cleanup/optimizations".

There are no fixes here it's just minor cleanups and optimizations.

1/3 removes makes the "fix" for the stale stable_node fall in the
    standard case without introducing new cases.  Setting stable_node to
    NULL was marginally safer, but stale pointer is still wiped from the
    caller, this looks cleaner.

2/3 should fix the false positive from Dan's static checker.

3/3 is a microoptimization to apply the the refile of future merge
    candidate dups at the head of the chain in all cases and to skip it in
    one case where we did it and but it was a noop (to avoid checking if
    it was already at the head but now we've to check it anyway so it got
    optimized away).


This patch (of 3):

When the stable_node chain is collapsed we can as well set the caller
stable_node to match the returned stable_node_dup in chain_prune().

This way the collapse case becomes indistinguishable from the regular
stable_node case and we can remove two branches from the KSM page
migration handling slow paths.

While it was all correct this looks cleaner (and faster) as the caller has
to deal with fewer special cases.

Link: http://lkml.kernel.org/r/20170518173721.22316-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Evgheni Dereveanchin <ederevea@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Gavin Guo <gavin.guo@canonical.com>
Cc: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-stable_node-chain-collapse-case mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-stable_node-chain-collapse-case
+++ a/mm/ksm.c
@@ -1392,14 +1392,18 @@ static struct stable_node *stable_node_d
 			ksm_stable_node_chains--;
 			ksm_stable_node_dups--;
 			/*
-			 * NOTE: the caller depends on the
-			 * *_stable_node to become NULL if the chain
-			 * was collapsed. Enforce that if anything
-			 * uses a stale (freed) stable_node chain a
-			 * visible crash will materialize (instead of
-			 * an use after free).
+			 * NOTE: the caller depends on the stable_node
+			 * to be equal to stable_node_dup if the chain
+			 * was collapsed.
 			 */
-			*_stable_node = stable_node = NULL;
+			*_stable_node = found;
+			/*
+			 * Just for robustneess as stable_node is
+			 * otherwise left as a stable pointer, the
+			 * compiler shall optimize it away at build
+			 * time.
+			 */
+			stable_node = NULL;
 		} else if (__is_page_sharing_candidate(found, 1)) {
 			/*
 			 * Refile our candidate at the head
@@ -1505,7 +1509,11 @@ again:
 		 * not NULL. stable_node_dup may have been inserted in
 		 * the rbtree instead as a regular stable_node (in
 		 * order to collapse the stable_node chain if a single
-		 * stable_node dup was found in it).
+		 * stable_node dup was found in it). In such case the
+		 * stable_node is overwritten by the calleee to point
+		 * to the stable_node_dup that was collapsed in the
+		 * stable rbtree and stable_node will be equal to
+		 * stable_node_dup like if the chain never existed.
 		 */
 		if (!stable_node_dup) {
 			/*
@@ -1623,15 +1631,13 @@ out:
 replace:
 	/*
 	 * If stable_node was a chain and chain_prune collapsed it,
-	 * stable_node will be NULL here. In that case the
-	 * stable_node_dup is the regular stable_node that has
-	 * replaced the chain. If stable_node is not NULL and equal to
-	 * stable_node_dup there was no chain and stable_node_dup is
-	 * the regular stable_node in the stable rbtree. Otherwise
-	 * stable_node is the chain and stable_node_dup is the dup to
-	 * replace.
+	 * stable_node has been updated to be the new regular
+	 * stable_node. A collapse of the chain is indistinguishable
+	 * from the case there was no chain in the stable
+	 * rbtree. Otherwise stable_node is the chain and
+	 * stable_node_dup is the dup to replace.
 	 */
-	if (!stable_node || stable_node_dup == stable_node) {
+	if (stable_node_dup == stable_node) {
 		VM_BUG_ON(is_stable_node_chain(stable_node_dup));
 		VM_BUG_ON(is_stable_node_dup(stable_node_dup));
 		/* there is no chain */
@@ -1676,13 +1682,13 @@ chain_append:
 		stable_node_dup = stable_node_any;
 	/*
 	 * If stable_node was a chain and chain_prune collapsed it,
-	 * stable_node will be NULL here. In that case the
-	 * stable_node_dup is the regular stable_node that has
-	 * replaced the chain. If stable_node is not NULL and equal to
-	 * stable_node_dup there was no chain and stable_node_dup is
-	 * the regular stable_node in the stable rbtree.
+	 * stable_node has been updated to be the new regular
+	 * stable_node. A collapse of the chain is indistinguishable
+	 * from the case there was no chain in the stable
+	 * rbtree. Otherwise stable_node is the chain and
+	 * stable_node_dup is the dup to replace.
 	 */
-	if (!stable_node || stable_node_dup == stable_node) {
+	if (stable_node_dup == stable_node) {
 		VM_BUG_ON(is_stable_node_chain(stable_node_dup));
 		VM_BUG_ON(is_stable_node_dup(stable_node_dup));
 		/* chain is missing so create it */
_
