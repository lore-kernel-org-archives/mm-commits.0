From: akpm@linux-foundation.org
Subject: [merged] mm-remove-worrying-dead-code-from-find_get_pages.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:53 -0700
Message-ID: <201103232040.p2NKeTUu028537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933347Ab1CWUzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, npiggin@kernel.dk, sqazi@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove worrying dead code from find_get_pages()
has been removed from the -mm tree.  Its filename was
     mm-remove-worrying-dead-code-from-find_get_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove worrying dead code from find_get_pages()
From: Hugh Dickins <hughd@google.com>

The radix_tree_deref_retry() case in find_get_pages() has a strange little
excrescence, not seen in the other gang lookups: it looks like the start
of an abandoned attempt to guarantee forward progress in a case that
cannot arise.

ret should always be 0 here: if it isn't, then going back to restart will
leak references to pages already gotten.  There used to be a comment
saying nr_found is necessarily 1 here: that's not quite true, but the
radix_tree_deref_retry() case is peculiar to the entry at index 0, when we
race with it being moved out of the radix_tree root or back.

Remove the worrisome two lines, add a brief comment here and in
find_get_pages_contig() and find_get_pages_tag(), and a WARN_ON in
find_get_pages() should it ever be seen elsewhere than at 0.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Salman Qazi <sqazi@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-remove-worrying-dead-code-from-find_get_pages mm/filemap.c
--- a/mm/filemap.c~mm-remove-worrying-dead-code-from-find_get_pages
+++ a/mm/filemap.c
@@ -863,9 +863,13 @@ repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
+
+		/*
+		 * This can only trigger when the entry at index 0 moves out
+		 * of or back to the root: none yet gotten, safe to restart.
+		 */
 		if (radix_tree_deref_retry(page)) {
-			if (ret)
-				start = pages[ret-1]->index;
+			WARN_ON(start | i);
 			goto restart;
 		}
 
@@ -915,6 +919,11 @@ repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
+
+		/*
+		 * This can only trigger when the entry at index 0 moves out
+		 * of or back to the root: none yet gotten, safe to restart.
+		 */
 		if (radix_tree_deref_retry(page))
 			goto restart;
 
@@ -975,6 +984,11 @@ repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
+
+		/*
+		 * This can only trigger when the entry at index 0 moves out
+		 * of or back to the root: none yet gotten, safe to restart.
+		 */
 		if (radix_tree_deref_retry(page))
 			goto restart;
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
prio_tree-debugging-patch.patch

