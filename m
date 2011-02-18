From: akpm@linux-foundation.org
Subject: [merged] mm-fix-out-of-date-comments-which-refers-non-existent-functions.patch removed from -mm tree
Date: Fri, 18 Feb 2011 13:11:45 -0800
Message-ID: <201102182111.p1ILBjLj016845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab1BRVMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Feb 2011 16:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ozaki.ryota@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix out-of-date comments which refers non-existent functions
has been removed from the -mm tree.  Its filename was
     mm-fix-out-of-date-comments-which-refers-non-existent-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix out-of-date comments which refers non-existent functions
From: Ryota Ozaki <ozaki.ryota@gmail.com>

do_file_page() and do_no_page() don't exist anymore, but some comments
still refers them.  The patch fixes them by replacing them with existing
ones.

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-fix-out-of-date-comments-which-refers-non-existent-functions mm/memory.c
--- a/mm/memory.c~mm-fix-out-of-date-comments-which-refers-non-existent-functions
+++ a/mm/memory.c
@@ -2143,10 +2143,10 @@ EXPORT_SYMBOL_GPL(apply_to_page_range);
  * handle_pte_fault chooses page fault handler according to an entry
  * which was read non-atomically.  Before making any commitment, on
  * those architectures or configurations (e.g. i386 with PAE) which
- * might give a mix of unmatched parts, do_swap_page and do_file_page
+ * might give a mix of unmatched parts, do_swap_page and do_nonlinear_fault
  * must check under lock before unmapping the pte and proceeding
  * (but do_wp_page is only called after already making such a check;
- * and do_anonymous_page and do_no_page can safely check later on).
+ * and do_anonymous_page can safely check later on).
  */
 static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 				pte_t *page_table, pte_t orig_pte)
@@ -2342,7 +2342,7 @@ reuse:
 		 * bit after it clear all dirty ptes, but before a racing
 		 * do_wp_page installs a dirty pte.
 		 *
-		 * do_no_page is protected similarly.
+		 * __do_fault is protected similarly.
 		 */
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
_

Patches currently in -mm which might be from ozaki.ryota@gmail.com are

linux-next.patch

