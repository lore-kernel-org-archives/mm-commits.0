From: akpm@linux-foundation.org
Subject: + mm-remove-worrying-dead-code-from-find_get_pages.patch added to -mm tree
Date: Thu, 24 Feb 2011 16:16:23 -0800
Message-ID: <201102250016.p1P0GPgh003339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab1BYARI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 19:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, npiggin@kernel.dk, sqazi@google.com


The patch titled
     mm: remove worrying dead code from find_get_pages()
has been added to the -mm tree.  Its filename is
     mm-remove-worrying-dead-code-from-find_get_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -875,9 +875,13 @@ repeat:
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
 
@@ -927,6 +931,11 @@ repeat:
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
 
@@ -987,6 +996,11 @@ repeat:
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
linux-next.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-remove-worrying-dead-code-from-find_get_pages.patch
prio_tree-debugging-patch.patch

