From: akpm@linux-foundation.org
Subject: [merged] mm-fix-hugepage-migration.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:24 -0800
Message-ID: <201101142252.p0EMqEo9005600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab1ANWwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix hugepage migration
has been removed from the -mm tree.  Its filename was
     mm-fix-hugepage-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix hugepage migration
From: Hugh Dickins <hughd@google.com>

2.6.37 added an unmap_and_move_huge_page() for memory failure recovery,
but its anon_vma handling was still based around the 2.6.35 conventions.
Update it to use page_lock_anon_vma, get_anon_vma, page_unlock_anon_vma,
drop_anon_vma in the same way as we're now changing unmap_and_move().

I don't particularly like to propose this for stable when I've not seen
its problems in practice nor tested the solution: but it's clearly out of
synch at present.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: <stable@kernel.org> [2.6.37, 2.6.36]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff -puN mm/migrate.c~mm-fix-hugepage-migration mm/migrate.c
--- a/mm/migrate.c~mm-fix-hugepage-migration
+++ a/mm/migrate.c
@@ -827,7 +827,6 @@ static int unmap_and_move_huge_page(new_
 	int rc = 0;
 	int *result = NULL;
 	struct page *new_hpage = get_new_page(hpage, private, &result);
-	int rcu_locked = 0;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!new_hpage)
@@ -842,12 +841,10 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (PageAnon(hpage)) {
-		rcu_read_lock();
-		rcu_locked = 1;
-
-		if (page_mapped(hpage)) {
-			anon_vma = page_anon_vma(hpage);
-			atomic_inc(&anon_vma->external_refcount);
+		anon_vma = page_lock_anon_vma(hpage);
+		if (anon_vma) {
+			get_anon_vma(anon_vma);
+			page_unlock_anon_vma(anon_vma);
 		}
 	}
 
@@ -859,16 +856,8 @@ static int unmap_and_move_huge_page(new_
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
 
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount,
-					    &anon_vma->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
