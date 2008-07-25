From: akpm@linux-foundation.org
Subject: - mm-speculative-page-references-fix-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:55:34 -0700
Message-ID: <200807252355.m6PNtYpg006090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbYGYX5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, hugh@veritas.com, jeff@garzik.org, paulmck@us.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     mm-speculative-page-references-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-speculative-page-references-fix-fix.patch

This patch was dropped because it was folded into mm-speculative-page-references.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-speculative-page-references-fix-fix
From: Nick Piggin <nickpiggin@yahoo.com.au>

free_it obviously should be below the unlock_page.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-speculative-page-references-fix-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-speculative-page-references-fix-fix
+++ a/mm/vmscan.c
@@ -391,7 +391,7 @@ static pageout_t pageout(struct page *pa
 }
 
 /*
- * Save as remove_mapping, but if the page is removed from the mapping, it
+ * Same as remove_mapping, but if the page is removed from the mapping, it
  * gets returned with a refcount of 0.
  */
 static int __remove_mapping(struct address_space *mapping, struct page *page)
@@ -619,6 +619,13 @@ static unsigned long shrink_page_list(st
 				if (put_page_testzero(page))
 					goto free_it;
 				else {
+					/*
+					 * rare race with speculative reference.
+					 * the speculative reference will free
+					 * this page shortly, so we may
+					 * increment nr_reclaimed here (and
+					 * leave it off the LRU).
+					 */
 					nr_reclaimed++;
 					continue;
 				}
@@ -628,8 +635,8 @@ static unsigned long shrink_page_list(st
 		if (!mapping || !__remove_mapping(mapping, page))
 			goto keep_locked;
 
-free_it:
 		unlock_page(page);
+free_it:
 		nr_reclaimed++;
 		if (!pagevec_add(&freed_pvec, page)) {
 			__pagevec_free(&freed_pvec);
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-hugh-fix3.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

