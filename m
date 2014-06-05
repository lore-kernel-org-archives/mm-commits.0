From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:53:27 -0700
Message-ID: <5390cab7.0s76ePagxNZ0qIoz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaFETx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, koct9i@gmail.com

Subject: [merged] mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags.patch removed from -mm tree
To: koct9i@gmail.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:27 -0700


The patch titled
     Subject: mm/rmap.c: cleanup ttu_flags
has been removed from the -mm tree.  Its filename was
     mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm/rmap.c: cleanup ttu_flags

Transform action part of ttu_flags into individiual bits.  These flags
aren't part of any uses-space visible api or even trace events.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 +++----
 mm/rmap.c            |   10 +++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/rmap.h~mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags
+++ a/include/linux/rmap.h
@@ -72,10 +72,9 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
-	TTU_UNMAP = 0,			/* unmap mode */
-	TTU_MIGRATION = 1,		/* migration mode */
-	TTU_MUNLOCK = 2,		/* munlock mode */
-	TTU_ACTION_MASK = 0xff,
+	TTU_UNMAP = 1,			/* unmap mode */
+	TTU_MIGRATION = 2,		/* migration mode */
+	TTU_MUNLOCK = 4,		/* munlock mode */
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
diff -puN mm/rmap.c~mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags mm/rmap.c
--- a/mm/rmap.c~mm-make-try_to_unmap_one-static-and-cleanup-ttu_flags
+++ a/mm/rmap.c
@@ -1162,7 +1162,7 @@ static int try_to_unmap_one(struct page
 		if (vma->vm_flags & VM_LOCKED)
 			goto out_mlock;
 
-		if (TTU_ACTION(flags) == TTU_MUNLOCK)
+		if (flags & TTU_MUNLOCK)
 			goto out_unmap;
 	}
 	if (!(flags & TTU_IGNORE_ACCESS)) {
@@ -1230,7 +1230,7 @@ static int try_to_unmap_one(struct page
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
+			BUG_ON(!(flags & TTU_MIGRATION));
 			entry = make_migration_entry(page, pte_write(pteval));
 		}
 		swp_pte = swp_entry_to_pte(entry);
@@ -1239,7 +1239,7 @@ static int try_to_unmap_one(struct page
 		set_pte_at(mm, address, pte, swp_pte);
 		BUG_ON(pte_file(*pte));
 	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
+		   (flags & TTU_MIGRATION)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1252,7 +1252,7 @@ static int try_to_unmap_one(struct page
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret != SWAP_FAIL && TTU_ACTION(flags) != TTU_MUNLOCK)
+	if (ret != SWAP_FAIL && !(flags & TTU_MUNLOCK))
 		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
@@ -1539,7 +1539,7 @@ int try_to_unmap(struct page *page, enum
 	 * locking requirements of exec(), migration skips
 	 * temporary VMAs until after exec() completes.
 	 */
-	if (flags & TTU_MIGRATION && !PageKsm(page) && PageAnon(page))
+	if ((flags & TTU_MIGRATION) && !PageKsm(page) && PageAnon(page))
 		rwc.invalid_vma = invalid_migration_vma;
 
 	ret = rmap_walk(page, &rwc);
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
linux-next.patch

