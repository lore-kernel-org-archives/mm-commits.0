From: akpm@linux-foundation.org
Subject: + mm-fix-hugepage-migration.patch added to -mm tree
Date: Tue, 11 Jan 2011 13:36:09 -0800
Message-ID: <201101112136.p0BLaAfJ008152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab1AKVgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 16:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: fix hugepage migration
has been added to the -mm tree.  Its filename is
     mm-fix-hugepage-migration.patch

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
@@ -828,7 +828,6 @@ static int unmap_and_move_huge_page(new_
 	int rc = 0;
 	int *result = NULL;
 	struct page *new_hpage = get_new_page(hpage, private, &result);
-	int rcu_locked = 0;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!new_hpage)
@@ -843,12 +842,10 @@ static int unmap_and_move_huge_page(new_
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
 
@@ -860,16 +857,8 @@ static int unmap_and_move_huge_page(new_
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
 
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount,
-					    &anon_vma->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
-
-	if (rcu_locked)
-		rcu_read_unlock();
+	if (anon_vma)
+		drop_anon_vma(anon_vma);
 out:
 	unlock_page(hpage);
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-vmap-area-cache-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-transparent-hugepage-core-fixlet.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
ksm-drain-pagevecs-to-lru.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-fix-hugepage-migration.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch
prio_tree-debugging-patch.patch

