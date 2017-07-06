From: akpm@linux-foundation.org
Subject: [patch 035/108] ksm: optimize refile of stable_node_dup at
 the head of the chain
Date: Thu, 06 Jul 2017 15:37:08 -0700
Message-ID: <20170706223708.j7x4qwEX7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdGFWhK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, arjan@linux.intel.com, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dave@stgolabs.net, ederevea@redhat.com, gavin.guo@canonical.com, hughd@google.com, jay.vosburgh@canonical.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, pholasek@redhat.com, torvalds@linux-foundation.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: optimize refile of stable_node_dup at the head of the chain

If a candidate stable_node_dup has been found and it can accept further
merges it can be refiled to the head of the list to speedup next searches
without altering which dup is found and how the dups accumulate in the
chain.

We already refiled it back to the head in the prune_stale_stable_nodes
case, but we didn't refile it if not pruning (which is more common).  And
we also refiled it when it was already at the head which is unnecessary
(in the prune_stale_stable_nodes case, nr > 1 means there's more than one
dup in the chain, it doesn't mean it's not already at the head of the
chain).

The stable_node_chain list is single threaded and there's no SMP locking
contention so it should be faster to refile it to the head of the list
also if prune_stale_stable_nodes is false.

Profiling shows the refile happens 1.9% of the time when a dup is found
with a max_page_sharing limit setting of 3 (with max_page_sharing of 2 the
refile never happens of course as there's never space for one more merge)
which is reasonably low.  At higher max_page_sharing values it should be
much less frequent.

This is just an optimization.

Link: http://lkml.kernel.org/r/20170518173721.22316-4-aarcange@redhat.com
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

 mm/ksm.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff -puN mm/ksm.c~ksm-optimize-refile-of-stable_node_dup-at-the-head-of-the-chain mm/ksm.c
--- a/mm/ksm.c~ksm-optimize-refile-of-stable_node_dup-at-the-head-of-the-chain
+++ a/mm/ksm.c
@@ -1367,13 +1367,14 @@ struct page *stable_node_dup(struct stab
 		put_page(_tree_page);
 	}
 
-	/*
-	 * nr is relevant only if prune_stale_stable_nodes is true,
-	 * otherwise we may break the loop at nr == 1 even if there
-	 * are multiple entries.
-	 */
-	if (prune_stale_stable_nodes && found) {
-		if (nr == 1) {
+	if (found) {
+		/*
+		 * nr is counting all dups in the chain only if
+		 * prune_stale_stable_nodes is true, otherwise we may
+		 * break the loop at nr == 1 even if there are
+		 * multiple entries.
+		 */
+		if (prune_stale_stable_nodes && nr == 1) {
 			/*
 			 * If there's not just one entry it would
 			 * corrupt memory, better BUG_ON. In KSM
@@ -1404,12 +1405,22 @@ struct page *stable_node_dup(struct stab
 			 * time.
 			 */
 			stable_node = NULL;
-		} else if (__is_page_sharing_candidate(found, 1)) {
+		} else if (stable_node->hlist.first != &found->hlist_dup &&
+			   __is_page_sharing_candidate(found, 1)) {
 			/*
-			 * Refile our candidate at the head
-			 * after the prune if our candidate
-			 * can accept one more future sharing
-			 * in addition to the one underway.
+			 * If the found stable_node dup can accept one
+			 * more future merge (in addition to the one
+			 * that is underway) and is not at the head of
+			 * the chain, put it there so next search will
+			 * be quicker in the !prune_stale_stable_nodes
+			 * case.
+			 *
+			 * NOTE: it would be inaccurate to use nr > 1
+			 * instead of checking the hlist.first pointer
+			 * directly, because in the
+			 * prune_stale_stable_nodes case "nr" isn't
+			 * the position of the found dup in the chain,
+			 * but the total number of dups in the chain.
 			 */
 			hlist_del(&found->hlist_dup);
 			hlist_add_head(&found->hlist_dup,
_
